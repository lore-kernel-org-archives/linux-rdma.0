From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback query_transport()
Date: Mon, 27 Apr 2015 17:16:25 -0700
Message-ID: <553ED159.2090006@talpey.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com> <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com> <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com> <553DE799.5050608@profitbricks.com> <20150427215229.GD5347@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150427215229.GD5347-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/27/2015 2:52 PM, ira.weiny wrote:
> On Mon, Apr 27, 2015 at 09:39:05AM +0200, Michael Wang wrote:
>>
>>
>> On 04/24/2015 05:12 PM, Liran Liss wrote:
>>>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>>>>
>>> [snip]
>>>> a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index
>>>> 65994a1..d54f91e 100644
>>>> --- a/include/rdma/ib_verbs.h
>>>> +++ b/include/rdma/ib_verbs.h
>>>> @@ -75,10 +75,13 @@ enum rdma_node_type {  };
>>>>
>>>>   enum rdma_transport_type {
>>>> +	/* legacy for users */
>>>>   	RDMA_TRANSPORT_IB,
>>>>   	RDMA_TRANSPORT_IWARP,
>>>>   	RDMA_TRANSPORT_USNIC,
>>>> -	RDMA_TRANSPORT_USNIC_UDP
>>>> +	RDMA_TRANSPORT_USNIC_UDP,
>>>> +	/* new transport */
>>>> +	RDMA_TRANSPORT_IBOE,
>>>
>>> Remove RDMA_TRANSPORT_IBOE - it is not a transport.
>>> ROCE uses IBTA transport.
>>>
>>> If any code should test for ROCE should invoke a specific helper, e.g., rdma_protocol_iboe().
>>> This is  what you currently call "rdma_tech_iboe" is patch 02/26.
>>>
>>> I think that pretty much everybody agrees that rdma_protocol_*() is a better name than rdma_tech_*(), right?
>>> So, let's change this.
>>
>> Sure, sounds reasonable now, about the IBOE, we still need it to
>> separate the port support IB/ETH without the check on link-layer,
>> So what about a new enum on protocol type?
>>
>> Like:
>>
>> enum rdma_protocol {
>> 	RDMA_PROTOCOL_IB,
>> 	RDMA_PROTOCOL_IBOE,
>> 	RDMA_PROTOCOL_IWARP,
>> 	RDMA_PROTOCOL_USNIC_UDP
>> };
>>
>> So we could use query_protocol() to ask device provide the protocol
>> type, and there will be no mixing with the legacy transport type
>> anymore :-)
>
> I'm ok with that.  I like introducing a unique namespace which is clearly
> different from the previous "transport" one.

I agree the word "transport" takes things into the weeds.

But on the topic of naming protocols, I've been wondering, is there
some reason that "IBOE" is being used instead of "RoCE"? The IBOE
protocol used to exist and is not the same as the currently
standardized RoCE, right?

Also wondering, why add "UDP" to USNIC, is there a different USNIC?

Naming multiple layers together seems confusing and maybe in the end
will create more code to deal with the differences. For example, what
token will RoCEv2 take? RoCE_UDP, RoCE_v2 or ... ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
