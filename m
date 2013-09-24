From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [Patch v2 2/3] IB/cma: Check for GID on listening device first
Date: Tue, 24 Sep 2013 17:16:28 -0400
Message-ID: <aa1e1e21c41fc6aa287aeb99d71fa257557d40b2.1380056994.git.dledford@redhat.com>
References: <cover.1380056994.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1380056994.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1380056994.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1380056994.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Drier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As a simple optimization that should speed up the vast majority of
connect attemps on IB devices, when we are searching for the GID of an
incoming connection in the cached GID lists of devices, search the
device that received the incoming connection request first.  If we don't
find it there, then move on to other devices.

This reduces the time to perform 10,000 connections considerably.
Prior to this patch, a bad run of cmtime would look like this:

connect      :    12399.26   12351.10    8609.00    1239.93

With this patch, it looks more like this:

connect      :     5864.86    5799.80    8876.00     586.49

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index c62ff9e..dadc486 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -349,7 +349,8 @@ static int cma_translate_addr(struct sockaddr *addr, struct rdma_dev_addr *dev_a
 	return ret;
 }
 
-static int cma_acquire_dev(struct rdma_id_private *id_priv)
+static int cma_acquire_dev(struct rdma_id_private *id_priv,
+			   struct rdma_id_private *listen_id_priv)
 {
 	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
 	struct cma_device *cma_dev;
@@ -367,8 +368,30 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 	iboe_addr_get_sgid(dev_addr, &iboe_gid);
 	memcpy(&gid, dev_addr->src_dev_addr +
 	       rdma_addr_gid_offset(dev_addr), sizeof gid);
+	if (listen_id_priv &&
+	    rdma_port_get_link_layer(listen_id_priv->id.device,
+				     listen_id_priv->id.port_num) == dev_ll) {
+		cma_dev = listen_id_priv->cma_dev;
+		port = listen_id_priv->id.port_num;
+		if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
+		    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
+			ret = ib_find_cached_gid(cma_dev->device, &iboe_gid,
+						 &found_port, NULL);
+		else
+			ret = ib_find_cached_gid(cma_dev->device, &gid,
+						 &found_port, NULL);
+
+		if (!ret && (port  == found_port)) {
+			id_priv->id.port_num = found_port;
+			goto out;
+		}
+	}
 	list_for_each_entry(cma_dev, &dev_list, list) {
-		for (port = 1; port <= cma_dev->device->phys_port_cnt; ++port)
+		for (port = 1; port <= cma_dev->device->phys_port_cnt; ++port) {
+			if (listen_id_priv &&
+			    listen_id_priv->cma_dev == cma_dev &&
+			    listen_id_priv->id.port_num == port)
+				continue;
 			if (rdma_port_get_link_layer(cma_dev->device, port) == dev_ll) {
 				if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
 				    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
@@ -381,6 +404,7 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv)
 					goto out;
 				}
 			}
+		}
 	}
 
 out:
@@ -1269,7 +1293,7 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	}
 
 	mutex_lock_nested(&conn_id->handler_mutex, SINGLE_DEPTH_NESTING);
-	ret = cma_acquire_dev(conn_id);
+	ret = cma_acquire_dev(conn_id, listen_id);
 	if (ret)
 		goto err2;
 
@@ -1458,7 +1482,7 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 		goto out;
 	}
 
-	ret = cma_acquire_dev(conn_id);
+	ret = cma_acquire_dev(conn_id, listen_id);
 	if (ret) {
 		mutex_unlock(&conn_id->handler_mutex);
 		rdma_destroy_id(new_cm_id);
@@ -2027,7 +2051,7 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 		goto out;
 
 	if (!status && !id_priv->cma_dev)
-		status = cma_acquire_dev(id_priv);
+		status = cma_acquire_dev(id_priv, NULL);
 
 	if (status) {
 		if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED,
@@ -2524,7 +2548,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 		if (ret)
 			goto err1;
 
-		ret = cma_acquire_dev(id_priv);
+		ret = cma_acquire_dev(id_priv, NULL);
 		if (ret)
 			goto err1;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
