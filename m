From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/cm: Fix false possible recursive locking
Date: Wed, 25 Apr 2012 17:42:35 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373469D8371@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following lockdep problem was reported by Or Gerlitz
<ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>.

=============================================
[ INFO: possible recursive locking detected ]
3.3.0-32035-g1b2649e-dirty #4 Not tainted
---------------------------------------------
kworker/5:1/418 is trying to acquire lock:
 (&id_priv->handler_mutex){+.+.+.}, at: [<ffffffffa0138a41>] rdma_destroy_id+0x33/0x1f0 [rdma_cm]

but task is already holding lock:
 (&id_priv->handler_mutex){+.+.+.}, at: [<ffffffffa0135130>] cma_disable_callback+0x24/0x45 [rdma_cm]

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&id_priv->handler_mutex);
  lock(&id_priv->handler_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/5:1/418:
 #0:  (ib_cm){.+.+.+}, at: [<ffffffff81042ac1>] process_one_work+0x210/0x4a6
 #1:  ((&(&work->work)->work)){+.+.+.}, at: [<ffffffff81042ac1>] process_one_work+0x210/0x4a6
 #2:  (&id_priv->handler_mutex){+.+.+.}, at: [<ffffffffa0135130>] cma_disable_callback+0x24/0x45 [rdma_cm]

stack backtrace:
Pid: 418, comm: kworker/5:1 Not tainted 3.3.0-32035-g1b2649e-dirty #4
Call Trace:
 [<ffffffff8102b0fb>] ? console_unlock+0x1f4/0x204
 [<ffffffff81068771>] __lock_acquire+0x16b5/0x174e
 [<ffffffff8106461f>] ? save_trace+0x3f/0xb3
 [<ffffffff810688fa>] lock_acquire+0xf0/0x116
 [<ffffffffa0138a41>] ? rdma_destroy_id+0x33/0x1f0 [rdma_cm]
 [<ffffffff81364351>] mutex_lock_nested+0x64/0x2ce
 [<ffffffffa0138a41>] ? rdma_destroy_id+0x33/0x1f0 [rdma_cm]
 [<ffffffff81065a78>] ? trace_hardirqs_on_caller+0x11e/0x155
 [<ffffffff81065abc>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa0138a41>] rdma_destroy_id+0x33/0x1f0 [rdma_cm]
 [<ffffffffa0139c02>] cma_req_handler+0x418/0x644 [rdma_cm]
 [<ffffffffa012ee88>] cm_process_work+0x32/0x119 [ib_cm]
 [<ffffffffa0130299>] cm_req_handler+0x928/0x982 [ib_cm]
 [<ffffffffa01302f3>] ? cm_req_handler+0x982/0x982 [ib_cm]
 [<ffffffffa0130326>] cm_work_handler+0x33/0xfe5 [ib_cm]
 [<ffffffff81065a78>] ? trace_hardirqs_on_caller+0x11e/0x155
 [<ffffffffa01302f3>] ? cm_req_handler+0x982/0x982 [ib_cm]
 [<ffffffff81042b6e>] process_one_work+0x2bd/0x4a6
 [<ffffffff81042ac1>] ? process_one_work+0x210/0x4a6
 [<ffffffff813669f3>] ? _raw_spin_unlock_irq+0x2b/0x40
 [<ffffffff8104316e>] worker_thread+0x1d6/0x350
 [<ffffffff81042f98>] ? rescuer_thread+0x241/0x241
 [<ffffffff81046a32>] kthread+0x84/0x8c
 [<ffffffff8136e854>] kernel_thread_helper+0x4/0x10
 [<ffffffff81366d59>] ? retint_restore_args+0xe/0xe
 [<ffffffff810469ae>] ? __init_kthread_worker+0x56/0x56
 [<ffffffff8136e850>] ? gs_change+0xb/0xb

The actual locking is fine, since we're dealing with different locks, but
from the same lock class.  cma_disable_callback() acquires the listening
id mutex, whereas rdma_destroy_id() acquires the mutex for the new
connection id.  To fix this, delay the call to rdma_destroy_id() until
we've released the listening id mutex.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   42 +++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e3e470f..79c7eeb 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1218,13 +1218,13 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	}
 	if (!conn_id) {
 		ret = -ENOMEM;
-		goto out;
+		goto err1;
 	}
 
 	mutex_lock_nested(&conn_id->handler_mutex, SINGLE_DEPTH_NESTING);
 	ret = cma_acquire_dev(conn_id);
 	if (ret)
-		goto release_conn_id;
+		goto err2;
 
 	conn_id->cm_id.ib = cm_id;
 	cm_id->context = conn_id;
@@ -1236,31 +1236,33 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	 */
 	atomic_inc(&conn_id->refcount);
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
-	if (!ret) {
-		/*
-		 * Acquire mutex to prevent user executing rdma_destroy_id()
-		 * while we're accessing the cm_id.
-		 */
-		mutex_lock(&lock);
-		if (cma_comp(conn_id, RDMA_CM_CONNECT) && (conn_id->id.qp_type != IB_QPT_UD))
-			ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
-		mutex_unlock(&lock);
-		mutex_unlock(&conn_id->handler_mutex);
-		cma_deref_id(conn_id);
-		goto out;
-	}
+	if (ret)
+		goto err3;
+
+	/*
+	 * Acquire mutex to prevent user executing rdma_destroy_id()
+	 * while we're accessing the cm_id.
+	 */
+	mutex_lock(&lock);
+	if (cma_comp(conn_id, RDMA_CM_CONNECT) && (conn_id->id.qp_type != IB_QPT_UD))
+		ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
+	mutex_unlock(&lock);
+	mutex_unlock(&conn_id->handler_mutex);
+	mutex_unlock(&listen_id->handler_mutex);
 	cma_deref_id(conn_id);
+	return 0;
 
+err3:
+	cma_deref_id(conn_id);
 	/* Destroy the CM ID by returning a non-zero value. */
 	conn_id->cm_id.ib = NULL;
-
-release_conn_id:
+err2:
 	cma_exch(conn_id, RDMA_CM_DESTROYING);
 	mutex_unlock(&conn_id->handler_mutex);
-	rdma_destroy_id(&conn_id->id);
-
-out:
+err1:
 	mutex_unlock(&listen_id->handler_mutex);
+	if (conn_id)
+		rdma_destroy_id(&conn_id->id);
 	return ret;
 }
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
