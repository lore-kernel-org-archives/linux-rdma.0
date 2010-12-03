From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: user SA notifications, redux
Date: Fri, 3 Dec 2010 12:50:25 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3DB@MNEXMB1.qlogic.org>
References: <4CBF0AD7.80904@systemfabricworks.com>
 <4CC831C4.5030502@dev.mellanox.co.il>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D4675EEB@MNEXMB1.qlogic.org>
 <4CC959B9.7030402@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC959B9.7030402-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hal, 

You said:

> How about support for the other (than TrapNumber) InformInfo fields ? Of 
> particular interest are GID or LID range as not all apps want all the 
> ones for the entire subnet. I'm not sure about whether support for any 
> other fields is needed or not.

But, since these notifications have to be "multiplexed" when ib_usa actually 
Subscribes to them, how would we work that? I would guess that ib_usa would 
have to subscribe to some sort of union of all the requests from user apps. 

My concern there is that my reading of the spec says that a node can only subscribe
to a particular trap once; that's quite difficult when talking about 
non-overlapping Lid ranges or Gids.

What I'm thinking of is having ib_usa send informinfo messages that don't specify
a Lid or Gid, but then filtering incoming notices against the subscription
requests of user apps when deciding which apps should receive them. The downside,
of course, is additional traffic. 
	
What do you think?

-----Original Message-----
From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org] 
Sent: Thursday, October 28, 2010 7:09 AM
To: Mike Heinz
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org; Sean Hefty; Roland Dreier; Todd Rimmer
Subject: Re: user SA notifications, redux

On 10/27/2010 2:10 PM, Mike Heinz wrote:
>
>
> -----Original Message-----
>> Is this intended to handle multiple applications subscribing/unsubscribing for the same report ?
>
> Yes. This is based on Sean's old patches to the ib_sa which added support for multiplexing traps/notices to multiple client apps and which provided "ib_usa" to expose this capability to user space. I had originally submitted his code as-is for acceptance into OFED and the upstream kernel, but we got hung up on what the application API would be. These headers are meant to address that part of the conversation. Once we get that out of the way we can decide what needs to change in ib_sa and ib_usa to meet the API needs.

>> Why aren't traps 144 and 145 also defined ?
>
> Only because the existing ib_usa patch doesn't support them and I forgot to add them. That can be done.
>
>> Nit: If trap_number is in network byte order, shouldn't it be ib_net16_t below ?
>
> Done.
>
>> Shouldn't there be more granularity in this API in terms of what can be
>> subscribed for ?  IMO trap number is insufficient for registration and
>> this API should contain a trap specific variable with a component mask
>> indicating what fields are valid in that variable.
>
> I don't think I understand what you're getting at. You subscribe to the individual traps that you are interested in. When a trap is generated, you get an "event" which contains the entire message.

How about support for the other (than TrapNumber) InformInfo fields ? Of 
particular interest are GID or LID range as not all apps want all the 
ones for the entire subnet. I'm not sure about whether support for any 
other fields is needed or not.

>> Also, this API should be able to support registering for "all" traps.
>
> That capability is already present:
>
> IBV_SA_SM_TRAP_ALL                         = __constant_cpu_to_be16(0xFFFF)
>
>
>> What does releasing SA registration mean exactly ? Is it purely a local
>> operation or does it also do the deregistration with the SA ? I can't
>> tell for sure from the description above but suspect this API causes the
>> SA deregistration to occur as well.
>
> No, this is strictly local. Registering and deregistering with the SM depends on the patched ib_sa module and I don't think it unregisters with the module till it unloads.>

Shouldn't there be an API to deregister from the SA (without unloading) 
? I think to do that subscription reference counting would be needed 
which I don't think is supported in ib_usa.

-- Hal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
