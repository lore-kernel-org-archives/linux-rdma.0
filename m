From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 6/7] IB/hfi1: Set hdr_type when tx req is allocated
Date: Mon, 09 Oct 2017 12:38:26 -0700
Message-ID: <20171009193824.6965.48215.stgit@scvm10.sc.intel.com>
References: <20171009161736.6965.75352.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009161736.6965.75352.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Setting the protocol type should be part of initializing the tx request.
For UC and RC, the current protocol type is part of the qp priv structure.
For ud requests, it needs to be adjusted dynamically, based on the AV
posted with the WQE. This patch will simplify the initialization of the
tx request.

Fixes: 5b6cabb0db77 ("IB/hfi1: Add 16B RC/UC support")
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c          |    1 -
 drivers/infiniband/hw/hfi1/uc.c          |    1 -
 drivers/infiniband/hw/hfi1/verbs_txreq.h |    2 ++
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index e1cf0c0..bfe3e38 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -276,7 +276,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	if (IS_ERR(ps->s_txreq))
 		goto bail_no_tx;
 
-	ps->s_txreq->phdr.hdr.hdr_type = priv->hdr_type;
 	if (priv->hdr_type == HFI1_PKT_TYPE_9B) {
 		/* header size in 32-bit words LRH+BTH = (8+12)/4. */
 		hwords = 5;
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index 0b64617..fcd8186 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -93,7 +93,6 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		goto done_free_tx;
 	}
 
-	ps->s_txreq->phdr.hdr.hdr_type = priv->hdr_type;
 	if (priv->hdr_type == HFI1_PKT_TYPE_9B) {
 		/* header size in 32-bit words LRH+BTH = (8+12)/4. */
 		hwords = 5;
diff --git a/drivers/infiniband/hw/hfi1/verbs_txreq.h b/drivers/infiniband/hw/hfi1/verbs_txreq.h
index 76216f2..cec7a4b 100644
--- a/drivers/infiniband/hw/hfi1/verbs_txreq.h
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.h
@@ -92,6 +92,8 @@ struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 	tx->psc = priv->s_sendcontext;
 	/* so that we can test if the sdma decriptors are there */
 	tx->txreq.num_desc = 0;
+	/* Set the header type */
+	tx->phdr.hdr.hdr_type = priv->hdr_type;
 	return tx;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
