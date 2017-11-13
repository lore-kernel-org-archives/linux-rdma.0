From: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/4] ibacm: Use MONOTONIC time base to avoid timer
 expiration issues
Date: Mon, 13 Nov 2017 16:25:04 -0500
Message-ID: <20171113212454.24293.68783.stgit@phlsvslse11.ph.intel.com>
References: <20171113212220.24293.97479.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113212220.24293.97479.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The event_wait() function uses the CLOCK_REALTIME time base for
calculating expiration times (default time base for gettimeofday()).

Using the CLOCK_REALTIME time base can introduce incorrect expiration
timeout calculations if the REALTIME clock changes, making a timeout
too long (possibly hours or days), or too short.

Update time base usage to the CLOCK_MONOTONIC time base to avoid time
change issues.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 ibacm/linux/osd.h |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index d6cbb8f..1901a89 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -88,20 +88,23 @@ typedef struct { volatile int val; } atomic_t;
 typedef struct { pthread_cond_t cond; pthread_mutex_t mutex; } event_t;
 static inline void event_init(event_t *e)
 {
-	pthread_cond_init(&e->cond, NULL);
+	pthread_condattr_t attr;
+
+	pthread_condattr_init(&attr);
+	pthread_condattr_setclock(&attr, CLOCK_MONOTONIC);
+	pthread_cond_init(&e->cond, &attr);
 	pthread_mutex_init(&e->mutex, NULL);
 }
 #define event_signal(e)	pthread_cond_signal(&(e)->cond)
 #define ONE_SEC_IN_NSEC  1000000000
 static inline int event_wait(event_t *e, int timeout)
 {
-	struct timeval curtime;
 	struct timespec wait;
 	int ret;
 
-	gettimeofday(&curtime, NULL);
-	wait.tv_sec = curtime.tv_sec + ((unsigned) timeout) / 1000;
-	wait.tv_nsec = (curtime.tv_usec + (((unsigned) timeout) % 1000) * 1000) * 1000;
+	clock_gettime(CLOCK_MONOTONIC, &wait);
+	wait.tv_sec = wait.tv_sec + ((unsigned) timeout) / 1000;
+	wait.tv_nsec = (wait.tv_nsec + (((unsigned) timeout) % 1000) * 1000000);
 	if (wait.tv_nsec > ONE_SEC_IN_NSEC) {
 		wait.tv_sec++;
 		wait.tv_nsec -= ONE_SEC_IN_NSEC;
@@ -114,10 +117,9 @@ static inline int event_wait(event_t *e, int timeout)
 
 static inline uint64_t time_stamp_us(void)
 {
-	struct timeval curtime;
-	timerclear(&curtime);
-	gettimeofday(&curtime, NULL);
-	return (uint64_t) curtime.tv_sec * 1000000 + (uint64_t) curtime.tv_usec;
+	struct timespec t;
+	clock_gettime(CLOCK_MONOTONIC, &t);
+	return ((uint64_t)t.tv_sec * ONE_SEC_IN_NSEC + (uint64_t)t.tv_nsec) / 1000;
 }
 
 #define time_stamp_ms()  (time_stamp_us() / (uint64_t) 1000)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
