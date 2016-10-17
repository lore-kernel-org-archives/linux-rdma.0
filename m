From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/12] IB/hfi1: Optimize pio cachelines
Date: Mon, 17 Oct 2016 04:19:13 -0700
Message-ID: <20161017111912.7934.1192.stgit@scvm10.sc.intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017103326.7934.21558.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Move buffers_allocated pcpu pointer to allocator line.

Move hw_free pointer to releaser line.

Fill other holes revealed by pahole.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pio.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.h b/drivers/infiniband/hw/hfi1/pio.h
index e709eaf..bd19507 100644
--- a/drivers/infiniband/hw/hfi1/pio.h
+++ b/drivers/infiniband/hw/hfi1/pio.h
@@ -104,7 +104,6 @@ struct send_context {
 	void __iomem *base_addr;	/* start of PIO memory */
 	union pio_shadow_ring *sr;	/* shadow ring */
 
-	volatile __le64 *hw_free;	/* HW free counter */
 	struct work_struct halt_work;	/* halted context work queue entry */
 	unsigned long flags;		/* flags */
 	int node;			/* context home node */
@@ -116,19 +115,20 @@ struct send_context {
 	u32 group;			/* credit return group */
 	/* allocator fields */
 	spinlock_t alloc_lock ____cacheline_aligned_in_smp;
+	u32 sr_head;			/* shadow ring head */
 	unsigned long fill;		/* official alloc count */
 	unsigned long alloc_free;	/* copy of free (less cache thrash) */
-	u32 sr_head;			/* shadow ring head */
+	u32 __percpu *buffers_allocated;/* count of buffers allocated */
 	/* releaser fields */
 	spinlock_t release_lock ____cacheline_aligned_in_smp;
-	unsigned long free;		/* official free count */
 	u32 sr_tail;			/* shadow ring tail */
+	unsigned long free;		/* official free count */
+	volatile __le64 *hw_free;	/* HW free counter */
 	/* list for PIO waiters */
 	struct list_head piowait  ____cacheline_aligned_in_smp;
 	spinlock_t credit_ctrl_lock ____cacheline_aligned_in_smp;
-	u64 credit_ctrl;		/* cache for credit control */
 	u32 credit_intr_count;		/* count of credit intr users */
-	u32 __percpu *buffers_allocated;/* count of buffers allocated */
+	u64 credit_ctrl;		/* cache for credit control */
 	wait_queue_head_t halt_wait;    /* wait until kernel sees interrupt */
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
