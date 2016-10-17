From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 06/13] ibacm: remove unused LIB_DESTRUCTOR define
Date: Mon, 17 Oct 2016 21:11:15 +0200
Message-ID: <1476731482-26491-7-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/linux/osd.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 00a5084..5fafd4d 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -53,7 +53,6 @@
 #define ACM_ADDR_FILE "ibacm_addr.cfg"
 #define ACM_OPTS_FILE "ibacm_opts.cfg"
 
-#define LIB_DESTRUCTOR __attribute__((destructor))
 #define CDECL_FUNC
 
 #if DEFINE_ATOMICS
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
