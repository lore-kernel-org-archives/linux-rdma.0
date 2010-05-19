From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] libibverbs: add path record definitions to sa.h
Date: Wed, 19 May 2010 16:37:06 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801D4D8232@irsmsx503.ger.corp.intel.com>
References: <2420730B531C4665BD842A7F46007DA2@amr.corp.intel.com>
	<adapr18zmmj.fsf@roland-alpha.cisco.com>
	<63BD07796ED544AEAC6E41E669DC6EAC@amr.corp.intel.com>
	<adavdano5lb.fsf@roland-alpha.cisco.com>
	<4BF146F2.5060909@opengridcomputing.com>
 <adask5pnav3.fsf@roland-alpha.cisco.com>
 <4BF29E3D.40704@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BF29E3D.40704-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Steve, 

Do you plan some changes in the core code related to RAW_QPT? 

Could you explain me better what means "priviledged interface" for you?

Regards, 

Mirek
-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
Sent: Tuesday, May 18, 2010 4:04 PM
To: Roland Dreier
Cc: Hefty, Sean; linux-rdma
Subject: Re: [PATCH v2] libibverbs: add path record definitions to sa.h

Roland Dreier wrote:
>  > Can you add the RAW_ETY qp type in this release as well?
>
> To be honest I haven't looked at the iWARP datagram stuff at all.  I'm
> not sure overloading the RAW_ETY QP type is necessarily the right thing
> to do -- it has quite different (never implemented) semantics in the IB
> case.  Is there any overview of what you guys are planning as far as
> how work requests are created for such QPs?
>   

The RAW_ETY qp would be just that:  A kernel-bypass/user mode qp that 
allows sending/receiving ethernet packets.   It would also provide a way 
for user applications to join/leave ethernet mcast groups (which 
requires an rdma core kernel change that Intel posted too).  What the 
iWARP vendors are doing on top of that is implementing some form of UDP 
in user mode.  The main goal here is to provide an ultra low latency UDP 
multicast and unicast channel for important market segments that desire 
this paradigm.  Also, due to the nature of this (send/recv raw eth 
frames), the interface would be privileged.

If you want to wait, then later I'll post patches on how this is being 
done for cxgb4.  But I thought adding the RAW_ETY was definitely a 
common requirement for Intel and Chelsio.


Steve.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
