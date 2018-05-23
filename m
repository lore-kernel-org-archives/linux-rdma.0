From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH rdma-next 1/5] RDMA/hns: Implement the
 disassociate_ucontext API
Date: Wed, 23 May 2018 17:33:58 +0800
Message-ID: <5B053586.8090800@huawei.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-2-git-send-email-xavier.huwei@huawei.com>
 <20180517150019.GB10842@ziepe.ca> <5AFFDF48.9010805@huawei.com>
 <20180522202141.GA21148@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180522202141.GA21148@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org



On 2018/5/23 4:21, Jason Gunthorpe wrote:
> On Sat, May 19, 2018 at 04:24:40PM +0800, Wei Hu (Xavier) wrote:
>>
>> On 2018/5/17 23:00, Jason Gunthorpe wrote:
>>> On Thu, May 17, 2018 at 04:02:49PM +0800, Wei Hu (Xavier) wrote:
>>>> This patch Implements the IB core disassociate_ucontext API.
>>>>
>>>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
>>>>  drivers/infiniband/hw/hns/hns_roce_main.c | 36 +++++++++++++++++++++++++++++++
>>>>  1 file changed, 36 insertions(+)
>>>>
>>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
>>>> index 96fb6a9..7fafe9d 100644
>>>> +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
>>>> @@ -33,6 +33,9 @@
>>>>  #include <linux/acpi.h>
>>>>  #include <linux/of_platform.h>
>>>>  #include <linux/module.h>
>>>> +#include <linux/sched.h>
>>>> +#include <linux/sched/mm.h>
>>>> +#include <linux/sched/task.h>
>>>>  #include <rdma/ib_addr.h>
>>>>  #include <rdma/ib_smi.h>
>>>>  #include <rdma/ib_user_verbs.h>
>>>> @@ -422,6 +425,38 @@ static int hns_roce_port_immutable(struct ib_device *ib_dev, u8 port_num,
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static void hns_roce_disassociate_ucontext(struct ib_ucontext *ibcontext)
>>>> +{
>>>> +	struct task_struct *process;
>>>> +	struct mm_struct   *mm;
>>>> +
>>>> +	process = get_pid_task(ibcontext->tgid, PIDTYPE_PID);
>>>> +	if (!process)
>>>> +		return;
>>>> +
>>>> +	mm = get_task_mm(process);
>>>> +	if (!mm) {
>>>> +		pr_info("no mm, disassociate ucontext is pending task termination\n");
>>>> +		while (1) {
>>>> +			put_task_struct(process);
>>>> +			usleep_range(1000, 2000);
>>>> +			process = get_pid_task(ibcontext->tgid, PIDTYPE_PID);
>>>> +			if (!process || process->state == TASK_DEAD) {
>>>> +				pr_info("disassociate ucontext done, task was terminated\n");
>>>> +				/* if task was dead, need to release the task
>>>> +				 * struct.
>>>> +				 */
>>>> +				if (process)
>>>> +					put_task_struct(process);
>>>> +				return;
>>>> +			}
>>>> +		}
>>>> +	}
>>> I don't want to see this boilerplate code copied into every
>>> driver. Hoist it into the core code, have the disassociate driver callback
>>> accept a mm_struct parameter, and refactor the other drivers using this.
>> When the userspace RDMA application process is suspended for some reason
>> without executing ibv_close_device function,
>> There will be calltrace as follows when rmmod roce kernel driver ko in
>> the current version.
>> It looks like a common problem to every driver and the code segment
>> above is suitable for every driver.
>> Pardon me for asking, but if you have any plan to do this?
> My plan is to ask you to do it :)
Hi, Jason
    I will pull this patch out of the series and send V2.
    We will think how to hoist it into the core code later.
    Thanks

    Regards
Wei Hu
> Jason
>
> .
>
