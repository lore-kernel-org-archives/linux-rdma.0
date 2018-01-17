From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 08/14] IB/srpt: Log all zero-length writes and completions
Date: Tue, 16 Jan 2018 16:14:12 -0800
Message-ID: <20180117001418.7852-9-bart.vanassche@wdc.com>
References: <20180117001418.7852-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117001418.7852-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The new pr_debug() statements are useful when debugging the ib_srpt
driver.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index b248515a4fe4..866ff4be553c 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -840,6 +840,9 @@ static int srpt_zerolength_write(struct srpt_rdma_ch *ch)
 {
 	struct ib_send_wr wr, *bad_wr;
 
+	pr_debug("%s-%d: queued zerolength write\n", ch->sess_name,
+		 ch->qp->qp_num);
+
 	memset(&wr, 0, sizeof(wr));
 	wr.opcode = IB_WR_RDMA_WRITE;
 	wr.wr_cqe = &ch->zw_cqe;
@@ -851,6 +854,9 @@ static void srpt_zerolength_write_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct srpt_rdma_ch *ch = cq->cq_context;
 
+	pr_debug("%s-%d wc->status %d\n", ch->sess_name, ch->qp->qp_num,
+		 wc->status);
+
 	if (wc->status == IB_WC_SUCCESS) {
 		srpt_process_wait_list(ch);
 	} else {
@@ -1804,8 +1810,6 @@ static bool srpt_close_ch(struct srpt_rdma_ch *ch)
 		pr_err("%s-%d: changing queue pair into error state failed: %d\n",
 		       ch->sess_name, ch->qp->qp_num, ret);
 
-	pr_debug("%s-%d: queued zerolength write\n", ch->sess_name,
-		 ch->qp->qp_num);
 	ret = srpt_zerolength_write(ch);
 	if (ret < 0) {
 		pr_err("%s-%d: queuing zero-length write failed: %d\n",
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
