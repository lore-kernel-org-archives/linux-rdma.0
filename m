From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v8 13/23] IB/Verbs: Reform cma_acquire_dev()
Date: Tue,  5 May 2015 14:50:30 +0200
Message-ID: <1430830240-32389-14-git-send-email-yun.wang@profitbricks.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430830240-32389-1-git-send-email-yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reform cma_acquire_dev() with management helpers, introduce
cma_validate_port() to make the code more clean.

Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 68 +++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 34ec13f..3fb3458 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -349,18 +349,35 @@ static int cma_translate_addr(struct sockaddr *addr, struct rdma_dev_addr *dev_a
 	return ret;
 }
 
+static inline int cma_validate_port(struct ib_device *device, u8 port,
+				      union ib_gid *gid, int dev_type)
+{
+	u8 found_port;
+	int ret = -ENODEV;
+
+	if ((dev_type == ARPHRD_INFINIBAND) && !rdma_protocol_ib(device, port))
+		return ret;
+
+	if ((dev_type != ARPHRD_INFINIBAND) && rdma_protocol_ib(device, port))
+		return ret;
+
+	ret = ib_find_cached_gid(device, gid, &found_port, NULL);
+	if (port != found_port)
+		return -ENODEV;
+
+	return ret;
+}
+
 static int cma_acquire_dev(struct rdma_id_private *id_priv,
 			   struct rdma_id_private *listen_id_priv)
 {
 	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
 	struct cma_device *cma_dev;
-	union ib_gid gid, iboe_gid;
+	union ib_gid gid, iboe_gid, *gidp;
 	int ret = -ENODEV;
-	u8 port, found_port;
-	enum rdma_link_layer dev_ll = dev_addr->dev_type == ARPHRD_INFINIBAND ?
-		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;
+	u8 port;
 
-	if (dev_ll != IB_LINK_LAYER_INFINIBAND &&
+	if (dev_addr->dev_type != ARPHRD_INFINIBAND &&
 	    id_priv->id.ps == RDMA_PS_IPOIB)
 		return -EINVAL;
 
@@ -370,41 +387,36 @@ static int cma_acquire_dev(struct rdma_id_private *id_priv,
 
 	memcpy(&gid, dev_addr->src_dev_addr +
 	       rdma_addr_gid_offset(dev_addr), sizeof gid);
-	if (listen_id_priv &&
-	    rdma_port_get_link_layer(listen_id_priv->id.device,
-				     listen_id_priv->id.port_num) == dev_ll) {
+
+	if (listen_id_priv) {
 		cma_dev = listen_id_priv->cma_dev;
 		port = listen_id_priv->id.port_num;
-		if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
-		    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
-			ret = ib_find_cached_gid(cma_dev->device, &iboe_gid,
-						 &found_port, NULL);
-		else
-			ret = ib_find_cached_gid(cma_dev->device, &gid,
-						 &found_port, NULL);
+		gidp = rdma_protocol_iboe(cma_dev->device, port) ?
+		       &iboe_gid : &gid;
 
-		if (!ret && (port  == found_port)) {
-			id_priv->id.port_num = found_port;
+		ret = cma_validate_port(cma_dev->device, port, gidp,
+					dev_addr->dev_type);
+		if (!ret) {
+			id_priv->id.port_num = port;
 			goto out;
 		}
 	}
+
 	list_for_each_entry(cma_dev, &dev_list, list) {
 		for (port = 1; port <= cma_dev->device->phys_port_cnt; ++port) {
 			if (listen_id_priv &&
 			    listen_id_priv->cma_dev == cma_dev &&
 			    listen_id_priv->id.port_num == port)
 				continue;
-			if (rdma_port_get_link_layer(cma_dev->device, port) == dev_ll) {
-				if (rdma_node_get_transport(cma_dev->device->node_type) == RDMA_TRANSPORT_IB &&
-				    rdma_port_get_link_layer(cma_dev->device, port) == IB_LINK_LAYER_ETHERNET)
-					ret = ib_find_cached_gid(cma_dev->device, &iboe_gid, &found_port, NULL);
-				else
-					ret = ib_find_cached_gid(cma_dev->device, &gid, &found_port, NULL);
-
-				if (!ret && (port == found_port)) {
-					id_priv->id.port_num = found_port;
-					goto out;
-				}
+
+			gidp = rdma_protocol_iboe(cma_dev->device, port) ?
+			       &iboe_gid : &gid;
+
+			ret = cma_validate_port(cma_dev->device, port, gidp,
+						dev_addr->dev_type);
+			if (!ret) {
+				id_priv->id.port_num = port;
+				goto out;
 			}
 		}
 	}
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
