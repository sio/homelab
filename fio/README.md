# Disk i/o benchmarks with fio

This directory contains reusable fio configuration for most common i/o
performance tests. Use `make read`, `make write` and `make rw` to launch a
specific subset of available tests or `make all` to execute all tests.

By default all historical runs are logged to `fio.log` in this directory.
Use `make results` to print all historical data and `make results-read`,
`make results-write-random`, `make results-rw-random-4k` to filter by prefix.
