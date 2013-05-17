From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: fix lockdep splat in qib_alloc_lkey()
Date: Fri, 17 May 2013 08:40:32 -0400
Message-ID: <20130517124032.22780.44153.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following backtrace is reported with CONFIG_PROVE_RCU:

kernel: drivers/infiniband/hw/qib/qib_keys.c:64
suspicious rcu_dereference_check() usage!
kernel:
kernel: other info that might help us debug this:
kernel:
:
rcu_scheduler_active = 1, debug_locks = 1
4 locks held by kworker/0:1/56:
kernel: #0:  (events){.+.+.+}, at: [<ffffffff8107a4f5>] process_one_work+0x165/0x4a0
kernel: #1:  ((&wfc.work)){+.+.+.}, at: [<ffffffff8107a4f5>] process_one_work+0x165/0x4a0
kernel: #2:  (device_mutex){+.+.+.}, at: [<ffffffffa0148dd8>] ib_register_device+0x38/0x220 [ib_core]
kernel: #3:  (&(&dev->lk_table.lock)->rlock){......}, at: [<ffffffffa017e81c>] qib_alloc_lkey+0x3c/0x1b0 [ib_qib]
kernel:
kernel: stack backtrace:
kernel: Pid: 56, comm: kworker/0:1 Not tainted 3.10.0-rc1+ #6
kernel: Call Trace:
kernel: [<ffffffff810c0b85>] lockdep_rcu_suspicious+0xe5/0x130
kernel: [<ffffffffa017e8e1>] qib_alloc_lkey+0x101/0x1b0 [ib_qib]
kernel: [<ffffffffa0184886>] qib_get_dma_mr+0xa6/0xd0 [ib_qib]
kernel: [<ffffffffa01461aa>] ib_get_dma_mr+0x1a/0x50 [ib_core]
kernel: [<ffffffffa01678dc>] ib_mad_port_open+0x12c/0x390 [ib_mad]
kernel: [<ffffffff810c2c55>] ?  trace_hardirqs_on_caller+0x105/0x190
kernel: [<ffffffffa0167b92>] ib_mad_init_device+0x52/0x110 [ib_mad]
kernel: [<ffffffffa01917c0>] ?  sl2vl_attr_show+0x30/0x30 [ib_qib]
kernel: [<ffffffffa0148f49>] ib_register_device+0x1a9/0x220 [ib_core]
kernel: [<ffffffffa01b1685>] qib_register_ib_device+0x735/0xa40 [ib_qib]
kernel: [<ffffffff8106ba98>] ? mod_timer+0x118/0x220
kernel: [<ffffffffa017d425>] qib_init_one+0x1e5/0x400 [ib_qib]
kernel: [<ffffffff812ce86e>] local_pci_probe+0x4e/0x90
kernel: [<ffffffff81078118>] work_for_cpu_fn+0x18/0x30
kernel: [<ffffffff8107a566>] process_one_work+0x1d6/0x4a0
kernel: [<ffffffff8107a4f5>] ?  process_one_work+0x165/0x4a0
kernel: [<ffffffff8107c9c9>] worker_thread+0x119/0x370
kernel: [<ffffffff8107c8b0>] ?  manage_workers+0x180/0x180
kernel: [<ffffffff8108294e>] kthread+0xee/0x100
kernel: [<ffffffff81082860>] ?  __init_kthread_worker+0x70/0x70
kernel: [<ffffffff815c04ac>] ret_from_fork+0x7c/0xb0
kernel: [<ffffffff81082860>] ?  __init_kthread_worker+0x70/0x70

Per Documentation/RCU/lockdep-splat.txt, the code now uses rcu_access_pointer()
vs. rcu_dereference().

Reported-by: Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_keys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 81c7b73..3b9afcc 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -61,7 +61,7 @@ int qib_alloc_lkey(struct qib_mregion *mr, int dma_region)
 	if (dma_region) {
 		struct qib_mregion *tmr;
 
-		tmr = rcu_dereference(dev->dma_mr);
+		tmr = rcu_access_pointer(dev->dma_mr);
 		if (!tmr) {
 			qib_get_mr(mr);
 			rcu_assign_pointer(dev->dma_mr, mr);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
