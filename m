From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] libibverbs: add path record definitions to sa.h
Date: Fri, 21 May 2010 15:58:04 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801D5370A4@irsmsx503.ger.corp.intel.com>
References: <2420730B531C4665BD842A7F46007DA2@amr.corp.intel.com>
	<adapr18zmmj.fsf@roland-alpha.cisco.com>
	<63BD07796ED544AEAC6E41E669DC6EAC@amr.corp.intel.com>
	<adavdano5lb.fsf@roland-alpha.cisco.com>
	<4BF146F2.5060909@opengridcomputing.com>
 <adask5pnav3.fsf@roland-alpha.cisco.com>
 <4BF29E3D.40704@opengridcomputing.com>
 <BE2BFE91933D1B4089447C64486040801D4D8232@irsmsx503.ger.corp.intel.com>
 <4BF40B09.6070809@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BF40B09.6070809-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Steve, 

I want to add a change preventing creation of the L2 RAW_QPT from user priviledge (uid = 0 will be able to do such operation) 

What is the best place to do such change: ibv_create_qp in libibverbs(verbs.c) or  allowing to  decide for NIC vendors if they want to enable such API to user or root. In that case the change is requested only for libnes library?

Regards,

Mirek

-----Original Message-----
From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org] 
Sent: Wednesday, May 19, 2010 6:00 PM
To: Walukiewicz, Miroslaw
Cc: Roland Dreier; Hefty, Sean; linux-rdma
Subject: Re: [PATCH v2] libibverbs: add path record definitions to sa.h

Walukiewicz, Miroslaw wrote:
> Hello Steve, 
>
> Do you plan some changes in the core code related to RAW_QPT? 
>
>   


The only changes I see needed to the kernel core is the mcast change you 
already proposed to allow mcast attach/detach for RAW_ETY qps...


> Could you explain me better what means "priviledged interface" for you?
>
>   


I just mean that allocating these raw qps should only be allowed by 
effective UID 0.  This is analogous to PF_PACKET sockets which are 
privileged as well.



Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
