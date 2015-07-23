From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH WIP 37/43] xprtrdma: Port to new memory registration API
Date: Thu, 23 Jul 2015 08:46:03 -0500
Message-ID: <002001d0c54d$eab839c0$c028ad40$@opengridcomputing.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com> <1437548143-24893-38-git-send-email-sagig@mellanox.com> <55AFED4C.9040409@opengridcomputing.com> <55B0C002.60307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B0C002.60307-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Thursday, July 23, 2015 5:21 AM
> To: Steve Wise; Sagi Grimberg; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Liran Liss; Oren Duer
> Subject: Re: [PATCH WIP 37/43] xprtrdma: Port to new memory registration API
> 
> On 7/22/2015 10:21 PM, Steve Wise wrote:
> >
> > On 7/22/2015 1:55 AM, Sagi Grimberg wrote:
> >> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> ---
> >>   net/sunrpc/xprtrdma/frwr_ops.c  | 80
> >> ++++++++++++++++++++++-------------------
> >>   net/sunrpc/xprtrdma/xprt_rdma.h |  4 ++-
> >>   2 files changed, 47 insertions(+), 37 deletions(-)
> >
> > Did you intend to change svcrdma as well?
> 
> All the ULPs need to convert. I didn't have a chance to convert
> svcrdma yet. Want to take it?

Not right now.  My focus is still on enabling iSER.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
