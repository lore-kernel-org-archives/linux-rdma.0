From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 09/11] IB: remove the struct ib_phys_buf definition
Date: Sun, 22 Nov 2015 18:46:47 +0100
Message-ID: <1448214409-7729-10-git-send-email-hch@lst.de>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448214409-7729-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 include/rdma/ib_verbs.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1b2412b..81e047e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1128,11 +1128,6 @@ enum ib_access_flags {
 	IB_ACCESS_ON_DEMAND     = (1<<6),
 };
 
-struct ib_phys_buf {
-	u64      addr;
-	u64      size;
-};
-
 /*
  * XXX: these are apparently used for ->rereg_user_mr, no idea why they
  * are hidden here instead of a uapi header!
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
