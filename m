From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 35/37] librdmacm/mckey: use AF_IB for unmapped multicast addresses
Date: Wed, 7 Apr 2010 10:12:43 -0700
Message-ID: <C572C17389DF4C2CA163D2400FFA4273@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the user joins an unmapped multicast address, use AF_IB,
rather than AF_INET6, to communicate that information with the
kernel.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
This requires AF_IB support in the kernel.

 examples/mckey.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/examples/mckey.c b/examples/mckey.c
index ddc3495..a6b5c4d 100644
--- a/examples/mckey.c
+++ b/examples/mckey.c
@@ -46,6 +46,7 @@
 #include <getopt.h>
 
 #include <rdma/rdma_cma.h>
+#include <infiniband/ib.h>
 
 struct cmatest_node {
 	int			id;
@@ -67,9 +68,9 @@ struct cmatest {
 	int			conn_index;
 	int			connects_left;
 
-	struct sockaddr_in6	dst_in;
+	struct sockaddr_storage	dst_in;
 	struct sockaddr		*dst_addr;
-	struct sockaddr_in6	src_in;
+	struct sockaddr_storage	src_in;
 	struct sockaddr		*src_addr;
 };
 
@@ -460,6 +461,20 @@ static int get_addr(char *dst, struct sockaddr *addr)
 	return ret;
 }
 
+static int get_dst_addr(char *dst, struct sockaddr *addr)
+{
+	struct sockaddr_ib *sib;
+
+	if (!unmapped_addr)
+		return get_addr(dst, addr);
+
+	sib = (struct sockaddr_ib *) addr;
+	memset(sib, 0, sizeof *sib);
+	sib->sib_family = AF_IB;
+	inet_pton(AF_INET6, dst, &sib->sib_addr);
+	return 0;
+}
+
 static int run(void)
 {
 	int i, ret;
@@ -471,7 +486,7 @@ static int run(void)
 			return ret;
 	}
 
-	ret = get_addr(dst_addr, (struct sockaddr *) &test.dst_in);
+	ret = get_dst_addr(dst_addr, (struct sockaddr *) &test.dst_in);
 	if (ret)
 		return ret;
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
