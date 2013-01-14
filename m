From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: [PATCH] IB: cxgb3: delay freeing mem untill entirely done with it
Date: Mon, 14 Jan 2013 20:34:09 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1301142031050.31033@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sure, it's just the pointer value we use, but the coverity checker
complains about a use-after-free bug and it really does seem cleaner
to delay freeing until we are entirely done with the memory. So,
rearrange the code to move the kfree() later untill we are completely
done.
Trivial and harmless, but nice IMHO.

Signed-off-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 0bdf09a..145d82a 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -783,8 +783,8 @@ static int iwch_dealloc_mw(struct ib_mw *mw)
 	mmid = (mw->rkey) >> 8;
 	cxio_deallocate_window(&rhp->rdev, mhp->attr.stag);
 	remove_handle(rhp, &rhp->mmidr, mmid);
-	kfree(mhp);
 	PDBG("%s ib_mw %p mmid 0x%x ptr %p\n", __func__, mw, mmid, mhp);
+	kfree(mhp);
 	return 0;
 }
 
-- 
1.7.1


-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
