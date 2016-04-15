From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Sat, 16 Apr 2016 00:14:31 +0300
Message-ID: <20160415211431.GE10689@leon.nu>
References: <20160414180540.GA12554@obsidianresearch.com>
 <20160414184200.GA10416@phlsvsds.ph.intel.com>
 <20160414185659.GB12997@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB041C34@ORSMSX109.amr.corp.intel.com>
 <20160414212702.GA14137@obsidianresearch.com>
 <20160415000242.GA18400@rhel.sc.intel.com>
 <20160415044124.GA16805@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0422AE@ORSMSX109.amr.corp.intel.com>
 <20160415181811.GA22322@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB042530@ORSMSX109.amr.corp.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="84ND8YJRMFlzkrP4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB042530-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--84ND8YJRMFlzkrP4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2016 at 09:04:26PM +0000, Hefty, Sean wrote:
> The RDMA stack currently allows drivers to export their own interfaces di=
rectly to user space.  At this point, I see no reason why we should block a=
 driver for following what has been an acceptable practice for years.  Denn=
is fixed the write/writev issue, which would make the hfi1 driver the only =
device in the RDMA tree with an acceptable interface.
>=20
> If the RDMA "community" defines the ultimate ioctl interface ever created=
, great.  Every driver added after that interface has been defined and merg=
ed can be forced to use it.

Why do you think that ioctl interface is the only one which is
"acceptable"? Did you consider netdev? What about netdev macros +
ioctls?

>=20
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--84ND8YJRMFlzkrP4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXEVm3AAoJEORje4g2cliniEoQAJ+Xb+qZcjSk1+3BrO8Vd3op
ZGi69RtStyBao0fMDGU6HFht7PhmHa007a/VO62kiS5u3KvxigB9/0d0VR1k6dMC
qG5nGgVa/4bI1OctE+z+Oc861lTiPJ20N3BokZ9osZZTxMc/kz9hFUW55wXlbsMb
9cHuokvu0qwxBlDGx31aAVI8ZToLSSe1Sq1EEIEta9hnslO3p81vSj2cIl5+ji18
/iqLDv3oDz72/rMYYpAvxj6TIeillzV9ffSmyJ7XOy/Ak+pz59zGiYQlr+rM7FQr
gBc6ZwuXTtm8bC/b4o62AIy43x6h7pG4zYd0+xG0WZNcMlQzWrlK+6iZlkBd8FCV
cjlW0XGAwrKum/BsIyrXlGvFrRoX2yMNQdSnO/RqF77oP8b43G14GM/+6kvRjtEA
IhvJl0rZ163gdjaIVaWBtc/7X+IKeh6BW+6KBpgBOxetTfi5HAF8bHhwjgOoI2Zk
u2cxsh4vYVhD0yAlKfirJHiHNrL5Ah5rQkuQq6+VLutsCbjra0d5w9dSBMX4f/EV
tc71jWtbm0Y0YtSrFYl/bwBDCBdmFGUl2bLKax7R5BvrbZpV76wjTDUDsnGIU9N4
GmYYK2qZcOoSnqol89kKkumpk9/7nyKBoAjF+wmZnTo2p+cOqi20/yMZYZviEwih
8ua36IB6KGYIxnRwdRVe
=3avB
-----END PGP SIGNATURE-----

--84ND8YJRMFlzkrP4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
