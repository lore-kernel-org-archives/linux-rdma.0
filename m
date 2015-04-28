From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback query_transport()
Date: Tue, 28 Apr 2015 16:29:14 +0200
Message-ID: <553F993A.8030805@profitbricks.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>		 <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com>		 <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>		 <553DE799.5050608@profitbricks.com>		 <20150427215229.GD5347@phlsvsds.ph.intel.com>	 <553ED159.2090006@talpey.com> <1430181360.44548.35.camel@redhat.com>	 <553EDA01.9040708@talpey.com> <1430184275.44548.44.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430184275.44548.44.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/28/2015 03:24 AM, Doug Ledford wrote:
[snip]
>>>> Also wondering, why add "UDP" to USNIC, is there a different USNIC?
>>>
>>> Yes, there are two transports, one a distinct ethertype and one that
>>> encapsulates USNIC in UDP.
>>
>> But this new enum isn't about transport, it's about protocol. So is
>> there one USNIC protocol, with a raw layering and a separate one with
>> UDP? Or is it one USNIC protocol with two different framings? Seems
>> there should be at least the USNIC protocol, without the _UDP
>> decoration, and I don't see it in the enum.
> 
> Keep in mind that this enum was Liran's response to Michael's original
> patch.  In the enum in Michael's patch, there was both USNIC and
> USNIC_UDP.

Yeah, I've not enum PROTOCOL_USNIC since currently there is no place
need it...

The only three cases currently are:
1. trasnport IB, link layer IB		//PROTOCOL_IB
2. transport IB, link layer ETH		//PROTOCOL_IBOE
3. transport IWARP			//PROTOCOL_IWARP

Regards,
Michael Wang

> 
>>>
>>>> Naming multiple layers together seems confusing and maybe in the end
>>>> will create more code to deal with the differences. For example, what
>>>> token will RoCEv2 take? RoCE_UDP, RoCE_v2 or ... ?
>>>
>>> Uncertain as of now.
>>
>> Ok, but it's imminent, right? What's the preference/guidance?
> 
> There is a patchset from Devesh Sharma at Emulex.  It added the RoCEv2
> capability.  As I recall, it used a new flag added to the existing port
> capabilities bitmask and notably did not modify either the node type or
> link layer that are currently used to differentiate between the
> different protocols.  That's from memory though, so I could be mistaken.
> 
> But that patchset was not written with this patchset in mind, and
> merging the two may well change that.  In any case, there is a proposed
> spec to follow, so for now that's the preference/guidance (unless this
> rework means that we need to depart from the spec on internals for
> implementation reasons).
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
