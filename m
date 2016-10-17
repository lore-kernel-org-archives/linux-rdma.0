From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 05/13] ibacm: remove unused helper beginthread
Date: Mon, 17 Oct 2016 21:11:14 +0200
Message-ID: <1476731482-26491-6-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/linux/osd.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 7ce52e6..00a5084 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -130,10 +130,4 @@ static inline uint64_t time_stamp_us(void)
 #define time_stamp_sec() (time_stamp_ms() / (uint64_t) 1000)
 #define time_stamp_min() (time_stamp_sec() / (uint64_t) 60)
 
-static inline int beginthread(void (*func)(void *), void *arg)
-{
-	pthread_t thread;
-	return pthread_create(&thread, NULL, (void *(*)(void*)) func, arg);
-}
-
 #endif /* OSD_H */
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
