From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm/cmatose: add support for ipv6
Date: Tue, 27 Oct 2009 12:42:26 -0700
Message-ID: <4EED1F3C9F7C49A2998F4DBDCB8CC3E7@amr.corp.intel.com>
References: <1255992430.12075.7.camel@wilder.ibm.com>	 <20091019234329.GC9643@obsidianresearch.com>	 <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com>	 <20091020003344.GA14520@obsidianresearch.com>	 <1256164230.12075.31.camel@wilder.ibm.com>	 <20091021230845.GR14520@obsidianresearch.com>	 <1256245942.12075.46.camel@wilder.ibm.com>	 <660D538F30E647F3AE1E5E6C1ACBE882@amr.corp.intel.com> <1256667738.16192.1.camel@wilder.ibm.com> <EE6710D62B854E4FBA82524DEB84E8DC@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE6710D62B854E4FBA82524DEB84E8DC-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'David J. Wilder'" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: David J. Wilder <[dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org]>

Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
We need to update struct cmatest to allow storing an IPv6 address,
or we can overrun the buffer.

Running with this patch, the client causes a kernel bug on 2.6.31 in
addr_resolve_local, so we'll still fixes for that.  It also meant that
I couldn't test this patch.

 examples/cmatose.c |   53 ++++++++++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/examples/cmatose.c b/examples/cmatose.c
index 8c12347..84831ec 100644
--- a/examples/cmatose.c
+++ b/examples/cmatose.c
@@ -75,10 +75,7 @@ struct cmatest {
 	int			connects_left;
 	int			disconnects_left;
 
-	struct sockaddr_in	dst_in;
-	struct sockaddr		*dst_addr;
-	struct sockaddr_in	src_in;
-	struct sockaddr		*src_addr;
+	struct rdma_addr	addr;
 };
 
 static struct cmatest test;
@@ -505,7 +502,7 @@ static int migrate_channel(struct rdma_cm_id *listen_id)
 	return ret;
 }
 
-static int get_addr(char *dst, struct sockaddr_in *addr)
+static int get_addr(char *dst, struct sockaddr *addr)
 {
 	struct addrinfo *res;
 	int ret;
@@ -516,15 +513,15 @@ static int get_addr(char *dst, struct sockaddr_in *addr)
 		return ret;
 	}
 
-	if (res->ai_family != PF_INET) {
+	if (res->ai_family == PF_INET)
+		memcpy(addr, res->ai_addr, sizeof(struct sockaddr_in));
+	else if (res->ai_family == PF_INET6)
+		memcpy(addr, res->ai_addr, sizeof(struct sockaddr_in6));
+	else
 		ret = -1;
-		goto out;
-	}
 
-	*addr = *(struct sockaddr_in *) res->ai_addr;
-out:
-	freeaddrinfo(res);
-	return ret;
+        freeaddrinfo(res);
+        return ret;
 }
 
 static int run_server(void)
@@ -540,14 +537,21 @@ static int run_server(void)
 	}
 
 	if (src_addr) {
-		ret = get_addr(src_addr, &test.src_in);
+		ret = get_addr(src_addr, &test.addr.src_addr);
 		if (ret)
 			goto out;
-	} else
-		test.src_in.sin_family = PF_INET;
+		if (test.addr.src_addr.sa_family == AF_INET)
+			((struct sockaddr_in *) &test.addr.src_addr)->sin_port = port;
+		else
+			((struct sockaddr_in6 *) &test.addr.src_addr)->sin6_port = port;
+		
+	} else {
+		test.addr.src_addr.sa_family = PF_INET;
+		((struct sockaddr_in *) &test.addr.src_addr)->sin_port = port;
+	}
+
+	ret = rdma_bind_addr(listen_id, &test.addr.src_addr);
 
-	test.src_in.sin_port = port;
-	ret = rdma_bind_addr(listen_id, test.src_addr);
 	if (ret) {
 		perror("cmatose: bind address failed");
 		goto out;
@@ -614,22 +618,25 @@ static int run_client(void)
 
 	printf("cmatose: starting client\n");
 	if (src_addr) {
-		ret = get_addr(src_addr, &test.src_in);
+		ret = get_addr(src_addr, &test.addr.src_addr);
 		if (ret)
 			return ret;
 	}
 
-	ret = get_addr(dst_addr, &test.dst_in);
+	ret = get_addr(dst_addr, &test.addr.dst_addr);
 	if (ret)
 		return ret;
 
-	test.dst_in.sin_port = port;
+	if (test.addr.dst_addr.sa_family == AF_INET)
+		((struct sockaddr_in *) &test.addr.dst_addr)->sin_port = port;
+	else
+		((struct sockaddr_in6 *) &test.addr.dst_addr)->sin6_port = port;
 
 	printf("cmatose: connecting\n");
 	for (i = 0; i < connections; i++) {
 		ret = rdma_resolve_addr(test.nodes[i].cma_id,
-					src_addr ? test.src_addr : NULL,
-					test.dst_addr, 2000);
+					src_addr ? &test.addr.src_addr : NULL,
+					&test.addr.dst_addr, 2000);
 		if (ret) {
 			perror("cmatose: failure getting addr");
 			connect_error();
@@ -717,8 +724,6 @@ int main(int argc, char **argv)
 		}
 	}
 
-	test.dst_addr = (struct sockaddr *) &test.dst_in;
-	test.src_addr = (struct sockaddr *) &test.src_in;
 	test.connects_left = connections;
 	test.disconnects_left = connections;
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
