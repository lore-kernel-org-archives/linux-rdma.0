From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: MLX5 iSER issue on 4.6?
Date: Fri, 27 May 2016 16:32:33 -0600
Message-ID: <CAANLjFpPoynQeBiQjZ=2RA1YHaNp3jZKtavZ5URWcsJu+x85vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I've been running iSER on 4.1/4.4 with a Connect-IB and ConnectX-3 and
everything works fine. When running the 4.6 kernel, the Connect-IB
card aren't able to login to iSER even though the ConnectX-3 card does
just fine. Hopefully, someone here has an idea of what the issue may
be. For this test, we are making 12 sessions to the same host (three
ports on each host, four sessions per port). Only four sessions become
established which correlate to the ConnectX-3 card. It doesn't seem to
matter which kernel the target is on, only the initiator.

02:00.0 Network controller: Mellanox Technologies MT27500 Family [ConnectX-3]
81:00.0 Infiniband controller: Mellanox Technologies MT27600 [Connect-IB]

# mstflint -d 02:00.0 q
Image type:      FS2
FW Version:      2.35.5100
Rom Info:        type=PXE version=3.4.648 devid=4099
Device ID:       4099
Description:     Node             Port1            Port2            Sys image
GUIDs:           0cc47affff4fea34 0cc47affff4fea35 0cc47affff4fea36
0cc47affff4fea37
MACs:                                 0cc47a4fea35     0cc47a4fea36
VSD:             n/a
PSID:            SM_2221000001000
# mstflint -d 81:00.0 q
Image type:      FS3
FW Version:      10.0014.1100
FW Release Date: 31.1.2016
Product Version: rel-10_14_1100
Description:     UID                GuidsNumber  Step
Base GUID1:      e41d2d030000e010        8       1
Base GUID2:      e41d2d030000e018        8       1
Base MAC1:       0000e41d2d00e010        8       1
Base MAC2:       0000e41d2d00e018        8       1
Image VSD:
Device VSD:
PSID:            MT_1210110019

# iscsiadm -m session
iser: [36] 10.218.128.17:3260,1 iqn.2003-01.org.setup.lun.test1 (non-flash)
iser: [37] 10.219.128.17:3260,1 iqn.2003-01.org.setup.lun.test1 (non-flash)
iser: [38] 10.220.128.17:3260,1 iqn.2003-01.org.setup.lun.test1 (non-flash)
iser: [39] 10.218.202.17:3260,1 iqn.2003-01.org.setup.lun.test1 (non-flash)
iser: [40] 10.220.202.17:3260,1 iqn.2003-01.org.setup.lun.test1 (non-flash)
iser: [41] 10.218.203.17:3260,1 iqn.2003-01.org.setup.lun.test1 (non-flash)
iser: [42] 10.218.204.17:3260,1 iqn.2003-01.org.setup.lun.test1 (non-flash)
iser: [43] 10.220.203.17:3260,1 iqn.2003-01.org.setup.lun.test1 (non-flash)
iser: [44] 10.220.204.17:3260,1 iqn.2003-01.org.setup.lun.test1 (non-flash)

# lsscsi -l -v
[11:0:0:0]   disk    LIO-ORG  test1            4.0   /dev/sdb
 state=running queue_depth=32 scsi_level=6 type=0 device_blocked=0 timeout=30
 dir: /sys/bus/scsi/devices/11:0:0:0
[/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/host11/session36/target11:0:0/11:0:0:0]
[14:0:0:0]   disk    LIO-ORG  test1            4.0   /dev/sdc
 state=running queue_depth=32 scsi_level=6 type=0 device_blocked=0 timeout=30
 dir: /sys/bus/scsi/devices/14:0:0:0
[/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/host14/session39/target14:0:0/14:0:0:0]
[16:0:0:0]   disk    LIO-ORG  test1            4.0   /dev/sdd
 state=running queue_depth=32 scsi_level=6 type=0 device_blocked=0 timeout=30
 dir: /sys/bus/scsi/devices/16:0:0:0
[/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/host16/session41/target16:0:0/16:0:0:0]
[17:0:0:0]   disk    LIO-ORG  test1            4.0   /dev/sde
 state=running queue_depth=32 scsi_level=6 type=0 device_blocked=0 timeout=30
 dir: /sys/bus/scsi/devices/17:0:0:0
[/sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/host17/session42/target17:0:0/17:0:0:0]


# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
group default qlen 1
   link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
   inet 127.0.0.1/8 scope host lo
      valid_lft forever preferred_lft forever
   inet6 ::1/128 scope host
      valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
group default qlen 1000
   link/ether 0c:c4:7a:74:28:24 brd ff:ff:ff:ff:ff:ff
   inet 10.192.0.18/12 brd 10.207.255.255 scope global eth0
      valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group
default qlen 1000
   link/ether 0c:c4:7a:74:28:25 brd ff:ff:ff:ff:ff:ff
4: ib0: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN group
default qlen 256
   link/infiniband
80:00:02:08:fe:80:00:00:00:00:00:00:0c:c4:7a:ff:ff:4f:ea:35 brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
5: ib1: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN group
default qlen 256
   link/infiniband
