From: roel <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: missing parentheses
Date: Sun, 10 Apr 2011 21:47:48 +0200
Message-ID: <4DA20964.6050806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Parens are missing: '|' has a higher presedence than '?'.

Signed-off-by: Roel Kluin <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 70a5a3c..80cab20 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -214,7 +214,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		V_FW_RI_RES_WR_HOSTFCMODE(0) |	/* no host cidx updates */
 		V_FW_RI_RES_WR_CPRIO(0) |	/* don't keep in chip cache */
 		V_FW_RI_RES_WR_PCIECHN(0) |	/* set by uP at ri_init time */
-		t4_sq_onchip(&wq->sq) ? F_FW_RI_RES_WR_ONCHIP : 0 |
+		(t4_sq_onchip(&wq->sq) ? F_FW_RI_RES_WR_ONCHIP : 0) |
 		V_FW_RI_RES_WR_IQID(scq->cqid));
 	res->u.sqrq.dcaen_to_eqsize = cpu_to_be32(
 		V_FW_RI_RES_WR_DCAEN(0) |
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
