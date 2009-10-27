From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] link-local address fix for rdma_resolve_addr
Date: Tue, 27 Oct 2009 11:22:18 -0700
Message-ID: <1256667738.16192.1.camel@wilder.ibm.com>
References: <1255992430.12075.7.camel@wilder.ibm.com>
	 <20091019234329.GC9643@obsidianresearch.com>
	 <676AB781CD644CC28E1AD4951EA4EEF8@amr.corp.intel.com>
	 <20091020003344.GA14520@obsidianresearch.com>
	 <1256164230.12075.31.camel@wilder.ibm.com>
	 <20091021230845.GR14520@obsidianresearch.com>
	 <1256245942.12075.46.camel@wilder.ibm.com>
	 <660D538F30E647F3AE1E5E6C1ACBE882@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <660D538F30E647F3AE1E5E6C1ACBE882-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Thu, 2009-10-22 at 15:02 -0700, Sean Hefty wrote:
> >For ipv6 I ran what I described previously.  What I do need to do is add
> >the option to rping to specify a source address and run it with various
> >address.  Any help you can give defining what exactly needs to be tested
> >would be appreciated.
> 
> You can also test with ucmatose to verify ipv4 still works.  Use the -b option
> to bind to a specific address.
> 
> - Sean 
> 

Sean
This patch adds ipv6 support to ucmatose.

Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

------------------------------------------------------
 examples/cmatose.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/examples/cmatose.c b/examples/cmatose.c
index 8c12347..481a6d0 100644
--- a/examples/cmatose.c
+++ b/examples/cmatose.c
@@ -516,15 +516,15 @@ static int get_addr(char *dst, struct sockaddr_in *addr)
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
@@ -543,11 +543,18 @@ static int run_server(void)
 		ret = get_addr(src_addr, &test.src_in);
 		if (ret)
 			goto out;
-	} else
+		if(test.src_in.sin_family == AF_INET)
+			((struct sockaddr_in *) &test.src_in)->sin_port = port;
+		else
+			((struct sockaddr_in6 *) &test.src_in)->sin6_port=port;
+		
+	} else {
 		test.src_in.sin_family = PF_INET;
+		test.src_in.sin_port = port;
+	}
+
+	ret = rdma_bind_addr(listen_id, (struct sockaddr *)&test.src_in);
 
-	test.src_in.sin_port = port;
-	ret = rdma_bind_addr(listen_id, test.src_addr);
 	if (ret) {
 		perror("cmatose: bind address failed");
 		goto out;
@@ -628,8 +635,8 @@ static int run_client(void)
 	printf("cmatose: connecting\n");
 	for (i = 0; i < connections; i++) {
 		ret = rdma_resolve_addr(test.nodes[i].cma_id,
-					src_addr ? test.src_addr : NULL,
-					test.dst_addr, 2000);
+			src_addr ? (struct sockaddr *)&test.src_in : NULL,
+			(struct sockaddr *)&test.dst_in, 2000);
 		if (ret) {
 			perror("cmatose: failure getting addr");
 			connect_error();


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
