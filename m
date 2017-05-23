From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/core: Don't resolve IP address to the loopback device
Date: Tue, 23 May 2017 10:48:45 +0300
Message-ID: <20170523074845.10845-2-leon@kernel.org>
References: <20170523074845.10845-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523074845.10845-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When resolving an IP address that is on the host of the caller the
result from querying the routing table is the loopback device. This is
not a valid response, because it doesn't represent the RDMA device and
the port.

Therefore, callers need to check the resolved device and if it is a
loopback device find an alternative way to resolve it. To avoid this we
make sure that the response from rdma_resolve_ip() will not be the
loopback device.

While that, we fix an static checker warning about dereferencing an
unintitialized pointer using the same solution as in commit abeffce90c7f
("net/mlx5e: Fix a -Wmaybe-uninitialized warning") as a reference.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/addr.c  | 40 +++++++++++++++++++++++++++++-----------
 drivers/infiniband/core/cma.c   | 32 +++-----------------------------
 drivers/infiniband/core/verbs.c |  5 -----
 3 files changed, 32 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index d2afcb3dd81a..283ebe8f4783 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -269,6 +269,7 @@ int rdma_translate_ip(const struct sockaddr *addr,
 			return ret;
 
 		ret = rdma_copy_addr(dev_addr, dev, NULL);
+		dev_addr->bound_dev_if = dev->ifindex;
 		if (vlan_id)
 			*vlan_id = rdma_vlan_dev_vlan_id(dev);
 		dev_put(dev);
@@ -281,6 +282,7 @@ int rdma_translate_ip(const struct sockaddr *addr,
 					  &((const struct sockaddr_in6 *)addr)->sin6_addr,
 					  dev, 1)) {
 				ret = rdma_copy_addr(dev_addr, dev, NULL);
+				dev_addr->bound_dev_if = dev->ifindex;
 				if (vlan_id)
 					*vlan_id = rdma_vlan_dev_vlan_id(dev);
 				break;
@@ -406,10 +408,10 @@ static int addr4_resolve(struct sockaddr_in *src_in,
 	fl4.saddr = src_ip;
 	fl4.flowi4_oif = addr->bound_dev_if;
 	rt = ip_route_output_key(addr->net, &fl4);
-	if (IS_ERR(rt)) {
-		ret = PTR_ERR(rt);
-		goto out;
-	}
+	ret = PTR_ERR_OR_ZERO(rt);
+	if (ret)
+		return ret;
+
 	src_in->sin_family = AF_INET;
 	src_in->sin_addr.s_addr = fl4.saddr;
 
@@ -424,8 +426,6 @@ static int addr4_resolve(struct sockaddr_in *src_in,
 
 	*prt = rt;
 	return 0;
-out:
-	return ret;
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -536,8 +536,12 @@ static int addr_resolve(struct sockaddr *src_in,
 		if (resolve_neigh)
 			ret = addr_resolve_neigh(&rt->dst, dst_in, addr, seq);
 
-		ndev = rt->dst.dev;
-		dev_hold(ndev);
+		if (addr->bound_dev_if) {
+			ndev = dev_get_by_index(addr->net, addr->bound_dev_if);
+		} else {
+			ndev = rt->dst.dev;
+			dev_hold(ndev);
+		}
 
 		ip_rt_put(rt);
 	} else {
@@ -553,13 +557,27 @@ static int addr_resolve(struct sockaddr *src_in,
 		if (resolve_neigh)
 			ret = addr_resolve_neigh(dst, dst_in, addr, seq);
 
-		ndev = dst->dev;
-		dev_hold(ndev);
+		if (addr->bound_dev_if) {
+			ndev = dev_get_by_index(addr->net, addr->bound_dev_if);
+		} else {
+			ndev = dst->dev;
+			dev_hold(ndev);
+		}
 
 		dst_release(dst);
 	}
 
-	addr->bound_dev_if = ndev->ifindex;
+	if (ndev->flags & IFF_LOOPBACK) {
+		ret = rdma_translate_ip(dst_in, addr, NULL);
+		/*
+		 * Put the loopback device and get the translated
+		 * device instead.
+		 */
+		dev_put(ndev);
+		ndev = dev_get_by_index(addr->net, addr->bound_dev_if);
+	} else {
+		addr->bound_dev_if = ndev->ifindex;
+	}
 	dev_put(ndev);
 
 	return ret;
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 91b7a2fe5a55..2a6dc10c5624 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -623,22 +623,11 @@ static inline int cma_validate_port(struct ib_device *device, u8 port,
 	if ((dev_type != ARPHRD_INFINIBAND) && rdma_protocol_ib(device, port))
 		return ret;
 
-	if (dev_type == ARPHRD_ETHER && rdma_protocol_roce(device, port)) {
+	if (dev_type == ARPHRD_ETHER && rdma_protocol_roce(device, port))
 		ndev = dev_get_by_index(&init_net, bound_if_index);
-		if (ndev && ndev->flags & IFF_LOOPBACK) {
-			pr_info("detected loopback device\n");
-			dev_put(ndev);
-
-			if (!device->get_netdev)
-				return -EOPNOTSUPP;
-
-			ndev = device->get_netdev(device, port);
-			if (!ndev)
-				return -ENODEV;
-		}
-	} else {
+	else
 		gid_type = IB_GID_TYPE_IB;
-	}
+
 
 	ret = ib_find_cached_gid_by_port(device, gid, gid_type, port,
 					 ndev, NULL);
@@ -2570,21 +2559,6 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 			goto err2;
 		}
 
-		if (ndev->flags & IFF_LOOPBACK) {
-			dev_put(ndev);
-			if (!id_priv->id.device->get_netdev) {
-				ret = -EOPNOTSUPP;
-				goto err2;
-			}
-
-			ndev = id_priv->id.device->get_netdev(id_priv->id.device,
-							      id_priv->id.port_num);
-			if (!ndev) {
-				ret = -ENODEV;
-				goto err2;
-			}
-		}
-
 		supported_gids = roce_gid_type_mask_support(id_priv->id.device,
 							    id_priv->id.port_num);
 		gid_type = cma_route_gid_type(addr->dev_addr.network,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 4792f5209ac2..3d1389efa777 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -506,11 +506,6 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		}
 
 		resolved_dev = dev_get_by_index(&init_net, if_index);
-		if (resolved_dev->flags & IFF_LOOPBACK) {
-			dev_put(resolved_dev);
-			resolved_dev = idev;
-			dev_hold(resolved_dev);
-		}
 		rcu_read_lock();
 		if (resolved_dev != idev && !rdma_is_upper_dev_rcu(idev,
 								   resolved_dev))
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
