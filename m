From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 2/3 v5] IB/srp: Implement SRP_CRED_REQ and SRP_AER_REQ
Date: Thu, 19 Aug 2010 06:52:06 -0400
Message-ID: <1282215126.25848.42.camel@obelisk.thedillows.org>
References: <201008162055.02750.bvanassche@acm.org>
	 <1282178932.25848.27.camel@obelisk.thedillows.org>
	 <AANLkTimhOGgMr4SXzz4-pKXVyfCUjtrO+Avi=FGCacDW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimhOGgMr4SXzz4-pKXVyfCUjtrO+Avi=FGCacDW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-08-19 at 12:10 +0200, Bart Van Assche wrote:
> On Thu, Aug 19, 2010 at 2:48 AM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> > On Mon, 2010-08-16 at 20:55 +0200, Bart Van Assche wrote:
> >> Implements SRP_CRED_REQ and SRP_AER_REQ, which are information units defined
> >> in the SRP (draft) standard.  Adds declarations for the SRP_CRED_REQ,
> >> SRP_CRED_RSP, SRP_AER_REQ and SRP_AER_RSP information units to
> >> include/scsi/srp.h. Changes function definition order in ib_srp in order to
> >> avoid having to add more forward declarations.
> >
> > I still don't like the style of this patch -- too much code duplication
> > and the SRP_TX_IU_* constants are too ugly to live. I'd also prefer to
> > put the code movement in a separate patch, so in this case I'd accept
> > the forward declaration and we can do a separate patch later to move the
> > code around in one swoop. I think there's quite a bit that can
> > potentially be cleaned up there, and I don't expect you to do it as part
> > of this series.
> 
> I will put the code movement in a separate patch.

> Regarding code duplication: are you referring to the duplicated test
> of the SRP response opcode ?

There's less duplication than your first go at this, but I don't like
the __srp_post_send_req/__srp_post_send_rsp split and the way you've
broken out the processing.

Again, it comes down to style and the shape of the code.

> If I do not receive any further feedback,
> I will modify srp_handle_req() such that it accepts a third argument,
> a function pointer, and will change the call sites of that function
> such that either a pointer to the srp_handle_cred_req function or a
> pointer to the srp_handle_aer_req function is passed.

There's no need to do that; I don't think it will make it look better.
I've given you a clean, simple way to get there. What objections did you
have to the code I posted?

Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
