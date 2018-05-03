From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/umem: use tgid instead of pid in ib_umem structure
Date: Thu, 3 May 2018 09:33:10 -0600
Message-ID: <20180503153310.GA9738@ziepe.ca>
References: <1525356274-736-1-git-send-email-lidongchen@tencent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1525356274-736-1-git-send-email-lidongchen@tencent.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lidong Chen <jemmy858585@gmail.com>
Cc: dledford@redhat.com, akpm@linux-foundation.org, qing.huang@oracle.com, leon@kernel.org, artemyko@mellanox.com, dan.j.williams@intel.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, adido@mellanox.com, galsha@mellanox.com, aviadye@mellanox.com, Lidong Chen <lidongchen@tencent.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 03, 2018 at 10:04:34PM +0800, Lidong Chen wrote:
> The userspace may invoke ibv_reg_mr and ibv_dereg_mr by different threads.
> If when ibv_dereg_mr invoke and the thread which invoked ibv_reg_mr has
> exited, get_pid_task will return NULL, ib_umem_release does not decrease
> mm->pinned_vm. This patch fixes it by use tgid.
> 
> Signed-off-by: Lidong Chen <lidongchen@tencent.com>
> ---
>  drivers/infiniband/core/umem.c | 12 ++++++------
>  include/rdma/ib_umem.h         |  2 +-
>  2 files changed, 7 insertions(+), 7 deletions(-)

Why are we even using a struct pid for this? Does anyone know?

I'm surprised that struct task isn't held in the struct ib_umem..

Is group_leader really OK and always guarenteed to return the same
struct mm?? For some reason I have this recollection that the leader
can change under some situation..

> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index 9a4e899..8813ba5 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -119,7 +119,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  	umem->length     = size;
>  	umem->address    = addr;
>  	umem->page_shift = PAGE_SHIFT;
> -	umem->pid	 = get_task_pid(current, PIDTYPE_PID);
> +	umem->tgid	 = get_task_pid(current->group_leader, PIDTYPE_PID);
>  	/*
>  	 * We ask for writable memory if any of the following
>  	 * access flags are set.  "Local write" and "remote write"
> @@ -132,7 +132,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  		 IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
>  
>  	if (access & IB_ACCESS_ON_DEMAND) {
> -		put_pid(umem->pid);
> +		put_pid(umem->tgid);
>  		ret = ib_umem_odp_get(context, umem, access);
>  		if (ret) {
>  			kfree(umem);
> @@ -148,7 +148,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  
>  	page_list = (struct page **) __get_free_page(GFP_KERNEL);
>  	if (!page_list) {
> -		put_pid(umem->pid);
> +		put_pid(umem->tgid);
>  		kfree(umem);
>  		return ERR_PTR(-ENOMEM);
>  	}
> @@ -231,7 +231,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  	if (ret < 0) {
>  		if (need_release)
>  			__ib_umem_release(context->device, umem, 0);
> -		put_pid(umem->pid);
> +		put_pid(umem->tgid);
>  		kfree(umem);
>  	} else
>  		current->mm->pinned_vm = locked;
> @@ -274,8 +274,8 @@ void ib_umem_release(struct ib_umem *umem)
>  
>  	__ib_umem_release(umem->context->device, umem, 1);
>  
> -	task = get_pid_task(umem->pid, PIDTYPE_PID);
> -	put_pid(umem->pid);
> +	task = get_pid_task(umem->tgid, PIDTYPE_PID);
> +	put_pid(umem->tgid);
>  	if (!task)
>  		goto out;
>  	mm = get_task_mm(task);
> diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
> index 23159dd..2398849 100644
> --- a/include/rdma/ib_umem.h
> +++ b/include/rdma/ib_umem.h
> @@ -48,7 +48,7 @@ struct ib_umem {
>  	int                     writable;
>  	int                     hugetlb;
>  	struct work_struct	work;
> -	struct pid             *pid;
> +	struct pid             *tgid;
>  	struct mm_struct       *mm;
>  	unsigned long		diff;
>  	struct ib_umem_odp     *odp_data;
> -- 
> 1.8.3.1
> 
