From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/i40iw: Remove unused argument
Date: Thu, 24 Aug 2017 20:11:42 +0300
Message-ID: <20170824171142.31428-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

None of the calls to i40iw_netdev_vlan_ipv6 are using mac so let's
remove it from func's args-list.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index a2b135039e5a..14f36ba4e5be 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1582,15 +1582,14 @@ static enum i40iw_status_code i40iw_del_multiple_qhash(
 }
 
 /**
- * i40iw_netdev_vlan_ipv6 - Gets the netdev and mac
+ * i40iw_netdev_vlan_ipv6 - Gets the netdev and vlan
  * @addr: local IPv6 address
  * @vlan_id: vlan id for the given IPv6 address
- * @mac: mac address for the given IPv6 address
  *
  * Returns the net_device of the IPv6 address and also sets the
- * vlan id and mac for that address.
+ * vlan id for that address.
  */
-static struct net_device *i40iw_netdev_vlan_ipv6(u32 *addr, u16 *vlan_id, u8 *mac)
+static struct net_device *i40iw_netdev_vlan_ipv6(u32 *addr, u16 *vlan_id)
 {
 	struct net_device *ip_dev = NULL;
 	struct in6_addr laddr6;
@@ -1600,15 +1599,11 @@ static struct net_device *i40iw_netdev_vlan_ipv6(u32 *addr, u16 *vlan_id, u8 *ma
 	i40iw_copy_ip_htonl(laddr6.in6_u.u6_addr32, addr);
 	if (vlan_id)
 		*vlan_id = I40IW_NO_VLAN;
-	if (mac)
-		eth_zero_addr(mac);
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, ip_dev) {
 		if (ipv6_chk_addr(&init_net, &laddr6, ip_dev, 1)) {
 			if (vlan_id)
 				*vlan_id = rdma_vlan_dev_vlan_id(ip_dev);
-			if (ip_dev->dev_addr && mac)
-				ether_addr_copy(mac, ip_dev->dev_addr);
 			break;
 		}
 	}
@@ -3588,7 +3583,7 @@ int i40iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		cm_node->vlan_id = i40iw_get_vlan_ipv4(cm_node->loc_addr);
 	} else {
 		cm_node->ipv4 = false;
-		i40iw_netdev_vlan_ipv6(cm_node->loc_addr, &cm_node->vlan_id, NULL);
+		i40iw_netdev_vlan_ipv6(cm_node->loc_addr, &cm_node->vlan_id);
 	}
 	i40iw_debug(cm_node->dev,
 		    I40IW_DEBUG_CM,
@@ -3787,7 +3782,7 @@ int i40iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 				    raddr6->sin6_addr.in6_u.u6_addr32);
 		cm_info.loc_port = ntohs(laddr6->sin6_port);
 		cm_info.rem_port = ntohs(raddr6->sin6_port);
-		i40iw_netdev_vlan_ipv6(cm_info.loc_addr, &cm_info.vlan_id, NULL);
+		i40iw_netdev_vlan_ipv6(cm_info.loc_addr, &cm_info.vlan_id);
 	}
 	cm_info.cm_id = cm_id;
 	cm_info.tos = cm_id->tos;
@@ -3929,8 +3924,7 @@ int i40iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 		cm_info.loc_port = ntohs(laddr6->sin6_port);
 		if (ipv6_addr_type(&laddr6->sin6_addr) != IPV6_ADDR_ANY)
 			i40iw_netdev_vlan_ipv6(cm_info.loc_addr,
-					       &cm_info.vlan_id,
-					       NULL);
+					       &cm_info.vlan_id);
 		else
 			wildcard = true;
 	}
-- 
2.13.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
