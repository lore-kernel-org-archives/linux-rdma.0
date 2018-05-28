From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH V3 rdma-next 3/4] RDMA/uverbs: Hoist the common process of
 disassociate_ucontext into ib core
Date: Mon, 28 May 2018 19:06:35 +0800
Message-ID: <5B0BE2BB.8000101@huawei.com>
References: <1527324107-56593-1-git-send-email-xavier.huwei@huawei.com>
 <1527324107-56593-4-git-send-email-xavier.huwei@huawei.com>
 <20180527150500.GA3085@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180527150500.GA3085@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 2018/5/27 23:05, Leon Romanovsky wrote:
> On Sat, May 26, 2018 at 04:41:46PM +0800, Wei Hu (Xavier) wrote:
>> This patch hoisted the common process of disassociate_ucontext
>> callback function into ib core code, and these code are common
>> to ervery ib_device driver.
>>
>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
>> ---
>>  drivers/infiniband/core/uverbs_main.c | 45 ++++++++++++++++++++++++++++++++++-
>>  drivers/infiniband/hw/mlx4/main.c     | 34 --------------------------
>>  drivers/infiniband/hw/mlx5/main.c     | 34 --------------------------
>>  3 files changed, 44 insertions(+), 69 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
>> index 4445d8e..a0a1c70 100644
>> --- a/drivers/infiniband/core/uverbs_main.c
>> +++ b/drivers/infiniband/core/uverbs_main.c
>> @@ -41,6 +41,8 @@
>>  #include <linux/fs.h>
>>  #include <linux/poll.h>
>>  #include <linux/sched.h>
>> +#include <linux/sched/mm.h>
>> +#include <linux/sched/task.h>
>>  #include <linux/file.h>
>>  #include <linux/cdev.h>
>>  #include <linux/anon_inodes.h>
>> @@ -1090,6 +1092,47 @@ static void ib_uverbs_add_one(struct ib_device *device)
>>  	return;
>>  }
>>
>> +static void ib_uverbs_disassociate_ucontext(struct ib_ucontext *ibcontext)
>> +{
>> +	struct ib_device *ib_dev = ibcontext->device;
>> +	struct task_struct *owning_process  = NULL;
>> +	struct mm_struct   *owning_mm       = NULL;
>> +
>> +	owning_process = get_pid_task(ibcontext->tgid, PIDTYPE_PID);
>> +	if (!owning_process)
>> +		return;
>> +
>> +	owning_mm = get_task_mm(owning_process);
>> +	if (!owning_mm) {
>> +		pr_info("no mm, disassociate ucontext is pending task termination\n");
>> +		while (1) {
>> +			put_task_struct(owning_process);
>> +			usleep_range(1000, 2000);
>> +			owning_process = get_pid_task(ibcontext->tgid,
>> +						      PIDTYPE_PID);
>> +			if (!owning_process ||
>> +			    owning_process->state == TASK_DEAD) {
>> +				pr_info("disassociate ucontext done, task was terminated\n");
>> +				/* in case task was dead need to release the
>> +				 * task struct.
>> +				 */
>> +				if (owning_process)
>> +					put_task_struct(owning_process);
>> +				return;
>> +			}
>> +		}
>> +	}
>> +
>> +	/* need to protect from a race on closing the vma as part of
>> +	 * mlx5_ib_vma_close.
> Except this "mlx5_ib_vma_close"
>
> Acked-by: Leon Romanovsky <leonro@mellanox.com>
Hi, Leon
Thanks, We will fix it in V4.
    Regards
Wei Hu
>> +	 */
>> +	down_write(&owning_mm->mmap_sem);
>> +	ib_dev->disassociate_ucontext(ibcontext);
>> +	up_write(&owning_mm->mmap_sem);
>> +	mmput(owning_mm);
>> +	put_task_struct(owning_process);
>> +}
>> +
>>  static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
>>  					struct ib_device *ib_dev)
>>  {
>> @@ -1130,7 +1173,7 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
>>  			 * (e.g mmput).
>>  			 */
>>  			ib_uverbs_event_handler(&file->event_handler, &event);
>> -			ib_dev->disassociate_ucontext(ucontext);
>> +			ib_uverbs_disassociate_ucontext(ucontext);
>>  			mutex_lock(&file->cleanup_mutex);
>>  			ib_uverbs_cleanup_ucontext(file, ucontext, true);
>>  			mutex_unlock(&file->cleanup_mutex);
>> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
>> index bf12394..59aed45 100644
>> --- a/drivers/infiniband/hw/mlx4/main.c
>> +++ b/drivers/infiniband/hw/mlx4/main.c
>> @@ -1189,40 +1189,10 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
>>  	int ret = 0;
>>  	struct vm_area_struct *vma;
>>  	struct mlx4_ib_ucontext *context = to_mucontext(ibcontext);
>> -	struct task_struct *owning_process  = NULL;
>> -	struct mm_struct   *owning_mm       = NULL;
>> -
>> -	owning_process = get_pid_task(ibcontext->tgid, PIDTYPE_PID);
>> -	if (!owning_process)
>> -		return;
>> -
>> -	owning_mm = get_task_mm(owning_process);
>> -	if (!owning_mm) {
>> -		pr_info("no mm, disassociate ucontext is pending task termination\n");
>> -		while (1) {
>> -			/* make sure that task is dead before returning, it may
>> -			 * prevent a rare case of module down in parallel to a
>> -			 * call to mlx4_ib_vma_close.
>> -			 */
>> -			put_task_struct(owning_process);
>> -			usleep_range(1000, 2000);
>> -			owning_process = get_pid_task(ibcontext->tgid,
>> -						      PIDTYPE_PID);
>> -			if (!owning_process ||
>> -			    owning_process->state == TASK_DEAD) {
>> -				pr_info("disassociate ucontext done, task was terminated\n");
>> -				/* in case task was dead need to release the task struct */
>> -				if (owning_process)
>> -					put_task_struct(owning_process);
>> -				return;
>> -			}
>> -		}
>> -	}
>>
>>  	/* need to protect from a race on closing the vma as part of
>>  	 * mlx4_ib_vma_close().
>>  	 */
>> -	down_write(&owning_mm->mmap_sem);
>>  	for (i = 0; i < HW_BAR_COUNT; i++) {
>>  		vma = context->hw_bar_info[i].vma;
>>  		if (!vma)
>> @@ -1241,10 +1211,6 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
>>  		/* context going to be destroyed, should not access ops any more */
>>  		context->hw_bar_info[i].vma->vm_ops = NULL;
>>  	}
>> -
>> -	up_write(&owning_mm->mmap_sem);
>> -	mmput(owning_mm);
>> -	put_task_struct(owning_process);
>>  }
>>
>>  static void mlx4_ib_set_vma_data(struct vm_area_struct *vma,
>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>> index f3e7d7c..136d64f 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
>> @@ -1965,38 +1965,7 @@ static void mlx5_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
>>  	struct vm_area_struct *vma;
>>  	struct mlx5_ib_vma_private_data *vma_private, *n;
>>  	struct mlx5_ib_ucontext *context = to_mucontext(ibcontext);
>> -	struct task_struct *owning_process  = NULL;
>> -	struct mm_struct   *owning_mm       = NULL;
>>
>> -	owning_process = get_pid_task(ibcontext->tgid, PIDTYPE_PID);
>> -	if (!owning_process)
>> -		return;
>> -
>> -	owning_mm = get_task_mm(owning_process);
>> -	if (!owning_mm) {
>> -		pr_info("no mm, disassociate ucontext is pending task termination\n");
>> -		while (1) {
>> -			put_task_struct(owning_process);
>> -			usleep_range(1000, 2000);
>> -			owning_process = get_pid_task(ibcontext->tgid,
>> -						      PIDTYPE_PID);
>> -			if (!owning_process ||
>> -			    owning_process->state == TASK_DEAD) {
>> -				pr_info("disassociate ucontext done, task was terminated\n");
>> -				/* in case task was dead need to release the
>> -				 * task struct.
>> -				 */
>> -				if (owning_process)
>> -					put_task_struct(owning_process);
>> -				return;
>> -			}
>> -		}
>> -	}
>> -
>> -	/* need to protect from a race on closing the vma as part of
>> -	 * mlx5_ib_vma_close.
>> -	 */
>> -	down_write(&owning_mm->mmap_sem);
>>  	mutex_lock(&context->vma_private_list_mutex);
>>  	list_for_each_entry_safe(vma_private, n, &context->vma_private_list,
>>  				 list) {
>> @@ -2013,9 +1982,6 @@ static void mlx5_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
>>  		kfree(vma_private);
>>  	}
>>  	mutex_unlock(&context->vma_private_list_mutex);
>> -	up_write(&owning_mm->mmap_sem);
>> -	mmput(owning_mm);
>> -	put_task_struct(owning_process);
>>  }
>>
>>  static inline char *mmap_cmd2str(enum mlx5_ib_mmap_cmd cmd)
>> --
>> 1.9.1
>>
