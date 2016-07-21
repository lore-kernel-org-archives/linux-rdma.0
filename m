From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 3/5] IB/srpt: Limit the number of SG elements per work
 request
Date: Thu, 21 Jul 2016 13:03:47 -0700
Message-ID: <446e3039-ec25-89d8-2583-5e60dd2bfc88@sandisk.com>
References: <75fc8647-16a6-5a89-400f-f5f418a8d6eb@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <75fc8647-16a6-5a89-400f-f5f418a8d6eb-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Limit the number of SG elements per work request to what the HCA
and the queue pair support.

Fixes: 34693573fde0 ("IB/srpt: Reduce QP buffer size")
Reported-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v4.7+
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 3 ++-
 drivers/infiniband/ulp/srpt/ib_srpt.h | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 4a41556..9a3b954 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1601,6 +1601,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	struct ib_qp_init_attr *qp_init;
 	struct srpt_port *sport = ch->sport;
 	struct srpt_device *sdev = sport->sdev;
+	const struct ib_device_attr *attrs = &sdev->device->attrs;
 	u32 srp_sq_size = sport->port_attrib.srp_sq_size;
 	int ret;
 
@@ -1638,7 +1639,7 @@ retry:
 	 */
 	qp_init->cap.max_send_wr = srp_sq_size / 2;
 	qp_init->cap.max_rdma_ctxs = srp_sq_size / 2;
-	qp_init->cap.max_send_sge = SRPT_DEF_SG_PER_WQE;
+	qp_init->cap.max_send_sge = min(attrs->max_sge, SRPT_MAX_SG_PER_WQE);
 	qp_init->port_num = ch->sport->port;
 
 	ch->qp = ib_create_qp(sdev->pd, qp_init);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 3890304..5818787 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -106,7 +106,11 @@ enum {
 	SRP_LOGIN_RSP_MULTICHAN_MAINTAINED = 0x2,
 
 	SRPT_DEF_SG_TABLESIZE = 128,
-	SRPT_DEF_SG_PER_WQE = 16,
+	/*
+	 * An experimentally determined value that avoids that QP creation
+	 * fails due to "swiotlb buffer is full" on systems using the swiotlb.
+	 */
+	SRPT_MAX_SG_PER_WQE = 16,
 
 	MIN_SRPT_SQ_SIZE = 16,
 	DEF_SRPT_SQ_SIZE = 4096,
-- 
2.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
