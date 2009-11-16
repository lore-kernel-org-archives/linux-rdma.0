From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/9] rdma/addr: use appropriate locking with for_each_netdev
Date: Mon, 16 Nov 2009 15:56:49 -0800
Message-ID: <2ECCDE30329F4354A214C698E4611BFD@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

for_each_netdev() should be used with RTNL or dev_base_lock held,
or risk a crash.

Signed-off-by: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/addr.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 5be1bd4..de16126 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -131,6 +131,7 @@ int rdma_translate_ip(struct sockaddr *addr, struct rdma_dev_addr *dev_addr)
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	case AF_INET6:
+		read_lock(&dev_base_lock);
 		for_each_netdev(&init_net, dev) {
 			if (ipv6_chk_addr(&init_net,
 					  &((struct sockaddr_in6 *) addr)->sin6_addr,
@@ -139,6 +140,7 @@ int rdma_translate_ip(struct sockaddr *addr, struct rdma_dev_addr *dev_addr)
 				break;
 			}
 		}
+		read_unlock(&dev_base_lock);
 		break;
 #endif
 	}
@@ -391,14 +393,17 @@ static int addr_resolve_local(struct sockaddr *src_in,
 	{
 		struct in6_addr *a;
 
+		read_lock(&dev_base_lock);
 		for_each_netdev(&init_net, dev)
 			if (ipv6_chk_addr(&init_net,
 					  &((struct sockaddr_in6 *) addr)->sin6_addr,
 					  dev, 1))
 				break;
 
-		if (!dev)
+		if (!dev) {
+			read_unlock(&dev_base_lock);
 			return -EADDRNOTAVAIL;
+		}
 
 		a = &((struct sockaddr_in6 *) src_in)->sin6_addr;
 
@@ -416,6 +421,7 @@ static int addr_resolve_local(struct sockaddr *src_in,
 			if (!ret)
 				memcpy(addr->dst_dev_addr, dev->dev_addr, MAX_ADDR_LEN);
 		}
+		read_unlock(&dev_base_lock);
 		break;
 	}
 #endif



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
