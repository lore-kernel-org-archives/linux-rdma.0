From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Fw: general protection fault
Date: Thu, 18 Mar 2010 09:07:03 -0500
Message-ID: <4BA23387.80609@opengridcomputing.com>
References: <201003181055542343477@inspur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201003181055542343477-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lihaidong <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Without more info, I cannot help much. Are you calling it in a save
context? You probably cannot call it from an interrupt context. Was
there a stack trace?



lihaidong wrote:
> Hi, Steve
> Could you help me with this case.
> The server has 16GB memory,linux-2.6.29, OFED-1.5
> When using ib_dma_map_single, it report GFP error. I saw that krping
> use dma_map_single directly.
> >Hi=A3=BA
> >Sorry to bother you.
> >I don't know who you are, I saw you email address in linux-rdma mail
> archive since I met the same problem as you met in July, 3th, 2009.
> >Just like your email said
> >"when I am trying to map allocated memory for DMA, I get GPF:
> >general protection fault: 0000 [1] SMP
> >.
> >.
> >.
> >"
> >I saw no comments on your email. So Did you get over this problem? I=
f
> so, could you give me some tips , please?
> >
> >Thanks.
> >
> 2010-03-17
> ---------------------------------------------------------------------=
---
> lihaidong

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
