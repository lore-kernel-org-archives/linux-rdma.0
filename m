From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 01/16] xprtrdma: Fix buffer leak after transport set up
 failure
Date: Thu, 14 Dec 2017 20:56:01 -0500
Message-ID: <20171215015601.13776.43834.stgit@manet.1015granger.net>
References: <20171215015403.13776.46706.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171215015403.13776.46706.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This leak has been around forever, and is exceptionally rare.

EINVAL causes mount to fail with "an incorrect mount option was
specified" although it's not likely that one of the mount
options is incorrect. Instead, return ENODEV in this case, as this
appears to be an issue with system or device configuration rather
than a specific mount option.

Some obsolete comments are also removed.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 6ee1ad8..7f9b628 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -414,20 +414,10 @@
 	if (rc)
 		goto out2;
 
-	/*
-	 * Allocate pre-registered send and receive buffers for headers and
-	 * any inline data. Also specify any padding which will be provided
-	 * from a preregistered zero buffer.
-	 */
 	rc = rpcrdma_buffer_create(new_xprt);
 	if (rc)
 		goto out3;
 
-	/*
-	 * Register a callback for connection events. This is necessary because
-	 * connection loss notification is async. We also catch connection loss
-	 * when reaping receives.
-	 */
 	INIT_DELAYED_WORK(&new_xprt->rx_connect_worker,
 			  xprt_rdma_connect_worker);
 
@@ -448,8 +438,9 @@
 	return xprt;
 
 out4:
+	rpcrdma_buffer_destroy(&new_xprt->rx_buf);
 	xprt_rdma_free_addresses(xprt);
-	rc = -EINVAL;
+	rc = -ENODEV;
 out3:
 	rpcrdma_ep_destroy(new_ep, &new_xprt->rx_ia);
 out2:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
