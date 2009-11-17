From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/complib/cl_event.c: Cosmetic changes
Date: Tue, 17 Nov 2009 09:02:57 -0500
Message-ID: <20091117140257.GA16153@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Remove unneeded parentheses around value in return statements
Remove some unneeded braces

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/complib/cl_event.c b/opensm/complib/cl_event.c
index 1d2feed..27b4ae5 100644
--- a/opensm/complib/cl_event.c
+++ b/opensm/complib/cl_event.c
@@ -62,7 +62,7 @@ cl_status_t cl_event_init(IN cl_event_t * const p_event,
 	p_event->manual_reset = manual_reset;
 	p_event->state = CL_INITIALIZED;
 
-	return (CL_SUCCESS);
+	return CL_SUCCESS;
 }
 
 void cl_event_destroy(IN cl_event_t * const p_event)
@@ -94,7 +94,7 @@ cl_status_t cl_event_signal(IN cl_event_t * const p_event)
 
 	pthread_mutex_unlock(&p_event->mutex);
 
-	return (CL_SUCCESS);
+	return CL_SUCCESS;
 }
 
 cl_status_t cl_event_reset(IN cl_event_t * const p_event)
@@ -106,7 +106,7 @@ cl_status_t cl_event_reset(IN cl_event_t * const p_event)
 	p_event->signaled = FALSE;
 	pthread_mutex_unlock(&p_event->mutex);
 
-	return (CL_SUCCESS);
+	return CL_SUCCESS;
 }
 
 cl_status_t cl_event_wait_on(IN cl_event_t * const p_event,
@@ -129,13 +129,13 @@ cl_status_t cl_event_wait_on(IN cl_event_t * const p_event,
 			p_event->signaled = FALSE;
 
 		pthread_mutex_unlock(&p_event->mutex);
-		return (CL_SUCCESS);
+		return CL_SUCCESS;
 	}
 
 	/* If just testing the state, return CL_TIMEOUT. */
 	if (wait_us == 0) {
 		pthread_mutex_unlock(&p_event->mutex);
-		return (CL_TIMEOUT);
+		return CL_TIMEOUT;
 	}
 
 	if (wait_us == EVENT_NO_TIMEOUT) {
@@ -164,13 +164,12 @@ cl_status_t cl_event_wait_on(IN cl_event_t * const p_event,
 				status = CL_TIMEOUT;
 			else
 				status = CL_NOT_DONE;
-		} else {
+		} else
 			status = CL_ERROR;
-		}
 	}
 	if (!p_event->manual_reset)
 		p_event->signaled = FALSE;
 
 	pthread_mutex_unlock(&p_event->mutex);
-	return (status);
+	return status;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
