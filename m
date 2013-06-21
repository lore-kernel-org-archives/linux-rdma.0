From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 13/15 ibacm] ib_acme.c: Support IPv6 addressing in resolve_ip
Date: Fri, 21 Jun 2013 07:02:41 -0400
Message-ID: <51C432D1.9000804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/acme.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/src/acme.c b/src/acme.c
index ea44eb94..db47faa 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -471,29 +471,52 @@ static int resolve_ip(struct ibv_path_record *path)
 {
 	struct ibv_path_data *paths;
 	struct sockaddr_in src, dest;
+	struct sockaddr_in6 src6, dest6;
 	struct sockaddr *saddr;
 	int ret, count;
+	int is_ipv6_src, is_ipv6_dest;
 
 	if (src_addr) {
+		is_ipv6_src = 0;
 		src.sin_family = AF_INET;
 		ret = inet_pton(AF_INET, src_addr, &src.sin_addr);
 		if (ret <= 0) {
-			printf("inet_pton error on source address (%s): 0x%x\n", src_addr, ret);
-			return -1;
+			src6.sin6_family = AF_INET6;
+			ret = inet_pton(AF_INET6, src_addr, &src6.sin6_addr);
+			if (ret <= 0) {
+				printf("inet_pton error on source address (%s): 0x%x\n", src_addr, ret);
+				return -1;
+			}
+			is_ipv6_src = 1;
 		}
-		saddr = (struct sockaddr *) &src;
+		if (is_ipv6_src)
+			saddr = (struct sockaddr *) &src6;
+		else
+			saddr = (struct sockaddr *) &src;
 	} else {
 		saddr = NULL;
 	}
 
+	is_ipv6_dest = 0;
 	dest.sin_family = AF_INET;
 	ret = inet_pton(AF_INET, dest_addr, &dest.sin_addr);
 	if (ret <= 0) {
-		printf("inet_pton error on destination address (%s): 0x%x\n", dest_addr, ret);
+		dest6.sin6_family = AF_INET6;
+		ret = inet_pton(AF_INET6, dest_addr, &dest6.sin6_addr);
+		if (ret <= 0) {
+			printf("inet_pton error on destination address (%s): 0x%x\n", dest_addr, ret);
+			return -1;
+		}
+		is_ipv6_dest = 1;
+	}
+
+	if (src_addr && is_ipv6_src != is_ipv6_dest) {
+		printf("source and destination address families don't match\n");
 		return -1;
 	}
 
-	ret = ib_acm_resolve_ip(saddr, (struct sockaddr *) &dest,
+	ret = ib_acm_resolve_ip(saddr,
+		(is_ipv6_dest ? (struct sockaddr *) &dest6 : (struct sockaddr *) &dest),
 		&paths, &count, get_resolve_flags());
 	if (ret) {
 		printf("ib_acm_resolve_ip failed: %s\n", strerror(errno));
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
