# Windows 10

## Installation image url

Open <https://www.microsoft.com/en-us/software-download/windows10ISO/> with
any non-Windows user agent (e.g. Ipad via Chrome/Firefox Developer Tools) and
fill in the form to receive download URL (valid only for 24 hours).


## Notes

- When running `make build` remotely via ssh make sure to use some kind of
  session manager like tmux or screen. Otherwise connectivity issues between
  control machine and build machine will result in build being killed for no
  good reason.
