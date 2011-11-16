From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Wed, 16 Nov 2011 18:56:05 +0000 (GMT)
Message-ID: <1321469765.79338.YahooMailNeo@web24712.mail.ird.yahoo.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com> <4EBF7F3C.2020804@dev.mellanox.co.il> <CAL1RGDV3X=vrCC4YCuUBRx9UwMQp0LfRG0y6Lh5z6hx4ROZ4yw@mail.gmail.com> <1321315430.19223.YahooMailNeo@web24701.mail.ird.yahoo.com> <CAL1RGDVas0srOARofFV2e9=9_5z+VTTpa1k+Eh532xxGVC0uyw@mail.gmail.com> <CAL1RGDWNJrbVkTTQ9sDod_x5H6FBEWkyqXT=--TomX1DhTRSmA@mail.gmail.com> <1321387415.58210.YahooMailNeo@web24716.mail.ird.yahoo.com> <CAL1RGDXa8hy-Hg-eauj3NbPv=YsFjpQkNq1fTF1qpE7cdhRdng@mail.gmail.com> <1321402689.7734.YahooMailNeo@web24705.mail.ird.yahoo.com> <1321451273.56607.YahooMailNeo@web24706.mail.ird.yahoo.com>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321451273.56607.YahooMailNeo-C13AICjm7gDyX4RqAA4FmIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org> wrote:

> I get this BUG message from the kernel:
> [ 1032.739077] swap_free: Bad swap file entry 100005e000061800
> [ 1032.739206] BUG: Bad page map in process ibv_devinfo=A0 pte:bc0000=
c300104848=20
> pmd:00fc947c
> [ 1032.739324] addr:fffff80100114000 vm_flags:000844fa anon_vma:=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 (null)=20
> mapping:fffff807f5d1c930 index:6180082
> [ 1032.739503] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x8/0x38=20
> [ib_uverbs]
> [ 1032.739551] Call Trace:
> [ 1032.739589]=A0 [00000000004cd430] unmap_vmas+0x514/0x7f4
> [ 1032.739641]=A0 [00000000004d114c] unmap_region+0xb4/0x164
> [ 1032.739690]=A0 [00000000004d2198] do_munmap+0x2a8/0x31c
> [ 1032.739744]=A0 [000000000042d340] SyS_64_munmap+0x88/0xa8
> [ 1032.739800]=A0 [0000000000406154] linux_sparc_syscall+0x34/0x44
> [ 1032.739845] Disabling lock debugging due to kernel taint
>=20
> I also get such BUG messages when I try to use OpenMPI over Infiniban=
d and=20
> mpirun dies.
> Same with:
> - OFED-1.5.3.2 and linux-2.6.39.4 vanilla
> - OFED-1.5.3.2 and linux-2.6.38
>=20

I've tried a rather old kernel, too. I get same BUG messages with:
- OFED-1.5.3.2 and linux-2.6.29 vanilla
- linux-2.6.39.4 vanilla (with the included Infiniband modules - not th=
e modules from OFED)

That's the whole conversation:
http://thread.gmane.org/gmane.linux.drivers.rdma/10157

Regards,
Lukas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
