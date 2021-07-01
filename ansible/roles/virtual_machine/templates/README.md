# Libvirt templates

## Sane defaults are omitted

- `memballoon` is enabled by default
- Default cache mode for virtual drives is `writeback` but virtio drivers are
  allowed to revert to `writethrough` (which is very performant, almost as
  fast as setting cache to `none`
