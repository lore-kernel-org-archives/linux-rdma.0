From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/8] SUNRPC: Fix large reads on NFS/RDMA
Date: Mon, 03 Feb 2014 16:02:06 -0500
Message-ID: <20140203210206.3533.26891.stgit@manet.1015granger.net>
References: <20140203205903.3533.39213.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140203205903.3533.39213.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

After commit a11a2bf4, "SUNRPC: Optimise away unnecessary data moves
in xdr_align_pages", Thu Aug 2 13:21:43 2012, READs larger than a
few hundred bytes via NFS/RDMA no longer work.  This commit exposed
a long-standing bug in rpcrdma_inline_fixup().

I reproduce this with an rsize=4096 mount using the cthon04 basic
tests.  Test 5 fails with an EIO error.

For my reproducer, kernel log shows:

  NFS: server cheating in read reply: count 4096 > recvd 0

rpcrdma_inline_fixup() is zeroing the xdr_stream::page_len field,
and xdr_align_pages() is now returning that value to the READ XDR
decoder function.

That field is set up by xdr_inline_pages() by the READ XDR encoder
function.  As far as I can tell, it is supposed to be left alone
after that, as it describes the dimensions of the reply xdr_stream,
not the contents of that stream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=68391
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.7+
---

 net/sunrpc/xprtrdma/rpc_rdma.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index e03725b..96ead52 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -649,9 +649,7 @@ rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len, int pad)
 				break;
 			page_base = 0;
 		}
-		rqst->rq_rcv_buf.page_len = olen - copy_len;
-	} else
-		rqst->rq_rcv_buf.page_len = 0;
+	}
 
 	if (copy_len && rqst->rq_rcv_buf.tail[0].iov_len) {
 		curlen = copy_len;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
