From: Junxue ZHANG <jzhangcs-t+iU6Fs6CelnrVKH7T7RYw@public.gmane.org>
Subject: =?Windows-1252?Q?Problem_of_changing_the_inline_mode_or_turning_on_the_en?=
 =?Windows-1252?Q?capsulation_support_of_Mellanox_NIC=92s_eswitch?=
Date: Mon, 20 Nov 2017 03:29:00 +0000
Message-ID: <HK2PR01MB0834534F555D6F532694DE5AF5220@HK2PR01MB0834.apcprd01.prod.exchangelabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi all,=20

I encountered a problem when I tried to change the inline mode or turn on t=
he encapsulation support of Mellanox NIC=92s eswitch. I wonder if anyone co=
uld help me with this. Thanks.

I want to use VXLan with OVS and try to offload the rules in hardware. I do=
n=92t know whether it is necessary to turn on the encapsulation support. It=
 would also be of great help if anyone could tell me the correct way to acc=
omplish that. Thanks.


Problem:=20
=97=97=97=97=97=97=97=97=97
I can successfully turned on the switchdev mode of my Mellanox NIC. But whe=
n I tried to change the inline-mode or turn on the encapsulation support, i=
t failed.

I can create VFs successfully and use those VFs with switch with link inlin=
e mode and encapsulation support off.

How to reproduce:
=97=97=97=97=97=97=97=97=97
Before each of the following steps, I first turn the switchdev mode off and=
 turn on the legacy mode.

1. Change the inline mode:

$ devlink dev eswitch set pci/0000:81:00.0 mode switchdev inline-mode netwo=
rk
devlink answers: Invalid argument

Output of Syslog:
Nov 20 00:05:04 ip-192-168-2-203 kernel: [ 2968.592023] mlx5_0:wait_for_asy=
nc_commands:735:(pid 2332): done with all pending requests
Nov 20 00:05:04 ip-192-168-2-203 systemd-udevd[2335]: Could not generate pe=
rsistent MAC address for eth0: No such file or directory
Nov 20 00:05:04 ip-192-168-2-203 systemd-udevd[2340]: Could not generate pe=
rsistent MAC address for eth1: No such file or directory
Nov 20 00:05:04 ip-192-168-2-203 kernel: [ 2968.707239] (0000:81:00.0): E-S=
witch: SRIOV enabled: active vports(3)
Nov 20 00:05:04 ip-192-168-2-203 kernel: [ 2968.707712] mlx5_core 0000:81:0=
0.0: mlx5_cmd_check:710:(pid 2332): MODIFY_NIC_VPORT_CONTEXT(0x755) op_mod(=
0x0) failed, status bad parameter(0x3), syndrome (0x40ea03)
Nov 20 00:05:04 ip-192-168-2-203 kernel: [ 2968.707790] (0000:81:00.0): E-S=
witch: Failed to set min inline on vport 1

2. Turn on the encapsulation:

$ devlink dev eswitch set pci/0000:81:00.0 mode switchdev encap enable
devlink answers: Operation not supported

Output of Syslog:

Nov 20 00:06:16 ip-192-168-2-203 kernel: [ 3040.121748] (0000:81:00.0): E-S=
witch: disable SRIOV: active vports(3) mode(1)
Nov 20 00:06:16 ip-192-168-2-203 kernel: [ 3040.161942] (0000:81:00.0): E-S=
witch: E-Switch enable SRIOV: nvfs(2) mode (2)
Nov 20 00:06:18 ip-192-168-2-203 kernel: [ 3042.847377] mlx5_0:wait_for_asy=
nc_commands:735:(pid 2371): done with all pending requests
Nov 20 00:06:19 ip-192-168-2-203 systemd-udevd[2374]: Could not generate pe=
rsistent MAC address for eth0: No such file or directory
Nov 20 00:06:19 ip-192-168-2-203 systemd-udevd[2379]: Could not generate pe=
rsistent MAC address for eth1: No such file or directory
Nov 20 00:06:19 ip-192-168-2-203 kernel: [ 3042.961906] (0000:81:00.0): E-S=
witch: SRIOV enabled: active vports(3)

3. Query the status

$ devlink dev eswitch show pci/0000:81:00.0
pci/0000:81:00.0: mode switchdev inline-mode link encap disable


NIC hardware model:
=97=97=97=97=97=97=97=97=97
ConnectX=AE-4 EN network interface card, 40GbE dual-port QSFP28, PCIe3.0 x8=
, tall bracket, ROHS R6


NIC firmware:
=97=97=97=97=97=97=97=97=97
$ mstflint -d 81:00.1 q

Image type:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 FS3
FW Version:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 12.21.1000
FW Release Date:=A0=A0=A0=A0=A0=A0 29.10.2017
Product Version:=A0=A0=A0=A0=A0=A0 rel-12_21_1000
Rom Info:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 type=3DPXE version=3D3.5.3=
05 devid=3D4115 cpu=3DAMD64
Description:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UID=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 GuidsNumber
Base GUID:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ec0d9a0300373802=A0=A0=A0=A0=
=A0=A0=A0 4
Base MAC:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0000ec0d9a373802=A0=A0=A0=
=A0=A0=A0=A0 4
Image VSD:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 N/A
Device VSD:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 N/A
PSID:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 MT_2130110027
Security Attributes:=A0=A0 N/A

Linux distribution:
=97=97=97=97=97=97=97=97=97
$ cat /etc/*-release

PRETTY_NAME=3D"Debian GNU/Linux 9 (stretch)"
NAME=3D"Debian GNU/Linux"
VERSION_ID=3D"9"
VERSION=3D"9 (stretch)"
ID=3Ddebian
HOME_URL=3D"https://www.debian.org/"
SUPPORT_URL=3D"https://www.debian.org/support"
BUG_REPORT_URL=3D"https://bugs.debian.org/"

Linux kernel:
=97=97=97=97=97=97=97=97=97
$ uname -r

4.14.0-rc7-amd64

NIC driver:
=97=97=97=97=97=97=97=97=97
$ ethtool -i ens6f0

driver: mlx5_core
version: 5.0-0
firmware-version: 12.21.1000 (MT_2130110027)
expansion-rom-version:
bus-info: 0000:81:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes

Best,

Junxue

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
