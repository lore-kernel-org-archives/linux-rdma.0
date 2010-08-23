From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] complib/cl_timer.c: fixing cl_timer calculation
Date: Mon, 23 Aug 2010 17:38:00 +0300
Message-ID: <4C7287C8.1040106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tzachi Dar <tzachid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When calculating p_timer->timeout.tv_sec and p_timer->timeout.tv_nsec,
the carry was ignored, resulting in wrong value in p_timer->timeout.tv_sec,
and value > 10^9 in p_timer->timeout.tv_nsec (illegal value).

Signed-off-by:  Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---
 opensm/complib/cl_timer.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/opensm/complib/cl_timer.c b/opensm/complib/cl_timer.c
index 2acdb51..09a5584 100644
--- a/opensm/complib/cl_timer.c
+++ b/opensm/complib/cl_timer.c
@@ -299,7 +299,8 @@ cl_status_t cl_timer_start(IN cl_timer_t * const p_timer,
 {
 	struct timeval curtime;
 	cl_list_item_t *p_list_item;
-	uint32_t delta_time = time_ms;
+	uint32_t delta_time_sec = time_ms / 1000;
+	uint32_t delta_time_usec = (time_ms % 1000) * 1000;

 	CL_ASSERT(p_timer);
 	CL_ASSERT(p_timer->state == CL_INITIALIZED);
@@ -324,9 +325,10 @@ cl_status_t cl_timer_start(IN cl_timer_t * const p_timer,
 	/* if (delta_time < 1000.0) {delta_time = 1000;} */

 	/* Calculate the timeout. */
-	p_timer->timeout.tv_sec = curtime.tv_sec + (delta_time / 1000);
+	p_timer->timeout.tv_sec = curtime.tv_sec + delta_time_sec +
+		((curtime.tv_usec + delta_time_usec) / 1000000);
 	p_timer->timeout.tv_nsec =
-	    (curtime.tv_usec + ((delta_time % 1000) * 1000)) * 1000;
+	    ((curtime.tv_usec + delta_time_usec) % 1000000) * 1000;

 	/* Add the timer to the queue. */
 	if (cl_is_qlist_empty(&gp_timer_prov->queue)) {
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
