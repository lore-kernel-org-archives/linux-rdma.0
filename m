From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 1/7] IB/srpt: Limit the send and receive queue sizes to what the HCA supports
Date: Fri,  6 Oct 2017 14:42:37 -0700
Message-ID: <20171006214243.11296-2-bart.vanassche@wdc.com>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006214243.11296-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Additionally, correct the comment about ch->rq_size.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 95178b4e3565..76370e39857d 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1650,7 +1650,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	 * both both, as RDMA contexts will also post completions for the
 	 * RDMA READ case.
 	 */
-	qp_init->cap.max_send_wr = srp_sq_size / 2;
+	qp_init->cap.max_send_wr = min(srp_sq_size / 2, attrs->max_qp_wr + 0U);
 	qp_init->cap.max_rdma_ctxs = srp_sq_size / 2;
 	qp_init->cap.max_send_sge = min(attrs->max_sge, SRPT_MAX_SG_PER_WQE);
 	qp_init->port_num = ch->sport->port;
@@ -1953,10 +1953,11 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	ch->cm_id = cm_id;
 	cm_id->context = ch;
 	/*
-	 * Avoid QUEUE_FULL conditions by limiting the number of buffers used
-	 * for the SRP protocol to the command queue size.
+	 * ch->rq_size should be at least as large as the initiator queue
+	 * depth to avoid that the initiator driver has to report QUEUE_FULL
+	 * to the SCSI mid-layer.
 	 */
-	ch->rq_size = SRPT_RQ_SIZE;
+	ch->rq_size = min(SRPT_RQ_SIZE, sdev->device->attrs.max_qp_wr);
 	spin_lock_init(&ch->spinlock);
 	ch->state = CH_CONNECTING;
 	INIT_LIST_HEAD(&ch->cmd_wait_list);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
