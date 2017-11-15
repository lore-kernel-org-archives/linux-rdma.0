From: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core v4 2/4] ibacm: Calculate correct tv_nsec value in
 event_wait()
Date: Wed, 15 Nov 2017 14:35:02 -0500
Message-ID: <20171115193449.470.91750.stgit@phlsvslse11.ph.intel.com>
References: <20171115193155.470.85049.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115193155.470.85049.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The event_wait() function calculates a tv_nsec value based on the
given timeout.  If the tv_nsec value calculation ends ups larger
than 1 second, the pthread_cond_timedwait() will return EINVAL,
and will not wait.

This causes the retry loop to spin (busy wait) until the actual
timeout occurs.

Ensure that the tv_nsec value is less than 1 second.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 ibacm/linux/osd.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 95713e6..eabf5ed 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -92,6 +92,7 @@ static inline void event_init(event_t *e)
 	pthread_mutex_init(&e->mutex, NULL);
 }
 #define event_signal(e)	pthread_cond_signal(&(e)->cond)
+#define ONE_SEC_IN_NSEC  1000000000ULL
 static inline int event_wait(event_t *e, int timeout)
 {
 	struct timeval curtime;
@@ -101,6 +102,10 @@ static inline int event_wait(event_t *e, int timeout)
 	gettimeofday(&curtime, NULL);
 	wait.tv_sec = curtime.tv_sec + ((unsigned) timeout) / 1000;
 	wait.tv_nsec = (curtime.tv_usec + (((unsigned) timeout) % 1000) * 1000) * 1000;
+	if (wait.tv_nsec > ONE_SEC_IN_NSEC) {
+		wait.tv_sec++;
+		wait.tv_nsec -= ONE_SEC_IN_NSEC;
+	}
 	pthread_mutex_lock(&e->mutex);
 	ret = pthread_cond_timedwait(&e->cond, &e->mutex, &wait);
 	pthread_mutex_unlock(&e->mutex);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
