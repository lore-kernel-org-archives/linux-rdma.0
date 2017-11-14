From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 24/31] RDMA/core: Avoid copying ifindex twice
Date: Tue, 14 Nov 2017 14:52:11 +0200
Message-ID: <20171114125218.20477-25-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

rdma_copy_addr copies the ifndex to bound_dev_if.
Therefore avoid copying it again after rdma_copy_addr call is completed.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/addr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 0ae18608761c..a5b4cf030c11 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -265,7 +265,6 @@ int rdma_translate_ip(const struct sockaddr *addr,
 			return -EADDRNOTAVAIL;
 
 		rdma_copy_addr(dev_addr, dev, NULL);
-		dev_addr->bound_dev_if = dev->ifindex;
 		dev_put(dev);
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -276,7 +275,6 @@ int rdma_translate_ip(const struct sockaddr *addr,
 					  &((const struct sockaddr_in6 *)addr)->sin6_addr,
 					  dev, 1)) {
 				rdma_copy_addr(dev_addr, dev, NULL);
-				dev_addr->bound_dev_if = dev->ifindex;
 				break;
 			}
 		}
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
