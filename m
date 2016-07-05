From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next] IB/rxe: Simplify rxe_init_ports logic
Date: Tue,  5 Jul 2016 19:10:23 +0300
Message-ID: <1467735023-21942-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Simplify rxe_init_ports and remove double free.

Fixes: 0784481b2f32 ('Add initialization for Soft RoCE driver, pools constants etc.')
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/rxe/rxe.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/rxe/rxe.c b/drivers/infiniband/hw/rxe/rxe.c
index 48c41e00..d49418b 100644
--- a/drivers/infiniband/hw/rxe/rxe.c
+++ b/drivers/infiniband/hw/rxe/rxe.c
@@ -165,42 +165,25 @@ static int rxe_init_port_param(struct rxe_port *port)
  */
 static int rxe_init_ports(struct rxe_dev *rxe)
 {
-	int err;
-	struct rxe_port *port;
-
-	port = &rxe->port;
+	struct rxe_port *port = &rxe->port;
 
 	rxe_init_port_param(port);
 
-	if (!port->attr.pkey_tbl_len) {
-		err = -EINVAL;
-		goto err1;
-	}
+	if (!port->attr.pkey_tbl_len || !port->attr.gid_tbl_len)
+		return -EINVAL;
 
 	port->pkey_tbl = kcalloc(port->attr.pkey_tbl_len,
 			sizeof(*port->pkey_tbl), GFP_KERNEL);
-	if (!port->pkey_tbl) {
-		err = -ENOMEM;
-		goto err1;
-	}
 
-	port->pkey_tbl[0] = 0xffff;
-
-	if (!port->attr.gid_tbl_len) {
-		kfree(port->pkey_tbl);
-		err = -EINVAL;
-		goto err1;
-	}
+	if (!port->pkey_tbl)
+		return -ENOMEM;
 
+	port->pkey_tbl[0] = 0xffff;
 	port->port_guid = rxe->ifc_ops->port_guid(rxe);
 
 	spin_lock_init(&port->port_lock);
 
 	return 0;
-
-err1:
-	kfree(port->pkey_tbl);
-	return err;
 }
 
 /* init pools of managed objects */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
