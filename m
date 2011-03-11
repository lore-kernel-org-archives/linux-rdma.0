From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/7] RDMA/cxgb4: debugfs dump_qp() updates.
Date: Fri, 11 Mar 2011 16:29:50 -0600
Message-ID: <20110311222950.16418.37365.stgit@build.ogc.int>
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

- Show whether the SQ is in onchip memory or not.
- Dump both SQ and RQ QIDs.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 54fbc11..f5638f2 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -87,17 +87,22 @@ static int dump_qp(int id, void *p, void *data)
 		return 1;
 
 	if (qp->ep)
-		cc = snprintf(qpd->buf + qpd->pos, space, "qp id %u state %u "
+		cc = snprintf(qpd->buf + qpd->pos, space, 
+			     "qp sq id %u rq id %u state %u onchip %u "
 			     "ep tid %u state %u %pI4:%u->%pI4:%u\n",
-			     qp->wq.sq.qid, (int)qp->attr.state,
+			     qp->wq.sq.qid, qp->wq.rq.qid, (int)qp->attr.state,
+			     qp->wq.sq.flags & T4_SQ_ONCHIP,
 			     qp->ep->hwtid, (int)qp->ep->com.state,
 			     &qp->ep->com.local_addr.sin_addr.s_addr,
 			     ntohs(qp->ep->com.local_addr.sin_port),
 			     &qp->ep->com.remote_addr.sin_addr.s_addr,
 			     ntohs(qp->ep->com.remote_addr.sin_port));
 	else
-		cc = snprintf(qpd->buf + qpd->pos, space, "qp id %u state %u\n",
-			      qp->wq.sq.qid, (int)qp->attr.state);
+		cc = snprintf(qpd->buf + qpd->pos, space,
+			     "qp sq id %u rq id %u state %u onchip %u\n",
+			      qp->wq.sq.qid, qp->wq.rq.qid,
+			      (int)qp->attr.state,
+			      qp->wq.sq.flags & T4_SQ_ONCHIP);
 	if (cc < space)
 		qpd->pos += cc;
 	return 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
