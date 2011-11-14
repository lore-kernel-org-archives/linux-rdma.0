From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Mon, 14 Nov 2011 17:10:18 +0000 (GMT)
Message-ID: <1321290618.98338.YahooMailNeo@web24709.mail.ird.yahoo.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com> <4EBF7F3C.2020804@dev.mellanox.co.il> <1321183221.65654.YahooMailNeo@web24703.mail.ird.yahoo.com> <4EC0D87E.6090203@dev.mellanox.co.il>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EC0D87E.6090203-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> =A0  hca_id: mlx4_0

>> =A0 =A0 =A0 =A0 =A0 =A0 transport:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 InfiniBand (0)
>> =A0 =A0 =A0 =A0 =A0 =A0 fw_ver:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0  2.6.628
>> =A0 =A0 =A0 =A0 =A0 =A0 node_guid:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 0003:ba00:0100:b1d8
>> =A0 =A0 =A0 =A0 =A0 =A0 sys_image_guid:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
  0003:ba00:0100:b1db
>> =A0 =A0 =A0 =A0 =A0 =A0 vendor_id:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 0x03ba
>> =A0 =A0 =A0 =A0 =A0 =A0 vendor_part_id:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
  25418
>> =A0 =A0 =A0 =A0 =A0 =A0 hw_ver:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0  0xA0
>> =A0 =A0 =A0 =A0 =A0 =A0 board_id:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0  SUN0070000001
>> =A0 =A0 =A0 =A0 =A0 =A0 phys_port_cnt:=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 2
>>=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port:=A0  1
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 state:=A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PORT_ACTIVE (4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 max_mtu:=A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 2048 (4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 active_mtu:=A0=
 =A0 =A0 =A0 =A0 =A0  2048 (4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sm_lid:=A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0  1
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port_lid:=A0=
 =A0 =A0 =A0 =A0 =A0 =A0  6
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 port_lmc:=A0=
 =A0 =A0 =A0 =A0 =A0 =A0  0x00
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 link_layer:=A0=
 =A0 =A0 =A0 =A0 =A0  IB[...]
>>=A0=20
>>
>>  2. problem: For burning the firmware I need the MFT package, right?
>>  But Mellanox doesn't provide it for sparc64.
>>  I could build the kernel modules of kernel-mft-2.7.1-7.src.rpm with=
out any=20
> problems.
>>  But the user space stuff is ppc64, x86 and x86_64 only...
>>  Is there maybe a possibility to get sparc64 binaries?
>
> You can burn FW binary image using mstflint.
> Use MFT (mlxburn) to create the binary image from FW mlx file and ini=
 file. You=20
> can install MFT on some Linux or Windows machine.


Hello Vladimir,

thanks again for this tip!

I need a "/dev/mst/mt25418_pci_cr0" when I use mstflint.
Therefore I've extracted the "/etc/init.d/mst" script from the "mft-2.7=
=2E1-7.x86.rpm"
which creates a "/dev/mst/mt25418_pci_cr0".

But the script outputs errors and I can't use the created device:
# mstflint -d /dev/mst/mt25418_pci_cr0 q
Unable to parse device name /dev/mst/mt25418_pci_cr0
-E- Can not open /dev/mst/mt25418_pci_cr0: Invalid argument MFE_CR_ERRO=
R

Maybe it works when I create "/dev/mst/mt25418_pci_cr0" manually but I =
don't know how.
So could you maybe write a short instruction list for me what I have to=
 do after loading the mst_* modules to get the needed device file? Or d=
o you maybe have another idea how I could flash the firmware?

Regards,
Lukas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
