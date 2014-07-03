From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 5/5] IB/srp: Optimize completion queue polling
Date: Thu, 03 Jul 2014 15:48:15 +0200
Message-ID: <53B55F1F.6000704@acm.org>
References: <53B55E55.5040907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B55E55.5040907-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reduce completion queue lock contention by polling for multiple
work completions at once. Limit the number of poll cycles per
completion notification to preserve fairness if multiple verbs
applications use the same port or if multiple IB interrupts have
been mapped to the same CPU core.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 55 +++++++++++++++++++++++++------------
 drivers/infiniband/ulp/srp/ib_srp.h |  4 +++
 2 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f685e06..b017a3a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1818,33 +1818,54 @@ static void srp_handle_qp_err(u64 wr_id, enum ib_wc_status wc_status,
 	target->qp_in_error = true;
 }
 
+static void srp_poll_recv(struct ib_cq *cq, struct srp_target_port *target,
+			  int budget)
+{
+	struct ib_wc *const wc = target->recv_wc;
+	int i, n;
+
+	while ((n = ib_poll_cq(cq, min_t(int, ARRAY_SIZE(target->recv_wc),
+					 budget), wc)) > 0) {
+		budget -= n;
+		for (i = 0; i < n; ++i) {
+			if (likely(wc[i].status == IB_WC_SUCCESS)) {
+				srp_handle_recv(target, &wc[i]);
+			} else {
+				srp_handle_qp_err(wc[i].wr_id, wc[i].status,
+						  false, target);
+			}
+		}
+	}
+}
+
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
-	struct ib_wc wc;
+	int n = SRP_POLL_BUDGET;
 
-	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		if (likely(wc.status == IB_WC_SUCCESS)) {
-			srp_handle_recv(target, &wc);
-		} else {
-			srp_handle_qp_err(wc.wr_id, wc.status, false, target);
-		}
-	}
+	do {
+		srp_poll_recv(cq, target, n);
+		n = ib_req_notify_cq(cq, IB_CQ_NEXT_COMP |
+				     IB_CQ_REPORT_MISSED_EVENTS);
+	} while (n > 0);
 }
 
 static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 {
 	struct srp_target_port *target = target_ptr;
-	struct ib_wc wc;
+	struct ib_wc *const wc = target->send_wc;
 	struct srp_iu *iu;
-
-	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		if (likely(wc.status == IB_WC_SUCCESS)) {
-			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
-			list_add(&iu->list, &target->free_tx);
-		} else {
-			srp_handle_qp_err(wc.wr_id, wc.status, true, target);
+	int i, n;
+
+	while ((n = ib_poll_cq(cq, ARRAY_SIZE(target->send_wc), wc)) > 0) {
+		for (i = 0; i < n; ++i) {
+			if (likely(wc[i].status == IB_WC_SUCCESS)) {
+				iu = (struct srp_iu *) (uintptr_t) wc[i].wr_id;
+				list_add(&iu->list, &target->free_tx);
+			} else {
+				srp_handle_qp_err(wc[i].wr_id, wc[i].status,
+						  true, target);
+			}
 		}
 	}
 }
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index e46ecb1..e81d190 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -70,6 +70,8 @@ enum {
 
 	LOCAL_INV_WR_ID_MASK	= 1,
 	FAST_REG_WR_ID_MASK	= 2,
+
+	SRP_POLL_BUDGET		= 512,
 };
 
 enum srp_target_state {
@@ -151,6 +153,8 @@ struct srp_target_port {
 	unsigned int		cmd_sg_cnt;
 	unsigned int		indirect_size;
 	bool			allow_ext_sg;
+	struct ib_wc		recv_wc[16];
+	struct ib_wc		send_wc[16];
 
 	/* Everything above this point is used in the hot path of
 	 * command processing. Try to keep them packed into cachelines.
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
