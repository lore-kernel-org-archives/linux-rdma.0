From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] xprtrdma: Fix calculation of ri_max_send_sges
Date: Wed, 31 Jan 2018 12:34:05 -0500
Message-ID: <20180131173405.11367.42982.stgit@manet.1015granger.net>
References: <20180131173308.11367.93367.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180131173308.11367.93367.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 16f906d66cd7 ("xprtrdma: Reduce required number of send
SGEs") introduced the rpcrdma_ia::ri_max_send_sges field. This fixes
a problem where xprtrdma would not work if the device's max_sge
capability was small (low single digits).

At least RPCRDMA_MIN_SEND_SGES are needed for the inline parts of
each RPC. ri_max_send_sges is set to this value:

  ia->ri_max_send_sges = max_sge - RPCRDMA_MIN_SEND_SGES;

Then when marshaling each RPC, rpcrdma_args_inline uses that value
to determine whether the device has enough Send SGEs to convey an
NFS WRITE payload inline, or whether instead a Read chunk is
required.

More recently, commit ae72950abf99 ("xprtrdma: Add data structure to
manage RDMA Send arguments") used the ri_max_send_sges value to
calculate the size of an array, but that commit erroneously assumed
ri_max_send_sges contains a value similar to the device's max_sge,
and not one that was reduced by the minimum SGE count.

This assumption results in the calculated size of the sendctx's
Send SGE array to be too small. When the array is used to marshal
an RPC, the code can write Send SGEs into the following sendctx
element in that array, corrupting it. When the device's max_sge is
large, this issue is entirely harmless; but it results in an oops
in the provider's post_send method, if dev.attrs.max_sge is small.

So let's straighten this out: ri_max_send_sges will now contain a
value with the same meaning as dev.attrs.max_sge, which makes
the code easier to understand, and enables rpcrdma_sendctx_create
to calculate the size of the SGE array correctly.

Reported-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Fixes: 16f906d66cd7 ("xprtrdma: Reduce required number of send SGEs")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |    2 +-
 net/sunrpc/xprtrdma/verbs.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 162e5dd..f0855a9 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -143,7 +143,7 @@ static bool rpcrdma_args_inline(struct rpcrdma_xprt *r_xprt,
 	if (xdr->page_len) {
 		remaining = xdr->page_len;
 		offset = offset_in_page(xdr->page_base);
-		count = 0;
+		count = RPCRDMA_MIN_SEND_SGES;
 		while (remaining) {
 			remaining -= min_t(unsigned int,
 					   PAGE_SIZE - offset, remaining);
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index f4eb63e..bb56b9d 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -505,7 +505,7 @@
 		pr_warn("rpcrdma: HCA provides only %d send SGEs\n", max_sge);
 		return -ENOMEM;
 	}
-	ia->ri_max_send_sges = max_sge - RPCRDMA_MIN_SEND_SGES;
+	ia->ri_max_send_sges = max_sge;
 
 	if (ia->ri_device->attrs.max_qp_wr <= RPCRDMA_BACKWARD_WRS) {
 		dprintk("RPC:       %s: insufficient wqe's available\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
