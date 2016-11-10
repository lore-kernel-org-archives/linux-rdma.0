From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/4] Add packet pacing support for IB verbs
Date: Thu, 10 Nov 2016 09:22:42 +0200
Message-ID: <20161110072242.GC28957@leon.nu>
References: <1477909297-14491-1-git-send-email-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0A7B31@ORSMSX109.amr.corp.intel.com>
 <20161109064009.GE27883@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB0A7F0A@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0A7F0A-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 09, 2016 at 05:06:52PM +0000, Hefty, Sean wrote:
> > On Tue, Nov 08, 2016 at 05:49:26PM +0000, Hefty, Sean wrote:
> > > > When sending from a 10G host to a 1G host, it is easy to overrun
> > the
> > > > receiver,
> > > > leading to packet loss and traffic backing off. Similar problems
> > occur
> > > > when
> > > > a 10G host sends data to a sub-10G virtual circuit, or a 40G host
> > > > sending
> > > > to a 10G host. Packet pacing could control packet injection rate
> > and
> > > > reduces
> > > > network congestion to maximize throughput & minimize network
> > latency.
> > >
> > > Why isn't the path record data and existing mechanisms sufficient to
> > handle this?
> > >
> >
> > Packet pacing allows different combinations of traffic shaping: per-
> > CPU,
> > per-flow and their combinations with better and steady QoS requirements
> > without involving subnet management.
>
> The patch adds this as a QP attribute, and we already have a rate for that.  I still don't see why the standard mechanisms are insufficient or couldn't be adapted.

I'll let to Bodong to elaborate on it more, but as far as I see, the AH
attribute is relevant to UD QP only, while the packet pacing is intended
for all types of QPs.

Thanks

--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYJCBCAAoJEORje4g2clin/IUP/RpcCL9SClpBTYSmR+Zm3FQ5
trPJMlZyoPVpEfGDCegKkUaIwMTZbEgg6DRSIU+OuVlfWX3doQJKcVUEhW7FwREn
H04/0XczjWx98RKo50UL3Hu701dhoXWKJZm9Lrjvh3k2Mw2Z82g05P/Ob8UdHhx0
qjCf6roD+ez1phNYA+hQwPlB+W7+LGs2qfxsUJKvFPqWJEnlGv7SXVWCPSQhO5WP
G1w5plljbJZzwJjfwxMj751Wyh0zEq+Kb9/8OOhJ8RnPthYeZwSw/nrVaZWWOjEn
K44RyUucsYSGT2QVFE6ffjthGV5NdYCC1AwrbF+4zAXekMntprx4xUFKuCq1oFgZ
zRYWimXdlM0IQEhdqja9ApLv/+VE3Jc4AklYsI3GNWzFwCPqAziPHHyWQbuGWrnJ
dGR4/rmcZXhLaqwyJWkhm8YCVPjneP9HJRcNQSV3V1YBSyBJT6uS6KAyfD8W9yuI
7N/YWAuPIaJV+OnKwNjKm47/S/HE9oxe3SAwSyU3sqr1ArVZHLPz59XSwqtLloST
l1sSWqSg1BtnbldScqTqURHKw/PI4Q5KSg+nUPyX/JZkp1KVTlIhgs/QtVsG9Uxn
l/KOJ66Na9Gj8tSxvdSgvoKyFdDL/V85HNf3pqxjuVKViRUnae9E2PczLgfHNcQt
d67lngBCAORyJoAEbxtO
=J+z9
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
