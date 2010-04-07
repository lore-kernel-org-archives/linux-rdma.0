From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 26/37] librdmacm: set src_addr in rdma_getaddrinfo
Date: Wed, 7 Apr 2010 10:12:43 -0700
Message-ID: <B7B5C575DF7D4C51AB84AFFAC7A5D5C5@amr.corp.intel.com>
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

RDMA requires the user to allocate hardware resources before
establishing a connection.  To support this, the user must know
the source address that the connection will use to reach the
remote endpoint.  Modify rdma_getaddrinfo to determine an
appropriate source address based on the specified destination,
when a source address is not given.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/addrinfo.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/src/addrinfo.c b/src/addrinfo.c
index 15ae071..dfaf9d5 100644
--- a/src/addrinfo.c
+++ b/src/addrinfo.c
@@ -39,6 +39,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netdb.h>
+#include <unistd.h>
 
 #include "cma.h"
 #include <rdma/rdma_cma.h>
@@ -129,6 +130,48 @@ static int ucma_convert_to_rai(struct rdma_addrinfo *rai, struct addrinfo *ai)
 	return 0;
 }
 
+static int ucma_resolve_src(struct rdma_addrinfo *rai)
+{
+	struct sockaddr *addr;
+	socklen_t len;
+	int ret, s;
+
+	s = socket(rai->ai_family, SOCK_DGRAM, IPPROTO_UDP);
+	if (s < 0)
+		return s;
+
+	ret = connect(s, rai->ai_dst_addr, rai->ai_dst_len);
+	if (ret)
+		goto err1;
+
+	addr = zalloc(rai->ai_dst_len);
+	if (!addr) {
+		ret = ERR(ENOMEM);
+		goto err1;
+	}
+
+	len = rai->ai_dst_len;
+	ret = getsockname(s, addr, &len);
+	if (ret)
+		goto err2;
+
+	if (addr->sa_family == AF_INET)
+		((struct sockaddr_in *) addr)->sin_port = 0;
+	else
+		((struct sockaddr_in6 *) addr)->sin6_port = 0;
+	rai->ai_src_addr = addr;
+	rai->ai_src_len = len;
+
+	close(s);
+	return 0;
+
+err2:
+	free(addr);
+err1:
+	close(s);
+	return ret;
+}
+
 int rdma_getaddrinfo(char *node, char *service,
 		     struct rdma_addrinfo *hints,
 		     struct rdma_addrinfo **res)
@@ -159,6 +202,23 @@ int rdma_getaddrinfo(char *node, char *service,
 	if (ret)
 		goto err2;
 
+	if (!rai->ai_src_len) {
+		if (hints && hints->ai_src_len) {
+			rai->ai_src_addr = zalloc(hints->ai_src_len);
+			if (!rai->ai_src_addr) {
+				ret = ERR(ENOMEM);
+				goto err2;
+			}
+			memcpy(rai->ai_src_addr, hints->ai_src_addr,
+			       hints->ai_src_len);
+			rai->ai_src_len = hints->ai_src_len;
+		} else {
+			ret = ucma_resolve_src(rai);
+			if (ret)
+				goto err2;
+		}
+	}
+
 	freeaddrinfo(ai);
 	*res = rai;
 	return 0;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
