class TinyMeta(object):
    def __init__(self, prog):
        self.prog = prog
        prog.wake()
        self.root = {
            "boardmeta": {
                "hver": "0.0.0",
                "name": "TinyFPGA BX",
                "fpga": "ICE40LP8K-cm81",
                "uuid": "4a300a6f-895a-44d3-b021-356c6b38b339",
            },
            "bootmeta": {
                "bver": "2.0.0",
                "bootloader": "TinyFPGA USB Bootloader",
                "update": "https://tinyfpga.com/update/tinyfpga-bx",
                "addrmap": {
                    "bootloader": "0x00000-0x28000",
                    "userimage":  "0x28000-0x50000",
                    "userdata":   "0x50000-0xFC000",
                    "desc.tgz":   "0xFC000-0xFFFFF"
                }
            }
        }
