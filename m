From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] IB/uverbs: Lock SRQ / CQ / PD objects in a consistent order
Date: Mon, 30 Apr 2012 12:57:38 -0700
Message-ID: <1335815858-27833-2-git-send-email-roland@kernel.org>
References: <1335815858-27833-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335815858-27833-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Since XRC support was added, the uverbs code has locked SRQ, CQ and PD
objects needed during QP and SRQ creation in different orders
depending on the the code path.  This leads to the (at least
theoretical) possibility of deadlock, and triggers the lockdep splat
below.

Fix this by making sure we always lock the SRQ first, then CQs and
finally the PD.

    ======================================================
    [ INFO: possible circular locking dependency detected ]
    3.4.0-rc5+ #34 Not tainted
    -------------------------------------------------------
    ibv_srq_pingpon/2484 is trying to acquire lock:
     (SRQ-uobj){+++++.}, at: [<ffffffffa00af51b>] idr_read_uobj+0x2f/0x4d [ib_uverbs]

    but task is already holding lock:
     (CQ-uobj){+++++.}, at: [<ffffffffa00af51b>] idr_read_uobj+0x2f/0x4d [ib_uverbs]

    which lock already depends on the new lock.

    the existing dependency chain (in reverse order) is:

    -> #2 (CQ-uobj){+++++.}:
           [<ffffffff81070fd0>] lock_acquire+0xbf/0xfe
           [<ffffffff81384f28>] down_read+0x34/0x43
           [<ffffffffa00af51b>] idr_read_uobj+0x2f/0x4d [ib_uverbs]
           [<ffffffffa00af542>] idr_read_obj+0x9/0x19 [ib_uverbs]
           [<ffffffffa00b16c3>] ib_uverbs_create_qp+0x180/0x684 [ib_uverbs]
           [<ffffffffa00ae3dd>] ib_uverbs_write+0xb7/0xc2 [ib_uverbs]
           [<ffffffff810fe47f>] vfs_write+0xa7/0xee
           [<ffffffff810fe65f>] sys_write+0x45/0x69
           [<ffffffff8138cdf9>] system_call_fastpath+0x16/0x1b

    -> #1 (PD-uobj){++++++}:
           [<ffffffff81070fd0>] lock_acquire+0xbf/0xfe
           [<ffffffff81384f28>] down_read+0x34/0x43
           [<ffffffffa00af51b>] idr_read_uobj+0x2f/0x4d [ib_uverbs]
           [<ffffffffa00af542>] idr_read_obj+0x9/0x19 [ib_uverbs]
           [<ffffffffa00af8ad>] __uverbs_create_xsrq+0x96/0x386 [ib_uverbs]
           [<ffffffffa00b31b9>] ib_uverbs_detach_mcast+0x1cd/0x1e6 [ib_uverbs]
           [<ffffffffa00ae3dd>] ib_uverbs_write+0xb7/0xc2 [ib_uverbs]
           [<ffffffff810fe47f>] vfs_write+0xa7/0xee
           [<ffffffff810fe65f>] sys_write+0x45/0x69
           [<ffffffff8138cdf9>] system_call_fastpath+0x16/0x1b

    -> #0 (SRQ-uobj){+++++.}:
           [<ffffffff81070898>] __lock_acquire+0xa29/0xd06
           [<ffffffff81070fd0>] lock_acquire+0xbf/0xfe
           [<ffffffff81384f28>] down_read+0x34/0x43
           [<ffffffffa00af51b>] idr_read_uobj+0x2f/0x4d [ib_uverbs]
           [<ffffffffa00af542>] idr_read_obj+0x9/0x19 [ib_uverbs]
           [<ffffffffa00b1728>] ib_uverbs_create_qp+0x1e5/0x684 [ib_uverbs]
           [<ffffffffa00ae3dd>] ib_uverbs_write+0xb7/0xc2 [ib_uverbs]
           [<ffffffff810fe47f>] vfs_write+0xa7/0xee
           [<ffffffff810fe65f>] sys_write+0x45/0x69
           [<ffffffff8138cdf9>] system_call_fastpath+0x16/0x1b

    other info that might help us debug this:

    Chain exists of:
      SRQ-uobj --> PD-uobj --> CQ-uobj

     Possible unsafe locking scenario:

           CPU0                    CPU1
           ----                    ----
      lock(CQ-uobj);
                                   lock(PD-uobj);
                                   lock(CQ-uobj);
      lock(SRQ-uobj);

     *** DEADLOCK ***

    3 locks held by ibv_srq_pingpon/2484:
     #0:  (QP-uobj){+.+...}, at: [<ffffffffa00b162c>] ib_uverbs_create_qp+0xe9/0x684 [ib_uverbs]
     #1:  (PD-uobj){++++++}, at: [<ffffffffa00af51b>] idr_read_uobj+0x2f/0x4d [ib_uverbs]
     #2:  (CQ-uobj){+++++.}, at: [<ffffffffa00af51b>] idr_read_uobj+0x2f/0x4d [ib_uverbs]

    stack backtrace:
    Pid: 2484, comm: ibv_srq_pingpon Not tainted 3.4.0-rc5+ #34
    Call Trace:
     [<ffffffff8137eff0>] print_circular_bug+0x1f8/0x209
     [<ffffffff81070898>] __lock_acquire+0xa29/0xd06
     [<ffffffffa00af37c>] ? __idr_get_uobj+0x20/0x5e [ib_uverbs]
     [<ffffffffa00af51b>] ? idr_read_uobj+0x2f/0x4d [ib_uverbs]
     [<ffffffff81070fd0>] lock_acquire+0xbf/0xfe
     [<ffffffffa00af51b>] ? idr_read_uobj+0x2f/0x4d [ib_uverbs]
     [<ffffffff81070eee>] ? lock_release+0x166/0x189
     [<ffffffff81384f28>] down_read+0x34/0x43
     [<ffffffffa00af51b>] ? idr_read_uobj+0x2f/0x4d [ib_uverbs]
     [<ffffffffa00af51b>] idr_read_uobj+0x2f/0x4d [ib_uverbs]
     [<ffffffffa00af542>] idr_read_obj+0x9/0x19 [ib_uverbs]
     [<ffffffffa00b1728>] ib_uverbs_create_qp+0x1e5/0x684 [ib_uverbs]
     [<ffffffff81070fec>] ? lock_acquire+0xdb/0xfe
     [<ffffffff81070c09>] ? lock_release_non_nested+0x94/0x213
     [<ffffffff810d470f>] ? might_fault+0x40/0x90
     [<ffffffff810d470f>] ? might_fault+0x40/0x90
     [<ffffffffa00ae3dd>] ib_uverbs_write+0xb7/0xc2 [ib_uverbs]
     [<ffffffff810fe47f>] vfs_write+0xa7/0xee
     [<ffffffff810ff736>] ? fget_light+0x3b/0x99
     [<ffffffff810fe65f>] sys_write+0x45/0x69
     [<ffffffff8138cdf9>] system_call_fastpath+0x16/0x1b

