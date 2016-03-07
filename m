From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/10] IB/hfi1: Fix ordering of trace for accuracy
Date: Mon, 07 Mar 2016 11:35:24 -0800
Message-ID: <20160307193524.4913.88137.stgit@scvm10.sc.intel.com>
References: <20160307193146.4913.42900.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160307193146.4913.42900.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The postitioning of the sdma ibhdr trace was
causing an extra trace message when the tx send
returned -EBUSY.

Move the trace to just before the return
and handle negative return values to avoid
any trace.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index e605e09..467e6c3 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -891,11 +891,14 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		if (unlikely(ret))
 			goto bail_build;
 	}
+	ret =  sdma_send_txreq(tx->sde, &priv->s_iowait, &tx->txreq);
+	if (unlikely(ret < 0)) {
+		if (ret == -ECOMM)
+			goto bail_ecomm;
+		return ret;
+	}
 	trace_sdma_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
 				&ps->s_txreq->phdr.hdr);
-	ret =  sdma_send_txreq(tx->sde, &priv->s_iowait, &tx->txreq);
-	if (unlikely(ret == -ECOMM))
-		goto bail_ecomm;
 	return ret;
 
 bail_ecomm:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
