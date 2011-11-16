From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Wed, 16 Nov 2011 00:18:09 +0000 (GMT)
Message-ID: <1321402689.7734.YahooMailNeo@web24705.mail.ird.yahoo.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com> <4EBF7F3C.2020804@dev.mellanox.co.il> <CAL1RGDV3X=vrCC4YCuUBRx9UwMQp0LfRG0y6Lh5z6hx4ROZ4yw@mail.gmail.com> <1321315430.19223.YahooMailNeo@web24701.mail.ird.yahoo.com> <CAL1RGDVas0srOARofFV2e9=9_5z+VTTpa1k+Eh532xxGVC0uyw@mail.gmail.com> <CAL1RGDWNJrbVkTTQ9sDod_x5H6FBEWkyqXT=--TomX1DhTRSmA@mail.gmail.com> <1321387415.58210.YahooMailNeo@web24716.mail.ird.yahoo.com> <CAL1RGDXa8hy-Hg-eauj3NbPv=YsFjpQkNq1fTF1qpE7cdhRdng@mail.gmail.com>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXa8hy-Hg-eauj3NbPv=YsFjpQkNq1fTF1qpE7cdhRdng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:

> If it's possible, it would be useful to try with the vanilla kernel
> and all upstream
> modules too.=A0 Otherwise I can't rule out the possiblity that we're=20
> chasing a
> bug that OFED introduces.

OK, I've tested the modules from the kernel.

What I've done:
I've built linux-2.6.39.4 (vanilla) with the belonging Infiniband drive=
rs.
I've installed OFED-1.5.4-rc4 as usual and deleted the new modules in '=
/lib/modules/<version>/update/drivers' (because we want to use the linu=
x-2.6.39.4 modules).
I've run 'depmod -a'.

When I executed '/etc/init.d/openib start' I've got this kernel log:
[ 1438.479977] mlx4_core: Mellanox ConnectX core driver v0.01 (May 1, 2=
007)
[ 1438.480106] mlx4_core: Initializing 0000:12:00.0
[ 1438.480229] mlx4_core 0000:12:00.0: Warning: couldn't set 64-bit PCI=
 DMA mask.
[ 1438.480348] mlx4_core 0000:12:00.0: Warning: couldn't set 64-bit con=
sistent PCI DMA mask.
[ 1440.546533] Kernel unaligned access at TPC[102df650] mlx4_QUERY_ADAP=
TER+0xf0/0x11c [mlx4_core]
[ 1440.546704] Kernel unaligned access at TPC[102df650] mlx4_QUERY_ADAP=
TER+0xf0/0x11c [mlx4_core]
[ 1440.546865] Kernel unaligned access at TPC[102df650] mlx4_QUERY_ADAP=
TER+0xf0/0x11c [mlx4_core]
[ 1440.547026] Kernel unaligned access at TPC[102df650] mlx4_QUERY_ADAP=
TER+0xf0/0x11c [mlx4_core]
[ 1440.771361] mlx4_core 0000:12:00.0: Sense command failed for port: 1
[ 1440.771926] mlx4_core 0000:12:00.0: Sense command failed for port: 2
[ 1440.884909] mlx4_ib: Mellanox ConnectX InfiniBand driver v1.0 (April=
 4, 2008)
[ 1441.469341] ADDRCONF(NETDEV_UP): ib0: link is not ready
[ 1442.860385] ib0: enabling connected mode will cause multicast packet=
 drops
[ 1442.886875] ib0: mtu > 2044 will cause multicast packet drops.
[ 1443.932557] ib1: enabling connected mode will cause multicast packet=
 drops
[ 1443.938749] ib1: mtu > 2044 will cause multicast packet drops.
[ 1444.481266] ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready


Then I executed 'ibv_devinfo' and got erros (which I hadn't with the ke=
rnel modules from OFED):
# ibv_devinfo=20
mlx4: There is a mismatch between the kernel and the userspace librarie=
s: Kernel does not support XRC. Exiting.
=46ailed to open device

And the error in the kernel log was existent, too:
[ 1464.503632] swap_free: Bad swap file entry 100005e000061800
[ 1464.503759] BUG: Bad page map in process ibv_devinfo=A0 pte:bc0000c3=
00104848 pmd:00fe46f0
[ 1464.503877] addr:fffff80100114000 vm_flags:000844fa anon_vma:=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 (null) mapping:fffff807f401b6a0 index:6180082
[ 1464.504054] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x8/0x38 [ib_uv=
erbs]
[ 1464.504102] Call Trace:
[ 1464.504141]=A0 [00000000004cd430] unmap_vmas+0x514/0x7f4
[ 1464.504191]=A0 [00000000004d114c] unmap_region+0xb4/0x164
[ 1464.504269]=A0 [00000000004d2198] do_munmap+0x2a8/0x31c
[ 1464.504323]=A0 [000000000042d340] SyS_64_munmap+0x88/0xa8
[ 1464.504378]=A0 [0000000000406154] linux_sparc_syscall+0x34/0x44
[ 1464.504423] Disabling lock debugging due to kernel taint
[ 1464.504478] swap_free: Bad swap file entry 100005e000061802
[ 1464.504526] BUG: Bad page map in process ibv_devinfo=A0 pte:bc0000c3=
00504848 pmd:00fe46f0
[ 1464.504585] addr:fffff8010011a000 vm_flags:000844fa anon_vma:=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 (null) mapping:fffff807f401b6a0 index:6180282
[ 1464.504665] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x8/0x38 [ib_uv=
erbs]
[ 1464.504711] Call Trace:
[ 1464.504742]=A0 [00000000004cd430] unmap_vmas+0x514/0x7f4
[ 1464.504790]=A0 [00000000004d114c] unmap_region+0xb4/0x164
[ 1464.504838]=A0 [00000000004d2198] do_munmap+0x2a8/0x31c
[ 1464.504888]=A0 [000000000042d340] SyS_64_munmap+0x88/0xa8
[ 1464.504967]=A0 [0000000000406154] linux_sparc_syscall+0x34/0x44

BTW: I'm still trying to get the new firmware for my adapters. Maybe it=
 clicks tomorrow...

Regards,
Lukas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
