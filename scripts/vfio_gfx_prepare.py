#!/usr/bin/env python3
'''
Prepare system for passing graphics card to virtual machine

This script currently supports only integrated Intel HD Graphics cards
but is written to be expandable to support other vendors later

Useful links:
    https://worthdoingbadly.com/gpupassthrough/
    https://www.doc.ic.ac.uk/%7Ebh1511/blog/20180817-ubuntu-headless-vm/
'''


import glob
import logging
import re
import subprocess
import sys
from argparse import ArgumentParser
from pathlib import Path


log = logging.getLogger(__name__.split('.')[0])


def main():
    '''Script entry point'''
    # TODO: discover neighbors in IOMMU device groups
    args = parse_args()
    configure_logging(args.verbose)
    try:
        prepare(args.card)
    except ScriptFailure as exc:
        log.critical(f'ERROR: {exc.message}')
        sys.exit(1)


def prepare(card):
    '''Prepare graphics card for being passed through to VM'''
    log.info(f'Processing {card}')
    if not iommu_enabled(card.vendor_name):
        raise ScriptFailure(f'iommu is not enabled for {card.vendor_name} devices')
    disable_vt_console()
    remove_modules = {
        'intel': [
            'snd_hda_intel',
            'i915',
        ],
    }
    for module in remove_modules[card.vendor_name]:
        rmmod(module)
    modprobe('vfio-pci')
    card.bind_driver('vfio-pci')


def parse_args(*a, **ka):
    '''Parse commandline arguments'''
    parser = ArgumentParser(
        description=__doc__.strip().splitlines()[0],
        epilog='Licensed under the Apache License, version 2.0',
    )
    parser.add_argument(
        'card',
        metavar='PCI_ADDR',
        help='PCI address of the graphics card, for example: 0000:00:02.0',
        type=PCIDevice,
    )
    parser.add_argument(
        '-v',
        '--verbose',
        action='count',
        default=0,
        help='Increase output verbosity. Repeat multiple times to output even more details',
    )
    args = parser.parse_args(*a, **ka)
    return args


def configure_logging(verbosity=0):
    levels = {
        0: logging.WARNING,
        1: logging.INFO,
        2: logging.DEBUG,
        3: logging.NOTSET + 1,
    }
    if verbosity > max(levels):
        verbosity = max(levels)
    if not log.hasHandlers() and not log.root.hasHandlers():
        handler = logging.StreamHandler()
        handler.setLevel(logging.DEBUG)
        log.addHandler(handler)
    current = levels[0] if log.level == 0 else log.level
    log.setLevel(min(current, levels[verbosity]))


class ScriptFailure(Exception):
    '''Unrecoverable runtime script failure'''
    @property
    def message(self):
        return self.args[0] if self.args else None


class PCIDevice:
    '''Manage PCI device'''
    VENDOR_NAMES = {
        '0x8086': 'intel',
    }

    def __init__(self, pci_addr):
        self.pci = pci_addr
        if not Path(f'/sys/bus/pci/devices/{pci_addr}').exists():
            raise ValueError(f'invalid PCI address: {pci_addr}')
        for item in ['vendor', 'device']:
            with open(f'/sys/bus/pci/devices/{pci_addr}/{item}') as f:
                setattr(self, item, f.read().strip())

    def __repr__(self):
        return (
            f'<{self.__class__.__name__} pci={self.pci}, '
            f'vendor={self.vendor} ({self.vendor_name}), '
            f'device={self.device}>'
        )

    @property
    def vendor_name(self):
        return self.VENDOR_NAMES.get(self.vendor, 'UNKNOWN')

    @property
    def driver(self):
        '''Name of the driver in use'''
        driver = Path(f'/sys/bus/pci/devices/{self.pci}/driver')
        if not driver.exists():
            return None
        if driver.is_symlink():
            return driver.resolve().name
        raise RuntimeError('driver detection failed')

    def unbind_driver(self):
        '''Unbind PCI device from its driver'''
        driver = Path(f'/sys/bus/pci/devices/{self.pci}/driver')
        if driver.exists():
            with open(driver / 'unbind', 'w') as f:
                f.write(self.pci)
            log.info('Removed driver binding for {self.pci}')

    def bind_driver(self, driver: str):
        '''Bind PCI device to driver'''
        current = self.driver
        if current == driver:
            return
        if current: # device is bound to another driver
            self.unbind_driver()
        with open(f'/sys/bus/pci/drivers/{driver}/new_id', 'w') as f:
            f.write(f'{self.vendor} {self.device}')
        log.info('Created driver binding for {self.pci} to {driver}')


def module_loaded(module):
    '''Check if kernel module is loaded'''
    lsmod = subprocess.run(['lsmod'], capture_output=True, check=True)
    module_regex = re.compile(rf'^\s*{module}\s.*$', re.MULTILINE)
    return bool(module_regex.search(lsmod.stdout.decode()))


def rmmod(module):
    '''Unload kernel module'''
    if module_loaded(module):
        subprocess.run(['rmmod', module], capture_output=True, check=True)
        log.info(f'Unloaded kernel module: {module}')


def modprobe(module, *args):
    '''Load kernel module'''
    if args:
        rmmod(module)
    if not module_loaded(module):
        subprocess.run(['modprobe', module] + list(args), capture_output=True, check=True)
        log.info(f'Loaded kernel module: {module}')


def iommu_enabled(vendor):
    '''Check if iommu is enabled'''
    with open('/proc/cmdline') as f:
        cmdline = f.read().strip()
        log.debug(f'Kernel cmdline: {cmdline}')
    iommu = {
        'intel': re.compile(r'\bintel_iommu\s*=\s*on\b'),
    }
    if vendor not in iommu:
        raise ScriptFailure(f'IOMMU status check not implemented for vendor: {vendor}')
    return bool(iommu[vendor].search(cmdline))


def disable_vt_console():
    '''Disable kernel text console'''
    for vtcon in glob.glob('/sys/class/vtconsole/*/bind'):
        with open(vtcon, 'w') as vt:
            vt.write('0')
        log.info(f'Virtual console disabled: {vtcon}')


if __name__ == '__main__':
    main()
