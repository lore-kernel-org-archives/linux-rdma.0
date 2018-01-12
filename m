From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/2] RDMA/rxe: Fix rxe_qp_cleanup()
Date: Fri, 12 Jan 2018 15:11:59 -0800
Message-ID: <20180112231159.26569-3-bart.vanassche@wdc.com>
References: <20180112231159.26569-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180112231159.26569-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Moni Shoua <monis@mellanox.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

rxe_qp_cleanup() can sleep so it must be run in thread context and
not in atomic context. This patch avoids that the following bug is
triggered:

Kernel BUG at 00000000560033f3 [verbose debug info unavailable]
BUG: sleeping function called from invalid context at net/core/sock.c:2761
in_atomic(): 1, irqs_disabled(): 0, pid: 7, name: ksoftirqd/0
INFO: lockdep is turned off.
Preemption disabled at:
[<00000000b6e69628>] __do_softirq+0x4e/0x540
CPU: 0 PID: 7 Comm: ksoftirqd/0 Not tainted 4.15.0-rc7-dbg+ #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
Call Trace:
 dump_stack+0x85/0xbf
 ___might_sleep+0x177/0x260
 lock_sock_nested+0x1d/0x90
 inet_shutdown+0x2e/0xd0
 rxe_qp_cleanup+0x107/0x140 [rdma_rxe]
 rxe_elem_release+0x18/0x80 [rdma_rxe]
 rxe_requester+0x1cf/0x11b0 [rdma_rxe]
 rxe_do_task+0x78/0xf0 [rdma_rxe]
 tasklet_action+0x99/0x270
 __do_softirq+0xc0/0x540
 run_ksoftirqd+0x1c/0x70
 smpboot_thread_fn+0x1be/0x270
 kthread+0x117/0x130
 ret_from_fork+0x24/0x30

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Moni Shoua <monis@mellanox.com>
Cc: stable@vger.kernel.org
---
 drivers/infiniband/sw/rxe/rxe_qp.c    | 12 ++++++++++--
 drivers/infiniband/sw/rxe/rxe_verbs.h |  3 +++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 4469592b839d..137d6c0c49d4 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -824,9 +824,9 @@ void rxe_qp_destroy(struct rxe_qp *qp)
 }
 
 /* called when the last reference to the qp is dropped */
-void rxe_qp_cleanup(struct rxe_pool_entry *arg)
+static void rxe_qp_do_cleanup(struct work_struct *work)
 {
-	struct rxe_qp *qp = container_of(arg, typeof(*qp), pelem);
+	struct rxe_qp *qp = container_of(work, typeof(*qp), cleanup_work.work);
 
 	rxe_drop_all_mcast_groups(qp);
 
@@ -859,3 +859,11 @@ void rxe_qp_cleanup(struct rxe_pool_entry *arg)
 	kernel_sock_shutdown(qp->sk, SHUT_RDWR);
 	sock_release(qp->sk);
 }
+
+/* called when the last reference to the qp is dropped */
+void rxe_qp_cleanup(struct rxe_pool_entry *arg)
+{
+	struct rxe_qp *qp = container_of(arg, typeof(*qp), pelem);
+
+	execute_in_process_context(rxe_qp_do_cleanup, &qp->cleanup_work);
+}
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 0c2dbe45c729..1019f5e7dbdd 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -35,6 +35,7 @@
 #define RXE_VERBS_H
 
 #include <linux/interrupt.h>
+#include <linux/workqueue.h>
 #include <rdma/rdma_user_rxe.h>
 #include "rxe_pool.h"
 #include "rxe_task.h"
@@ -281,6 +282,8 @@ struct rxe_qp {
 	struct timer_list rnr_nak_timer;
 
 	spinlock_t		state_lock; /* guard requester and completer */
+
+	struct execute_work	cleanup_work;
 };
 
 enum rxe_mem_state {
-- 
2.15.1
