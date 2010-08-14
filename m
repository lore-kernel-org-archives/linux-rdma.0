From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 2/3 v4] IB/srp: Implement SRP_CRED_REQ
Date: Sat, 14 Aug 2010 12:55:47 -0400
Message-ID: <1281804947.2670.2.camel@obelisk.thedillows.org>
References: <201008102033.57038.bvanassche@acm.org>
	 <1281729320.2437.142.camel@lap75545.ornl.gov>
	 <AANLkTi=Wy50xcE=-+Y67HB+GbOyLmWe72jZLYu8Cjoep@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=Wy50xcE=-+Y67HB+GbOyLmWe72jZLYu8Cjoep-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2010-08-14 at 09:22 +0200, Bart Van Assche wrote:
> On Fri, Aug 13, 2010 at 9:55 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> >
> > On Tue, 2010-08-10 at 20:33 +0200, Bart Van Assche wrote:
> > > Implements SRP_CRED_REQ, which is an information unit defined in the SRP
> > > (draft) standard and that allows an SRP target to inform an SRP initiator that
> > > more requests may be sent by the initiator. Adds declarations for the
> > > SRP_CRED_REQ and SRP_CRED_RSP information units to include/scsi/srp.h.
> >
> > I don't seem to be communicating my comments very clearly, so let me try
> > the language of code. Here's a proposed alternative version. Compile
> > tested only, based on your patch 1/3 v4, with the __srp_get_tx_iu()
> > changes partially reverted. It would need to be rebased once you send a
> > revised 1/3 and would need testing.
> 
> It's not that your communication is not clear but that I'm not sure
> whether it's a good idea to ignore the sense data included in an
> SRP_AER_REQ message. Supporting SRP_AER_REQ properly does not only
> mean processing the credit data included in that message but also
> processing the sense data included in that message.

As far as I know, there is no current way to inject the sense data into
the SCSI mid-layer. This at least gives us a starting point to work on
that, while allowing us to recover the credits transferred to the
initiator by the message. We don't have to do it all in one go, and now
we'll at least know when a target uses SRP_AER_REQ.

Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
