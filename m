From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] IB/srp: use IB_CQ_REPORT_MISSED_EVENTS to avoid missed CQ
	callbacks
Date: Wed, 31 Mar 2010 10:57:52 -0700
Message-ID: <20100331175752.24522.66519.stgit@chromite.mv.qlogic.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100331175742.24522.17850.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ib_req_notify_cq(IB_CQ_NEXT_COMP) is not guaranteed to generate
a callback for the next completion entered since there is a race
between arming the callback and another CQE being added to the queue.
The IB_CQ_REPORT_MISSED_EVENTS flag was added to detect this
race and allow the verbs consumer to call ib_poll_cq() and
ib_req_notify_cq() again to avoid delays in processing the CQE.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/ulp/srp/ib_srp.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ed3f9eb..b0376f1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -921,8 +921,9 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
 	struct ib_wc wc;
+	int ret;
 
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+again:
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
 		if (wc.status) {
 			shost_printk(KERN_ERR, target->scsi_host,
@@ -934,6 +935,10 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 
 		srp_handle_recv(target, &wc);
 	}
+	ret = ib_req_notify_cq(cq, IB_CQ_NEXT_COMP |
+				   IB_CQ_REPORT_MISSED_EVENTS);
+	if (ret > 0)
+		goto again;
 }
 
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