80:00:00:36:fe:80:00:00:00:00:00:00:e4:1d:2d:03:00:00:e0:10 brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
6: ib2: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN group
default qlen 256
   link/infiniband
80:00:00:38:fe:80:00:00:00:00:00:00:e4:1d:2d:03:00:00:e0:18 brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
7: ib0.84ab@ib0: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65520
qdisc pfifo_fast state UP group default qlen 256
   link/infiniband
80:00:02:09:fe:80:00:00:00:00:00:00:0c:c4:7a:ff:ff:4f:ea:35 brd
00:ff:ff:ff:ff:12:40:1b:84:ab:00:00:00:00:00:00:ff:ff:ff:ff
   inet 10.217.0.18/16 brd 10.217.255.255 scope global ib0.84ab
      valid_lft forever preferred_lft forever
   inet6 fe80::ec4:7aff:ff4f:ea35/64 scope link
      valid_lft forever preferred_lft forever
8: ib0.9770@ib0: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65520
qdisc pfifo_fast state UP group default qlen 256
   link/infiniband
80:00:02:0a:fe:80:00:00:00:00:00:00:0c:c4:7a:ff:ff:4f:ea:35 brd
00:ff:ff:ff:ff:12:40:1b:97:70:00:00:00:00:00:00:ff:ff:ff:ff
   inet 10.218.128.18/16 brd 10.218.255.255 scope global ib0.9770
      valid_lft forever preferred_lft forever
   inet6 fe80::ec4:7aff:ff4f:ea35/64 scope link
      valid_lft forever preferred_lft forever
9: ib1.9770@ib1: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65520
qdisc pfifo_fast state UP group default qlen 256
   link/infiniband
80:00:00:3b:fe:80:00:00:00:00:00:00:e4:1d:2d:03:00:00:e0:10 brd
00:ff:ff:ff:ff:12:40:1b:97:70:00:00:00:00:00:00:ff:ff:ff:ff
   inet 10.219.128.18/16 brd 10.219.255.255 scope global ib1.9770
      valid_lft forever preferred_lft forever
   inet6 fe80::e61d:2d03:0:e010/64 scope link
      valid_lft forever preferred_lft forever
10: ib2.9770@ib2: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 65520
qdisc pfifo_fast state UP group default qlen 256
   link/infiniband
80:00:00:3d:fe:80:00:00:00:00:00:00:e4:1d:2d:03:00:00:e0:18 brd
00:ff:ff:ff:ff:12:40:1b:97:70:00:00:00:00:00:00:ff:ff:ff:ff
   inet 10.220.128.18/16 brd 10.220.255.255 scope global ib2.9770
      valid_lft forever preferred_lft forever
   inet6 fe80::e61d:2d03:0:e018/64 scope link
      valid_lft forever preferred_lft forever

# for i in {0..2}; do ethtool -i ib${i}; done
driver: ib_ipoib
version: 1.0.0
firmware-version: 2.35.5100
bus-info: 0000:02:00.0
supports-statistics: no
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no
driver: ib_ipoib
version: 1.0.0
firmware-version: 10.14.1100
bus-info: 0000:81:00.0
supports-statistics: no
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no
driver: ib_ipoib
version: 1.0.0
firmware-version: 10.14.1100
bus-info: 0000:81:00.0
supports-statistics: no
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

[ 4980.405578] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4980.413768]  connection44:0: detected conn error (1011)
[ 4981.317301] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4981.317768]  connection37:0: detected conn error (1011)
[ 4981.330503] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4981.331991]  connection40:0: detected conn error (1011)
[ 4981.343592] mlx5_core 0000:81:00.0:
0000:81:00.0:mlx5_get_rsc:59:(pid 0): Async event for bogus resource
0x125
[ 4981.367406]  connection38:0: detected conn error (1011)
[ 4981.727210] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4981.729622]  connection44:0: detected conn error (1011)
[ 4981.743622]  connection43:0: detected conn error (1011)
[ 4983.377350] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4983.411846]  connection37:0: detected conn error (1011)
[ 4983.767503] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4983.775916]  connection40:0: detected conn error (1011)
[ 4983.777828] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4983.790153]  connection38:0: detected conn error (1011)
[ 4984.138063] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4984.138986]  connection43:0: detected conn error (1011)
[ 4984.151393] mlx5_core 0000:81:00.0:
0000:81:00.0:mlx5_get_rsc:59:(pid 0): Async event for bogus resource
0x130
[ 4984.153873]  connection44:0: detected conn error (1011)
[ 4985.778038] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4985.812704]  connection37:0: detected conn error (1011)
[ 4986.177901] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4986.185883]  connection40:0: detected conn error (1011)
[ 4986.187800] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4986.200398]  connection38:0: detected conn error (1011)
[ 4986.558119] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4986.558734]  connection43:0: detected conn error (1011)
[ 4986.571350] iser: iser_qp_event_callback: qp event QP access error (3)
[ 4986.574044]  connection44:0: detected conn error (1011)

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
