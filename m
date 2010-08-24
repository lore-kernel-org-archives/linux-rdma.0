From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] complib/cl_timer.c: fixing cl_timer calculation
Date: Tue, 24 Aug 2010 16:21:33 +0300
Message-ID: <4C73C75D.30003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Tzachi Dar <tzachid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When calculating p_timer->timeout.tv_sec and p_timer->timeout.tv_nsec,
the carry was ignored, resulting in wrong value in p_timer->timeout.tv_sec,
and value > 10^9 in p_timer->timeout.tv_nsec (illegal value).

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---

V2: - using macros instead of int types
    - fixed the same problem in cl_timer_trim()

 opensm/complib/cl_timer.c |   48 ++++++++++++++++++++++----------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/opensm/complib/cl_timer.c b/opensm/complib/cl_timer.c
index 2acdb51..3b3c7b0 100644
--- a/opensm/complib/cl_timer.c
+++ b/opensm/complib/cl_timer.c
@@ -294,12 +294,32 @@ static cl_status_t __cl_timer_find(IN const cl_list_item_t * const p_list_item,
 	return (CL_NOT_FOUND);
 }

+/*
+ * Calculate 'struct timespec' value that is the
+ * current time plus the 'time_ms' milliseconds.
+ */
+static __inline void __cl_timer_calculate(IN const uint32_t time_ms,
+					  OUT struct timespec * const p_timer)
+{
+	struct timeval curtime, deltatime, endtime;
+
+#ifndef timerclear
+#define timerclear(tvp)  (tvp)->tv_sec = (time_t)0, (tvp)->tv_usec = 0L
+#endif
+	timerclear(&curtime);
+	gettimeofday(&curtime, NULL);
+
+	deltatime.tv_sec = time_ms / 1000;
+	deltatime.tv_usec = (time_ms % 1000) * 1000;
+	timeradd(&curtime, &deltatime, &endtime);
+	p_timer->tv_sec = endtime.tv_sec;
+	p_timer->tv_nsec = endtime.tv_usec * 1000;
+}
+
 cl_status_t cl_timer_start(IN cl_timer_t * const p_timer,
 			   IN const uint32_t time_ms)
 {
-	struct timeval curtime;
 	cl_list_item_t *p_list_item;
-	uint32_t delta_time = time_ms;

 	CL_ASSERT(p_timer);
 	CL_ASSERT(p_timer->state == CL_INITIALIZED);
@@ -313,20 +333,7 @@ cl_status_t cl_timer_start(IN cl_timer_t * const p_timer,
 		cl_qlist_remove_item(&gp_timer_prov->queue,
 				     &p_timer->list_item);

-	/* Get the current time */
-#ifndef timerclear
-#define	timerclear(tvp)		(tvp)->tv_sec = (time_t)0, (tvp)->tv_usec = 0L
-#endif
-	timerclear(&curtime);
-	gettimeofday(&curtime, NULL);
-
-	/* do not do 0 wait ! */
-	/* if (delta_time < 1000.0) {delta_time = 1000;} */
-
-	/* Calculate the timeout. */
-	p_timer->timeout.tv_sec = curtime.tv_sec + (delta_time / 1000);
-	p_timer->timeout.tv_nsec =
-	    (curtime.tv_usec + ((delta_time % 1000) * 1000)) * 1000;
+	__cl_timer_calculate(time_ms, &p_timer->timeout);

 	/* Add the timer to the queue. */
 	if (cl_is_qlist_empty(&gp_timer_prov->queue)) {
@@ -385,7 +392,6 @@ void cl_timer_stop(IN cl_timer_t * const p_timer)
 cl_status_t cl_timer_trim(IN cl_timer_t * const p_timer,
 			  IN const uint32_t time_ms)
 {
-	struct timeval curtime;
 	struct timespec newtime;
 	cl_status_t status;

@@ -394,13 +400,7 @@ cl_status_t cl_timer_trim(IN cl_timer_t * const p_timer,

 	pthread_mutex_lock(&gp_timer_prov->mutex);

-	/* Get the current time */
-	timerclear(&curtime);
-	gettimeofday(&curtime, NULL);
-
-	/* Calculate the timeout. */
-	newtime.tv_sec = curtime.tv_sec + (time_ms / 1000);
-	newtime.tv_nsec = (curtime.tv_usec + ((time_ms % 1000) * 1000)) * 1000;
+	__cl_timer_calculate(time_ms, &newtime);

 	if (p_timer->timer_state == CL_TIMER_QUEUED) {
 		/* If the old time is earlier, do not trim it.  Just return. */
-- 
1.6.2.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
