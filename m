From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 01/16] xprtrdma: Enable swap-on-NFS/RDMA
Date: Sat, 24 Oct 2015 17:26:29 -0400
Message-ID: <20151024212629.4715.58465.stgit@manet.1015granger.net>
References: <20151024211707.4715.61650.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151024211707.4715.61650.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

After adding a swapfile on an NFS/RDMA mount and removing the
normal swap partition, I was able to push the NFS client well
into swap without any issue.

I forgot to swapoff the NFS file before rebooting. This pinned
the NFS mount and the IB core and provider, causing shutdown to
hang. I think this is expected and safe behavior. Probably
shutdown scripts should "swapoff -a" before unmounting any
filesystems.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Tested-By: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 41e452b..e9e5ed7 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -676,7 +676,7 @@ static void xprt_rdma_print_stats(struct rpc_xprt *xprt, struct seq_file *seq)
 static int
 xprt_rdma_enable_swap(struct rpc_xprt *xprt)
 {
-	return -EINVAL;
+	return 0;
 }
 
 static void

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
