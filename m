From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 04/17] IB/core: Add umem function to read data from
 user-space
Date: Thu, 11 Dec 2014 15:48:10 +0100
Message-ID: <1418309290.11111.108.camel@opteya.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
	 <1415723783-2138-5-git-send-email-haggaie@mellanox.com>
	 <1418228521.11111.50.camel@opteya.com> <54897B84.9000708@mellanox.com>
	 <1418301590.11111.95.camel@opteya.com>
	 <CAJ3xEMh-=wLD_FLxNaiDYofA4mOf+woep2PPmKDbY2-k9XBS+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMh-=wLD_FLxNaiDYofA4mOf+woep2PPmKDbY2-k9XBS+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or,

Le jeudi 11 d=C3=A9cembre 2014 =C3=A0 15:09 +0200, Or Gerlitz a =C3=A9c=
rit :
> On Thu, Dec 11, 2014 at 2:39 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>=
 wrote:

> > BTW, ib_copy_from_udata() is defined as an inline function. Would i=
t be
> > better to have ib_umem_copy_from() being an inline function too ?
> > (In such case, I would remove the error message to not duplicate it
> >  across all modules using the function)
>=20
> Yann, Lets leave your 2nd comment to be addressed as future
> cleanup/improvement. Really, these patches
> are on the list for 7-8 moths and we were asking for feedback over al=
l
> this time, jumping now with inlining comments and such when the merge
> window is just across the door isn't appropriate.

Sure, I've no right and no power to delay or NACK anything: I'm just=20
lazily following the list, and my involvement in InfiniBand/RDMA
community is slowly dropping to 0, being involved in other (paid)=20
projects, with some spike from time to time, waiting to find time to=20
drain my patch queue. Unfortunately I'm not on the same schedule.

Anyway, everyone is free to provide comments at anytime.
And you're free to take them in account.

It's a fact of kernel development: sometime a patchset take many months
and multiple revision before being applied.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
