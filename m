From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Problem of changing the =?utf-8?Q?inli?=
 =?utf-8?Q?ne_mode_or_turning_on_the_encapsulation_support_of_Mellanox_NI?=
 =?utf-8?B?Q+KAmXM=?= eswitch
Date: Mon, 20 Nov 2017 09:23:51 +0200
Message-ID: <20171120072351.GA18825@mtr-leonro.local>
References: <HK2PR01MB0834534F555D6F532694DE5AF5220@HK2PR01MB0834.apcprd01.prod.exchangelabs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j4rZmesUqe38Ef+x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <HK2PR01MB0834534F555D6F532694DE5AF5220-j5d1BCxnhFliu6CZMbmO22kgRNbfFy2WiWZaQy0nMoadU/p4gVGmPFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Junxue ZHANG <jzhangcs-t+iU6Fs6CelnrVKH7T7RYw@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--j4rZmesUqe38Ef+x
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 20, 2017 at 03:29:00AM +0000, Junxue ZHANG wrote:
> Hi all,
>
> I encountered a problem when I tried to change the inline mode or turn on=
 the encapsulation support of Mellanox NIC=E2=80=99s eswitch. I wonder if a=
nyone could help me with this. Thanks.
>
> I want to use VXLan with OVS and try to offload the rules in hardware. I =
don=E2=80=99t know whether it is necessary to turn on the encapsulation sup=
port. It would also be of great help if anyone could tell me the correct wa=
y to accomplish that. Thanks.
>

+ Saeed and Or


The failure in drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
990         err =3D esw_inline_mode_from_devlink(mode, &mlx5_mode);
991         if (err)
992                 goto out;
993
994         for (vport =3D 1; vport < esw->enabled_vports; vport++) {
995                 err =3D mlx5_modify_nic_vport_min_inline(dev, vport, ml=
x5_mode);
996                 if (err) {
997                         esw_warn(dev, "Failed to set min inline on vpor=
t %d\n",
998                                  vport);
999                         goto revert_inline_mode;
1000                 }
1001         }

Thanks

>
> Problem:
> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94
> I can successfully turned on the switchdev mode of my Mellanox NIC. But w=
hen I tried to change the inline-mode or turn on the encapsulation support,=
 it failed.
