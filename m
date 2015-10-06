From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] [RESEND] IB/cma: Accept connection without a valid netdev on RoCE
Date: Tue,  6 Oct 2015 17:56:00 +0300
Message-ID: <1444143360-18549-1-git-send-email-haggaie@mellanox.com>
References: <5607AC87.7070504@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5607AC87.7070504-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The netdev checks recently added to RDMA CM expect a valid netdev to be
found for both InfiniBand and RoCE, but the code that find a netdev is
only implemented for InfiniBand.

Currently RoCE doesn't provide an API to find the netdev matching a
given set of parameters, so this patch just disables the netdev enforcement
for each incoming connections when the link layer is RoCE.

Fixes: 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to RDMA CM")
Reported-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
I accidentally forgot to send this to the list, so I'm sending again.

 drivers/infiniband/core/cma.c | 54 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b92a3c2c060b..f163ac680841 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1232,14 +1232,32 @@ static bool cma_match_private_data(struct rdma_id_private *id_priv,
 	return true;
 }
 
+static bool cma_protocol_roce_dev_port(struct ib_device *device, int port_num)
+{
+	enum rdma_link_layer ll = rdma_port_get_link_layer(device, port_num);
+	enum rdma_transport_type transport =
+		rdma_node_get_transport(device->node_type);
+
+	return ll == IB_LINK_LAYER_ETHERNET && transport == RDMA_TRANSPORT_IB;
+}
+
+static bool cma_protocol_roce(const struct rdma_cm_id *id)
+{
+	struct ib_device *device = id->device;
+	const int port_num = id->port_num ?: rdma_start_port(device);
+
+	return cma_protocol_roce_dev_port(device, port_num);
+}
+
 static bool cma_match_net_dev(const struct rdma_id_private *id_priv,
 			      const struct net_device *net_dev)
 {
 	const struct rdma_addr *addr = &id_priv->id.route.addr;
 
 	if (!net_dev)
-		/* This request is an AF_IB request */
-		return addr->src_addr.ss_family == AF_IB;
+		/* This request is an AF_IB request or a RoCE request */
+		return addr->src_addr.ss_family == AF_IB ||
+		       cma_protocol_roce(&id_priv->id);
 
 	return !addr->dev_addr.bound_dev_if ||
 	       (net_eq(dev_net(net_dev), &init_net) &&
@@ -1294,6 +1312,10 @@ static struct rdma_id_private *cma_id_from_event(struct ib_cm_id *cm_id,
 		if (PTR_ERR(*net_dev) == -EAFNOSUPPORT) {
 			/* Assuming the protocol is AF_IB */
 			*net_dev = NULL;
+		} else if (cma_protocol_roce_dev_port(req.device, req.port)) {
+			/* TODO find the net dev matching the request parameters
+			 * through the RoCE GID table */
+			*net_dev = NULL;
 		} else {
 			return ERR_CAST(*net_dev);
 		}
@@ -1593,11 +1615,16 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 		if (ret)
 			goto err;
 	} else {
-		/* An AF_IB connection */
-		WARN_ON_ONCE(ss_family != AF_IB);
-
-		cma_translate_ib((struct sockaddr_ib *)cma_src_addr(id_priv),
-				 &rt->addr.dev_addr);
+		if (!cma_protocol_roce(listen_id) &&
+		    cma_any_addr(cma_src_addr(id_priv))) {
+			rt->addr.dev_addr.dev_type = ARPHRD_INFINIBAND;
+			rdma_addr_set_sgid(&rt->addr.dev_addr, &rt->path_rec[0].sgid);
+			ib_addr_set_pkey(&rt->addr.dev_addr, be16_to_cpu(rt->path_rec[0].pkey));
+		} else if (!cma_any_addr(cma_src_addr(id_priv))) {
+			ret = cma_translate_addr(cma_src_addr(id_priv), &rt->addr.dev_addr);
+			if (ret)
+				goto err;
+		}
 	}
 	rdma_addr_set_dgid(&rt->addr.dev_addr, &rt->path_rec[0].dgid);
 
@@ -1635,13 +1662,12 @@ static struct rdma_id_private *cma_new_udp_id(struct rdma_cm_id *listen_id,
 		if (ret)
 			goto err;
 	} else {
-		/* An AF_IB connection */
-		WARN_ON_ONCE(ss_family != AF_IB);
-
-		if (!cma_any_addr(cma_src_addr(id_priv)))
-			cma_translate_ib((struct sockaddr_ib *)
-						cma_src_addr(id_priv),
-					 &id->route.addr.dev_addr);
+		if (!cma_any_addr(cma_src_addr(id_priv))) {
+			ret = cma_translate_addr(cma_src_addr(id_priv),
+						 &id->route.addr.dev_addr);
+			if (ret)
+				goto err;
+		}
 	}
 
 	id_priv->state = RDMA_CM_CONNECT;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
