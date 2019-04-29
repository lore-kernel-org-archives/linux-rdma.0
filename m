From: "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Subject: RE: [PATCH 5/5] IB/hfi1: Fix improper uses of
 smp_mb__before_atomic()
Date: Mon, 29 Apr 2019 21:24:24 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663BE6AADCE@FMSMSX108.amr.corp.intel.com>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1556568902-12464-6-git-send-email-andrea.parri@amarulasolutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1556568902-12464-6-git-send-email-andrea.parri@amarulasolutions.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Parri <andrea.parri@amarulasolutions.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>-----Original Message-----
>From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>owner@vger.kernel.org] On Behalf Of Andrea Parri
>Sent: Monday, April 29, 2019 4:15 PM
>To: linux-kernel@vger.kernel.org
>Cc: Andrea Parri <andrea.parri@amarulasolutions.com>;
>stable@vger.kernel.org; Dalessandro, Dennis
><dennis.dalessandro@intel.com>; Marciniszyn, Mike
><mike.marciniszyn@intel.com>; Doug Ledford <dledford@redhat.com>;
>Jason Gunthorpe <jgg@ziepe.ca>; linux-rdma@vger.kernel.org
>Subject: [PATCH 5/5] IB/hfi1: Fix improper uses of smp_mb__before_atomic()
>
>This barrier only applies to the read-modify-write operations; in
>particular, it does not apply to the atomic_read() primitive.
>
>Replace the barrier with an smp_mb().

This is one of a couple of barrier issues that we are currently looking into.

See:

[PATCH for-next 6/9] IB/rdmavt: Add new completion inline

We will take a look at this one as well.

Thanks,

Mike

>Fixes: 856cc4c237add ("IB/hfi1: Add the capability for reserved operations")
>Cc: stable@vger.kernel.org
>Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
>Reported-by: Peter Zijlstra <peterz@infradead.org>
>Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
>Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
>Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
>Cc: Doug Ledford <dledford@redhat.com>
>Cc: Jason Gunthorpe <jgg@ziepe.ca>
>Cc: linux-rdma@vger.kernel.org
>---
> drivers/infiniband/sw/rdmavt/qp.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/infiniband/sw/rdmavt/qp.c
>b/drivers/infiniband/sw/rdmavt/qp.c
>index a34b9a2a32b60..b64fd151d31fb 100644
>--- a/drivers/infiniband/sw/rdmavt/qp.c
>+++ b/drivers/infiniband/sw/rdmavt/qp.c
>@@ -1863,11 +1863,11 @@ static inline int rvt_qp_is_avail(
> 	u32 reserved_used;
>
> 	/* see rvt_qp_wqe_unreserve() */
>-	smp_mb__before_atomic();
>+	smp_mb();
> 	reserved_used = atomic_read(&qp->s_reserved_used);
> 	if (unlikely(reserved_op)) {
> 		/* see rvt_qp_wqe_unreserve() */
>-		smp_mb__before_atomic();
>+		smp_mb();
> 		if (reserved_used >= rdi->dparms.reserved_operations)
> 			return -ENOMEM;
> 		return 0;
>@@ -1882,7 +1882,7 @@ static inline int rvt_qp_is_avail(
> 		avail = slast - qp->s_head;
>
> 	/* see rvt_qp_wqe_unreserve() */
>-	smp_mb__before_atomic();
>+	smp_mb();
> 	reserved_used = atomic_read(&qp->s_reserved_used);
> 	avail =  avail - 1 -
> 		(rdi->dparms.reserved_operations - reserved_used);
>--
>2.7.4
