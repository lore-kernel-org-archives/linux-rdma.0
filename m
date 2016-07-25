From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 23/28] IB/hfi1: Remove unused elements from struct
 ahg_ib_header
Date: Mon, 25 Jul 2016 13:40:10 -0700
Message-ID: <20160725204009.4800.59124.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

sde and hfi1_ib_header are not used anymore.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/ruc.c   |    2 --
 drivers/infiniband/hw/hfi1/ud.c    |    1 -
 drivers/infiniband/hw/hfi1/verbs.h |    2 --
 3 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 7e76d33..c7c2f48 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -735,7 +735,6 @@ static inline void build_ahg(struct rvt_qp *qp, u32 npsn)
 			qp->s_ahgpsn = npsn;
 			priv->s_hdr->tx_flags |= SDMA_TXREQ_F_AHG_COPY;
 			/* save to protect a change in another thread */
-			priv->s_hdr->sde = priv->s_sde;
 			priv->s_hdr->ahgidx = qp->s_ahgidx;
 			qp->s_flags |= RVT_S_AHG_VALID;
 		}
@@ -804,7 +803,6 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
 	priv->s_hdr->tx_flags = 0;
 	priv->s_hdr->ahgcount = 0;
 	priv->s_hdr->ahgidx = 0;
-	priv->s_hdr->sde = NULL;
 	if (qp->s_mig_state == IB_MIG_MIGRATED)
 		bth0 |= IB_BTH_MIG_REQ;
 	else
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 02488c6..d4afb1d 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -433,7 +433,6 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	priv->s_hdr->ahgcount = 0;
 	priv->s_hdr->ahgidx = 0;
 	priv->s_hdr->tx_flags = 0;
-	priv->s_hdr->sde = NULL;
 	/* pbc */
 	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 4883567..4bd1cd4 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -179,12 +179,10 @@ struct hfi1_ib_header {
 } __packed;
 
 struct ahg_ib_header {
-	struct sdma_engine *sde;
 	u32 ahgdesc[2];
 	u16 tx_flags;
 	u8 ahgcount;
 	u8 ahgidx;
-	struct hfi1_ib_header ibh;
 };
 
 struct hfi1_pio_header {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
