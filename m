From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RESEND][PATCH v4 for-next 0/2] Bugfixes for eq support in hns
Date: Tue, 2 Jan 2018 11:09:36 +0800
Message-ID: <24236028-de62-72be-b9ef-6df445b1e5db@huawei.com>
References: <1514546779-206832-1-git-send-email-liuyixian@huawei.com>
 <20171229181029.GA12569@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171229181029.GA12569-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/12/30 2:10, Jason Gunthorpe wrote:
> On Fri, Dec 29, 2017 at 07:26:17PM +0800, Yixian Liu wrote:
>> This patch set fixes the bugs according to Jason's two comments
>> on my previous patch set, which listed in the NOTE.
>>
>> NOTE: This patch set is dependent on the following patches.
>>    "RDMA/hns: Add eq support of hip08"
>>    "RDMA/hns: Refactor eq code for hip06"
>> v3 -> v4:
>> 1. Delete two unnecessary mb() caller in patch [1/2].
>> v2 -> v3:
>> 1. Update according to Jason's comments
>>    - use dma_rmb instead of rmb in patch [1/2]
>>    - delete unnecessary assignment for doorbell64
>> v1 -> v2:
>> 1. Update according to Leon's comment, see the changelog
>>    of patch [2/2].
>>
>> Yixian Liu (2):
>>   RDMA/hns: Add detailed comments for mb() call
> 
> I applied this one to for-next, it looks great, thanks
> 
>>   RDMA/hns: Fix alignment problem of the doorbell
> 
> and dropped this one, please resend with a full solution to this
> systemic problem as discussed.
> 

Okay, thanks!

> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
