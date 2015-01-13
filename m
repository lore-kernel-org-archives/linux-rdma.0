From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 07/10] svcrdma: rc_position sanity checking
Date: Tue, 13 Jan 2015 11:03:28 -0500
Message-ID: <20150113160328.8118.43894.stgit@klimt.1015granger.net>
References: <20150113155904.8118.57718.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150113155904.8118.57718.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

An RPC/RDMA client may send large RPC arguments via a read
list. This is a list of scatter/gather elements which convey
RPC call arguments too large to fit in a small RDMA SEND.

Each entry in the read list has a "position" field, whose value is
the byte offset in the XDR stream where the data in that entry is to
be inserted. Entries which share the same "position" value make up
the same RPC argument. The receiver inserts entries with the same
position field value in list order into the XDR stream.

Currently the Linux NFS/RDMA server cannot handle receiving read
chunks in more than one position, mostly because no current client
sends read lists with elements in more than one position. As a
sanity check, ensure that all received chunks have the same
"rc_position."

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index c3aebc1..a67dd1a 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -365,6 +365,7 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 	int page_no, ret;
 	struct rpcrdma_read_chunk *ch;
 	u32 handle, page_offset, byte_count;
+	u32 position;
 	u64 rs_offset;
 	bool last;
 
@@ -389,10 +390,17 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 	head->arg.len = rqstp->rq_arg.len;
 	head->arg.buflen = rqstp->rq_arg.buflen;
 
-	page_no = 0; page_offset = 0;
-	for (ch = (struct rpcrdma_read_chunk *)&rmsgp->rm_body.rm_chunks[0];
-	     ch->rc_discrim != 0; ch++) {
-		handle = be32_to_cpu(ch->rc_target.rs_handle);
+	ch = (struct rpcrdma_read_chunk *)&rmsgp->rm_body.rm_chunks[0];
+	position = be32_to_cpu(ch->rc_position);
+
+	ret = 0;
+	page_no = 0;
+	page_offset = 0;
+	for (; ch->rc_discrim != xdr_zero; ch++) {
+		if (be32_to_cpu(ch->rc_position) != position)
+			goto err;
+
+		handle = be32_to_cpu(ch->rc_target.rs_handle),
 		byte_count = be32_to_cpu(ch->rc_target.rs_length);
 		xdr_decode_hyper((__be32 *)&ch->rc_target.rs_offset,
 				 &rs_offset);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
