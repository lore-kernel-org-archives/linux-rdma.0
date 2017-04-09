From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 14/14] svcrdma: Clean out old XDR encoders
Date: Sun, 09 Apr 2017 13:07:21 -0400
Message-ID: <20170409170721.15073.23878.stgit@klimt.1015granger.net>
References: <20170409163820.15073.43257.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409163820.15073.43257.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: These have been replaced and are no longer used.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h        |    4 --
 net/sunrpc/xprtrdma/svc_rdma_marshal.c |   70 --------------------------------
 2 files changed, 74 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 479bb7f..f3787d8 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -187,10 +187,6 @@ extern int svc_rdma_handle_bc_reply(struct rpc_xprt *xprt,
 
 /* svc_rdma_marshal.c */
 extern int svc_rdma_xdr_decode_req(struct xdr_buf *);
-extern void svc_rdma_xdr_encode_reply_array(struct rpcrdma_write_array *, int);
-extern void svc_rdma_xdr_encode_array_chunk(struct rpcrdma_write_array *, int,
-					    __be32, __be64, u32);
-extern unsigned int svc_rdma_xdr_get_reply_hdr_len(__be32 *rdma_resp);
 
 /* svc_rdma_recvfrom.c */
 extern int svc_rdma_recvfrom(struct svc_rqst *);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_marshal.c b/net/sunrpc/xprtrdma/svc_rdma_marshal.c
index ae58a89..bdcf7d8 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_marshal.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_marshal.c
@@ -166,73 +166,3 @@ int svc_rdma_xdr_decode_req(struct xdr_buf *rq_arg)
 	dprintk("svcrdma: failed to parse transport header\n");
 	return -EINVAL;
 }
-
-/**
- * svc_rdma_xdr_get_reply_hdr_length - Get length of Reply transport header
- * @rdma_resp: buffer containing Reply transport header
- *
- * Returns length of transport header, in bytes.
- */
-unsigned int svc_rdma_xdr_get_reply_hdr_len(__be32 *rdma_resp)
-{
-	unsigned int nsegs;
-	__be32 *p;
-
-	p = rdma_resp;
-
-	/* RPC-over-RDMA V1 replies never have a Read list. */
-	p += rpcrdma_fixed_maxsz + 1;
-
-	/* Skip Write list. */
-	while (*p++ != xdr_zero) {
-		nsegs = be32_to_cpup(p++);
-		p += nsegs * rpcrdma_segment_maxsz;
-	}
-
-	/* Skip Reply chunk. */
-	if (*p++ != xdr_zero) {
-		nsegs = be32_to_cpup(p++);
-		p += nsegs * rpcrdma_segment_maxsz;
-	}
-
-	return (unsigned long)p - (unsigned long)rdma_resp;
-}
-
-void svc_rdma_xdr_encode_write_list(struct rpcrdma_msg *rmsgp, int chunks)
-{
-	struct rpcrdma_write_array *ary;
-
-	/* no read-list */
-	rmsgp->rm_body.rm_chunks[0] = xdr_zero;
-
-	/* write-array discrim */
-	ary = (struct rpcrdma_write_array *)
-		&rmsgp->rm_body.rm_chunks[1];
-	ary->wc_discrim = xdr_one;
-	ary->wc_nchunks = cpu_to_be32(chunks);
-
-	/* write-list terminator */
-	ary->wc_array[chunks].wc_target.rs_handle = xdr_zero;
-
-	/* reply-array discriminator */
-	ary->wc_array[chunks].wc_target.rs_length = xdr_zero;
-}
-
-void svc_rdma_xdr_encode_reply_array(struct rpcrdma_write_array *ary,
-				 int chunks)
-{
-	ary->wc_discrim = xdr_one;
-	ary->wc_nchunks = cpu_to_be32(chunks);
-}
-
-void svc_rdma_xdr_encode_array_chunk(struct rpcrdma_write_array *ary,
-				     int chunk_no,
-				     __be32 rs_handle,
-				     __be64 rs_offset,
-				     u32 write_len)
-{
-	struct rpcrdma_segment *seg = &ary->wc_array[chunk_no].wc_target;
-	seg->rs_handle = rs_handle;
-	seg->rs_offset = rs_offset;
-	seg->rs_length = cpu_to_be32(write_len);
-}

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
