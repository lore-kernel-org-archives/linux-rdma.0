From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT] lock scaling and bug fixes for 2.6.38
Date: Tue, 11 Jan 2011 18:43:40 +0100
Message-ID: <20110111174340.GD15933@htj.dyndns.org>
References: <1294699530.3038.27.camel@obelisk.thedillows.org>
 <adak4ic6wmo.fsf@cisco.com>
 <AANLkTikEnR6pjLy-L08UUbVdwS5f3k0+EutA-SrDVHMT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikEnR6pjLy-L08UUbVdwS5f3k0+EutA-SrDVHMT-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

On Tue, Jan 11, 2011 at 06:29:52PM +0100, Bart Van Assche wrote:
> On Tue, Jan 11, 2011 at 2:45 AM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wr=
ote:
> >
> > =A0> =A0 =A0git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-i=
nitiator.git srp-lock-scaling
> >
> > Thanks, pulled.
> >
> > Will try to merge Tejun's work queue patch shortly.
>=20
> Maybe it's=A0a good idea to add a comment above the declaration of th=
e
> global variable "extern struct workqueue_struct *ib_wq;" that explain=
s
> that that variable has been added during the work queue conversion an=
d
> that the preferred approach for new code is to define a new work queu=
e
> instead of using ib_wq ?

But why is defining more workqueues preferred?  Unless there's a
specific need, using what's already there (system or ib_wq) should be
preferable.

Thank you.

--=20
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
