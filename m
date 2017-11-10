From: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] ibacm: Fix an incorrect expiration check for the retry
 timer
Date: Fri, 10 Nov 2017 17:28:48 -0500
Message-ID: <20171110222835.10387.27974.stgit@phlsvslse11.ph.intel.com>
References: <20171110222658.10387.16845.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171110222658.10387.16845.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The acmp_process_wait_queue() checks to see if a message expiration
time has passed.

Because the check is for less than (<), if the timeout expires matches
the current time, the check will result in a timeout value of 0, and
the wait loop will spin until the next millisecond has passed.

Using example values to demonstrate the issue, we can see:

With '<':
wait = -2106577636 (no work)
wait = 2510        (message wait)
(process spins)
wait = 0           (expires - current time == 0)
wait = 0
wait = 0
...                (1 ms of output)
wait = 0
wait = -2106580147 (retry complete)
wait = 2512

With '<=':
wait = -2106688780 (no work)
wait = 2512        ( message wait)
(process sleeps)
wait = -2106691293 (retry complete)
wait = 2512

Expire the message if the expires is less than or equal.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 ibacm/prov/acmp/src/acmp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 78d9a29..d707b8e 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -1507,7 +1507,7 @@ static void acmp_process_wait_queue(struct acmp_ep *ep, uint64_t *next_expire)
 	struct ibv_send_wr *bad_wr;
 
 	list_for_each_safe(&ep->wait_queue, msg, next, entry) {
-		if (msg->expires < time_stamp_ms()) {
+		if (msg->expires <= time_stamp_ms()) {
 			list_del(&msg->entry);
 			(void) atomic_dec(&wait_cnt);
 			if (--msg->tries) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
