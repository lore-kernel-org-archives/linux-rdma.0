From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: [BUG] Bad page map in process ibv_devinfo
Date: Sat, 12 Nov 2011 15:15:51 +0000 (GMT)
Message-ID: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Mr. Sokolovsky,

i've built OFED-1.5.3.2 for a linux-2.6.39.4 sparc64 (vanilla) kernel. =
The IPoIB stuff works fine.

If I run 'ibv_devinfo' I get:
---

hca_id: mlx4_0
=A0=A0=A0=A0=A0=A0=A0 transport:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 InfiniBand (0)
=A0=A0=A0=A0=A0=A0=A0 fw_ver:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.6.628
=A0=A0=A0=A0=A0=A0=A0 node_guid:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 0003:ba00:0100:b1d8
=A0=A0=A0=A0=A0=A0=A0 sys_image_guid:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 0003:ba00:0100:b1db
=A0=A0=A0=A0=A0=A0=A0 vendor_id:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 0x03ba
=A0=A0=A0=A0=A0=A0=A0 vendor_part_id:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 25418
=A0=A0=A0=A0=A0=A0=A0 hw_ver:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0xA0
=A0=A0=A0=A0=A0=A0=A0 board_id:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 SUN0070000001
=A0=A0=A0=A0=A0=A0=A0 phys_port_cnt:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 2
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 port:=A0=A0 1
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
tate:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PORT_ACTIVE (4=
)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 m=
ax_mtu:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2048 (4)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 a=
ctive_mtu:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2048 (4)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
m_lid:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p=
ort_lid:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 6
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p=
ort_lmc:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x00
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 l=
ink_layer:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 IB[...]
---

But I also get this BUG message from the kernel:
---
[ 9305.698663] swap_free: Bad swap file entry 100005e000061800
[ 9305.698791] BUG: Bad page map in process ibv_devinfo=A0 pte:bc0000c3=
00104848 pmd:00f38054
[ 9305.698908] addr:fffff80100114000 vm_flags:000844fa anon_vma:=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 (null) mapping:fffff807f313a410 index:6180082
[ 9305.699087] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x8/0x38 [ib_uv=
erbs]
[ 9305.699135] Call Trace:
[ 9305.699174]=A0 [00000000004cd558] unmap_vmas+0x514/0x7f4
[ 9305.699302]=A0 [00000000004d1274] unmap_region+0xb4/0x164
[ 9305.699383]=A0 [00000000004d22c0] do_munmap+0x2a8/0x31c
[ 9305.699467]=A0 [000000000042d350] SyS_64_munmap+0x88/0xa8
[ 9305.699550]=A0 [0000000000406154] linux_sparc_syscall+0x34/0x44
---


I've the following
- System: Sun T5120 (SPARC64)

- OS: Debian 6.0.3
- IB-card:
# lspci -s 12:00

12:00.0 InfiniBand: Mellanox Technologies MT25418 [ConnectX VPI PCIe 2.=
0 2.5GT/s - IB DDR / 10GigE] (rev a0)


And same BUG messages with:
- OFED-1.5.3.2 with linux-2.6.38 (vanilla)

- OFED-1.5.4-rc4 with linux-2.6.39.4 (vanilla)


The problem is that I also get such messages when I run openmpi over op=
enib (naturally with another process name than 'ibv_devinfo'). Then mpi=
run dies with an error message. Hence I can't use MPI over the Infiniba=
nd cards...


So is there something I could try to do to get these cards working?
Can I give you more debug information?


I'm very happy about any help!


Regards,
Lukas



PS:
My kernel-config:
http://net.razik.de/linux/T5120/config-2.6.39.4-razik-2011-11-05


The OFED-packets I've installed:

---

kernel-ib
ofed-scripts
libibverbs
libibverbs-devel
libibverbs-utils
libmlx4
libmlx4-devel
libibumad
libibumad-devel
libibmad
libibmad-devel
librdmacm
librdmacm-utils
librdmacm-devel
opensm-libs
ibutils
infiniband-diags
ofed-docs
mpi-selector
openmpi_gcc
mpitests_openmpi_gcc
---

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