Reported-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |   66 ++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 85231e2..ad750f3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1423,13 +1423,6 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 		}
 		device = xrcd->device;
 	} else {
-		pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
-		scq = idr_read_cq(cmd.send_cq_handle, file->ucontext, 0);
-		if (!pd || !scq) {
-			ret = -EINVAL;
-			goto err_put;
-		}
-
 		if (cmd.qp_type == IB_QPT_XRC_INI) {
 			cmd.max_recv_wr = cmd.max_recv_sge = 0;
 		} else {
@@ -1440,13 +1433,24 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 					goto err_put;
 				}
 			}
-			rcq = (cmd.recv_cq_handle == cmd.send_cq_handle) ?
-			       scq : idr_read_cq(cmd.recv_cq_handle, file->ucontext, 1);
-			if (!rcq) {
-				ret = -EINVAL;
-				goto err_put;
+
+			if (cmd.recv_cq_handle != cmd.send_cq_handle) {
+				rcq = idr_read_cq(cmd.recv_cq_handle, file->ucontext, 0);
+				if (!rcq) {
+					ret = -EINVAL;
+					goto err_put;
+				}
 			}
 		}
+
+		scq = idr_read_cq(cmd.send_cq_handle, file->ucontext, !!rcq);
+		rcq = rcq ?: scq;
+		pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
+		if (!pd || !scq) {
+			ret = -EINVAL;
+			goto err_put;
+		}
+
 		device = pd->device;
 	}
 
@@ -2484,27 +2488,27 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &srq_lock_class);
 	down_write(&obj->uevent.uobject.mutex);
 
-	pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
-	if (!pd) {
-		ret = -EINVAL;
-		goto err;
-	}
-
 	if (cmd->srq_type == IB_SRQT_XRC) {
-		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext, 0);
-		if (!attr.ext.xrc.cq) {
-			ret = -EINVAL;
-			goto err_put_pd;
-		}
-
 		attr.ext.xrc.xrcd  = idr_read_xrcd(cmd->xrcd_handle, file->ucontext, &xrcd_uobj);
 		if (!attr.ext.xrc.xrcd) {
 			ret = -EINVAL;
-			goto err_put_cq;
+			goto err;
 		}
 
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
 		atomic_inc(&obj->uxrcd->refcnt);
+
+		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext, 0);
+		if (!attr.ext.xrc.cq) {
+			ret = -EINVAL;
+			goto err_put_xrcd;
+		}
+	}
+
+	pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
+	if (!pd) {
+		ret = -EINVAL;
+		goto err_put_cq;
 	}
 
 	attr.event_handler  = ib_uverbs_srq_event_handler;
@@ -2581,17 +2585,17 @@ err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
-	if (cmd->srq_type == IB_SRQT_XRC) {
-		atomic_dec(&obj->uxrcd->refcnt);
-		put_uobj_read(xrcd_uobj);
-	}
+	put_pd_read(pd);
 
 err_put_cq:
 	if (cmd->srq_type == IB_SRQT_XRC)
 		put_cq_read(attr.ext.xrc.cq);
 
-err_put_pd:
-	put_pd_read(pd);
+err_put_xrcd:
+	if (cmd->srq_type == IB_SRQT_XRC) {
+		atomic_dec(&obj->uxrcd->refcnt);
+		put_uobj_read(xrcd_uobj);
+	}
 
 err:
 	put_uobj_write(&obj->uevent.uobject);
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
