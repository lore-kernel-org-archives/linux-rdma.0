From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH V4] mlx4_core: allocate ICM memory in page size chunks
Date: Tue, 29 May 2018 23:34:34 -0400
Message-ID: <7a353b65-6b7f-1aee-1c48-e83c8e02f693@gmail.com>
References: <20180523232246.20445-1-qing.huang@oracle.com>
 <20180525.102321.858995452200286788.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180525.102321.858995452200286788.davem@davemloft.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, qing.huang@oracle.com
Cc: tariqt@mellanox.com, haakon.bugge@oracle.com, yanjun.zhu@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gi-oh.kim@profitbricks.com
List-Id: linux-rdma@vger.kernel.org



On 05/25/2018 10:23 AM, David Miller wrote:
> From: Qing Huang <qing.huang@oracle.com>
> Date: Wed, 23 May 2018 16:22:46 -0700
> 
>> When a system is under memory presure (high usage with fragments),
>> the original 256KB ICM chunk allocations will likely trigger kernel
>> memory management to enter slow path doing memory compact/migration
>> ops in order to complete high order memory allocations.
>>
>> When that happens, user processes calling uverb APIs may get stuck
>> for more than 120s easily even though there are a lot of free pages
>> in smaller chunks available in the system.
>>
>> Syslog:
>> ...
>> Dec 10 09:04:51 slcc03db02 kernel: [397078.572732] INFO: task
>> oracle_205573_e:205573 blocked for more than 120 seconds.
>> ...
>>
>> With 4KB ICM chunk size on x86_64 arch, the above issue is fixed.
>>
>> However in order to support smaller ICM chunk size, we need to fix
>> another issue in large size kcalloc allocations.
>>
>> E.g.
>> Setting log_num_mtt=30 requires 1G mtt entries. With the 4KB ICM chunk
>> size, each ICM chunk can only hold 512 mtt entries (8 bytes for each mtt
>> entry). So we need a 16MB allocation for a table->icm pointer array to
>> hold 2M pointers which can easily cause kcalloc to fail.
>>
>> The solution is to use kvzalloc to replace kcalloc which will fall back
>> to vmalloc automatically if kmalloc fails.
>>
>> Signed-off-by: Qing Huang <qing.huang@oracle.com>
>> Acked-by: Daniel Jurgens <danielj@mellanox.com>
>> Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> 
> Applied, thanks.
> 

I must say this patch causes regressions here.

KASAN is not happy.

It looks that you guys did not really looked at mlx4_alloc_icm()

This function is properly handling high order allocations with fallbacks to order-0 pages
under high memory pressure.

BUG: KASAN: slab-out-of-bounds in to_rdma_ah_attr+0x808/0x9e0 [mlx4_ib]
Read of size 4 at addr ffff8817df584f68 by task qp_listing_test/92585

CPU: 38 PID: 92585 Comm: qp_listing_test Tainted: G           O     
Call Trace:
 [<ffffffffba80d7bb>] dump_stack+0x4d/0x72
 [<ffffffffb951dc5f>] print_address_description+0x6f/0x260
 [<ffffffffb951e1c7>] kasan_report+0x257/0x370
 [<ffffffffb951e339>] __asan_report_load4_noabort+0x19/0x20
 [<ffffffffc0256d28>] to_rdma_ah_attr+0x808/0x9e0 [mlx4_ib]
 [<ffffffffc02785b3>] mlx4_ib_query_qp+0x1213/0x1660 [mlx4_ib]
 [<ffffffffc02dbfdb>] qpstat_print_qp+0x13b/0x500 [ib_uverbs]
 [<ffffffffc02dc3ea>] qpstat_seq_show+0x4a/0xb0 [ib_uverbs]
 [<ffffffffb95f125c>] seq_read+0xa9c/0x1230
 [<ffffffffb96e0821>] proc_reg_read+0xc1/0x180
 [<ffffffffb9577918>] __vfs_read+0xe8/0x730
 [<ffffffffb9578057>] vfs_read+0xf7/0x300
 [<ffffffffb95794d2>] SyS_read+0xd2/0x1b0
 [<ffffffffb8e06b16>] do_syscall_64+0x186/0x420
 [<ffffffffbaa00071>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
RIP: 0033:0x7f851a7bb30d
RSP: 002b:00007ffd09a758c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007f84ff959440 RCX: 00007f851a7bb30d
RDX: 000000000003fc00 RSI: 00007f84ff60a000 RDI: 000000000000000b
RBP: 00007ffd09a75900 R08: 00000000ffffffff R09: 0000000000000000
R10: 0000000000000022 R11: 0000000000000293 R12: 0000000000000000
R13: 000000000003ffff R14: 000000000003ffff R15: 00007f84ff60a000

Allocated by task 4488: 
 save_stack+0x46/0xd0
 kasan_kmalloc+0xad/0xe0
 __kmalloc+0x101/0x5e0
 ib_register_device+0xc03/0x1250 [ib_core]
 mlx4_ib_add+0x27d6/0x4dd0 [mlx4_ib]
 mlx4_add_device+0xa9/0x340 [mlx4_core]
 mlx4_register_interface+0x16e/0x390 [mlx4_core]
 xhci_pci_remove+0x7a/0x180 [xhci_pci]
 do_one_initcall+0xa0/0x230
 do_init_module+0x1b9/0x5a4
 load_module+0x63e6/0x94c0
 SYSC_init_module+0x1a4/0x1c0
 SyS_init_module+0xe/0x10
 do_syscall_64+0x186/0x420
 entry_SYSCALL_64_after_hwframe+0x3d/0xa2

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff8817df584f40
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 8 bytes to the right of
 32-byte region [ffff8817df584f40, ffff8817df584f60)
The buggy address belongs to the page:
page:ffffea005f7d6100 count:1 mapcount:0 mapping:ffff8817df584000 index:0xffff8817df584fc1
flags: 0x880000000000100(slab)
raw: 0880000000000100 ffff8817df584000 ffff8817df584fc1 000000010000003f
raw: ffffea005f3ac0a0 ffffea005c476760 ffff8817fec00900 ffff883ff78d26c0
page dumped because: kasan: bad access detected
page->mem_cgroup:ffff883ff78d26c0

Memory state around the buggy address:
 ffff8817df584e00: 00 03 fc fc fc fc fc fc 00 03 fc fc fc fc fc fc
 ffff8817df584e80: 00 00 00 04 fc fc fc fc 00 00 00 fc fc fc fc fc
>ffff8817df584f00: fb fb fb fb fc fc fc fc 00 00 00 00 fc fc fc fc
                                                          ^
 ffff8817df584f80: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8817df585000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

I will test :

diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
index 685337d58276fc91baeeb64387c52985e1bc6dda..4d2a71381acb739585d662175e86caef72338097 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.c
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
@@ -43,12 +43,13 @@
 #include "fw.h"
 
 /*
- * We allocate in page size (default 4KB on many archs) chunks to avoid high
- * order memory allocations in fragmented/high usage memory situation.
+ * We allocate in as big chunks as we can, up to a maximum of 256 KB
+ * per chunk. Note that the chunks are not necessarily in contiguous
+ * physical memory.
  */
 enum {
-       MLX4_ICM_ALLOC_SIZE     = PAGE_SIZE,
-       MLX4_TABLE_CHUNK_SIZE   = PAGE_SIZE,
+       MLX4_ICM_ALLOC_SIZE     = 1 << 18,
+       MLX4_TABLE_CHUNK_SIZE   = 1 << 18
 };
 
 static void mlx4_free_icm_pages(struct mlx4_dev *dev, struct mlx4_icm_chunk *chunk)
