From: Yann Droneaud <yann-WYdEh2jsUj5Wj0EZb7rXcA@public.gmane.org>
Subject: Re: [PATCH] Add const qualifier in rdma_reg*,
 rdma_post_send*|write and ibv_reg_mr (was: Re: non-const pointer void *
 addr in rdma_reg_* and rdma_post_[send|write])
Date: Fri, 29 Nov 2013 11:32:19 +0100
Message-ID: <1385721139.21498.19.camel@localhost.localdomain>
References: <9A0BFE48-9AED-4C41-80C8-F943D1C64E99@gmx.net>
	 <1385630590.21498.14.camel@localhost.localdomain>
	 <92ED2320-AE25-4A1B-8FDF-D31121D2B125@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <92ED2320-AE25-4A1B-8FDF-D31121D2B125-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 28 novembre 2013 =C3=A0 20:47 +0100, Hannes Weisbach a =C3=A9c=
rit :

> > But adding "const" should not break compilation of existing userspa=
ce program.

> That was my thought too.  However, because those functions are define=
d
> in as inline in a header, they actually do break user code.  For
> example, rdma_reg_msgs passes a const void * to ibv_reg_mr, which
> takes a void *, thus resulting in a warning.  If you (like me) compil=
e
> with the -Werror flag, this results in broken code.  The only
> offending libibverbs function I found so far is ibv_reg_mr().

> >=20
> > PS: this issue could also be raised against libibverbs, so once you=
've
> > fixed librdmacm, why not fix libibverbs after ?
> This was my plan.  But first I wanted to see if there even is interes=
t
> in fixing this.  As a user I deal with librdmacm directly, so I
> started to fix it first.
>=20
> Anyway, since patching librdmacm alone would break user code, I also
> included a patch for libibverbs, which adds the const qualifier to
> 'addr' parameter ib ibv_reg_mr().
>=20

To avoid adding cast to non-const in librdmacm that no one will remove
once added, you're correct in patching libibverbs first.

> lists.openfabrics.org says, this is also the mailing list for
> libibverbs (README is outdated ;)), I hope this is ok.
>=20

It's OK. Roland Dreier, libibverbs maintainer, is here (but sadly not a=
s
often as we would like).

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
