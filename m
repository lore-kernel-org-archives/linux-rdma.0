From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [GIT] lock scaling and bug fixes for 2.6.38
Date: Tue, 11 Jan 2011 18:29:52 +0100
Message-ID: <AANLkTikEnR6pjLy-L08UUbVdwS5f3k0+EutA-SrDVHMT@mail.gmail.com>
References: <1294699530.3038.27.camel@obelisk.thedillows.org> <adak4ic6wmo.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adak4ic6wmo.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 11, 2011 at 2:45 AM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> =A0> =A0 =A0git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-ini=
tiator.git srp-lock-scaling
>
> Thanks, pulled.
>
> Will try to merge Tejun's work queue patch shortly.

Maybe it's=A0a good idea to add a comment above the declaration of the
global variable "extern struct workqueue_struct *ib_wq;" that explains
that that variable has been added during the work queue conversion and
that the preferred approach for new code is to define a new work queue
instead of using ib_wq ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
