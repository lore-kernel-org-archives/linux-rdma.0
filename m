From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 11/14] RDMA/bnxt_re: Delete unsupported modify_port function
Date: Mon, 31 Jul 2017 10:09:21 +0300
Message-ID: <20170731070924.7193-12-leon@kernel.org>
References: <20170731070924.7193-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731070924.7193-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is no need to return always zero for function which is not
supported. The IB stack treats uninitialized ib_device->functions as
not implemented.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 17 -----------------
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  3 ---
 drivers/infiniband/hw/bnxt_re/main.c     |  1 -
 3 files changed, 21 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index f0e01b3ac711..5dc6e7ce3ab9 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -313,23 +313,6 @@ int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
-int bnxt_re_modify_port(struct ib_device *ibdev, u8 port_num,
-			int port_modify_mask,
-			struct ib_port_modify *port_modify)
-{
-	switch (port_modify_mask) {
-	case IB_PORT_SHUTDOWN:
-		break;
-	case IB_PORT_INIT_TYPE:
-		break;
-	case IB_PORT_RESET_QKEY_CNTR:
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
 int bnxt_re_get_port_immutable(struct ib_device *ibdev, u8 port_num,
 			       struct ib_port_immutable *immutable)
 {
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index a0bb7e33d7ca..1df11ed272ea 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -141,9 +141,6 @@ int bnxt_re_modify_device(struct ib_device *ibdev,
 			  struct ib_device_modify *device_modify);
 int bnxt_re_query_port(struct ib_device *ibdev, u8 port_num,
 		       struct ib_port_attr *port_attr);
-int bnxt_re_modify_port(struct ib_device *ibdev, u8 port_num,
-			int port_modify_mask,
-			struct ib_port_modify *port_modify);
 int bnxt_re_get_port_immutable(struct ib_device *ibdev, u8 port_num,
 			       struct ib_port_immutable *immutable);
 int bnxt_re_query_pkey(struct ib_device *ibdev, u8 port_num,
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index ceae2d92fb08..deec8002dd36 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -474,7 +474,6 @@ static int bnxt_re_register_ib(struct bnxt_re_dev *rdev)
 	ibdev->modify_device		= bnxt_re_modify_device;
 
 	ibdev->query_port		= bnxt_re_query_port;
-	ibdev->modify_port		= bnxt_re_modify_port;
 	ibdev->get_port_immutable	= bnxt_re_get_port_immutable;
 	ibdev->query_pkey		= bnxt_re_query_pkey;
 	ibdev->query_gid		= bnxt_re_query_gid;
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
