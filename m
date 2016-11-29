From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 08/10] svcrdma: Remove unused variable in rdma_copy_tail()
Date: Tue, 29 Nov 2016 11:05:23 -0500
Message-ID: <20161129160523.4477.15121.stgit@klimt.1015granger.net>
References: <20161129155521.4477.53561.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129155521.4477.53561.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up.

linux-2.6/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c: In function
 ‘rdma_copy_tail’:
linux-2.6/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c:376:6: warning:
 variable ‘ret’ set but not used [-Wunused-but-set-variable]
  int ret;
      ^

Fixes: a97c331f9aa9 ("svcrdma: Handle additional inline content")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 428ab4ef..57d35fb 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -373,9 +373,7 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	       u32 position, u32 byte_count, u32 page_offset, int page_no)
 {
 	char *srcp, *destp;
-	int ret;
 
-	ret = 0;
 	srcp = head->arg.head[0].iov_base + position;
 	byte_count = head->arg.head[0].iov_len - position;
 	if (byte_count > PAGE_SIZE) {

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
