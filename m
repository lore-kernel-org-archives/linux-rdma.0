From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 04 May 2015 15:40:25 -0400
Message-ID: <1430768425.2407.143.camel@redhat.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
	 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
	 <1430750492.2407.9.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
	 <1430761111.2407.85.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-XOahaGFLLItQWJodWw3B"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-XOahaGFLLItQWJodWw3B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-04 at 18:26 +0000, Hefty, Sean wrote:

> > Given that this is a per port thing, there is no assumption about a
> > device only supporting a single protocol.
>=20
> Device, no, but we are assuming this per port.

At a high level, there are certain things that will be per port because
they are tied to the link layer in question (you won't have a port with
IB_SA that doesn't have IB_SA on all its queue pairs on that port).

>   I don't think this is
> true for USNIC.

I can't speak for USNIC, I haven't read the driver for it closely
enough.

>   For that matter, it's entirely possible for a RoCEv2
> device to expose UDP directly to user space, same as USNIC.

I'm not sure I'm following what you are saying here.  USNIC is unique in
that it presents a NIC to the application that it has exclusive control
over.

>   (I'd
> actually be surprised if no devices have this capability, if for
> debugging capabilities, even if for nothing else.)  What are we going
> to do if there's a device that supports both iWarp and RoCEv2?  That's
> easily doable today through software.

It's doable, but nobody is actually doing it.

> Basically, I question how protocol is defined and what it means to
> expose it as a device attribute.  Should it instead be negotiated (i.e.
> more like sockets)?  If an app needs a specific "RDMA protocol" (IB or
> iWarp) or "application protocol" (IB or iWarp or UDP or MADs?), they
> can request it.  Otherwise, the app gets assigned some protocol.  And
> the protocol should really be associated with a QP, rather than a
> port.

If you're going down to that level (which we will when the RoCEv2
patches are integrated), then it doesn't quite map to QPs.  Since a UD
QP may need to talk to both RoCEv1 and RoCEv2 hosts, it's at the AH
level for RoCE.

To a certain extent you are right.  RoCE, RoCEv2, iWARP, and USNIC could
all reside on a single port by virtue of them all sharing an Ethernet
link layer.  IB link layer (and associated attributes) and OPA link
layer are the outliers in this method of thinking in that their ports
will only support their own transport.  So if we were to actually be
forward thinking about this, then the link layer is the important bit
you need to capture on a per port basis, not the transport technology.
We would have to modify lots of the stack to support per QP or per AH
transport settings though.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-XOahaGFLLItQWJodWw3B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVR8spAAoJELgmozMOVy/d9QMQALmytg26d+zJD0KmSc4iNA7Z
THCcroJ3X9olroEac7OaTkZbw1zD0Cqfaqd2Z1y0JkDGnbfeV6t3NO6fOuwF2+3e
Z3z4+xjpOwOjnypFD4bKcPFee0QtWJWw6trNLaK1dYTH3sBO7not05OVYJ2iuiLk
xAs2Da4A3pug0FxxL9w2fjERS3XPnNmEuztSWPRUOL3FkuImeK/j/NlAkexzM6us
ZZiOJ+Ubb3aG1VMPSpk/NypIEaBhRhGHOlZjtyHEXmRODYSXcIeE4QtJFLP77Bqv
UtM9YUkse8xqiLdbD41GCGhft1p1QAY98sxqB8uUH+l301IAeSDuF76wfnIZDesh
yT2pqGt7P05LmdEYZF/RxWsHShsJ/m26tEmqpaJzYJIMWkIqCD4zBVWKtT057e5k
MBLdO1tLmiAMjKChO4pzPVv2SrRFQopANg2LMP+UqJBiDhDBVzk4n5XTGL63G9gp
IZBjxYhz0AWM7gQVAnaYOtRFOeAy213K/eOZdtcDhP4an+azjNrQXqLr7VJu+EFh
kRAY80JlXKXeraU0UIswWFdlt8IRHPPEFhLVEsTenJ7fHEWK18y70tbKJk+f+Kav
2n4QWWXo2cBg3PPiZbG+bUd0NBw9GEPP0n4rVIxWytq1WUyfsplPGq8dIduGwyzh
XG/oSxDP40YGsaIcWsnV
=2aD6
-----END PGP SIGNATURE-----

--=-XOahaGFLLItQWJodWw3B--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
