From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 18/24] xprtrdma: Allocate missing pagelist
Date: Wed, 28 May 2014 10:34:24 -0400
Message-ID: <20140528143424.23214.59578.stgit@manet.1015granger.net>
References: <20140528142521.23214.39655.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140528142521.23214.39655.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

GETACL relies on transport layer to alloc memory for reply buffer.
However xprtrdma assumes that the reply buffer (pagelist) has been
pre-allocated in upper layer. This problem was reported by IOL OFA lab
test on PPC.

Signed-off-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Edward Mossman <emossman-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>
---

 net/sunrpc/xprtrdma/rpc_rdma.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 436d229..dc4a826 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -99,6 +99,12 @@ rpcrdma_convert_iovs(struct xdr_buf *xdrbuf, unsigned int pos,
 	page_base = xdrbuf->page_base & ~PAGE_MASK;
 	p = 0;
 	while (len && n < nsegs) {
+		if (!ppages[p]) {
+			/* alloc the pagelist for receiving buffer */
+			ppages[p] = alloc_page(GFP_ATOMIC);
+			if (!ppages[p])
+				return 0;
+		}
 		seg[n].mr_page = ppages[p];
 		seg[n].mr_offset = (void *)(unsigned long) page_base;
 		seg[n].mr_len = min_t(u32, PAGE_SIZE - page_base, len);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
