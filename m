From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] libhns: Support cq record doorbell
Date: Fri, 19 Jan 2018 19:04:42 +0800
Message-ID: <a33a1337-665f-4cd4-5b39-b12d9f03af72@huawei.com>
References: <1516242961-154453-1-git-send-email-liuyixian@huawei.com>
 <1516242961-154453-3-git-send-email-liuyixian@huawei.com>
 <20180118043717.GC8414@ziepe.ca>
 <9e577314-4fcb-45de-6909-d5b3be570196@huawei.com>
 <20180118161949.GA18973@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180118161949.GA18973-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2018/1/19 0:19, Jason Gunthorpe wrote:
> On Thu, Jan 18, 2018 at 03:25:04PM +0800, Liuyixian (Eason) wrote:
>>
>>
>> On 2018/1/18 12:37, Jason Gunthorpe wrote:
>>> On Thu, Jan 18, 2018 at 10:36:01AM +0800, Yixian Liu wrote:
>>>
>>>> diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
>>>> index cde8568..7037a1c 100644
>>>> +++ b/providers/hns/hns_roce_u_verbs.c
>>>> @@ -276,6 +276,16 @@ struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
>>>>  
>>>>  	cmd.buf_addr = (uintptr_t) cq->buf.buf;
>>>>  
>>>> +	if (to_hr_dev(context->device)->hw_version != HNS_ROCE_HW_VER1) {
>>>> +		cq->set_ci_db = hns_roce_alloc_db(to_hr_ctx(context),
>>>> +						  HNS_ROCE_CQ_TYPE_DB);
>>>> +		if (!cq->set_ci_db) {
>>>> +			fprintf(stderr, "alloc cq db buffer failed!\n");
>>>> +			goto err_buf;
>>>> +		}
>>>> +		cmd.db_addr  = (uintptr_t) cq->set_ci_db;
>>>
>>> Uhh.. why does the userspace already have the 'db_addr' member of
>>> hns_roce_create_cq when the kernel doesn't?
>>>
>>> What is going on here? How does forward and backwards compatibility of
>>> the kABI work?
>>>
>>> Jason
>>>
>> I have checked the history log, it seems that we have missed to add 'db_addr'
>> for the kernel when adding it for the userspace.
>> Up to now, we haven't referred this field in current driver both in kernel
>> and userspace, that's why we haven't found this bug.
>>
>> Thanks for your doubt!
> 
> Please explain how forward and backwards compatibility of
> the kABI will work with this new db_addr capability.
> 
> Normally we'd rely on the kernel seeing that the udata is longer to
> signal that userspace supports an optional feature, but that is broken
> in this case.
> 
> Jason
> 
> 
Hi Jason,

In my understand, there are two possible aspects when you mentioned compatibility
for the new kernel driver with db_addr field:
1. the new kernel driver needed to support old user application using old userspace driver.
2. whether the new kernel driver can work well with the new userspace driver or not.

I am not quite sure about which case you care about.
For case 1, the new kernel driver can't support old user application or old userspace driver.
Because we use the record db solution (what this patchset does and why add new db_addr in kernel)
to substitute with operating register, which used by the old userspace driver.
Therefore, users need to update the userspace driver to the version which support record db.

For case 2, after we add db_addr field in the struct of hns_roce_ib_create_cq for the kernel,
it will have **the same length** with the userspace, that will be ok if we run an application
based on the new kernel and userspace driver, which both support record db.

Eason


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
