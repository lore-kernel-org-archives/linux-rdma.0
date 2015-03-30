From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 04/15] xprtrdma: Byte-align FRWR registration
Date: Mon, 30 Mar 2015 14:34:02 -0400
Message-ID: <20150330183402.7856.3469.stgit@manet.1015granger.net>
References: <20150330182615.7856.61170.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150330182615.7856.61170.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The RPC/RDMA transport's FRWR registration logic registers whole
pages. This means areas in the first and last pages that are not
involved in the RDMA I/O are needlessly exposed to the server.

Buffered I/O is typically page-aligned, so not a problem there. But
for direct I/O, which can be byte-aligned, and for reply chunks,
which are nearly always smaller than a page, the transport could
expose memory outside the I/O buffer.

FRWR allows byte-aligned memory registration, so let's use it as
it was intended.

Reported-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Tested-by: Meghana Cheripady <Meghana.Cheripady-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Tested-by: Veeresh U. Kokatnur <veereshuk-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 1aa55b7..60f3317 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1924,23 +1924,19 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 		    offset_in_page((seg-1)->mr_offset + (seg-1)->mr_len))
 			break;
 	}
-	dprintk("RPC:       %s: Using frmr %p to map %d segments\n",
-		__func__, mw, i);
+	dprintk("RPC:       %s: Using frmr %p to map %d segments (%d bytes)\n",
+		__func__, mw, i, len);
 
 	frmr->fr_state = FRMR_IS_VALID;
 
 	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
 	fastreg_wr.wr_id = (unsigned long)(void *)mw;
 	fastreg_wr.opcode = IB_WR_FAST_REG_MR;
-	fastreg_wr.wr.fast_reg.iova_start = seg1->mr_dma;
+	fastreg_wr.wr.fast_reg.iova_start = seg1->mr_dma + pageoff;
 	fastreg_wr.wr.fast_reg.page_list = frmr->fr_pgl;
 	fastreg_wr.wr.fast_reg.page_list_len = page_no;
 	fastreg_wr.wr.fast_reg.page_shift = PAGE_SHIFT;
-	fastreg_wr.wr.fast_reg.length = page_no << PAGE_SHIFT;
-	if (fastreg_wr.wr.fast_reg.length < len) {
-		rc = -EIO;
-		goto out_err;
-	}
+	fastreg_wr.wr.fast_reg.length = len;
 
 	/* Bump the key */
 	key = (u8)(mr->rkey & 0x000000FF);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
