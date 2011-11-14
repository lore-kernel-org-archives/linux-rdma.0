From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Mon, 14 Nov 2011 21:10:22 +0000 (GMT)
Message-ID: <1321305022.98364.YahooMailNeo@web24703.mail.ird.yahoo.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com> <4EBF7F3C.2020804@dev.mellanox.co.il> <1321183221.65654.YahooMailNeo@web24703.mail.ird.yahoo.com> <4EC0D87E.6090203@dev.mellanox.co.il> <1321290618.98338.YahooMailNeo@web24709.mail.ird.yahoo.com>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321290618.98338.YahooMailNeo-KNHbfBHkazLyX4RqAA4FmIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>>  =A0=A0 hca_id: mlx4_0
>>>  =A0 =A0 =A0 =A0 =A0 =A0 transport:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 InfiniBand (0)

>>>  =A0 =A0 =A0 =A0 =A0 =A0 fw_ver:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0=A0 2.6.628
>>>  =A0 =A0 =A0 =A0 =A0 =A0 node_guid:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 0003:ba00:0100:b1d8
>>>  =A0 =A0 =A0 =A0 =A0 =A0 sys_image_guid:=A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0=A0 0003:ba00:0100:b1db
>>>  =A0 =A0 =A0 =A0 =A0 =A0 vendor_id:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 0x03ba
>>>  =A0 =A0 =A0 =A0 =A0 =A0 vendor_part_id:=A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0=A0 25418
>>>  =A0 =A0 =A0 =A0 =A0 =A0 hw_ver:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0=A0 0xA0
>>>  =A0 =A0 =A0 =A0 =A0 =A0 board_id:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0=A0 SUN0070000001
>>>  =A0 =A0 =A0 =A0 =A0 =A0 phys_port_cnt:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 2
>>> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port:=A0=A0 1
>>>  =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 state:=A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PORT_ACTIVE (4)
>>>  =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 max_mtu:=A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 2048 (4)
>>>  =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 active_mtu=
:=A0 =A0 =A0 =A0 =A0 =A0=A0 2048 (4)
>>>  =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sm_lid:=A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0 1
>>>  =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port_lid:=A0=
 =A0 =A0 =A0 =A0 =A0 =A0=A0 6
>>>  =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port_lmc:=A0=
 =A0 =A0 =A0 =A0 =A0 =A0=A0 0x00
>>>  =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 link_layer=
:=A0 =A0 =A0 =A0 =A0 =A0=A0 IB[...]
>>> =A0=20
>>>=20
>>  You can burn FW binary image using mstflint.
>
> I need a "/dev/mst/mt25418_pci_cr0" when I use mstflint.
> Therefore I've extracted the "/etc/init.d/mst" script from the=20
> "mft-2.7.1-7.x86.rpm"
> which creates a "/dev/mst/mt25418_pci_cr0".


Hello again, Vladimir!

To set up "/dev/mst/mt25418_pci_cr0" manually I've followed up what "/e=
tc/init.d/mst start" does.
I've seen that it uses the "minit" tool which is part of the arch depen=
dent mft-package.

Is there maybe a possibility to get "minit" for sparc64?
Otherwise I can't init "/dev/mst/mt25418_pci_cr0"... :-(

Many thanks for your time!

Best regards,
Lukas


PS: These are my steps:
# mkdir /dev/mst
# modprobe mst_pci
# modprobe mst_pciconf

I've looked up the pcimajor and piconfmajor :
# cat /proc/devices | grep mst_
251 mst_pciconf
252 mst_pci

Then the script finds the follwing PCI-card from its 'dev_id_database' =
:
# lspci -m -n -d 15b3:634a
12:00.0 "0c06" "15b3" "634a" -ra0 "15b3" "634a"
which is the ConnectX controller:
# lspci -s 12:00.0
12:00.0 InfiniBand: Mellanox Technologies MT25418 [ConnectX VPI PCIe 2.=
0 2.5GT/s - IB DDR / 10GigE] (rev a0)

With all these information it creates the device file:
# mknod -m 666 /dev/mst/mt25418_pci_cr0 c 252 0

And now I need the "minit" command from the mft package.
# /usr/bin/minit /dev/mst/mt25418_pci_cr0 12:00.0 0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
