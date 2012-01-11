From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/6] IB/core: fix wrong display of rate in sysfs
Date: Wed, 11 Jan 2012 21:45:55 +0200
Message-ID: <CAJZOPZJHbuyfXbQdEQ3QZt3O+bLTdzpBJOfUmB-Rqrvi9WUXuQ@mail.gmail.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1201111856160.10264@ogerlitz.voltaire.com>
	<1828884A29C6694DAF28B7E6B8A82373256757DB@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373256757DB-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2012 at 9:30 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> This function ends up like this, with my comments inline:
> =A0 =A0 =A0 =A0rate =3D (25 * attr.active_speed) / 10;
> We set rate here, but [...] The above switch statement
>  changes the value for 3 of the 5 cases, with 1 case not covered.
> =A0 =A0 =A0 =A0rate *=3D ib_width_enum_to_int(attr.active_width);
> It is modified again here

Yep, this function is surely not programming state of the art..
however, except for SDR, the above line doing rate =3D rate *
ib_width_enum_to_int(attr.active_width) would hold for all the speeds
and all the widths (1X, 4X, 12X), if we just set rate (possibly as a
string value) one time in each switch case, we would need to repeat
that multiplication there... I'm okay with that, would you recommend
to go that way? Roland any preference?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
