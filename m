From: "Chandramouli, Dasaratharaman"
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 02/11] IB/core: Change port_attr.sm_lid from 16 to 32
 bits
Date: Tue, 22 Nov 2016 21:43:40 -0800
Message-ID: <06bcc750-5c45-cfc4-bb86-434d4543e8f6@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1479843532-47496-3-git-send-email-dasaratharaman.chandramouli@intel.com>
 <20161122205717.GA6484@obsidianresearch.com>
 <cb14f866-0e19-1631-745d-5c9d67aabfe8@intel.com>
 <20161122212411.GC6484@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161122212411.GC6484-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 11/22/2016 1:24 PM, Jason Gunthorpe wrote:
> On Tue, Nov 22, 2016 at 01:13:26PM -0800, Chandramouli, Dasaratharaman wrote:
>>
>>
>> On 11/22/2016 12:57 PM, Jason Gunthorpe wrote:
>>> On Tue, Nov 22, 2016 at 02:38:43PM -0500, Dasaratharaman Chandramouli wrote:
>>>> +++ b/drivers/infiniband/core/sa_query.c
>>>> @@ -958,7 +958,7 @@ static void update_sm_ah(struct work_struct *work)
>>>> 		pr_err("Couldn't find index for default PKey\n");
>>>>
>>>> 	memset(&ah_attr, 0, sizeof ah_attr);
>>>> -	ah_attr.dlid     = port_attr.sm_lid;
>>>> +	ah_attr.dlid     = (u16)port_attr.sm_lid;
>>>
>>> Why are we dropping bits here?
>>
>> Patch 3 increases ah_attr.dlid to 32 bits and the typecast is dropped.
>> We added it in this patch just to avoid compiler warnings, if any.
>
> It would be alot better to fix this series so adding typecasts and
> then dropping them didn't happen so extensively. Just reodering some
> patched would do the trick. That would make it alot less churny and
> easy to read..
Yes, will re-order them. Thanks
>
>>>> -	sport->sm_lid = port_attr.sm_lid;
>>>> +	sport->sm_lid = (u16)port_attr.sm_lid;
>>>> 	sport->lid = port_attr.lid;
>>>
>>> And here..
>
>> Patch 11 increases lid and sm_lid fields in struct srpt_port and the
>> typecast is dropped.  We added it in this patch just to avoid
>> compiler warnings, if any.
>
> Eg if you do patch 11 first this hunk goes away.
>
> I also don't really care for all the added u16 casts, the compiler
> doesn't warn on implicit demotion without a higher warning level...
>
It's that higher warning level that we were a little concerned about.
If you feel very strongly about not having these casts, they can be 
removed but i would prefer leaving them there to silence certain odd 
ball compiler configurations.
>>>
>>>> +#define OPA_TO_IB_UCAST_LID(x)	(((x) >= be16_to_cpu(IB_MULTICAST_LID_BASE)) \
>>>> +				 ? 0 : x)
>>>
>>> static inline function please.
>> Will change. Thanks.
>
> All of them please.
Will change.
>
> And I think you should re-think how this is being used, the pattern
> around OPA_TO_IB_UCAST_LID is copied too many times for my liking, and
> isn't this UAPI compatability only?
They are only used when there is a user-space query into the kernel for 
lid and sm_lid.
>
> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
