From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 2/5] svcrdma: Fix send_reply() scatter/gather set-up
Date: Thu, 09 Jul 2015 16:45:18 -0400
Message-ID: <20150709204518.8481.10431.stgit@klimt.1015granger.net>
References: <20150709204230.8481.45457.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709204230.8481.45457.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The Linux NFS server returns garbage in the data payload of inline
NFS/RDMA READ replies. These are READs of under 1000 bytes or so
where the client has not provided either a reply chunk or a write
list.

The NFS server delivers the data payload for an NFS READ reply to
the transport in an xdr_buf page list. If the NFS client did not
provide a reply chunk or a write list, send_reply() is supposed to
set up a separate sge for the page containing the READ data, and
another sge for XDR padding if needed, then post all of the sges via
a single SEND Work Request.

The problem is send_reply() does not advance through the xdr_buf
when setting up scatter/gather entries for SEND WR. It always calls
dma_map_xdr with xdr_off set to zero. When there's more than one
sge, dma_map_xdr() sets up the SEND sge's so they all point to the
xdr_buf's head.

The current Linux NFS/RDMA client always provides a reply chunk or
a write list when performing an NFS READ over RDMA. Therefore, it
does not exercise this particular case. The Linux server has never
had to use more than one extra sge for building RPC/RDMA replies
with a Linux client.

However, an NFS/RDMA client _is_ allowed to send small NFS READs
without setting up a write list or reply chunk. The NFS READ reply
fits entirely within the inline reply buffer in this case. This is
perhaps a more efficient way of performing NFS READs that the Linux
NFS/RDMA client may some day adopt.

Fixes: b432e6b3d9c1 ('svcrdma: Change DMA mapping logic to . . .')
BugLink: https://bugzilla.linux-nfs.org/show_bug.cgi?id=285
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/svc_rdma_sendto.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index d25cd43..95412ab 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -384,6 +384,7 @@ static int send_reply(struct svcxprt_rdma *rdma,
 		      int byte_count)
 {
 	struct ib_send_wr send_wr;
+	u32 xdr_off;
 	int sge_no;
 	int sge_bytes;
 	int page_no;
@@ -418,8 +419,8 @@ static int send_reply(struct svcxprt_rdma *rdma,
 	ctxt->direction = DMA_TO_DEVICE;
 
 	/* Map the payload indicated by 'byte_count' */
+	xdr_off = 0;
 	for (sge_no = 1; byte_count && sge_no < vec->count; sge_no++) {
-		int xdr_off = 0;
 		sge_bytes = min_t(size_t, vec->sge[sge_no].iov_len, byte_count);
 		byte_count -= sge_bytes;
 		ctxt->sge[sge_no].addr =
@@ -457,6 +458,13 @@ static int send_reply(struct svcxprt_rdma *rdma,
 	}
 	rqstp->rq_next_page = rqstp->rq_respages + 1;
 
+	/* The loop above bumps sc_dma_used for each sge. The
+	 * xdr_buf.tail gets a separate sge, but resides in the
+	 * same page as xdr_buf.head. Don't count it twice.
+	 */
+	if (sge_no > ctxt->count)
+		atomic_dec(&rdma->sc_dma_used);
+
 	if (sge_no > rdma->sc_max_sge) {
 		pr_err("svcrdma: Too many sges (%d)\n", sge_no);
 		goto err;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
