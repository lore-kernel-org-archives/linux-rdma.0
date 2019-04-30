From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/5] IB/hfi1: Fix improper uses of smp_mb__before_atomic()
Date: Tue, 30 Apr 2019 10:28:14 +0200
Message-ID: <20190430082814.GC2677@hirez.programming.kicks-ass.net>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1556568902-12464-6-git-send-email-andrea.parri@amarulasolutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1556568902-12464-6-git-send-email-andrea.parri@amarulasolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Parri <andrea.parri@amarulasolutions.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Dennis Dalessandro <dennis.dalessandro@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 10:15:01PM +0200, Andrea Parri wrote:
> This barrier only applies to the read-modify-write operations; in
> particular, it does not apply to the atomic_read() primitive.
> 
> Replace the barrier with an smp_mb().
> 
> Fixes: 856cc4c237add ("IB/hfi1: Add the capability for reserved operations")
> Cc: stable@vger.kernel.org
> Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
> Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: linux-rdma@vger.kernel.org
> ---
>  drivers/infiniband/sw/rdmavt/qp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
> index a34b9a2a32b60..b64fd151d31fb 100644
> --- a/drivers/infiniband/sw/rdmavt/qp.c
> +++ b/drivers/infiniband/sw/rdmavt/qp.c
> @@ -1863,11 +1863,11 @@ static inline int rvt_qp_is_avail(
>  	u32 reserved_used;
>  
>  	/* see rvt_qp_wqe_unreserve() */

I see a completely bogus comment in rvf_op_wqe_unreserve(), referring to
bogus comments makes this barrier bogus too.

> -	smp_mb__before_atomic();
> +	smp_mb();
>  	reserved_used = atomic_read(&qp->s_reserved_used);
>  	if (unlikely(reserved_op)) {
>  		/* see rvt_qp_wqe_unreserve() */
> -		smp_mb__before_atomic();

This was before, but there is nothing _after_ this. Which means this
barrier was complete garbage anyway.

> +		smp_mb();
>  		if (reserved_used >= rdi->dparms.reserved_operations)
>  			return -ENOMEM;
>  		return 0;
> @@ -1882,7 +1882,7 @@ static inline int rvt_qp_is_avail(
>  		avail = slast - qp->s_head;
>  
>  	/* see rvt_qp_wqe_unreserve() */
> -	smp_mb__before_atomic();
> +	smp_mb();

Same as the first.

>  	reserved_used = atomic_read(&qp->s_reserved_used);
>  	avail =  avail - 1 -
>  		(rdi->dparms.reserved_operations - reserved_used);
