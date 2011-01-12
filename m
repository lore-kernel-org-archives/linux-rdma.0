From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: srp warning
Date: Wed, 12 Jan 2011 12:52:28 -0500
Message-ID: <1294854748.15826.26.camel@lap75545.ornl.gov>
References: <adalj2q587i.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <adalj2q587i.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-01-12 at 12:43 -0500, Roland Dreier wrote:
> Just noticed this in my latest build:
>=20
>     drivers/infiniband/ulp/srp/ib_srp.c: In function =E2=80=98srp_que=
uecommand=E2=80=99:
>     drivers/infiniband/ulp/srp/ib_srp.c:1116: warning: =E2=80=98req=E2=
=80=99 may be used uninitialized in this function
[snip]

> and my gcc at least is not smart enough to see that we can't reach th=
e
> use of req without initializing req.

Hmm, my version was, so I never saw this. :(

Out of curiosity, what version are you using? I've been using 4.4.5 and
4.5.1.

> Simplest fix is to mark req with uninitialized_var() but maybe there'=
s a
> nicer way to handle this.

I'll take a look.
--=20
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
