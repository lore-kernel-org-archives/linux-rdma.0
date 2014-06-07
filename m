From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] RDMA/core: Add support for iWARP Port Mapper user
 space service (Version 2)
Date: Sat, 7 Jun 2014 22:40:20 +0300
Message-ID: <CAJZOPZ+woOAzGfnRnMs7X71+3z4sBhaf37SZnPyBTGzNaNoveg@mail.gmail.com>
References: <20140326220735.GA14840@TENIKOLO-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140326220735.GA14840@TENIKOLO-MOBL1>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Lacombe, John S" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> The patch adds support for iWarp Port Mapper user space service

Reading the change-log below, I noted that pretty much nothing in it
explains what
is the role of this port mapper, with that presentation you sent not
being part of the upstream kernel, I think you need to add some
documentation. Care to resend this patch with modified change-log so
Roland can rebase his for-next branch or just send what you want to
add and Roland can re-word this commit.

Or.

>
> 1) Netlink interface functions are added: ibnl_unicast() and ibnl_mulitcast()
>    for sending netlink messages to user space
>
> 2) The signature of the existing ibnl_put_msg() is changed to more generic
>
> 3) Two netlink clients are added: RDMA_NL_NES, RDMA_NL_C4IW corresponding
>    to the two iWarp drivers - nes and cxgb4 which use the IWPM service
>
> 4) Enums are added to enumerate the attributes in the netlink messages, which
>    are exchanged between the user space IWPM service and the iWARP drivers
>
> 5) New files iw_portmap.h, iwpm_util.c iwpm_msg.c and iwpm_util.h are created
>    which contain the IWPM core functionality (service requests and callbacks)
>
>    iwpm_util.c, iwpm_msg.c and iwpm_util.h are added to infiniband/core
>    and the source files are compiled as part of iw_cm module.
>    iw_portmap.h which contains the port mapper driver API is added to
>    include/rdma. The iWarp drivers nes and cxgb4 are the two port mapper
>    clients which use the provided IWPM core functionality to communicate
>    with the user space port mapper service.
>
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off by: Peter Waskiewicz <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
