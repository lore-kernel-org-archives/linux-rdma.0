From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: Use completion objects for event blocking.
Date: Fri, 20 May 2011 11:25:05 -0500
Message-ID: <20110520162505.21192.27459.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There exists a race condition when using wait_queue_head_t objects that
are declared on the stack.  This was being done in a few places where
we are sending work requests to the FW and awaiting replies, but we
don't have an endpoint structure with an embedded c4iw_wr_wait struct.
So the code was allocating it locally on the stack.  Bad design. The
race is this:

1) thread on cpuX declares the wait_queue_head_t on the stack, then posts
a firmware WR with that wait object ptr as the cookie to be returned in
the WR reply.  This thread will proceed to block in wait_event_timeout()
but before it does:

2) An interrupt runs on cpuY with the WR reply.  fw6_msg() handles this
and calls c4iw_wake_up().  c4iw_wake_up() sets the condition variable
in the c4iw_wr_wait object to TRUE and will call wake_up(), but before
it calls wake_up():

3) The thread on cpuX calls c4iw_wait_for_reply(), which calls
wait_event_timeout().  The wait_event_timeout() macro checks the condition
variable and returns immediately since it is TRUE.  So this thread never
blocks/sleeps. The function then returns effectively deallocating the
c4iw_wr_wait object that was on the stack.

4) So at this point cpuY has a pointer to the c4iw_wr_wait object that
is no longer valid.  Further its pointing to a stack frame that might
now be in use by some other context/thread.  So cpuY continues execution
and calls wake_up() on a ptr to a wait object that as been effectively
deallocated.

This race, when it hits, can cause a crash in wake_up(), which I've seen
under heavy stress. It can also corrupt the referenced stack which can
cause any number of failures.

The fix:

Use completion objects which support on-stack declarations.  Completions
use a spinlock around setting the condition to true and the wake up
so that steps 2 and 4 above are atomic and step 3 can never happen
in-between.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 35d2a5d..4f04537 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -35,7 +35,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/idr.h>
-#include <linux/workqueue.h>
+#include <linux/completion.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
 #include <linux/pci.h>
@@ -131,28 +131,21 @@ static inline int c4iw_num_stags(struct c4iw_rdev *rdev)
 
 #define C4IW_WR_TO (10*HZ)
 
-enum {
-	REPLY_READY = 0,
-};
-
 struct c4iw_wr_wait {
-	wait_queue_head_t wait;
-	unsigned long status;
+	struct completion completion;
 	int ret;
 };
 
 static inline void c4iw_init_wr_wait(struct c4iw_wr_wait *wr_waitp)
 {
 	wr_waitp->ret = 0;
-	wr_waitp->status = 0;
-	init_waitqueue_head(&wr_waitp->wait);
+	init_completion(&wr_waitp->completion);
 }
 
 static inline void c4iw_wake_up(struct c4iw_wr_wait *wr_waitp, int ret)
 {
 	wr_waitp->ret = ret;
-	set_bit(REPLY_READY, &wr_waitp->status);
-	wake_up(&wr_waitp->wait);
+	complete(&wr_waitp->completion);
 }
 
 static inline int c4iw_wait_for_reply(struct c4iw_rdev *rdev,
@@ -164,8 +157,7 @@ static inline int c4iw_wait_for_reply(struct c4iw_rdev *rdev,
 	int ret;
 
 	do {
-		ret = wait_event_timeout(wr_waitp->wait,
-			test_and_clear_bit(REPLY_READY, &wr_waitp->status), to);
+		ret = wait_for_completion_timeout(&wr_waitp->completion, to);
 		if (!ret) {
 			printk(KERN_ERR MOD "%s - Device %s not responding - "
 			       "tid %u qpid %u\n", func,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
