From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/9] svcrdma: Do not add XDR padding to xdr_buf page
 vector
Date: Wed, 04 May 2016 10:52:55 -0400
Message-ID: <20160504145255.6602.10528.stgit@klimt.1015granger.net>
References: <20160504144730.6602.89073.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504144730.6602.89073.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

An xdr_buf has a head, a vector of pages, and a tail. Each
RPC request is presented to the NFS server contained in an
xdr_buf.

The RDMA transport would like to supply the NFS server with only
the NFS WRITE payload bytes in the page vector. In some common
cases, that would allow the NFS server to swap those pages right
into the target file's page cache.

Have the transport's RDMA Read logic put XDR pad bytes in the tail
iovec, and not in the pages that hold the data payload.

The NFSv3 WRITE XDR decoder is finicky about the lengths involved,
so make sure it is looking in the correct places when computing
the total length of the incoming NFS WRITE request.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/nfsd/nfs3xdr.c                       |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 2246454..c5eff5f 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -379,7 +379,7 @@ nfs3svc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p,
 	 */
 	hdr = (void*)p - rqstp->rq_arg.head[0].iov_base;
 	dlen = rqstp->rq_arg.head[0].iov_len + rqstp->rq_arg.page_len
-		- hdr;
+		+ rqstp->rq_arg.tail[0].iov_len - hdr;
 	/*
 	 * Round the length of the data which was specified up to
 	 * the next multiple of XDR units and then compare that
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 3b24a64..234be9d 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -488,7 +488,7 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 	if (page_offset & 3) {
 		u32 pad = 4 - (page_offset & 3);
 
-		head->arg.page_len += pad;
+		head->arg.tail[0].iov_len += pad;
 		head->arg.len += pad;
 		head->arg.buflen += pad;
 		page_offset += pad;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
