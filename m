From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH 03/28] [v2] infiniband: shut up a maybe-uninitialized warning
Date: Tue, 18 Oct 2016 00:05:32 +0200
Message-ID: <20161017220557.1688282-3-arnd@arndb.de>
References: <20161017220342.1627073-1-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017220342.1627073-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Some configurations produce this harmless warning when built with
gcc -Wmaybe-uninitialized:

infiniband/core/cma.c: In function 'cma_get_net_dev':
infiniband/core/cma.c:1242:12: warning: 'src_addr_storage.sin_addr.s_addr' may be used uninitialized in this function [-Wmaybe-uninitialized]

I previously reported this for the powerpc64 defconfig, but have now
reproduced the same thing for x86 as well, using gcc-5 or higher.

The code looks correct to me, and this change just rearranges it
by making sure we alway initialize the entire address structure
to make the warning disappear. My first approach added an
initialization at the time of the declaration, which Doug commented
may be too costly, so I hope this version doesn't add overhead.

Link: http://arm-soc.lixom.net/buildlogs/mainline/v4.7-rc6/buildall.powerpc.ppc64_defconfig.log.passed
Link: https://patchwork.kernel.org/patch/9212825/
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 56 ++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 36bf50e..24e0ea6 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1094,47 +1094,47 @@ static void cma_save_ib_info(struct sockaddr *src_addr,
 	}
 }
 
-static void cma_save_ip4_info(struct sockaddr *src_addr,
-			      struct sockaddr *dst_addr,
+static void cma_save_ip4_info(struct sockaddr_in *src_addr,
+			      struct sockaddr_in *dst_addr,
 			      struct cma_hdr *hdr,
 			      __be16 local_port)
 {
-	struct sockaddr_in *ip4;
-
 	if (src_addr) {
-		ip4 = (struct sockaddr_in *)src_addr;
-		ip4->sin_family = AF_INET;
-		ip4->sin_addr.s_addr = hdr->dst_addr.ip4.addr;
-		ip4->sin_port = local_port;
+		*src_addr = (struct sockaddr_in) {
+			.sin_family = AF_INET,
+			.sin_addr.s_addr = hdr->dst_addr.ip4.addr,
+			.sin_port = local_port,
+		};
 	}
 
 	if (dst_addr) {
-		ip4 = (struct sockaddr_in *)dst_addr;
-		ip4->sin_family = AF_INET;
-		ip4->sin_addr.s_addr = hdr->src_addr.ip4.addr;
-		ip4->sin_port = hdr->port;
+		*dst_addr = (struct sockaddr_in) {
+			.sin_family = AF_INET,
+			.sin_addr.s_addr = hdr->src_addr.ip4.addr,
+			.sin_port = hdr->port,
+		};
 	}
 }
 
-static void cma_save_ip6_info(struct sockaddr *src_addr,
-			      struct sockaddr *dst_addr,
+static void cma_save_ip6_info(struct sockaddr_in6 *src_addr,
+			      struct sockaddr_in6 *dst_addr,
 			      struct cma_hdr *hdr,
 			      __be16 local_port)
 {
-	struct sockaddr_in6 *ip6;
-
 	if (src_addr) {
-		ip6 = (struct sockaddr_in6 *)src_addr;
-		ip6->sin6_family = AF_INET6;
-		ip6->sin6_addr = hdr->dst_addr.ip6;
-		ip6->sin6_port = local_port;
+		*src_addr = (struct sockaddr_in6) {
+			.sin6_family = AF_INET6,
+			.sin6_addr = hdr->dst_addr.ip6,
+			.sin6_port = local_port,
+		};
 	}
 
 	if (dst_addr) {
-		ip6 = (struct sockaddr_in6 *)dst_addr;
-		ip6->sin6_family = AF_INET6;
-		ip6->sin6_addr = hdr->src_addr.ip6;
-		ip6->sin6_port = hdr->port;
+		*dst_addr = (struct sockaddr_in6) {
+			.sin6_family = AF_INET6,
+			.sin6_addr = hdr->src_addr.ip6,
+			.sin6_port = hdr->port,
+		};
 	}
 }
 
@@ -1159,10 +1159,12 @@ static int cma_save_ip_info(struct sockaddr *src_addr,
 
 	switch (cma_get_ip_ver(hdr)) {
 	case 4:
-		cma_save_ip4_info(src_addr, dst_addr, hdr, port);
+		cma_save_ip4_info((struct sockaddr_in *)src_addr,
+				  (struct sockaddr_in *)dst_addr, hdr, port);
 		break;
 	case 6:
-		cma_save_ip6_info(src_addr, dst_addr, hdr, port);
+		cma_save_ip6_info((struct sockaddr_in6 *)src_addr,
+				  (struct sockaddr_in6 *)dst_addr, hdr, port);
 		break;
 	default:
 		return -EAFNOSUPPORT;
@@ -1309,7 +1311,7 @@ static bool validate_net_dev(struct net_device *net_dev,
 static struct net_device *cma_get_net_dev(struct ib_cm_event *ib_event,
 					  const struct cma_req_info *req)
 {
-	struct sockaddr_storage listen_addr_storage, src_addr_storage;
+	struct sockaddr_storage listen_addr_storage = {}, src_addr_storage = {};
 	struct sockaddr *listen_addr = (struct sockaddr *)&listen_addr_storage,
 			*src_addr = (struct sockaddr *)&src_addr_storage;
 	struct net_device *net_dev;
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
