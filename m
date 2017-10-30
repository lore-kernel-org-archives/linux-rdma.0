From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/4] rpcrdma: Remove C structure definitions of XDR data
 items
Date: Mon, 30 Oct 2017 16:21:57 -0400
Message-ID: <20171030202157.8146.92508.stgit@manet.1015granger.net>
References: <20171030201903.8146.45897.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171030201903.8146.45897.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: C-structure style XDR encoding and decoding logic has
been replaced over the past several merge windows on both the
client and server. These data structures are no longer used.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 include/linux/sunrpc/rpc_rdma.h |   59 ---------------------------------------
 net/sunrpc/xprtrdma/rpc_rdma.c  |    6 ++--
 net/sunrpc/xprtrdma/xprt_rdma.h |    6 ----
 3 files changed, 3 insertions(+), 68 deletions(-)

diff --git a/include/linux/sunrpc/rpc_rdma.h b/include/linux/sunrpc/rpc_rdma.h
index b7e85b3..840afac 100644
--- a/include/linux/sunrpc/rpc_rdma.h
+++ b/include/linux/sunrpc/rpc_rdma.h
@@ -50,65 +50,6 @@ enum {
 	RPCRDMA_V1_DEF_INLINE_SIZE	= 1024,
 };
 
-struct rpcrdma_segment {
-	__be32 rs_handle;	/* Registered memory handle */
-	__be32 rs_length;	/* Length of the chunk in bytes */
-	__be64 rs_offset;	/* Chunk virtual address or offset */
-};
-
-/*
- * read chunk(s), encoded as a linked list.
- */
-struct rpcrdma_read_chunk {
-	__be32 rc_discrim;	/* 1 indicates presence */
-	__be32 rc_position;	/* Position in XDR stream */
-	struct rpcrdma_segment rc_target;
-};
-
-/*
- * write chunk, and reply chunk.
- */
-struct rpcrdma_write_chunk {
-	struct rpcrdma_segment wc_target;
-};
-
-/*
- * write chunk(s), encoded as a counted array.
- */
-struct rpcrdma_write_array {
-	__be32 wc_discrim;	/* 1 indicates presence */
-	__be32 wc_nchunks;	/* Array count */
-	struct rpcrdma_write_chunk wc_array[0];
-};
-
-struct rpcrdma_msg {
-	__be32 rm_xid;	/* Mirrors the RPC header xid */
-	__be32 rm_vers;	/* Version of this protocol */
-	__be32 rm_credit;	/* Buffers requested/granted */
-	__be32 rm_type;	/* Type of message (enum rpcrdma_proc) */
-	union {
-
-		struct {			/* no chunks */
-			__be32 rm_empty[3];	/* 3 empty chunk lists */
-		} rm_nochunks;
-
-		struct {			/* no chunks and padded */
-			__be32 rm_align;	/* Padding alignment */
-			__be32 rm_thresh;	/* Padding threshold */
-			__be32 rm_pempty[3];	/* 3 empty chunk lists */
-		} rm_padded;
-
-		struct {
-			__be32 rm_err;
-			__be32 rm_vers_low;
-			__be32 rm_vers_high;
-		} rm_error;
-
-		__be32 rm_chunks[0];	/* read, write and reply chunks */
-
-	} rm_body;
-};
-
 /*
  * XDR sizes, in quads
  */
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 4fdeaac..45cb549 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -75,11 +75,11 @@ static unsigned int rpcrdma_max_call_header_size(unsigned int maxsegs)
 
 	/* Maximum Read list size */
 	maxsegs += 2;	/* segment for head and tail buffers */
-	size = maxsegs * sizeof(struct rpcrdma_read_chunk);
+	size = maxsegs * rpcrdma_readchunk_maxsz * sizeof(__be32);
 
 	/* Minimal Read chunk size */
 	size += sizeof(__be32);	/* segment count */
-	size += sizeof(struct rpcrdma_segment);
+	size += rpcrdma_segment_maxsz * sizeof(__be32);
 	size += sizeof(__be32);	/* list discriminator */
 
 	dprintk("RPC:       %s: max call header size = %u\n",
@@ -102,7 +102,7 @@ static unsigned int rpcrdma_max_reply_header_size(unsigned int maxsegs)
 	/* Maximum Write list size */
 	maxsegs += 2;	/* segment for head and tail buffers */
 	size = sizeof(__be32);		/* segment count */
-	size += maxsegs * sizeof(struct rpcrdma_segment);
+	size += maxsegs * rpcrdma_segment_maxsz * sizeof(__be32);
 	size += sizeof(__be32);	/* list discriminator */
 
 	dprintk("RPC:       %s: max reply header size = %u\n",
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 6e64c82..8b9954c 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -145,12 +145,6 @@ struct rpcrdma_regbuf {
 	return rb->rg_iov.lkey;
 }
 
-static inline struct rpcrdma_msg *
-rdmab_to_msg(struct rpcrdma_regbuf *rb)
-{
-	return (struct rpcrdma_msg *)rb->rg_base;
-}
-
 static inline struct ib_device *
 rdmab_device(struct rpcrdma_regbuf *rb)
 {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
