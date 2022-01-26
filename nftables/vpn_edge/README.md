# Site-to-site VPN router that is connecting several networks together over WAN

This router is simultaneously connected to three kinds of networks:

- **Trusted**: our own networks (possibly in multiple physical locations)
- **Untrusted**: networks outside of our control that we need to have access to
- **WAN**: public internet and other hostile networks

Traffic control logic is explained in the diagram below:

```
+-------------+--------------+--------------+--------------+
|         TO  |   TRUSTED    |  UNTRUSTED   |     WAN      |
|  FROM       |              |              |              |
+-------------+--------------+--------------+--------------+
|  TRUSTED    |    ACCEPT    |    ACCEPT    |    ACCEPT    |
|             |              |              |  Masquerade  |
+-------------+--------------+--------------+--------------+
|  UNTRUSTED  |   Related;   |     DROP     |     DROP     |
|             | Established; |              |              |
|             |    DROP      |              |              |
+-------------+--------------+--------------+--------------+
|  WAN        |   Related;   |     DROP     |     DROP     |
|             | Established; |              |              |
|             |    DROP      |              |              |
+-------------+--------------+--------------+--------------+
```
