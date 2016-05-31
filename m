From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Tue, 31 May 2016 21:10:12 +0300
Message-ID: <20160531181012.GD7477@leon.nu>
References: <20160524223052.GI7950@obsidianresearch.com>
 <CAAKD3BA3fxgHwSXg__9LAPo7E4-7NY7h7Gea5+1GCg11ydn2kQ@mail.gmail.com>
 <20160526172244.GC27115@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BB5D@ORSMSX109.amr.corp.intel.com>
 <20160526233612.GA4396@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BC0C@ORSMSX109.amr.corp.intel.com>
 <20160527131956.GY25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB05BD12@ORSMSX109.amr.corp.intel.com>
 <20160529081646.GA25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB05CA92@ORSMSX109.amr.corp.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB05CA92-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 31, 2016 at 05:56:29PM +0000, Hefty, Sean wrote:
> > > I am referring to the creation of an ioctl handling framework that is=
 suitable for use by the rdma
> > cm, ib cm (if kept), verb devices, and non-verbs drivers that do not pl=
ug into the kernel verbs
> > framework.  The kernel clients are the items I mentioned.  Having a com=
mon ioctl handling framework
> > will maximize code reuse.
> >=20
> > It looks too generic for RDMA subsystem. What does it make this IOCTL f=
ramework specific to RDMA?
>=20
> I'm not sure how something can be too generic.  Everything I mentioned ab=
ove exists as part of the RDMA subsystem.

If I understand your proposal correctly, the proposed IOCTL framework will =
be
able to handle all types of objects without any limitations in order and lo=
cking,
everything is going to be processed by the driver, which will decide if
such object/method is supported or not.

What will stop the GPU with DRMs to use it?

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJXTdODAAoJEORje4g2clinqaMP+J/rWskV3Y/m4//aeP+B5PFX
VHgneNzR0cb6qywcbskCvaJ3sjM5S6EAG0gjjaQKxPz/TO3r35MIeHSfGpvCXyld
SSHNc//JzIF7YlCfINrP8AGoQvj78HrBBvsYmMYcs5bKL1z9/cmW3+xXJJUYc0Jh
kNx4/JF0MW17PPKtxSFTmHmns4sHwWLoiwWgztKsuLqXeEmeIax3vKPB/I78INHJ
BqgGH4JVuuTfk2aqD5RmH619HfgTI4HkkeObV8P63UmV2KfJt77a7OqNCEpsCXXQ
zJmLELISamnsw5ekH/yK5/ECpnPN8J3U0hx7puYER4YC+tyW+z/kGHxpQOiw9sFs
Citv8NRhrjA6lNyQgpM4Q2luBanUzz1a4rVVowccOC9NKzb6HDxRaFyYrC49zwJq
3NdnQ3o0HH9RZl4OpVgqKbOiWw3Id0yUJyZfatXbugeETIWQf8VoEy1CPN+RwiuD
6QiO55M7OYASl0wQeGTC/xou89sikgSy2LTBt6g9+aWq7pDAeZotKb9k8nVv9CA/
lIOn55q2lpHMfEFUg69kZL0+rVZp+xl6D/IZSf43QTMj1Pg7KwlgbY8TNFrV9Nqz
Mu/gscpIYphgFDIUDjAhRHxNjmR7hCgexRQAwm/t1MEvoTrGexb7H9LqFjECj+jc
XY16oti0xf0tbfbX7E8=
=k40M
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
