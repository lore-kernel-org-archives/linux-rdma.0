From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 05/17] i40iw: mark symbols static where possible
Date: Thu, 13 Oct 2016 21:56:04 +0200
Message-ID: <1476388576-22863-6-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/i40iw/i40iw_umain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index 1756e65..0540ee7 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -57,7 +57,7 @@ unsigned int i40iw_debug_level;
 	  .device = d,		\
 	  .type = INTEL_ ## t }
 
-struct {
+static struct {
 	unsigned int vendor;
 	unsigned int device;
 	enum i40iw_uhca_type type;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
