From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 1/4] RDMA/mlx5: Fix out-of-bound access while querying AH
Date: Fri, 12 Jan 2018 07:58:39 +0200
Message-ID: <20180112055842.23125-2-leon@kernel.org>
References: <20180112055842.23125-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112055842.23125-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The rdma_ah_find_type() accesses the port array based on index.

Such call to that function before actually checking the index leads
to the following out-of-bound crash.

==================================================================
BUG: KASAN: slab-out-of-bounds in to_rdma_ah_attr+0xa8/0x3b0
Read of size 4 at addr ffff880019ae2268 by task ibv_rc_pingpong/409

CPU: 0 PID: 409 Comm: ibv_rc_pingpong Not tainted 4.15.0-rc2-00031-gb60a3faf5b83-dirty #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
Call Trace:
 dump_stack+0xe9/0x18f
 print_address_description+0xa2/0x350
 kasan_report+0x3a5/0x400
 to_rdma_ah_attr+0xa8/0x3b0
 mlx5_ib_query_qp+0xd35/0x1330
 ib_query_qp+0x8a/0xb0
 ib_uverbs_query_qp+0x237/0x7f0
 ib_uverbs_write+0x617/0xd80
 __vfs_write+0xf7/0x500
 vfs_write+0x149/0x310
 SyS_write+0xca/0x190
 entry_SYSCALL_64_fastpath+0x18/0x85
RIP: 0033:0x7fe9c7a275a0
RSP: 002b:00007ffee5498738 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fe9c7ce4b00 RCX: 00007fe9c7a275a0
RDX: 0000000000000018 RSI: 00007ffee5498800 RDI: 0000000000000003
RBP: 000055d0c8d3f010 R08: 00007ffee5498800 R09: 0000000000000018
R10: 00000000000000ba R11: 0000000000000246 R12: 0000000000008000
R13: 0000000000004fb0 R14: 000055d0c8d3f050 R15: 00007ffee5498560

Allocated by task 1:
 __kmalloc+0x3f9/0x430
 alloc_mad_private+0x25/0x50
 ib_mad_post_receive_mads+0x204/0xa60
 ib_mad_init_device+0xa59/0x1020
 ib_register_device+0x83a/0xbc0
 mlx5_ib_add+0x50e/0x5c0
 mlx5_add_device+0x142/0x410
 mlx5_register_interface+0x18f/0x210
 mlx5_ib_init+0x56/0x63
 do_one_initcall+0x15b/0x270
 kernel_init_freeable+0x2d8/0x3d0
 kernel_init+0x14/0x190
 ret_from_fork+0x24/0x30

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff880019ae2000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 104 bytes to the right of
 512-byte region [ffff880019ae2000, ffff880019ae2200)
The buggy address belongs to the page:
page:000000005d674e18 count:1 mapcount:0 mapping:          (null) index:0x0 compound_mapcount: 0
flags: 0x4000000000008100(slab|head)
raw: 4000000000008100 0000000000000000 0000000000000000 00000001000c000c
raw: dead000000000100 dead000000000200 ffff88001a402000 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff880019ae2100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff880019ae2180: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
>ffff880019ae2200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                          ^
 ffff880019ae2280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff880019ae2300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
Disabling lock debugging due to kernel taint

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Fixes: 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr types")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 31ad28853efa..cffe5966aef9 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4362,12 +4362,11 @@ static void to_rdma_ah_attr(struct mlx5_ib_dev *ibdev,
 
 	memset(ah_attr, 0, sizeof(*ah_attr));
 
-	ah_attr->type = rdma_ah_find_type(&ibdev->ib_dev, path->port);
-	rdma_ah_set_port_num(ah_attr, path->port);
-	if (rdma_ah_get_port_num(ah_attr) == 0 ||
-	    rdma_ah_get_port_num(ah_attr) > MLX5_CAP_GEN(dev, num_ports))
+	if (!path->port || path->port > MLX5_CAP_GEN(dev, num_ports))
 		return;
 
+	ah_attr->type = rdma_ah_find_type(&ibdev->ib_dev, path->port);
+
 	rdma_ah_set_port_num(ah_attr, path->port);
 	rdma_ah_set_sl(ah_attr, path->dci_cfi_prio_sl & 0xf);
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
