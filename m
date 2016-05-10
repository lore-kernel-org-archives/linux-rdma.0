From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH] IB/mlx5: set correct gid_tbl_len for MAD_IFC
Date: Tue, 10 May 2016 13:42:02 -0700
Message-ID: <1462912922.23006.3.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here is a bug with mlx5_ib.

commit d603c809ef91fa2d211bde5e95be417847410379
Author: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Fri Mar 11 22:58:35 2016 +0200

    IB/mlx5: Fix decision on using MAD_IFC


This commit causes below WARN. The "ix" returns -1

 658 void ib_cache_gid_set_default_gid(struct ib_device *ib_dev, u8 port,
...

 693                 /* Coudn't find default GID location */
 694                 WARN_ON(ix < 0);
 695 


WARNING: CPU: 1 PID: 2651 at /home/mlin/linux/drivers/infiniband/core/cache.c:717 ib_cache_gid_set_default_gid+0x2f8/0x340 [ib_core]

[  394.725187] CPU: 1 PID: 2651 Comm: modprobe Tainted: G           OE   4.6.0-rc3+ #195
[  394.734464] Hardware name: Dell Inc. OptiPlex 7010/0YXT71, BIOS A15 08/12/2013
[  394.743131]  0000000000000000 ffff88006791b848 ffffffff8132996a 0000000000000000
[  394.752045]  0000000000000000 ffff88006791b888 ffffffff8106a7c7 000002cd00000008
[  394.761426]  0000000000000000 0000000000000001 ffff880063028780 ffff880060d7c000
[  394.770370] Call Trace:
[  394.774749]  [<ffffffff8132996a>] dump_stack+0x63/0x89
[  394.781582]  [<ffffffff8106a7c7>] __warn+0xc7/0xf0
[  394.788325]  [<ffffffff8106a8a8>] warn_slowpath_null+0x18/0x20
[  394.795732]  [<ffffffffc0860c48>] ib_cache_gid_set_default_gid+0x2f8/0x340 [ib_core]
[  394.804556]  [<ffffffff8109ef07>] ? pick_next_task_fair+0x367/0x490
[  394.811923]  [<ffffffff816db9e0>] ? __schedule+0x660/0x770
[  394.818487]  [<ffffffffc08624ef>] add_netdev_ips+0xaf/0xc0 [ib_core]
[  394.825935]  [<ffffffffc0862685>] enum_all_gids_of_dev_cb+0x85/0xc0 [ib_core]
[  394.834155]  [<ffffffffc0861760>] ? rdma_protocol_roce_eth_encap+0x20/0x20 [ib_core]
[  394.842993]  [<ffffffffc085e642>] ib_enum_roce_netdev+0xe2/0x100 [ib_core]
[  394.850959]  [<ffffffffc0862600>] ? is_eth_port_of_netdev+0x90/0x90 [ib_core]
[  394.859193]  [<ffffffffc086281c>] roce_rescan_device+0x1c/0x20 [ib_core]
[  394.866981]  [<ffffffffc0860d7b>] ib_cache_setup_one+0xeb/0x400 [ib_core]
[  394.874851]  [<ffffffffc085e299>] ib_register_device+0x2d9/0x500 [ib_core]
[  394.882807]  [<ffffffffc0979961>] mlx5_ib_add+0xad1/0x1370 [mlx5_ib]
[  394.890211]  [<ffffffff8108dad8>] ? ttwu_do_activate.constprop.81+0x58/0x60
[  394.898212]  [<ffffffff81084224>] ? __alloc_workqueue_key+0x1f4/0x540
[  394.905696]  [<ffffffffc08840ec>] mlx5_add_device+0x3c/0xa0 [mlx5_core]
[  394.913340]  [<ffffffffc09e3000>] ? 0xffffffffc09e3000
[  394.919516]  [<ffffffffc08841bc>] mlx5_register_interface+0x6c/0xa0 [mlx5_core]
[  394.927858]  [<ffffffffc09e3035>] mlx5_ib_init+0x35/0x4b [mlx5_ib]
[  394.935059]  [<ffffffff81002138>] do_one_initcall+0xc8/0x1f0
[  394.941734]  [<ffffffff81159690>] ? __vunmap+0x80/0xd0
[  394.947875]  [<ffffffff8111d04f>] do_init_module+0x56/0x1c8
[  394.954450]  [<ffffffff810dd2be>] load_module+0x1dae/0x2670
[  394.961034]  [<ffffffff810da7b0>] ? __symbol_put+0x50/0x50
[  394.967543]  [<ffffffff810ddd89>] SYSC_finit_module+0xa9/0xd0
[  394.974302]  [<ffffffff810dddc9>] SyS_finit_module+0x9/0x10
[  394.980878]  [<ffffffff816df1b6>] entry_SYSCALL_64_fastpath+0x1e/0xa8
[  394.988336] ---[ end trace df64015bed03617a ]---

[  395.007774] BUG: unable to handle kernel paging request at ffffffffffffffe0

[  395.302076] Call Trace:
[  395.305549]  [<ffffffff8106a7a0>] ? __warn+0xa0/0xf0
[  395.311550]  [<ffffffffc0860bd4>] ib_cache_gid_set_default_gid+0x284/0x340 [ib_core]
[  395.320335]  [<ffffffff816db9e0>] ? __schedule+0x660/0x770
[  395.326868]  [<ffffffffc08624ef>] add_netdev_ips+0xaf/0xc0 [ib_core]
[  395.334268]  [<ffffffffc0862685>] enum_all_gids_of_dev_cb+0x85/0xc0 [ib_core]
[  395.342452]  [<ffffffffc0861760>] ? rdma_protocol_roce_eth_encap+0x20/0x20 [ib_core]
[  395.351239]  [<ffffffffc085e642>] ib_enum_roce_netdev+0xe2/0x100 [ib_core]
[  395.359167]  [<ffffffffc0862600>] ? is_eth_port_of_netdev+0x90/0x90 [ib_core]
[  395.367353]  [<ffffffffc086281c>] roce_rescan_device+0x1c/0x20 [ib_core]
[  395.375115]  [<ffffffffc0860d7b>] ib_cache_setup_one+0xeb/0x400 [ib_core]
[  395.382949]  [<ffffffffc085e299>] ib_register_device+0x2d9/0x500 [ib_core]
[  395.390869]  [<ffffffffc0979961>] mlx5_ib_add+0xad1/0x1370 [mlx5_ib]
[  395.398289]  [<ffffffff8108dad8>] ? ttwu_do_activate.constprop.81+0x58/0x60
[  395.406318]  [<ffffffff81084224>] ? __alloc_workqueue_key+0x1f4/0x540
[  395.413806]  [<ffffffffc08840ec>] mlx5_add_device+0x3c/0xa0 [mlx5_core]
[  395.421467]  [<ffffffffc09e3000>] ? 0xffffffffc09e3000
[  395.427644]  [<ffffffffc08841bc>] mlx5_register_interface+0x6c/0xa0 [mlx5_core]
[  395.436002]  [<ffffffffc09e3035>] mlx5_ib_init+0x35/0x4b [mlx5_ib]
[  395.443222]  [<ffffffff81002138>] do_one_initcall+0xc8/0x1f0
[  395.449938]  [<ffffffff81159690>] ? __vunmap+0x80/0xd0
[  395.456114]  [<ffffffff8111d04f>] do_init_module+0x56/0x1c8
[  395.462722]  [<ffffffff810dd2be>] load_module+0x1dae/0x2670
[  395.469324]  [<ffffffff810da7b0>] ? __symbol_put+0x50/0x50
[  395.475872]  [<ffffffff810ddd89>] SYSC_finit_module+0xa9/0xd0
[  395.482656]  [<ffffffff810dddc9>] SyS_finit_module+0x9/0x10
[  395.489252]  [<ffffffff816df1b6>] entry_SYSCALL_64_fastpath+0x1e/0xa8


Instead of reverting the commit, I tried to find out the cause.

ib_cache_gid_set_default_gid() calls find_gid()

 249 static int find_gid(struct ib_gid_table *table, const union ib_gid *gid,
 250                     const struct ib_gid_attr *val, bool default_gid,
 251                     unsigned long mask, int *pempty)
 252 {
 253         int i = 0;
 254         int found = -1;
 255         int empty = pempty ? -1 : 0;
 256 
 257         while (i < table->sz && (found < 0 || empty < 0)) {

find_gid() returns -1 because table->sz is 0.


 757 static int _gid_table_setup_one(struct ib_device *ib_dev)
 758 {
 759         u8 port;
 760         struct ib_gid_table **table;
 761         int err = 0;
 762 
 763         table = kcalloc(ib_dev->phys_port_cnt, sizeof(*table), GFP_KERNEL);
 764 
 765         if (!table) {
 766                 pr_warn("failed to allocate ib gid cache for %s\n",
 767                         ib_dev->name);
 768                 return -ENOMEM;
 769         }
 770 
 771         for (port = 0; port < ib_dev->phys_port_cnt; port++) {
 772                 u8 rdma_port = port + rdma_start_port(ib_dev);
 773 
 774                 table[port] =
 775                         alloc_gid_table(
 776                                 ib_dev->port_immutable[rdma_port].gid_tbl_len);

"table" is allocated in alloc_gid_table().
And debug shows ib_dev->port_immutable[rdma_port].gid_tbl_len is 0.

"gid_tbl_len" is set in mlx5_query_mad_ifc_port()

498 int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u8 port,
499                             struct ib_port_attr *props)
500 {
...

537         props->gid_tbl_len      = out_mad->data[50];

Debug shows out_mad->data[50] is 0.

So here is the "temporary" patch.
I just copied it from mlx5_query_hca_port()

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 1534af1..ef19b5c 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -534,7 +534,7 @@ int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u8 port,
 	props->state		= out_mad->data[32] & 0xf;
 	props->phys_state	= out_mad->data[33] >> 4;
 	props->port_cap_flags	= be32_to_cpup((__be32 *)(out_mad->data + 20));
-	props->gid_tbl_len	= out_mad->data[50];
+	props->gid_tbl_len	= mlx5_get_gid_table_len(MLX5_CAP_GEN(mdev, gid_table_size));
 	props->max_msg_sz	= 1 << MLX5_CAP_GEN(mdev, log_max_msg);
 	props->pkey_tbl_len	= mdev->port_caps[port - 1].pkey_table_len;
 	props->bad_pkey_cntr	= be16_to_cpup((__be16 *)(out_mad->data + 46));



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
