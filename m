From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/7] staging/rdma/hfi1: Fix header size calculation for
 RC/UC QPs with GRH enabled
Date: Fri, 26 Feb 2016 13:33:13 -0800
Message-ID: <20160226213313.16535.27104.stgit@scvm10.sc.intel.com>
References: <20160226213022.16535.8149.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160226213022.16535.8149.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There is a header size counter in both the QP struture and the txreq
structure. The counter in the txreq structure is not updated properly
for RC and UC queue pairs with GRH enabled, and thus causing SDMA
send to fail. This patch fixes the RC and UC path.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/rc.c |    8 ++++----
 drivers/staging/rdma/hfi1/uc.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 8caad18..1ce0e08 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -358,11 +358,11 @@ normal:
 	}
 	qp->s_rdma_ack_cnt++;
 	qp->s_hdrwords = hwords;
-	/* pbc */
-	ps->s_txreq->hdr_dwords = hwords + 2;
 	ps->s_txreq->sde = priv->s_sde;
 	qp->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0, bth2, middle, ps);
+	/* pbc */
+	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 	return 1;
 
 bail:
@@ -763,8 +763,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	}
 	qp->s_len -= len;
 	qp->s_hdrwords = hwords;
-	/* pbc */
-	ps->s_txreq->hdr_dwords = hwords + 2;
 	ps->s_txreq->sde = priv->s_sde;
 	qp->s_cur_sge = ss;
 	qp->s_cur_size = len;
@@ -775,6 +773,8 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		bth2,
 		middle,
 		ps);
+	/* pbc */
+	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 	return 1;
 
 done_free_tx:
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index 5ba29af..df773d4 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -239,13 +239,13 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	}
 	qp->s_len -= len;
 	qp->s_hdrwords = hwords;
-	/* pbc */
-	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 	ps->s_txreq->sde = priv->s_sde;
 	qp->s_cur_sge = &qp->s_sge;
 	qp->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0 | (qp->s_state << 24),
 			     mask_psn(qp->s_psn++), middle, ps);
+	/* pbc */
+	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 	return 1;
 
 done_free_tx:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
