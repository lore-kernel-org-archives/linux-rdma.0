From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3 v2] rdma/cm: Listen on specific address family
Date: Thu, 14 Jun 2012 20:31:39 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A3176F@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The rdma_cm maps IPv4 and IPv6 addresses to the same service
ID.  This prevents apps from listening only for IPv4 or IPv6
addresses.  It also results in an app binding to an IPv4
address receiving connection requests for an IPv6 address.

Match socket behavior.  Restrict listens on IPv4 addresses
to only IPv4 addresses.  If a listen is on an IPv6 address,
allow it to receive either IPv4 or IPv6 addresses, based on
its address family binding.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
No change from v1

 drivers/infiniband/core/cma.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d6bb63e..9d83491 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1297,8 +1297,10 @@ static void cma_set_compare_data(enum rdma_port_space ps, struct sockaddr *addr,
 		} else {
 			cma_set_ip_ver(cma_data, 4);
 			cma_set_ip_ver(cma_mask, 0xF);
-			cma_data->dst_addr.ip4.addr = ip4_addr;
-			cma_mask->dst_addr.ip4.addr = htonl(~0);
+			if (!cma_any_addr(addr)) {
+				cma_data->dst_addr.ip4.addr = ip4_addr;
+				cma_mask->dst_addr.ip4.addr = htonl(~0);
+			}
 		}
 		break;
 	case AF_INET6:
@@ -1312,9 +1314,11 @@ static void cma_set_compare_data(enum rdma_port_space ps, struct sockaddr *addr,
 		} else {
 			cma_set_ip_ver(cma_data, 6);
 			cma_set_ip_ver(cma_mask, 0xF);
-			cma_data->dst_addr.ip6 = ip6_addr;
-			memset(&cma_mask->dst_addr.ip6, 0xFF,
-			       sizeof cma_mask->dst_addr.ip6);
+			if (!cma_any_addr(addr)) {
+				cma_data->dst_addr.ip6 = ip6_addr;
+				memset(&cma_mask->dst_addr.ip6, 0xFF,
+				       sizeof cma_mask->dst_addr.ip6);
+			}
 		}
 		break;
 	default:
@@ -1499,7 +1503,7 @@ static int cma_ib_listen(struct rdma_id_private *id_priv)
 
 	addr = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
 	svc_id = cma_get_service_id(id_priv->id.ps, addr);
-	if (cma_any_addr(addr))
+	if (cma_any_addr(addr) && !id_priv->afonly)
 		ret = ib_cm_listen(id_priv->cm_id.ib, svc_id, 0, NULL);
 	else {
 		cma_set_compare_data(id_priv->id.ps, addr, &compare_data);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