>
> I can create VFs successfully and use those VFs with switch with link inl=
ine mode and encapsulation support off.
>
> How to reproduce:
> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94
> Before each of the following steps, I first turn the switchdev mode off a=
nd turn on the legacy mode.
>
> 1. Change the inline mode:
>
> $ devlink dev eswitch set pci/0000:81:00.0 mode switchdev inline-mode net=
work
> devlink answers: Invalid argument
>
> Output of Syslog:
> Nov 20 00:05:04 ip-192-168-2-203 kernel: [ 2968.592023] mlx5_0:wait_for_a=
sync_commands:735:(pid 2332): done with all pending requests
> Nov 20 00:05:04 ip-192-168-2-203 systemd-udevd[2335]: Could not generate =
persistent MAC address for eth0: No such file or directory
> Nov 20 00:05:04 ip-192-168-2-203 systemd-udevd[2340]: Could not generate =
persistent MAC address for eth1: No such file or directory
> Nov 20 00:05:04 ip-192-168-2-203 kernel: [ 2968.707239] (0000:81:00.0): E=
-Switch: SRIOV enabled: active vports(3)
> Nov 20 00:05:04 ip-192-168-2-203 kernel: [ 2968.707712] mlx5_core 0000:81=
:00.0: mlx5_cmd_check:710:(pid 2332): MODIFY_NIC_VPORT_CONTEXT(0x755) op_mo=
d(0x0) failed, status bad parameter(0x3), syndrome (0x40ea03)
> Nov 20 00:05:04 ip-192-168-2-203 kernel: [ 2968.707790] (0000:81:00.0): E=
-Switch: Failed to set min inline on vport 1
>
> 2. Turn on the encapsulation:
>
> $ devlink dev eswitch set pci/0000:81:00.0 mode switchdev encap enable
> devlink answers: Operation not supported
>
> Output of Syslog:
>
> Nov 20 00:06:16 ip-192-168-2-203 kernel: [ 3040.121748] (0000:81:00.0): E=
-Switch: disable SRIOV: active vports(3) mode(1)
> Nov 20 00:06:16 ip-192-168-2-203 kernel: [ 3040.161942] (0000:81:00.0): E=
-Switch: E-Switch enable SRIOV: nvfs(2) mode (2)
> Nov 20 00:06:18 ip-192-168-2-203 kernel: [ 3042.847377] mlx5_0:wait_for_a=
sync_commands:735:(pid 2371): done with all pending requests
> Nov 20 00:06:19 ip-192-168-2-203 systemd-udevd[2374]: Could not generate =
persistent MAC address for eth0: No such file or directory
> Nov 20 00:06:19 ip-192-168-2-203 systemd-udevd[2379]: Could not generate =
persistent MAC address for eth1: No such file or directory
> Nov 20 00:06:19 ip-192-168-2-203 kernel: [ 3042.961906] (0000:81:00.0): E=
-Switch: SRIOV enabled: active vports(3)
>
> 3. Query the status
>
> $ devlink dev eswitch show pci/0000:81:00.0
> pci/0000:81:00.0: mode switchdev inline-mode link encap disable
>
>
> NIC hardware model:
> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94
> ConnectX=C2=AE-4 EN network interface card, 40GbE dual-port QSFP28, PCIe3=
=2E0 x8, tall bracket, ROHS R6
>
>
> NIC firmware:
> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94
> $ mstflint -d 81:00.1 q
>
> Image type:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 FS3
> FW Version:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 12.21.1000
> FW Release Date:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 29.10.2017
> Product Version:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rel-12_21_1000
> Rom Info:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 type=3DPXE version=3D3.5.305 devid=3D4115 cpu=3DAMD64
> Description:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
UID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 GuidsNumber
> Base GUID:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ec0d9a0300373802=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4
> Base MAC:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0000ec0d9a373802=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4
> Image VSD:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 N/A
> Device VSD:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 N/A
> PSID:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MT_2130110027
> Security Attributes:=C2=A0=C2=A0 N/A
>
> Linux distribution:
> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94
> $ cat /etc/*-release
>
> PRETTY_NAME=3D"Debian GNU/Linux 9 (stretch)"
> NAME=3D"Debian GNU/Linux"
> VERSION_ID=3D"9"
> VERSION=3D"9 (stretch)"
> ID=3Ddebian
> HOME_URL=3D"https://www.debian.org/"
> SUPPORT_URL=3D"https://www.debian.org/support"
> BUG_REPORT_URL=3D"https://bugs.debian.org/"
>
> Linux kernel:
> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94
> $ uname -r
>
> 4.14.0-rc7-amd64
>
> NIC driver:
> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=
=E2=80=94
> $ ethtool -i ens6f0
>
> driver: mlx5_core
> version: 5.0-0
> firmware-version: 12.21.1000 (MT_2130110027)
> expansion-rom-version:
> bus-info: 0000:81:00.0
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: no
> supports-register-dump: no
> supports-priv-flags: yes
>
> Best,
>
> Junxue
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--j4rZmesUqe38Ef+x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloSgwcACgkQ5GN7iDZy
WKe/ZA/9EJNyxFcylR++CBWicRD1D0YstcgWNfJz2oGRE19S7JBDR6lr16pmn5u8
YZTRkeLvrkFnf8WejiDHkv0RxNTIczEAsmhS1EgWjJ7hYXAuUMMtfx0FxhP1ECDZ
PSrD/+D4C0InWitpCB6JDm4YFJl760MD+EypqhFYzW/YCaGwhfmtwK81YMSs50kt
tOQQuSNkGbH4Wbnh2a52VcNcnbjyV7quQ2mEgmCMMTotAG6Me69pPuIR/B5mA9qD
w1Jp506aGri0gydWYlzymhp+vuGlQMj08dtdWaf3skyheUwMSB7LBytdhD2Hq5TW
1aAhL7f9RCziDl9/t+uu1GOmyHnvCxCqApOlr6jCYvWXuUploFqsqwhOeob4vE9m
n/nco9G+Q1DeOVc7mOsTda/XZ6bOzpFrZvlo6CeTYv383a8/RD0T/J1xJZiC4cxw
jA7ow/hMIrDYwI2PTCi/Iwmwyv9nRaZzrq3ER/3SiIAHIYcD96sxOhdklEvX2whT
y65w7Pt51LvShyeiDkafE04CQlxwaAsdke2nQZq8TxabJCtUvc9Xom8EShyeZMUp
cluzYhyDuFmjokT0RjCF+esNfQn2elv5o2Ff/psUl0kE5Kn/BxnvpdUglWK3f5UY
KNtRDY/tztoUzOlOdeCnBc0Il3YFXi2jUvU6CfEj257zmFZXdyE=
=swOk
-----END PGP SIGNATURE-----

--j4rZmesUqe38Ef+x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
