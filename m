From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] libhns: Support cq record doorbell
Date: Thu, 25 Jan 2018 21:16:58 +0800
Message-ID: <ad71c7d8-651f-229a-0eeb-362a096df585@huawei.com>
References: <9e577314-4fcb-45de-6909-d5b3be570196@huawei.com>
 <20180118161949.GA18973@ziepe.ca>
 <a33a1337-665f-4cd4-5b39-b12d9f03af72@huawei.com>
 <20180119200029.GD3437@ziepe.ca>
 <68e02f2a-0474-bc73-a784-fd52dbbde552@huawei.com>
 <20180120164625.GA14372@ziepe.ca>
 <124fa0b2-ac35-a103-205b-252fddea2665@huawei.com>
 <20180123150421.GA30670@ziepe.ca>
 <91b5f324-cfaf-e778-2d6c-46000267f2cb@huawei.com>
 <20180124115141.GG1393@mtr-leonro.local> <20180124163056.GC16845@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180124163056.GC16845-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2018/1/25 0:30, Jason Gunthorpe wrote:
> On Wed, Jan 24, 2018 at 01:51:41PM +0200, Leon Romanovsky wrote:
>> On Wed, Jan 24, 2018 at 06:35:20PM +0800, Liuyixian (Eason) wrote:
>>>
>>>
>>> On 2018/1/23 23:04, Jason Gunthorpe wrote:
>>>> On Tue, Jan 23, 2018 at 08:51:09PM +0800, Liuyixian (Eason) wrote:
>>>>> Could you please give me further comments on that email?  If you don't
>>>>> agree with what I said in that email, can you give some suggestions
>>>>> to resolve compatibility issue?
>>>>
>>>> You can't have a not compatible in your table.
>>>>
>>>> You need to add some kind of mechanism for userspace to enable the new
>>>> features conditionally.
>>>>
>>>> Jason
>>>>
>>> Thanks, I will consider your suggestion in next version patch set.
>>
>> ABI_VERSION cam help you to achieve that.
> 
> ABI_VERSION is mostly totally broken in verbs and breaks
> compatability with. It is a last emergency resort.
> 
> Probably in this case you just need to lengthen the response udata
> struct and the kernel can detect if the longer struct is provided to
> enable the feature and userspace can detect !0 to determine if the
> kernel supports it.
> 
> Jason

Okay, thanks both of you! I will fix the compatibility problem ASAP.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
