From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v2 0/2] libibverbs memory barrier fixes
Date: Mon, 30 May 2016 14:17:57 +0300
Message-ID: <a10b354c-f9f5-04c8-260d-841273e25b7c@mellanox.com>
References: <20160520200053.6983AE0B9D@smtp.ogc.us>
 <3ffd3089-ede9-aebf-4781-2e012bc65252@redhat.com>
 <00c801d1b694$f9d7f5b0$ed87e110$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00c801d1b694$f9d7f5b0$ed87e110$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/25/2016 5:51 PM, Steve Wise wrote:
>> On 05/20/2016 03:43 PM, Steve Wise wrote:
>>> This is v2 of the ARM64 mb* support, plus an additional patch to fail
>>> compiles if there is no platform implementation of the memory barriers.
>>> I've included the 2nd patch because I think it is important to not
>>> assume any default barrier implementation.  Getting it wrong can result
>>> in data corruption.
>>>
>>> Changes since V1:
>>>
>>> Put the RFC tag back on because I want to retest this series.
>>>
>>> Implemented the ARM64 memory barrier macros from scratch using the AMD
>>> reference docs.
>>>
>>> Added 2nd patch to fail compiles if no mb* macros exist for the platform.
>>>
>>> Steve Wise (2):
>>>   libibverbs: add ARM64 memory barrier macros
>>>   Fail compiles if no platform specific memory barriers exist
>>>
>>>  include/infiniband/arch.h |   15 +++++++++------
>>>  1 files changed, 9 insertions(+), 6 deletions(-)
>>>
>> Please remember to use --thread=shallow when sending patch emails using
>> git send-email (which is what I assume you did).
>>
>> Let me know how the testing comes out.  The patches look fine to me
>> (thanks for adding the second one, it's the right thing to do).
>>
> Hey Doug, the series tests good with cxgb4 on ARM64.  Do I need to repost a
> final series, or can you merge v2? 
>
> Hey Noa, have you all had a chance to test this series?

We didn't encounter any issue so far that seems to be related to this patch.
However, some extra functional / performance testing are needed to evaluate.
>From internal code review it seems that wmb() is quite strict in your patch and
may have a performance penalty.
Any reason not to use dsb instead of dmb for wmb()?
#define wmb()asm volatile("dsb st" ::: "memory")
#define wmb()asm volatile("dmb st" ::: "memory")

> Thanks,
>
> Steve.
>
Thanks,
Noa

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
