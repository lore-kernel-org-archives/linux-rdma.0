From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 08:19:56 +0300
Message-ID: <20160629051956.GG3584@leon.nu>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com>
 <20160628050246.GB3584@leon.nu>
 <20160628162028.GA27518@obsidianresearch.com>
 <20160628170549.GE3584@leon.nu>
 <022001d1d170$fda2c3e0$f8e84ba0$@opengridcomputing.com>
 <20160628211441.GA5786@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0663DA@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tvOENZuN7d6HfOWU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0663DA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--tvOENZuN7d6HfOWU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2016 at 09:26:38PM +0000, Hefty, Sean wrote:
> > The fundamental question is if it is acceptable for libibverbs to ship
> > a new core provider agnostic API (cq polling) that is optional
> > depending on provider.
> >=20
> > I say no, that is not acceptable.
>=20
> I agree - there's no compelling argument that the new calls can't work ov=
er all providers.

I agree too, this is why code is provided and nothing stops from other prov=
ider to support it.

--tvOENZuN7d6HfOWU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXc1p8AAoJEORje4g2clinr5AP/inslCk+RSY9vAOco0SJjaDb
HsGMQkxurXSst2M6dKvVQKZ/cqwkp2K4orhY5vHaPMJLbHGODIl7gLA23XSKQXyd
//6siLhrGeSyHnUJttNwxtyx/+Y7yDasrea2PD+hljIUAj8POp5fKkN4IRVEJUw7
aB6L6Xzk0CdX0aeEZDyAOJzAEpNFzSrWw7fRgRQRDe1jngQ4pVECW5ASz+nDwASv
PVFpNQyvzwf8L/c6zX0KiWd93kqAtg/zkxUG9DkUtr6U/TQ1ebz8tArtZ1JMTqGw
aNkyA8vZrfT/xBVp7xxhM2bEa/ag2I4/b3qpquxPclgbIIsEkyNNBRBiBlg+F1qu
T8HMdWVIf/URYjsLwJfqq1QiIiTVnIwfm2HxGcKNpP2IDmst6972OTliRrMQb5Qo
Nukv2+7mWZIPUMRAYJtAmUs3xA/x9KGquSUe5hQW/4mYnBsgXJJSdkF4Onzui64J
CrBiUN2RfcRg7/oxwivXCh2L5ziyVZe5ebOwWUZPBtlWdKotLvjr3bOVP/7S1SxT
UIaVoBiUouRArADgjIUXOLVVyCK0CFNMrhmCe3rjfURuR1eW7fdwpDchMSCZgm5w
ZwfP8JJOvWwvV7+kf7uX3w7kDK3SzcvSC2dVLy1rCBtzByg7BWJYC02J5CKlmQI5
OrdYWOj9e9PFsfHP9KTt
=Y1xy
-----END PGP SIGNATURE-----

--tvOENZuN7d6HfOWU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
