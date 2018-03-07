From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH 3/7] RDMAVT: Fix synchronization around percpu_ref
Date: Wed, 7 Mar 2018 10:39:58 -0500
Message-ID: <5288ee8a-179a-8e45-0300-6a3c382a1cf9@intel.com>
References: <20180306172657.3060270-1-tj@kernel.org>
 <20180306173316.3088458-1-tj@kernel.org>
 <20180306173316.3088458-3-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306173316.3088458-3-tj@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, torvalds@linux-foundation.org, jannh@google.com, paulmck@linux.vnet.ibm.com, bcrl@kvack.org, viro@zeniv.linux.org.uk, kent.overstreet@gmail.com
Cc: security@kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/6/2018 12:33 PM, Tejun Heo wrote:
> rvt_mregion uses percpu_ref for reference counting and RCU to protect
> accesses from lkey_table.  When a rvt_mregion needs to be freed, it
> first gets unregistered from lkey_table and then rvt_check_refs() is
> called to wait for in-flight usages before the rvt_mregion is freed.
> 
> rvt_check_refs() seems to have a couple issues.
> 
> * It has a fast exit path which tests percpu_ref_is_zero().  However,
>    a percpu_ref reading zero doesn't mean that the object can be
>    released.  In fact, the ->release() callback might not even have
>    started executing yet.  Proceeding with freeing can lead to
>    use-after-free.
> 
> * lkey_table is RCU protected but there is no RCU grace period in the
>    free path.  percpu_ref uses RCU internally but it's sched-RCU whose
>    grace periods are different from regular RCU.  Also, it generally
>    isn't a good idea to depend on internal behaviors like this.
> 
> To address the above issues, this patch removes the the fast exit and

Typo above too many "the".

> adds an explicit synchronize_rcu().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> Hello, Dennis, Mike.
> 
> I don't know RDMA at all and this patch is only compile tested.  Can
> you please take a careful look?

Looks good to me, passes my basic sanity tests. Thanks!

Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
