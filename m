From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 20/27] IB/rdmavt, IB/hfi1,
 IB/qib: Correct ack count for passive (RTR) QPs
Date: Wed, 08 Feb 2017 05:27:49 -0800
Message-ID: <20170208132748.16442.22246.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The send complete for RC QPs mismanages the ack count when the
responder side is only in RTR.

A QP in that state cannot send requests, but it can be the target
for operations that elicit responses.

Adjust the RC completion logic to correct the count maintenance
by reflecting RECV_OK in a new state test.

Reviewed-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c    |    2 +-
 drivers/infiniband/hw/qib/qib_rc.c |    2 +-
 include/rdma/rdmavt_qp.h           |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 85e7bf6..3cddf7d 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -990,7 +990,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 	u32 psn;
 
 	lockdep_assert_held(&qp->s_lock);
-	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_SEND_OR_FLUSH_OR_RECV_OK))
 		return;
 
 	/* Find out where the BTH is */
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index d712043..2a495fb 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -895,7 +895,7 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 	u32 opcode;
 	u32 psn;
 
-	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_SEND_OR_FLUSH_OR_RECV_OK))
 		return;
 
 	/* Find out where the BTH is */
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 561b6c8..2f91fae 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -144,6 +144,8 @@
 #define RVT_FLUSH_RECV			0x40
 #define RVT_PROCESS_OR_FLUSH_SEND \
 	(RVT_PROCESS_SEND_OK | RVT_FLUSH_SEND)
+#define RVT_SEND_OR_FLUSH_OR_RECV_OK \
+	(RVT_PROCESS_SEND_OK | RVT_FLUSH_SEND | RVT_PROCESS_RECV_OK)
 
 /*
  * Internal send flags

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
