# Juniper

## Console

Using the console you need to elevate into cli mode:

```
root@:RE:0% cli
root>
```

Then enter `edit` mode:

```
root> edit
Entering configuration mode

[edit]
root#
```

Now edit to your hearts content!

## L3 interface

Add the interface by itself:

```
interfaces {
    vlan {
        unit 44 {
            family inet {
                address 10.10.44.2/24;
            }
        }
    }
}
```

Associate `vlan 44` (i.e. private) with this unit:

```
vlans {
    ...
    private {
        vlan-id 44;
        l3-interface vlan.44;
    }
}
```
> Note vlan.44 maps to vlan unit 44 in the interface config
