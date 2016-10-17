From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 03/13] ibacm: use __thread directly
Date: Mon, 17 Oct 2016 21:11:12 +0200
Message-ID: <1476731482-26491-4-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 ibacm/linux/osd.h          | 1 -
 ibacm/prov/acmp/src/acmp.c | 2 +-
 ibacm/src/acm.c            | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 3580cc3..31a7044 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -136,7 +136,6 @@ static inline uint64_t time_stamp_us(void)
 #define time_stamp_sec() (time_stamp_ms() / (uint64_t) 1000)
 #define time_stamp_min() (time_stamp_sec() / (uint64_t) 60)
 
-#define PER_THREAD __thread
 static inline int beginthread(void (*func)(void *), void *arg)
 {
 	pthread_t thread;
diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 24d2b70..1f3aeef 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -259,7 +259,7 @@ static atomic_t wait_cnt;
 static pthread_t retry_thread_id;
 static int retry_thread_started = 0;
 
-PER_THREAD char log_data[ACM_MAX_ADDRESS];
+__thread char log_data[ACM_MAX_ADDRESS];
 
 /*
  * Service options - may be set through ibacm_opts.cfg file.
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index d40aa71..33fc044 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -186,7 +186,7 @@ static struct acmc_client client_array[FD_SETSIZE - 1];
 
 static FILE *flog;
 static pthread_mutex_t log_lock;
-PER_THREAD char log_data[ACM_MAX_ADDRESS];
+__thread char log_data[ACM_MAX_ADDRESS];
 static atomic_t counter[ACM_MAX_COUNTER];
 
 static struct acmc_device *
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
