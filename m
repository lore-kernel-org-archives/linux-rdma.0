From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] libibverbs: add path record definitions to sa.h
Date: Tue, 18 May 2010 09:03:41 -0500
Message-ID: <4BF29E3D.40704@opengridcomputing.com>
References: <2420730B531C4665BD842A7F46007DA2@amr.corp.intel.com>	<adapr18zmmj.fsf@roland-alpha.cisco.com>	<63BD07796ED544AEAC6E41E669DC6EAC@amr.corp.intel.com>	<adavdano5lb.fsf@roland-alpha.cisco.com>	<4BF146F2.5060909@opengridcomputing.com> <adask5pnav3.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adask5pnav3.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
