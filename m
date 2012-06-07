From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] opensm: Fix pthread_create() return value checks
Date: Thu, 07 Jun 2012 19:16:55 +0000
Message-ID: <4FD0FE27.6080700@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just like other POSIX thread functions, pthread_create() either returns zero
or a positive error code. Found this through source code review. See also
http://pubs.opengroup.org/onlinepubs/9699919799/functions/pthread_create.html

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 complib/cl_threadpool.c       |    2 +-
 libvendor/osm_vendor_ibumad.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/complib/cl_threadpool.c b/complib/cl_threadpool.c
index 4440808..0f6498b 100644
--- a/complib/cl_threadpool.c
+++ b/complib/cl_threadpool.c
@@ -105,7 +105,7 @@ cl_status_t cl_thread_pool_init(IN cl_thread_pool_t * const p_thread_pool,
 
 	for (i = 0; i < count; i++) {
 		if (pthread_create(&p_thread_pool->tid[i], NULL,
-				   thread_pool_routine, p_thread_pool) < 0) {
+				   thread_pool_routine, p_thread_pool) != 0) {
 			cl_thread_pool_destroy(p_thread_pool);
 			return CL_INSUFFICIENT_RESOURCES;
 		}
diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index 9b7168b..bb40e8b 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -425,7 +425,7 @@ static int umad_receiver_start(osm_vendor_t * p_vend)
 	p_ur->p_vend = p_vend;
 	p_ur->p_log = p_vend->p_log;
 
-	if (pthread_create(&p_ur->tid, NULL, umad_receiver, p_ur) < 0)
+	if (pthread_create(&p_ur->tid, NULL, umad_receiver, p_ur) != 0)
 		return -1;
 
 	return 0;
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
