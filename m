From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] IB/mlx4: Fix error paths in mlx4_ib_create_flow()
Date: Fri, 29 May 2015 23:11:27 -0700
Message-ID: <1432966287-12181-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

The unwinding clean up code are err_create_flow starts at the current
index i.  That means we shouldn't increment i until we're really sure
we won't have to destroy the current flow; otherwise we might
increment the index, fail inside an is_bonded block, and end up
accessing off the end of the reg_id[] array.

This was detected by Coverity (CID 1271229).

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index cc64400d41ac..8191e176c5b7 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1185,7 +1185,6 @@ static struct ib_flow *mlx4_ib_create_flow(struct ib_qp *qp,
 					    &mflow->reg_id[i].id);
 		if (err)
 			goto err_create_flow;
-		i++;
 		if (is_bonded) {
 			/* Application always sees one port so the mirror rule
 			 * must be on port #2
@@ -1200,6 +1199,7 @@ static struct ib_flow *mlx4_ib_create_flow(struct ib_qp *qp,
 			j++;
 		}
 
+		i++;
 	}
 
 	if (i < ARRAY_SIZE(type) && flow_attr->type == IB_FLOW_ATTR_NORMAL) {
@@ -1207,7 +1207,7 @@ static struct ib_flow *mlx4_ib_create_flow(struct ib_qp *qp,
 					       &mflow->reg_id[i].id);
 		if (err)
 			goto err_create_flow;
-		i++;
+
 		if (is_bonded) {
 			flow_attr->port = 2;
 			err = mlx4_ib_tunnel_steer_add(qp, flow_attr,
@@ -1218,6 +1218,7 @@ static struct ib_flow *mlx4_ib_create_flow(struct ib_qp *qp,
 			j++;
 		}
 		/* function to create mirror rule */
+		i++;
 	}
 
 	return &mflow->ibflow;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
