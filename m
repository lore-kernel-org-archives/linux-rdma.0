From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/16] staging/rdma/hfi1: use u8 for vl/sl
Date: Sun, 14 Feb 2016 12:45:27 -0800
Message-ID: <20160214204523.29247.41889.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The use should match the universal container size.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 229dde5..a4f8b26 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -809,7 +809,7 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	struct hfi1_pportdata *ppd = ps->ppd;
 	u32 *hdr = (u32 *)&ps->s_txreq->phdr.hdr;
 	u64 pbc_flags = 0;
-	u32 sc5;
+	u8 sc5;
 	unsigned long flags = 0;
 	struct send_context *sc;
 	struct pio_buf *pbuf;
@@ -825,7 +825,7 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		goto bail;
 	}
 	if (likely(pbc == 0)) {
-		u32 vl = sc_to_vlt(dd_from_ibdev(qp->ibqp.device), sc5);
+		u8 vl = sc_to_vlt(dd_from_ibdev(qp->ibqp.device), sc5);
 		/* set PBC_DC_INFO bit (aka SC[4]) in pbc_flags */
 		pbc_flags |= (!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT;
 		pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
