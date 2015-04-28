From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback query_transport()
Date: Mon, 27 Apr 2015 17:53:21 -0700
Message-ID: <553EDA01.9040708@talpey.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>	 <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com>	 <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>	 <553DE799.5050608@profitbricks.com>	 <20150427215229.GD5347@phlsvsds.ph.intel.com> <553ED159.2090006@talpey.com> <1430181360.44548.35.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430181360.44548.35.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/27/2015 5:36 PM, Doug Ledford wrote:
> On Mon, 2015-04-27 at 17:16 -0700, Tom Talpey wrote:
>> On 4/27/2015 2:52 PM, ira.weiny wrote:
>>> On Mon, Apr 27, 2015 at 09:39:05AM +0200, Michael Wang wrote:
>>>> On 04/24/2015 05:12 PM, Liran Liss wrote:
>>>>> [snip]
>>>>
>>>> Like:
>>>>
>>>> enum rdma_protocol {
>>>> 	RDMA_PROTOCOL_IB,
>>>> 	RDMA_PROTOCOL_IBOE,
>>>> 	RDMA_PROTOCOL_IWARP,
>>>> 	RDMA_PROTOCOL_USNIC_UDP
>>>> };
>>>>
>>>> So we could use query_protocol() to ask device provide the protocol
>>>> type, and there will be no mixing with the legacy transport type
>>>> anymore :-)
>>>
>>> I'm ok with that.  I like introducing a unique namespace which is clearly
>>> different from the previous "transport" one.
>>
>> I agree the word "transport" takes things into the weeds.
>>
>> But on the topic of naming protocols, I've been wondering, is there
>> some reason that "IBOE" is being used instead of "RoCE"?
>
> Because back in the day, when RoCE was accepted into the kernel, I'm
> pretty sure it was prior to the IBTA's final stamp of approval and
> before the name was set on RoCE, so IBoE was chosen upstream as the more
> "correct" name because it properly denoted what it was deemed to truly
> be: IB Verbs over Ethernet.

Well history is all well and good, but it seems weird to not use the
current, standard name in new code. It confuses me, anyway, because
it seems like IBOE could easily mean something else.

>> Also wondering, why add "UDP" to USNIC, is there a different USNIC?
>
> Yes, there are two transports, one a distinct ethertype and one that
> encapsulates USNIC in UDP.

But this new enum isn't about transport, it's about protocol. So is
there one USNIC protocol, with a raw layering and a separate one with
UDP? Or is it one USNIC protocol with two different framings? Seems
there should be at least the USNIC protocol, without the _UDP
decoration, and I don't see it in the enum.

>
>> Naming multiple layers together seems confusing and maybe in the end
>> will create more code to deal with the differences. For example, what
>> token will RoCEv2 take? RoCE_UDP, RoCE_v2 or ... ?
>
> Uncertain as of now.

Ok, but it's imminent, right? What's the preference/guidance?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
