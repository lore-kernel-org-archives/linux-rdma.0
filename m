From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Sun, 13 Nov 2011 11:20:21 +0000 (GMT)
Message-ID: <1321183221.65654.YahooMailNeo@web24703.mail.ird.yahoo.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com> <4EBF7F3C.2020804@dev.mellanox.co.il>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EBF7F3C.2020804-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 11/12/2011 05:15 PM, Lukas Razik wrote:

>>  Hello Mr. Sokolovsky,
>>=20
>>  i've built OFED-1.5.3.2 for a linux-2.6.39.4 sparc64 (vanilla) kern=
el.=20
> The IPoIB stuff works fine.
>>=20
>>  If I run 'ibv_devinfo' I get:
>>  ---
>>=20
>>  hca_id: mlx4_0
>> =A0 =A0 =A0 =A0 =A0 transport:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 InfiniBand (0)
>> =A0 =A0 =A0 =A0 =A0 fw_ver:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0  2.6.628
>> =A0 =A0 =A0 =A0 =A0 node_guid:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 0003:ba00:0100:b1d8
>> =A0 =A0 =A0 =A0 =A0 sys_image_guid:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0  =
0003:ba00:0100:b1db
>> =A0 =A0 =A0 =A0 =A0 vendor_id:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 0x03ba
>> =A0 =A0 =A0 =A0 =A0 vendor_part_id:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0  =
25418
>> =A0 =A0 =A0 =A0 =A0 hw_ver:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0  0xA0
>> =A0 =A0 =A0 =A0 =A0 board_id:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0  SUN0070000001
>> =A0 =A0 =A0 =A0 =A0 phys_port_cnt:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 2
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port:=A0  1
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 state:=A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 PORT_ACTIVE (4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 max_mtu:=A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 2048 (4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 active_mtu:=A0 =A0=
 =A0 =A0 =A0 =A0  2048 (4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sm_lid:=A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0  1
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port_lid:=A0 =A0=
 =A0 =A0 =A0 =A0 =A0  6
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port_lmc:=A0 =A0=
 =A0 =A0 =A0 =A0 =A0  0x00
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 link_layer:=A0 =A0=
 =A0 =A0 =A0 =A0  IB[...]
>>  ---
>>=20
>=20
>=20
> Hello Lukas,
> Try to update HCA's firmware to the latest version=20
> (http://www.mellanox.com/content/pages.php?pg=3Dfirmware_download).


Hello Vladimir,

many, many thanks for your fast answer!
But now I have two big problems:

1. problem: The board ID is SUN0070000001 .
If I compare the ibv_devinfo output (mstflint doesn't show me the chip =
rev.) with the Mellanox table I think it's a ConnectX adapter, isn't it=
?
http://www.mellanox.com/content/pages.php?pg=3Dfirmware_HCA_FW_identifi=
cation

So do I get the INI file _and_ the FW file from Oracle?
If I get the INI file only - do I need the following FW file then?
http://www.mellanox.com/downloads/firmware/disclaimer.php?download=3D/d=
ownloads/firmware/ConnectX-rel-2_9_1000.tgz

2. problem: For burning the firmware I need the MFT package, right?
But Mellanox doesn't provide it for sparc64.
I could build the kernel modules of kernel-mft-2.7.1-7.src.rpm without =
any problems.
But the user space stuff is ppc64, x86 and x86_64 only...
Is there maybe a possibility to get sparc64 binaries?

Best regards,
Lukas


PS: That's the output of mstflint
# mstflint -d 12:00.0 q
Image type:=A0=A0=A0=A0=A0 ConnectX
=46W Version:=A0=A0=A0=A0=A0 2.6.628
Device ID:=A0=A0=A0=A0=A0=A0 25418
Description:=A0=A0=A0=A0 Node=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Port1=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Port2=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 Sys image
GUIDs:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0003ba000100b1d8 0003ba000100b1d9 =
0003ba000100b1da 0003ba000100b1db=20
MACs:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0002c9000001=A0=A0=A0=A0 0002c9000002
Board ID:=A0=A0=A0=A0=A0=A0=A0 n/a (SUN0070000001)
VSD:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 n/a
PSID:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 SUN0070000001
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
