From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC 1/5] xprtrdma: Clean up SGE accounting in
 rpcrdma_prepare_msg_sges()
Date: Tue, 05 Sep 2017 13:00:20 -0400
Message-ID: <20170905170020.11106.36474.stgit@manet.1015granger.net>
References: <20170905164347.11106.27140.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170905164347.11106.27140.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

rpcrdma_prepare_hdr_sges() sets num_sge to one, then
rpcrdma_prepare_msg_sges() sets num_sge again to the count of SGEs
it added, plus one for the header SGE just mapped in
rpcrdma_prepare_hdr_sges().

Let's just add the number we mapped, instead of setting num_sge
again. The behavior should be the same, but the code is slightly
clearer and less likely to break due to unrelated changes.

Similarly, simplify mapped SGE counting by just adding the running
count of SGEs before returning.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 84584ca..7ec4fde 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -607,7 +607,6 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 			sge[sge_no].length = len;
 			sge[sge_no].lkey = lkey;
 
-			req->rl_mapped_sges++;
 			ppages++;
 			remaining -= len;
 			page_base = 0;
@@ -633,11 +632,11 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 			goto out_mapping_err;
 		sge[sge_no].length = len;
 		sge[sge_no].lkey = lkey;
-		req->rl_mapped_sges++;
 	}
 
 out:
-	req->rl_send_wr.num_sge = sge_no + 1;
+	req->rl_send_wr.num_sge += sge_no;
+	req->rl_mapped_sges += sge_no - 1;
 	return true;
 
 out_mapping_overflow:

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
