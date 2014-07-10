From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] svcrdma: Remove extra writeargs sanity check for NFSv2/3
Date: Thu, 10 Jul 2014 13:44:35 -0400
Message-ID: <20140710174435.3734.69638.stgit@klimt.1015granger.net>
References: <20140710174225.3734.44692.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140710174225.3734.44692.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-UeZzRo20aYc@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The server should comply with RFC 5667, and handle WRITE payloads
that may not have a zero pad on the end (XDR length round-up).

Fixes: f34b9568 (The NFSv2/NFSv3 server does not handle zero...)
BugLink: https://bugzilla.linux-nfs.org/show_bug.cgi?id=246
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 fs/nfsd/nfs3xdr.c |   15 +--------------
 fs/nfsd/nfsxdr.c  |   16 +---------------
 2 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index e6c01e8..6074f6a 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -361,7 +361,7 @@ int
 nfs3svc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p,
 					struct nfsd3_writeargs *args)
 {
-	unsigned int len, v, hdr, dlen;
+	unsigned int len, v, hdr;
 	u32 max_blocksize = svc_max_payload(rqstp);
 
 	p = decode_fh(p, &args->fh);
@@ -383,19 +383,6 @@ nfs3svc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p,
 	 * bytes.
 	 */
 	hdr = (void*)p - rqstp->rq_arg.head[0].iov_base;
-	dlen = rqstp->rq_arg.head[0].iov_len + rqstp->rq_arg.page_len
-		- hdr;
-	/*
-	 * Round the length of the data which was specified up to
-	 * the next multiple of XDR units and then compare that
-	 * against the length which was actually received.
-	 * Note that when RPCSEC/GSS (for example) is used, the
-	 * data buffer can be padded so dlen might be larger
-	 * than required.  It must never be smaller.
-	 */
-	if (dlen < XDR_QUADLEN(len)*4)
-		return 0;
-
 	if (args->count > max_blocksize) {
 		args->count = max_blocksize;
 		len = args->len = max_blocksize;
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 1ac306b..1f5347e 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -280,7 +280,7 @@ int
 nfssvc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p,
 					struct nfsd_writeargs *args)
 {
-	unsigned int len, hdr, dlen;
+	unsigned int len, hdr;
 	int v;
 
 	p = decode_fh(p, &args->fh);
@@ -302,20 +302,6 @@ nfssvc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p,
 	 * bytes.
 	 */
 	hdr = (void*)p - rqstp->rq_arg.head[0].iov_base;
-	dlen = rqstp->rq_arg.head[0].iov_len + rqstp->rq_arg.page_len
-		- hdr;
-
-	/*
-	 * Round the length of the data which was specified up to
-	 * the next multiple of XDR units and then compare that
-	 * against the length which was actually received.
-	 * Note that when RPCSEC/GSS (for example) is used, the
-	 * data buffer can be padded so dlen might be larger
-	 * than required.  It must never be smaller.
-	 */
-	if (dlen < XDR_QUADLEN(len)*4)
-		return 0;
-
 	rqstp->rq_vec[0].iov_base = (void*)p;
 	rqstp->rq_vec[0].iov_len = rqstp->rq_arg.head[0].iov_len - hdr;
 	v = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
