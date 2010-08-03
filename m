From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/srp: rename some symbolic constants
Date: Tue, 03 Aug 2010 11:20:59 -0400
Message-ID: <1280848859.20446.42.camel@lap75545.ornl.gov>
References: <201008021732.38682.bvanassche@acm.org>
 <1280784227.2451.72.camel@lap75545.ornl.gov>
 <AANLkTi=PHPXk3irmXsgr03GcBk+5L43BJA25hWLUESAV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <AANLkTi=PHPXk3irmXsgr03GcBk+5L43BJA25hWLUESAV-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-08-03 at 13:33 +0200, Bart Van Assche wrote:
> On Mon, Aug 2, 2010 at 11:23 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> >
> > On Mon, 2010-08-02 at 17:32 +0200, Bart Van Assche wrote:
> > > [ ... ]
> > >
> > > @@ -1051,7 +1052,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
> > >
> > >       srp_send_completion(target->send_cq, target);
> > >
> > > -     if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
> > > +     if (target->tx_head - target->tx_tail >= SRP_REQ_SQ_SIZE)
> > >               return NULL;
> >
> > I'm not keen on the name SRP_REQ_SQ_SIZE. I had used SRP_SQ_FULL here
> > and SRP_MAX_CREDIT elsewhere to be more descriptive of their use, but
> > I'm not sold on those names either. Anyone have better ideas?
> 
> SRP_REQ_SQ_SIZE is the number of elements of the send queue reserved
> for sending requests (SRP_CMD, SRP_TSK_MGMT and in the future maybe
> SRP_I_LOGOUT), and SRP_RSP_SQ_SIZE is the number of elements on the
> send queue reserved for sending responses (SRP_CRED_RSP and in the
> future also SRP_AER_RSP). So the names you suggested do not reflect
> what these constants are used for.

My thinking was SRP_SQ_FULL was a better indication of the use when
checking if there were buffers left, but I've already admitted I'm not
too happy with my name, either. :)

I used SRP_MAX_CREDIT for .can_queue, to reflect that we were limiting
the credits/outstanding requests we would use. Perhaps it is
superfluous, but I felt it helped clarify the intent.

I just really do not like the aesthetics of SRP_REQ_SQ_SIZE. I don't
have any better suggestions, so I'll drop it until/unless I can come up
with a better idea.

Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
