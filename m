From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v2] libibverbs: add path record definitions to sa.h
Date: Fri, 21 May 2010 10:03:08 -0500
Message-ID: <4BF6A0AC.8080601@opengridcomputing.com>
References: <2420730B531C4665BD842A7F46007DA2@amr.corp.intel.com>	<adapr18zmmj.fsf@roland-alpha.cisco.com>	<63BD07796ED544AEAC6E41E669DC6EAC@amr.corp.intel.com>	<adavdano5lb.fsf@roland-alpha.cisco.com>	<4BF146F2.5060909@opengridcomputing.com> <adask5pnav3.fsf@roland-alpha.cisco.com> <4BF29E3D.40704@opengridcomputing.com> <BE2BFE91933D1B4089447C64486040801D4D8232@irsmsx503.ger.corp.intel.com> <4BF40B09.6070809@opengridcomputing.com> <BE2BFE91933D1B4089447C64486040801D5370A4@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040801D5370A4-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Walukiewicz, Miroslaw wrote:
> Hello Steve, 
>
> I want to add a change preventing creation of the L2 RAW_QPT from user priviledge (uid = 0 will be able to do such operation) 
>
> What is the best place to do such change: ibv_create_qp in libibverbs(verbs.c) or  allowing to  decide for NIC vendors if they want to enable such API to user or root. In that case the change is requested only for libnes library?
>
>   

I think it should be done in your kernel driver in your create_qp 
function.  The user space libraries really aren't trusted.  IE someone 
would write their own library to call into the kernel to create this 
qp.  So only in the kernel can you enforce privs.

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
