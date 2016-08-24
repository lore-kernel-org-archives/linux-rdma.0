From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] IB/hns: Fix return value check in
 hns_roce_get_cfg()
Date: Wed, 24 Aug 2016 09:22:41 +0800
Message-ID: <57BCF6E1.2030707@huawei.com>
References: <1470445284-28970-1-git-send-email-weiyj.lk@gmail.com>
 <20160807053115.GQ27667@leon.nu>
 <087f4381-d830-fc57-ea5d-c516a1b160b5@gmail.com>
 <20160807131419.GS27667@leon.nu> <57AC56D4.3050401@huawei.com>
 <c27a3c5f-9604-546a-5ac7-e70613d93d50@redhat.com>
 <57BBAD65.6000108@huawei.com> <20160823105926.GG15065@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823105926.GG15065-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 2016/8/23 18:59, Leon Romanovsky wrote:
> On Tue, Aug 23, 2016 at 09:56:53AM +0800, Wei Hu (Xavier) wrote:
>>
>> On 2016/8/23 2:15, Doug Ledford wrote:
>>> On 8/11/2016 6:43 AM, Wei Hu (Xavier) wrote:
>>>> Hi,  Doug Ledford
>>>>
>>>>    Can you give me a suggestion that what we should do? Thanks very much!
>>> I still have a branch for your driver, the hns-roce branch in my tree
>>> (only available via my github repo for now).  Now that Dave Miller has
>>> taken in the most recent patch to add the needed reset function to the
>>> hns net driver, I rebased your branch in my tree on his net-next branch.
>>>   I'll submit it in the next merge window.  I then applied this patch on
>>> top of that branch.  So, future patches to your driver need to be
>>> against my hns-roce branch in my github repo, at least until I merge it
>>> into my official k.o/for-4.9 branch.
>> Hi, Doug Ledford
>>      Can you provide us your hns-roce branch in github repo?
> https://github.com/dledford/linux/tree/hns-roce
Thank you very much! :-)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
