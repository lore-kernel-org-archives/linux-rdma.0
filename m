From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 12/17] nes: move external declaration to nes_umain.h
Date: Thu, 13 Oct 2016 21:56:11 +0200
Message-ID: <1476388576-22863-13-git-send-email-hch@lst.de>
References: <1476388576-22863-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476388576-22863-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/nes/nes_umain.h  | 2 ++
 providers/nes/nes_uverbs.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/providers/nes/nes_umain.h b/providers/nes/nes_umain.h
index f3cc348..093956a 100644
--- a/providers/nes/nes_umain.h
+++ b/providers/nes/nes_umain.h
@@ -400,4 +400,6 @@ static inline uint32_t le32_to_cpu(uint32_t x)
 	return le32toh(x);
 }
 
+extern long int page_size;
+
 #endif				/* nes_umain_H */
diff --git a/providers/nes/nes_uverbs.c b/providers/nes/nes_uverbs.c
index aa9c2b9..287e773 100644
--- a/providers/nes/nes_uverbs.c
+++ b/providers/nes/nes_uverbs.c
@@ -49,8 +49,6 @@
 #include "nes_umain.h"
 #include "nes-abi.h"
 
-extern long int page_size;
-
 #define STATIC static
 #define INLINE inline
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
