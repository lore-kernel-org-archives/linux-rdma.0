From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/6] RDMA/cma: Fix setting RoCE specific path record fields
Date: Mon,  8 Jan 2018 17:04:47 +0200
Message-ID: <20180108150448.29069-6-leon@kernel.org>
References: <20180108150448.29069-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108150448.29069-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

rdma_set_ib_path() missed setting path record fields for RoCE
transport when RoCE transport support was added.

This results into setting incorrect ndev, destination mac address,
incorrect GID type etc errors. This patch uses recently introduced
helper function to setup such RoCE specific path record fields.

Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE devices")
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 68223bd56b53..f4c6c2cbc585 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2523,6 +2523,7 @@ int rdma_set_ib_path(struct rdma_cm_id *id,
 {
 	struct rdma_id_private *id_priv;
 	struct sa_path_rec *in_path_rec;
+	struct net_device *ndev;
 	struct sa_path_rec opa;
 	int ret;
 
@@ -2545,6 +2546,18 @@ int rdma_set_ib_path(struct rdma_cm_id *id,
 		goto err;
 	}
 
+	if (rdma_protocol_roce(id->device, id->port_num)) {
+		ndev = cma_iboe_set_path_rec_l2_fields(id_priv);
+		if (!ndev) {
+			ret = -ENODEV;
+			kfree(id->route.path_rec);
+			id->route.path_rec = NULL;
+			goto err;
+		} else {
+			dev_put(ndev);
+		}
+	}
+
 	id->route.num_paths = 1;
 	return 0;
 err:
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
