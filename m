From: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/4] ibacm: Fix a retry loop calculation race condition
Date: Mon, 13 Nov 2017 16:24:49 -0500
Message-ID: <20171113212437.24293.43071.stgit@phlsvslse11.ph.intel.com>
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

The retry loop calculation uses a conversion to int of an unsigned
64 bit number (next_expire) minus the current time to decide if
event_wait() should be called.  This calculation works correctly as
long as the next_expire value is not the default value (-1).

If the next_expire is the default value, periodically this subtraction
can result in a very large postive timeout value (days rather than
milliseconds).

For example:
next_expire  = 0xFFFFFFFFFFFFFFFF  (-1)
current_ms = 0x15f7db52146  (today's ms since 1970)

max_delay_ms = (int) next_expire - future_ms

future_ms  = 0x15f80000000  = max_delay_ms 2147483647
future_ms  = 0x16080000000  = max_delay_ms 2147483647

Converting max_delay_ms to days:
2147483647 / 1000 / 60 / 60 / 24 == 24 days

0xxx180000000 - 0xxx080000000 = 4294967296

every 48 days, this issue repeats

This calculation can occur if a wait_cnt is incremented and a message
expiration is handled so that next_expire is not updated.  If wait_cnt
is incremented before the wait calculation is done (the race condition),
event_wait() can be called with the potentially very large value.

If next_expire is not updated, do not do the wait calculation and
avoid the race condition.

Reported-by: Morys Grzegorz <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 ibacm/prov/acmp/src/acmp.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index d707b8e..884fc48 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -1579,10 +1579,12 @@ static void *acmp_retry_handler(void *context)
 		pthread_mutex_unlock(&acmp_dev_lock);
 
 		acmp_process_timeouts();
-		wait = (int) (next_expire - time_stamp_ms());
-		if (wait > 0 && atomic_get(&wait_cnt)) {
-			pthread_testcancel();
-			event_wait(&timeout_event, wait);
+		if (next_expire != -1) {
+			wait = (int) (next_expire - time_stamp_ms());
+			if (wait > 0 && atomic_get(&wait_cnt)) {
+				pthread_testcancel();
+				event_wait(&timeout_event, wait);
+			}
 		}
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
