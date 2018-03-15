From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 3/8] RDMAVT: Fix synchronization around percpu_ref
Date: Thu, 15 Mar 2018 16:24:28 -0600
Message-ID: <20180315222428.GE27537@ziepe.ca>
References: <20180314194515.1661824-1-tj@kernel.org>
 <20180314194515.1661824-3-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180314194515.1661824-3-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, jannh@google.com, paulmck@linux.vnet.ibm.com, bcrl@kvack.org, viro@zeniv.linux.org.uk, kent.overstreet@gmail.com, security@kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 14, 2018 at 12:45:10PM -0700, Tejun Heo wrote:
> rvt_mregion uses percpu_ref for reference counting and RCU to protect
> accesses from lkey_table.  When a rvt_mregion needs to be freed, it
> first gets unregistered from lkey_table and then rvt_check_refs() is
> called to wait for in-flight usages before the rvt_mregion is freed.
> 
> rvt_check_refs() seems to have a couple issues.
> 
> * It has a fast exit path which tests percpu_ref_is_zero().  However,
>   a percpu_ref reading zero doesn't mean that the object can be
>   released.  In fact, the ->release() callback might not even have
>   started executing yet.  Proceeding with freeing can lead to
>   use-after-free.
> 
> * lkey_table is RCU protected but there is no RCU grace period in the
>   free path.  percpu_ref uses RCU internally but it's sched-RCU whose
>   grace periods are different from regular RCU.  Also, it generally
>   isn't a good idea to depend on internal behaviors like this.
> 
> To address the above issues, this patch removes the fast exit and adds
> an explicit synchronize_rcu().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>  drivers/infiniband/sw/rdmavt/mr.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Applied to rdma for-next

Thanks,
Jason
