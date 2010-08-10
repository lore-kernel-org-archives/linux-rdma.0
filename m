From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: {RFC] ibv_post_send()/ibv_post_recv() kernel path optimizations
Date: Tue, 10 Aug 2010 08:39:17 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040805BE11F7D@irsmsx503.ger.corp.intel.com>
References: <BE2BFE91933D1B4089447C64486040805BD83E5F@irsmsx503.ger.corp.intel.com>
 <20100806163237.GJ11306@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100806163237.GJ11306-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Jason, 

Do you have any benchmarks that show the alloca is a measurable
overhead?  

We changed overall path (both kernel and user space) to allocation-less approach and 
We achieved twice better latency using call to kernel driver. I have no data which path 
Is dominant - kernel or user space. I think I will have some measurements next week, so I will share 
My results.

Roland is right, all you
really need is a per-context (+per-cpu?) buffer you can grab, fill,
and put back.

I agree. I will go into this direction.

Regards,

Mirek

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
Sent: Friday, August 06, 2010 6:33 PM
To: Walukiewicz, Miroslaw
Cc: Roland Dreier; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: {RFC] ibv_post_send()/ibv_post_recv() kernel path optimizations

On Fri, Aug 06, 2010 at 11:03:36AM +0100, Walukiewicz, Miroslaw wrote:

> Currently the transmit/receive path works following way: User calls
> ibv_post_send() where vendor specific function is called.  When the
> path should go through kernel the ibv_cmd_post_send() is called.
> The function creates the POST_SEND message body that is passed to
> kernel.  As the number of sges is unknown the dynamic allocation for
> message body is performed.  (see libibverbs/src/cmd.c)

Do you have any benchmarks that show the alloca is a measurable
overhead?  I'm pretty skeptical... alloca will generally boil down to
one or two assembly instructions adjusting the stack pointer, and not
even that if you are lucky and it can be merged into the function
prologe.

> In the kernel the message body is parsed and a structure of wr and
> sges is recreated using dynamic allocations in kernel The goal of
> this operation is having a similar structure like in user space.

.. the kmalloc call(s) on the other hand definately seems worth
looking at ..

> In kernel in ib_uverbs_post_send() instead of dynamic allocation of
> the ib_send_wr structures the table of 512 ib_send_wr structures
> will be defined and all entries will be linked to unidirectional
> list so qp->device->post_send(qp, wr, &bad_wr) API will be not
> changed.

Isn't there a kernel API already for managing a pool of
pre-allocated fixed-size allocations?

It isn't clear to me that is even necessary, Roland is right, all you
really need is a per-context (+per-cpu?) buffer you can grab, fill,
and put back.

> As I know no driver uses that kernel path to posting buffers so
> iWARP multicast acceleration implemented in NES driver Would be a
> first application that can utilize the optimized path.

??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
