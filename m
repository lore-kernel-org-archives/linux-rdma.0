From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v5 19/27] IB/Verbs: Use management helper cap_iw_cm()
Date: Mon, 20 Apr 2015 11:39:03 -0500
Message-ID: <55352BA7.5060104@opengridcomputing.com>
References: <5534B8C9.506@profitbricks.com> <5534BB7B.4020601@profitbricks.com> <55350698.9000109@opengridcomputing.com> <55351838.2060006@profitbricks.com> <5535209E.3020807@opengridcomputing.com> <20150420161927.GB7676@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150420161927.GB7676-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/20/15 11:19 AM, Jason Gunthorpe wrote:
> On Mon, Apr 20, 2015 at 10:51:58AM -0500, Tom Tucker wrote:
>> On 4/20/15 10:16 AM, Michael Wang wrote:
>>> On 04/20/2015 04:00 PM, Steve Wise wrote:
>>>> On 4/20/2015 3:40 AM, Michael Wang wrote:
>>> [snip]
>>>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>>>>> index 6805e3e..e4999f6 100644
>>>>> +++ b/include/rdma/ib_verbs.h
>>>>> @@ -1818,6 +1818,21 @@ static inline int cap_ib_cm(struct ib_device *device, u8 port_num)
>>>>>        return rdma_ib_or_iboe(device, port_num);
>>>>>    }
>>>>>    +/**
>>>>> + * cap_iw_cm - Check if the port of device has the capability IWARP
>>>>> + * Communication Manager.
>>>>> + *
>>>>> + * @device: Device to be checked
>>>>> + * @port_num: Port number of the device
>>>>> + *
>>>>> + * Return 0 when port of the device don't support IWARP
>>>>> + * Communication Manager.
>>>>> + */
>>>>> +static inline int cap_iw_cm(struct ib_device *device, u8 port_num)
>>>>> +{
>>>>> +    return rdma_tech_iwarp(device, port_num);
>>>>> +}
>>>>> +
>>>>>    int ib_query_gid(struct ib_device *device,
>>>>>             u8 port_num, int index, union ib_gid *gid);
>>>> iWARP devices _must_ support the IWCM so cap_iw_cm() is not really useful.
>>> Sean suggested to add this helper paired with cap_ib_cm(), may be there are
>>> some consideration on maintainability?
>>>
>>> Me too also prefer this way to make the code more readable ;-)
>> It's more consistent, but not necessarily more readable -- if by
>> readability we mean understanding.
>>
>> If the reader knows how the transports work, then the reader would
>> be confused by the addition of a check that is always true. For the
>> reader that doesn't know, the addition of the check implies that the
>> support is optional, which it is not.
> No, it says this code is concerned with the unique parts of iWarp
> related to CM, not the other unique parts of iWarp. The check isn't
> aways true, it is just always true on iWarp devices.
>
> That became the problem with the old way of just saying 'is iWarp'
> (and others). There are too many differences, the why became lost in
> many places.
>
> There are now too many standards, and several do not have public docs,
> to keep relying on a mess of 'is standard' tests.

You're right Jason, this gets called with the device handle so it's only 
true for iwarp.

> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
