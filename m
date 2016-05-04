From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/9] svcrdma: Support IPv6 with NFS/RDMA
Date: Wed, 04 May 2016 10:52:47 -0400
Message-ID: <20160504145247.6602.27804.stgit@klimt.1015granger.net>
References: <20160504144730.6602.89073.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504144730.6602.89073.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Allow both IPv4 and IPv6 to bind same port at the same time,
restricts use of the IPv6 socket to IPv6 communication.

Changes from v1:
 - Check rdma_set_afonly return value (suggested by Leon Romanovsky)

Changes from v2:
 - Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 9066896..d2680b8 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -789,7 +789,7 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
 	int ret;
 
 	dprintk("svcrdma: Creating RDMA socket\n");
-	if (sa->sa_family != AF_INET) {
+	if ((sa->sa_family != AF_INET) && (sa->sa_family != AF_INET6)) {
 		dprintk("svcrdma: Address family %d is not supported.\n", sa->sa_family);
 		return ERR_PTR(-EAFNOSUPPORT);
 	}
@@ -805,6 +805,16 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
 		goto err0;
 	}
 
+	/* Allow both IPv4 and IPv6 sockets to bind a single port
+	 * at the same time.
+	 */
+#if IS_ENABLED(CONFIG_IPV6)
+	ret = rdma_set_afonly(listen_id, 1);
+	if (ret) {
+		dprintk("svcrdma: rdma_set_afonly failed = %d\n", ret);
+		goto err1;
+	}
+#endif
 	ret = rdma_bind_addr(listen_id, sa);
 	if (ret) {
 		dprintk("svcrdma: rdma_bind_addr failed = %d\n", ret);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
