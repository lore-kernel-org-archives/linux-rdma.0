From: Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback query_transport()
Date: Mon, 27 Apr 2015 18:49:12 -0700
Message-ID: <553EE718.1030502@talpey.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>		 <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com>		 <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>		 <553DE799.5050608@profitbricks.com>		 <20150427215229.GD5347@phlsvsds.ph.intel.com>	 <553ED159.2090006@talpey.com> <1430181360.44548.35.camel@redhat.com>	 <553EDA01.9040708@talpey.com> <1430184275.44548.44.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430184275.44548.44.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "ira.weiny" <ira.weiny@intel.com>, Michael Wang <yun.wang@profitbricks.com>, Liran Liss <liranl@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 4/27/2015 6:24 PM, Doug Ledford wrote:
> On Mon, 2015-04-27 at 17:53 -0700, Tom Talpey wrote:
>> On 4/27/2015 5:36 PM, Doug Ledford wrote:
>>> On Mon, 2015-04-27 at 17:16 -0700, Tom Talpey wrote:
>>>> On 4/27/2015 2:52 PM, ira.weiny wrote:
>>>>> On Mon, Apr 27, 2015 at 09:39:05AM +0200, Michael Wang wrote:
>>>>>> On 04/24/2015 05:12 PM, Liran Liss wrote:
>>>>>>> [snip]
>>>>>>
>>>>>> Like:
>>>>>>
>>>>>> enum rdma_protocol {
>>>>>> 	RDMA_PROTOCOL_IB,
>>>>>> 	RDMA_PROTOCOL_IBOE,
>>>>>> 	RDMA_PROTOCOL_IWARP,
>>>>>> 	RDMA_PROTOCOL_USNIC_UDP
>>>>>> };
>>>>>>
>>>>>> So we could use query_protocol() to ask device provide the protocol
>>>>>> type, and there will be no mixing with the legacy transport type
>>>>>> anymore :-)
>>>>>
>>>>> I'm ok with that.  I like introducing a unique namespace which is clearly
>>>>> different from the previous "transport" one.
>>>>
>>>> I agree the word "transport" takes things into the weeds.
>>>>
>>>> But on the topic of naming protocols, I've been wondering, is there
>>>> some reason that "IBOE" is being used instead of "RoCE"?
>>>
>>> Because back in the day, when RoCE was accepted into the kernel, I'm
>>> pretty sure it was prior to the IBTA's final stamp of approval and
>>> before the name was set on RoCE, so IBoE was chosen upstream as the more
>>> "correct" name because it properly denoted what it was deemed to truly
>>> be: IB Verbs over Ethernet.
>>
>> Well history is all well and good, but it seems weird to not use the
>> current, standard name in new code. It confuses me, anyway, because
>> it seems like IBOE could easily mean something else.
>
> Having some of it refer to things as IBOE and some as ROCE would be
> similarly confusing, and switching existing IBOE usage to ROCE would
> cause pain to people with out of tree drivers (Lustre is the main one I
> know of).  There's not a good answer here.  There's only less sucky
> ones.

Hrm. Well, avoiding churn is good but legacies can wear ya down.
MHO it is worth doing since these are new enums/new patches.


>
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

Right! That's why I'm confused. Seems wrong to drop it, right?

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

Well, if RoCEv2 uses the same protocol enum, that may introduce new
confusion, for example there will be some new CM handling for UDP encap,
source port selection, and of course vlan/tag assignment, etc. But if
there is support under way, and everyone is clear, then, ok.

Thanks.
