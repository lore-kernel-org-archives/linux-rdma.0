From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Use runtime check for IS_ENABLED(CONFIG_IPV6)
Date: Wed,  9 Nov 2016 21:34:02 -0600
Message-ID: <20161110033402.21704-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To be consistent, use the runtime check instead of
conditional compile.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index c5e3d7a..aaca1d0 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -1579,9 +1579,10 @@ static enum i40iw_status_code i40iw_del_multiple_qhash(
 static struct net_device *i40iw_netdev_vlan_ipv6(u32 *addr, u16 *vlan_id, u8 *mac)
 {
 	struct net_device *ip_dev = NULL;
-#if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr laddr6;
 
+	if (!IS_ENABLED(CONFIG_IPV6))
+		return NULL;
 	i40iw_copy_ip_htonl(laddr6.in6_u.u6_addr32, addr);
 	if (vlan_id)
 		*vlan_id = I40IW_NO_VLAN;
@@ -1598,7 +1599,6 @@ static struct net_device *i40iw_netdev_vlan_ipv6(u32 *addr, u16 *vlan_id, u8 *ma
 		}
 	}
 	rcu_read_unlock();
-#endif
 	return ip_dev;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
