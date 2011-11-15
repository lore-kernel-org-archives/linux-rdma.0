From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Tue, 15 Nov 2011 20:03:35 +0000 (GMT)
Message-ID: <1321387415.58210.YahooMailNeo@web24716.mail.ird.yahoo.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com> <4EBF7F3C.2020804@dev.mellanox.co.il> <CAL1RGDV3X=vrCC4YCuUBRx9UwMQp0LfRG0y6Lh5z6hx4ROZ4yw@mail.gmail.com> <1321315430.19223.YahooMailNeo@web24701.mail.ird.yahoo.com> <CAL1RGDVas0srOARofFV2e9=9_5z+VTTpa1k+Eh532xxGVC0uyw@mail.gmail.com> <CAL1RGDWNJrbVkTTQ9sDod_x5H6FBEWkyqXT=--TomX1DhTRSmA@mail.gmail.com>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWNJrbVkTTQ9sDod_x5H6FBEWkyqXT=--TomX1DhTRSmA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:

> On Tue, Nov 15, 2011 at 11:10 AM, Roland Dreier <roland@purestorage.c=
om>=20
> wrote:
>>  Sorry, I missed the "vanilla" in your original email and just saw=20
> "OFED".
>>=20
>>  Anyway yes, looks like a bug in the mlx4 driver.
>=20
> Actually where is your mlx4 driver coming from?=A0 The upstream kerne=
l or OFED?

It comes from OFED.
Here it's from OFED-1.5.4 (although you see v1.0-ofed1.5.3 in the kerne=
l log).I think at this point it's useful to show all relevant (i.e. ofe=
d regarding) parts of the kernel log:

[=A0 195.010076] mlx4_core: Mellanox ConnectX core driver v1.0-ofed1.5.=
3 (January 19, 2011)
[=A0 195.010208] mlx4_core: Initializing 0000:12:00.0
[=A0 195.010294] PCI: Enabling device: (0000:12:00.0), cmd 2
[=A0 195.010356] mlx4_core 0000:12:00.0: Warning: couldn't set 64-bit P=
CI DMA mask.
[=A0 195.010469] mlx4_core 0000:12:00.0: Warning: couldn't set 64-bit c=
onsistent PCI DMA mask.
<snip>
[=A0 197.479244] Kernel unaligned access at TPC[10061624] mlx4_QUERY_AD=
APTER+0xf0/0x11c [mlx4_core]
[=A0 197.479424] Kernel unaligned access at TPC[10061624] mlx4_QUERY_AD=
APTER+0xf0/0x11c [mlx4_core]
[=A0 197.479594] Kernel unaligned access at TPC[10061624] mlx4_QUERY_AD=
APTER+0xf0/0x11c [mlx4_core]
[=A0 197.479764] Kernel unaligned access at TPC[10061624] mlx4_QUERY_AD=
APTER+0xf0/0x11c [mlx4_core]

<snip>

[=A0 231.377790] mlx4_ib: Mellanox ConnectX InfiniBand driver v1.0-ofed=
1.5.3 (January 19, 2011)
[=A0 232.217620] ADDRCONF(NETDEV_UP): ib0: link is not ready
[=A0 233.782679] ib0: enabling connected mode will cause multicast pack=
et drops
[=A0 233.782810] ib0: mtu > 2044 will cause multicast packet drops.
[=A0 233.782916] ib0: mtu > 2044 will cause multicast packet drops.
[=A0 234.860368] ib1: enabling connected mode will cause multicast pack=
et drops
[=A0 234.860502] ib1: mtu > 2044 will cause multicast packet drops.
[=A0 234.860613] ib1: mtu > 2044 will cause multicast packet drops.
[=A0 235.225652] ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready
[=A0 246.210384] ib0: no IPv6 routers present
[=A0 650.857233] swap_free: Bad swap file entry 100005e000061800
[=A0 650.857363] BUG: Bad page map in process ibv_devinfo=A0 pte:bc0000=
c300104848 pmd:00fc9bc4
[=A0 650.857481] addr:fffff80100114000 vm_flags:000844fa anon_vma:=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 (null) mapping:fffff807f6e06b38 index:6180082
[=A0 650.857661] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x8/0x38 [ib_=
uverbs]
[=A0 650.857708] Call Trace:
[=A0 650.857747]=A0 [00000000004cd430] unmap_vmas+0x514/0x7f4
[=A0 650.857826]=A0 [00000000004d114c] unmap_region+0xb4/0x164
[=A0 650.857875]=A0 [00000000004d2198] do_munmap+0x2a8/0x31c
[=A0 650.857958]=A0 [000000000042d340] SyS_64_munmap+0x88/0xa8
[=A0 650.858042]=A0 [0000000000406154] linux_sparc_syscall+0x34/0x44
[=A0 650.858116] Disabling lock debugging due to kernel taint


Please ask if you need more information. I'll provide them promptly.

Regards,
Lukas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
