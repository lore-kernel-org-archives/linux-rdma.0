From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/3 v4] IB/srp: Preparation for transmit ring response allocation
Date: Mon, 16 Aug 2010 20:21:43 +0200
Message-ID: <AANLkTik8q2fkkK1c59ZvBD+6AQpq3p+q55XcvpL_tzp1@mail.gmail.com>
References: <201008102033.29588.bvanassche@acm.org>
	<1281723889.2437.52.camel@lap75545.ornl.gov>
	<AANLkTikY4V6FULZX_LDMP6BFf6CE_L6KLm73LhtE-HKD@mail.gmail.com>
	<1281805494.2670.10.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1281805494.2670.10.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 14, 2010 at 7:04 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wro=
te:
>
> On Sat, 2010-08-14 at 09:35 +0200, Bart Van Assche wrote:
> > On Fri, Aug 13, 2010 at 8:24 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>=
 wrote:
> > >
> > > > +
> > > > + =A0 =A0 rsv =3D (req_type =3D=3D SRP_REQ_NORMAL) ? SRP_TSK_MG=
MT_RSV : 0;
> > > >
> > > > =A0 =A0 =A0 srp_send_completion(target->send_cq, target);
> > > >
> > > > - =A0 =A0 if (target->tx_head - target->tx_tail >=3D SRP_SQ_SIZ=
E)
> > > > + =A0 =A0 if (target->tx_head - target->tx_tail >=3D SRP_SQ_SIZ=
E - rsv)
> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> > >
> > > This isn't needed per my previous message. It is just a guard to =
make
> > > sure we don't use more buffers than are on the ring. The real lim=
iter is
> > > the number of credits. Perhaps swapping it with the req_limit che=
ck
> > > below and adding a WARN_ONCE() may be a good idea, since I don't =
think
> > > we should ever hit it.
> >
> > Replacing the above if-statement by a WARN_ON_ONCE() statement woul=
d
> > make sense if the value of tx_head - tx_tail did only depend on the
> > implementation of ib_srp.
>
> I didn't say replace the guard, I said add a message so we knew we hi=
t
> this case. The "isn't needed" was referring to the change to the line=
=2E
> WARN_ON_ONCE may not be the best thing to use, but perhaps a
> rate-limited shost_printk would be good. We really should never hit t=
he
> limit on tx buffers, unless we are dealing with a non-conforming targ=
et
> as you point out.

I'll leave out the check altogether - it has never been the primary
goal of ib_srp to serve as a debugging aid for target implementers.

I'll post a new patch series that should address all comments that
have been posted so far.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
