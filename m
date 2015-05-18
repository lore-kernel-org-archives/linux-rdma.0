From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/2] RDMA/iw_cm: Export tos field to iwarp providers
Date: Mon, 18 May 2015 15:27:10 -0500
Message-ID: <20150518202710.GA3048@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

rdma-cma/iw_cm: Export tos field to iwarp providers

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    2 ++
 include/rdma/iw_cm.h          |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d570030..beda319 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1593,6 +1593,7 @@ static int cma_iw_listen(struct rdma_id_private *id_priv, int backlog)
 	if (IS_ERR(id))
 		return PTR_ERR(id);
 
+	id->tos = id_priv->tos;
 	id_priv->cm_id.iw = id;
 
 	memcpy(&id_priv->cm_id.iw->local_addr, cma_src_addr(id_priv),
@@ -2840,6 +2841,7 @@ static int cma_connect_iw(struct rdma_id_private *id_priv,
 	if (IS_ERR(cm_id))
 		return PTR_ERR(cm_id);
 
+	cm_id->tos = id_priv->tos;
 	id_priv->cm_id.iw = cm_id;
 
 	memcpy(&cm_id->local_addr, cma_src_addr(id_priv),
diff --git a/include/rdma/iw_cm.h b/include/rdma/iw_cm.h
index 1017e0b..036bd27 100644
--- a/include/rdma/iw_cm.h
+++ b/include/rdma/iw_cm.h
@@ -91,6 +91,7 @@ struct iw_cm_id {
 	/* Used by provider to add and remove refs on IW cm_id */
 	void (*add_ref)(struct iw_cm_id *);
 	void (*rem_ref)(struct iw_cm_id *);
+	u8  tos;
 };
 
 struct iw_cm_conn_param {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
