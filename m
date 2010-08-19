From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/3 v5] IB/srp: Implement SRP_CRED_REQ and SRP_AER_REQ
Date: Thu, 19 Aug 2010 12:55:34 +0200
Message-ID: <AANLkTim7r2Z+-Po-rp+kVA6OD9nRE-3wH7JnO5Xz+2BK@mail.gmail.com>
References: <201008162055.02750.bvanassche@acm.org>
	<1282178932.25848.27.camel@obelisk.thedillows.org>
	<AANLkTimhOGgMr4SXzz4-pKXVyfCUjtrO+Avi=FGCacDW@mail.gmail.com>
	<1282215126.25848.42.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282215126.25848.42.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 19, 2010 at 12:52 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
>
> On Thu, 2010-08-19 at 12:10 +0200, Bart Van Assche wrote:
> > On Thu, Aug 19, 2010 at 2:48 AM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> > [ ... ]
> > If I do not receive any further feedback,
> > I will modify srp_handle_req() such that it accepts a third argument,
> > a function pointer, and will change the call sites of that function
> > such that either a pointer to the srp_handle_cred_req function or a
> > pointer to the srp_handle_aer_req function is passed.
>
> There's no need to do that; I don't think it will make it look better.
> I've given you a clean, simple way to get there. What objections did you
> have to the code I posted?

I don't like its style and aesthetics.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
