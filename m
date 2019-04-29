From: Andrea Parri <andrea.parri@amarulasolutions.com>
Subject: [PATCH 5/5] IB/hfi1: Fix improper uses of smp_mb__before_atomic()
Date: Mon, 29 Apr 2019 22:15:01 +0200
Message-ID: <1556568902-12464-6-git-send-email-andrea.parri@amarulasolutions.com>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrea Parri <andrea.parri@amarulasolutions.com>, stable@vger.kernel.org, Dennis Dalessandro <dennis.dalessandro@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This barrier only applies to the read-modify-write operations; in
particular, it does not apply to the atomic_read() primitive.

Replace the barrier with an smp_mb().

Fixes: 856cc4c237add ("IB/hfi1: Add the capability for reserved operations")
Cc: stable@vger.kernel.org
Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/sw/rdmavt/qp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index a34b9a2a32b60..b64fd151d31fb 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1863,11 +1863,11 @@ static inline int rvt_qp_is_avail(
 	u32 reserved_used;
 
 	/* see rvt_qp_wqe_unreserve() */
-	smp_mb__before_atomic();
+	smp_mb();
 	reserved_used = atomic_read(&qp->s_reserved_used);
 	if (unlikely(reserved_op)) {
 		/* see rvt_qp_wqe_unreserve() */
-		smp_mb__before_atomic();
+		smp_mb();
 		if (reserved_used >= rdi->dparms.reserved_operations)
 			return -ENOMEM;
 		return 0;
@@ -1882,7 +1882,7 @@ static inline int rvt_qp_is_avail(
 		avail = slast - qp->s_head;
 
 	/* see rvt_qp_wqe_unreserve() */
-	smp_mb__before_atomic();
+	smp_mb();
 	reserved_used = atomic_read(&qp->s_reserved_used);
 	avail =  avail - 1 -
 		(rdi->dparms.reserved_operations - reserved_used);
-- 
2.7.4
