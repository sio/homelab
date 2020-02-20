# Check required variables before doing any work

Sample:

```yaml
- hosts: all
  roles:
    - role: require
      require:
        equals:
          variable: value
          var_foo: value_foo
          var_bar: value_bar
        defined:
          - var_boo
          - variable_name
```
