From: 858585 jemmy <jemmy858585@gmail.com>
Subject: Re: [PATCH v2] IB/umem: ib_ucontext already have tgid, remove pid
 from ib_umem structure
Date: Wed, 13 Jun 2018 17:25:00 +0800
Message-ID: <CAOGPPbe8V45B0TVMUiezKDcm0_d5dJhrubpbu5ARhi-y6MXkUg@mail.gmail.com>
References: <1525769416-14596-1-git-send-email-lidongchen@tencent.com> <20180613043620.GA22578@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613043620.GA22578@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, akpm@linux-foundation.org, qing.huang@oracle.com, Leon Romanovsky <leon@kernel.org>, artemyko@mellanox.com, dan.j.williams@intel.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Adi Dotan <adido@mellanox.com>, Gal Shachaf <galsha@mellanox.com>, Aviad Yehezkel <aviadye@mellanox.com>, Lidong Chen <lidongchen@tencent.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 13, 2018 at 12:36 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Tue, May 08, 2018 at 04:50:16PM +0800, Lidong Chen wrote:
>> The userspace may invoke ibv_reg_mr and ibv_dereg_mr by different threads.
>> If when ibv_dereg_mr invoke and the thread which invoked ibv_reg_mr has
>> exited, get_pid_task will return NULL, ib_umem_release does not decrease
>> mm->pinned_vm. This patch fixes it by use tgid in ib_ucontext struct.
>>
>> Signed-off-by: Lidong Chen <lidongchen@tencent.com>
>> ---
>>  [v2]
>>  - use ib_ucontext tgid instread of tgid in ib_umem structure
>
> I'm looking at this again, and it doesn't seem quite right..
>
>> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
>> index 9a4e899..2b6c9b5 100644
>> --- a/drivers/infiniband/core/umem.c
>> +++ b/drivers/infiniband/core/umem.c
>> @@ -119,7 +119,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>>       umem->length     = size;
>>       umem->address    = addr;
>>       umem->page_shift = PAGE_SHIFT;
>> -     umem->pid        = get_task_pid(current, PIDTYPE_PID);
>>       /*
>>        * We ask for writable memory if any of the following
>>        * access flags are set.  "Local write" and "remote write"
>> @@ -132,7 +131,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>>                IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
>>
>>       if (access & IB_ACCESS_ON_DEMAND) {
>> -             put_pid(umem->pid);
>>               ret = ib_umem_odp_get(context, umem, access);
>>               if (ret) {
>>                       kfree(umem);
>> @@ -148,7 +146,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>>
>>       page_list = (struct page **) __get_free_page(GFP_KERNEL);
>>       if (!page_list) {
>> -             put_pid(umem->pid);
>>               kfree(umem);
>>               return ERR_PTR(-ENOMEM);
>>       }
>
> in ib_umem_get we are doing this:
>
>         down_write(&current->mm->mmap_sem);
>         locked     = npages + current->mm->pinned_vm;
>
> And then in release we now do:
>
>         task = get_pid_task(umem->context->tgid, PIDTYPE_PID);
>         if (!task)
>                 goto out;
>         mm = get_task_mm(task);
>         mm->pinned_vm -= diff;
>
> But there is no guarantee that context->tgid and 'current' are the
> same thing during ib_umem_get..

context->tgid and current maybe different. but different threads in one
process should point to one mm structure. so it should works for multithread.

>
> So in the dysfunctional case where someone forks and keeps the context
> FD open on both sides of the fork they can cause the pinned_vm
> counter to become wrong in the processes. Sounds bad..

I am not sure about fork support, I will check this problem.

>
> Thus, I think we need to go back to storing the tgid in the ib_umem
> and just fix it to store the group leader not the thread PID?
>
> And then even more we need the ib_get_mr_mm() helper to make sense of
> this, because all the drivers are doing the wrong thing by using the
> context->tgid too.
>
> Is that all right?
>
> Jason
