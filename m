From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 1/3 v4] IB/srp: Preparation for transmit ring response
 allocation
Date: Sat, 14 Aug 2010 13:04:54 -0400
Message-ID: <1281805494.2670.10.camel@obelisk.thedillows.org>
References: <201008102033.29588.bvanassche@acm.org>
	 <1281723889.2437.52.camel@lap75545.ornl.gov>
	 <AANLkTikY4V6FULZX_LDMP6BFf6CE_L6KLm73LhtE-HKD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikY4V6FULZX_LDMP6BFf6CE_L6KLm73LhtE-HKD-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2010-08-14 at 09:35 +0200, Bart Van Assche wrote:
> On Fri, Aug 13, 2010 at 8:24 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> >
> > > +
> > > +     rsv = (req_type == SRP_REQ_NORMAL) ? SRP_TSK_MGMT_RSV : 0;
> > >
> > >       srp_send_completion(target->send_cq, target);
> > >
> > > -     if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
> > > +     if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE - rsv)
> > >               return NULL;
> >
> > This isn't needed per my previous message. It is just a guard to make
> > sure we don't use more buffers than are on the ring. The real limiter is
> > the number of credits. Perhaps swapping it with the req_limit check
> > below and adding a WARN_ONCE() may be a good idea, since I don't think
> > we should ever hit it.
> 
> Replacing the above if-statement by a WARN_ON_ONCE() statement would
> make sense if the value of tx_head - tx_tail did only depend on the
> implementation of ib_srp.

I didn't say replace the guard, I said add a message so we knew we hit
this case. The "isn't needed" was referring to the change to the line.
WARN_ON_ONCE may not be the best thing to use, but perhaps a
rate-limited shost_printk would be good. We really should never hit the
limit on tx buffers, unless we are dealing with a non-conforming target
as you point out.

> > > @@ -1626,9 +1632,9 @@ static struct scsi_host_template srp_template = {
> > > -     .can_queue                      = SRP_SQ_SIZE,
> > > +     .can_queue                      = SRP_REQ_SQ_SIZE - SRP_TSK_MGMT_RSV,
> >
> > I don't like the naming here and the duplicate math in several places.
> > Pick a name for this and use it. Since this is just the template and is
> > overridden when we actually connect to a host, I'm not sure there is a
> > much of a reason to change things here anyways. Same for the next two...
> 
> I do not agree that the can_queue value filled in in the template is
> thrown away later on. As you can see in the ib_srp login code, the
> can_queue value is preserved when target->req_lim is larger than the
> can_queue value from the template:
> 
>         target->scsi_host->can_queue = min(target->req_lim,
> target->scsi_host->can_queue);

Yep, I missed that. That's what I get working from memory. We could just
change the setting of can_queue after connection to ignore the value in
scsi_host and clamp the the appropriate size. Probably not my best idea
-- perhaps the SCSI mid-layer wants to clamp that for some reason.

Either way, it needs a good name.

Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
