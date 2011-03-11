From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 6/7] RDMA/cxgb4: Do CIDX_INC updates every 1/16 cq depth cqe
	reaps.
Date: Fri, 11 Mar 2011 16:30:42 -0600
Message-ID: <20110311223042.16418.85498.stgit@build.ogc.int>
References: <20110311222826.16418.43582.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110311222826.16418.43582.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This avoids the CIDX_INC overflow issue with T4A2 when running
kernel RDMA applications.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/t4.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 7000442..9b84275 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -507,8 +507,14 @@ static inline void t4_swcq_consume(struct t4_cq *cq)
 static inline void t4_hwcq_consume(struct t4_cq *cq)
 {
 	cq->bits_type_ts = cq->queue[cq->cidx].bits_type_ts;
-	if (++cq->cidx_inc == cq->size)
+	if (++cq->cidx_inc == (cq->size >> 4)) {
+		u32 val;
+		
+		val = SEINTARM(0) | CIDXINC(cq->cidx_inc) | TIMERREG(7) |
+		      INGRESSQID(cq->cqid);
+		writel(val, cq->gts);
 		cq->cidx_inc = 0;
+	}
 	if (++cq->cidx == cq->size) {
 		cq->cidx = 0;
 		cq->gen ^= 1;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
