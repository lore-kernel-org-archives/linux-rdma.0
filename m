From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH rdma-next 1/5] RDMA/hns: Implement the
 disassociate_ucontext API
Date: Sat, 19 May 2018 16:24:40 +0800
Message-ID: <5AFFDF48.9010805@huawei.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-2-git-send-email-xavier.huwei@huawei.com>
 <20180517150019.GB10842@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180517150019.GB10842@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org



On 2018/5/17 23:00, Jason Gunthorpe wrote:
> On Thu, May 17, 2018 at 04:02:49PM +0800, Wei Hu (Xavier) wrote:
>> This patch Implements the IB core disassociate_ucontext API.
>>
>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
>>  drivers/infiniband/hw/hns/hns_roce_main.c | 36 +++++++++++++++++++++++++++++++
>>  1 file changed, 36 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
>> index 96fb6a9..7fafe9d 100644
>> +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
>> @@ -33,6 +33,9 @@
>>  #include <linux/acpi.h>
>>  #include <linux/of_platform.h>
>>  #include <linux/module.h>
>> +#include <linux/sched.h>
>> +#include <linux/sched/mm.h>
>> +#include <linux/sched/task.h>
>>  #include <rdma/ib_addr.h>
>>  #include <rdma/ib_smi.h>
>>  #include <rdma/ib_user_verbs.h>
>> @@ -422,6 +425,38 @@ static int hns_roce_port_immutable(struct ib_device *ib_dev, u8 port_num,
>>  	return 0;
>>  }
>>  
>> +static void hns_roce_disassociate_ucontext(struct ib_ucontext *ibcontext)
>> +{
>> +	struct task_struct *process;
>> +	struct mm_struct   *mm;
>> +
>> +	process = get_pid_task(ibcontext->tgid, PIDTYPE_PID);
>> +	if (!process)
>> +		return;
>> +
>> +	mm = get_task_mm(process);
>> +	if (!mm) {
>> +		pr_info("no mm, disassociate ucontext is pending task termination\n");
>> +		while (1) {
>> +			put_task_struct(process);
>> +			usleep_range(1000, 2000);
>> +			process = get_pid_task(ibcontext->tgid, PIDTYPE_PID);
>> +			if (!process || process->state == TASK_DEAD) {
>> +				pr_info("disassociate ucontext done, task was terminated\n");
>> +				/* if task was dead, need to release the task
>> +				 * struct.
>> +				 */
>> +				if (process)
>> +					put_task_struct(process);
>> +				return;
>> +			}
>> +		}
>> +	}
> I don't want to see this boilerplate code copied into every
> driver. Hoist it into the core code, have the disassociate driver callback
> accept a mm_struct parameter, and refactor the other drivers using this.

When the userspace RDMA application process is suspended for some reason
without executing ibv_close_device function,
There will be calltrace as follows when rmmod roce kernel driver ko in
the current version.
It looks like a common problem to every driver and the code segment
above is suitable for every driver.
Pardon me for asking, but if you have any plan to do this?

root@(none)# rmmod
../ko/hns-roce-hw-v2.ko                                                                                         

[ 1222.676069] INFO: task rmmod:1996 blocked for more than 120
seconds.                                                            
[ 1222.682423]       Not tainted 4.16.0-rc1-29112-ge237d0c-dirty
#15                                                               
[ 1222.688507] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.                                           
[ 1222.696327] rmmod           D    0  1996   1951
0x00000000                                                                      

[ 1222.701807] Call
trace:                                                                                                         

[ 1222.704252] 
__switch_to+0x9c/0xd8                                                                                              

[ 1222.707644] 
__schedule+0x1d8/0x854                                                                                             

[ 1222.711125] 
schedule+0x3c/0x9c                                                                                                 

[ 1222.714258] 
schedule_timeout+0x1dc/0x3f8                                                                                       

[ 1222.718260] 
wait_for_common+0x120/0x1e0                                                                                        

[ 1222.722174] 
wait_for_completion+0x28/0x34                                                                                      

[ 1222.726264] 
ib_uverbs_remove_one+0x29c/0x2bc                                                                                   

[ 1222.730614] 
ib_unregister_device+0xe8/0x198                                                                                    

[ 1222.734888]  hns_roce_exit+0xb4/0xc4
[hns_roce]                                                                                 

[ 1222.739414]  hns_roce_hw_v2_uninit_instance+0x24/0x40
[hns_roce_hw_v2]                                                          
[ 1222.745934] 
hclge_uninit_client_instance+0x88/0xb8                                                                             

[ 1222.750803] 
hnae3_match_n_instantiate+0xbc/0xd0                                                                                

[ 1222.755411] 
hnae3_unregister_client+0x50/0xb0                                                                                  

[ 1222.759850]  hns_roce_hw_v2_exit+0x10/0xd48
[hns_roce_hw_v2]                                                                    

[ 1222.765501] 
SyS_delete_module+0x1e8/0x238                                                                                      

[ 1222.769589] 
el0_svc_naked+0x30/0x34                                                                                            

   
Thanks, Jason

>> +	mmput(mm);
>> +	put_task_struct(process);
>> +}
> This can't be right, disassociate requires the driver to replace all
> the mmaps it make to user space with the 0 page, I see hns does use
> mmaps, so it must zap them here.
Ok, got it.
>
> Jason
>
> .
>
