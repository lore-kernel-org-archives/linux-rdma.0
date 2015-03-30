From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 05/15] xprtrdma: Prevent infinite loop in
 rpcrdma_ep_create()
Date: Mon, 30 Mar 2015 14:34:12 -0400
Message-ID: <20150330183412.7856.55625.stgit@manet.1015granger.net>
References: <20150330182615.7856.61170.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150330182615.7856.61170.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If a provider advertizes a zero max_fast_reg_page_list_len, FRWR
depth detection loops forever. Instead of just failing the mount,
try other memory registration modes.

Fixes: 0fc6c4e7bb28 ("xprtrdma: mind the device's max fast . . .")
Reported-by: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Tested-by: Meghana Cheripady <Meghana.Cheripady-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Tested-by: Veeresh U. Kokatnur <veereshuk-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 60f3317..99752b5 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -618,9 +618,10 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 
 	if (memreg == RPCRDMA_FRMR) {
 		/* Requires both frmr reg and local dma lkey */
-		if ((devattr->device_cap_flags &
+		if (((devattr->device_cap_flags &
 		     (IB_DEVICE_MEM_MGT_EXTENSIONS|IB_DEVICE_LOCAL_DMA_LKEY)) !=
-		    (IB_DEVICE_MEM_MGT_EXTENSIONS|IB_DEVICE_LOCAL_DMA_LKEY)) {
+		    (IB_DEVICE_MEM_MGT_EXTENSIONS|IB_DEVICE_LOCAL_DMA_LKEY)) ||
+		      (devattr->max_fast_reg_page_list_len == 0)) {
 			dprintk("RPC:       %s: FRMR registration "
 				"not supported by HCA\n", __func__);
 			memreg = RPCRDMA_MTHCAFMR;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
