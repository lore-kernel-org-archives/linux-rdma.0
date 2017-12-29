From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 for-next 2/2] RDMA/hns: Fix alignment problem of the
 doorbell
Date: Fri, 29 Dec 2017 15:26:43 +0800
Message-ID: <e85955f4-85a1-9f6e-f75f-5a355019fd54@huawei.com>
References: <1514470683-6972-1-git-send-email-liuyixian@huawei.com>
 <1514470683-6972-3-git-send-email-liuyixian@huawei.com>
 <20171229064843.GU3494@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171229064843.GU3494-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/12/29 14:48, Leon Romanovsky wrote:
> On Thu, Dec 28, 2017 at 10:18:03PM +0800, Yixian Liu wrote:
>> The array defined for doorbell is not guaranteed to be 64 bit
>> aligned while we write it to the hardware with 64 bit
>> alignment required.
>>
>> This patch fixes this problem by defining a union for doorbell
>> to make sure it 64 bit alignment.
>>
>> v2 -> v3:
>> 1. delete the unnecessary assignment for doorbell64.
>>
>> v2:
>> 1. Consider with Leon's comments, make sure it is 64 bit
>>    alignment by assigning the expected value to the u64
>>    member of the union type, i.e., assign doorbell array
>>    to doorbell64.
> 
> Please put changelog after "---", so it won't be visible in git log.
> See this patch as an example:
> https://lkml.org/lkml/2017/8/18/785
> 
> Thanks
> 

Okay, I will, Thanks!

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
