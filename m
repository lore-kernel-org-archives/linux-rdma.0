From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: DMA sync question
Date: Mon, 18 Oct 2010 09:08:00 -0400
Message-ID: <1287407280.10438.44.camel@lap75545.ornl.gov>
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
 <1287285925-11710-3-git-send-email-dillowda@ornl.gov>
 <AANLkTimvHRLr5YaCxeuLpQPMW7tY7cHsF9RrrSuMOmgS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <AANLkTimvHRLr5YaCxeuLpQPMW7tY7cHsF9RrrSuMOmgS-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-10-18 at 06:11 -0400, Bart Van Assche wrote:
> On Sun, Oct 17, 2010 at 5:25 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > [ ... ]
> > +static int srp_response_common(struct srp_target_port *target, s32 req_delta,
> > +                              void *rsp, int len)
[ ... ]
> > +
> > +       ib_dma_sync_single_for_cpu(dev, iu->dma, len, DMA_TO_DEVICE);
> > +       memcpy(iu->buf, rsp, len);
> > +       ib_dma_sync_single_for_device(dev, iu->dma, len, DMA_TO_DEVICE);
> > [ ... ]

> Hi Dave,
> 
> As far as I can see the above sync call applies to a buffer in the
> tx_ring[]. Data in that buffer is only modified by the CPU and never
> by the HCA. So why is the above sync call present ? Is that call
> necessary ?

In this instance, I copied existing practice from srp_queuecommand().

Documentation/DMA-API.txt seems to indicate we don't need the initial
*_sync_for_cpu() since the device never writes to the buffer, but I seem
to have an old memory that says we should do it anyways.

Perhaps LKML can clear it up -- do we need to call *_sync_for_cpu()
after a *sync_for_device(), even if the device never writes to the
buffer?
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
