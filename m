From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Fri, 27 May 2016 16:19:56 +0300
Message-ID: <20160527131956.GY25500@leon.nu>
References: <20160524210132.GB7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0501E2@ORSMSX109.amr.corp.intel.com>
 <20160524214951.GC7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05023F@ORSMSX109.amr.corp.intel.com>
 <20160524223052.GI7950@obsidianresearch.com>
 <CAAKD3BA3fxgHwSXg__9LAPo7E4-7NY7h7Gea5+1GCg11ydn2kQ@mail.gmail.com>
 <20160526172244.GC27115@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BB5D@ORSMSX109.amr.corp.intel.com>
 <20160526233612.GA4396@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BC0C@ORSMSX109.amr.corp.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4mUolEm2oNas7DxE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB05BC0C-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4mUolEm2oNas7DxE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 27, 2016 at 12:46:48AM +0000, Hefty, Sean wrote:
> > This is where I see the attraction of the attribute id labeled buffer.
>=20
> I like the idea of an attribute id labeled buffer myself.  But I think th=
e processing of the ioctl data is better handled by the kernel client, rath=
er than the framework.  The framework just needs to know enough to copy the=
 data efficiently into/out from the kernel, and I don't know what's the opt=
imal design here.

Sean,
What do you mean by "the kernel client"?

Maybe you are referring for something else, but I think about driver's
implementations of callbacks which will cause to code duplications.

>=20
> - Sean=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4mUolEm2oNas7DxE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXSEl8AAoJEORje4g2clinDQ4P/3/xr9rERr5bhFEpI89lqgnW
vc9Evkdb0+0Pv9R+vw44mgaFAc66aS7mjGr6114b3zJv1dTZa8mBzrxZeCYiinjH
Ce+n55zdY87G/cH/hgNyzcl8+KNf7LIzF+6ilkVmMzHq6g5909ulnQDztWJ4Bf11
jNCjdYtsLwGvTpopIfNB2RoZuILDKhIe+ZOcwzT62DG0VnSqbq9V5YfkYhWENvRX
N6ZpGUvWkFM/Tq4uO0PVgNiVRAQNO0vDUOEESfAaJHapkXdxD++cnSbKG0SHpZKh
iCgdgd5HUcU/X9POnV1xhL+sdNfU0A5YCBoLH0yqOdM5gf1t4U9OrqpX6y9Rm6a3
SYZ9VPrX4YfHftA1SI1Ywu5mSGZN4TLGAsPpb3zo+shf+hJeLE7Dd40zOnOkl475
ezv+PqAuzai/1GSh289HIvHwuvzah+MpTFCa4R+kIojVUxqkoG7lg9Lv1P8NXHGm
wRjE7na6AJN1UYuiP5GfvMM3sn7M0LteoPee+yUL3S2p+HyQm0bdtFtbRZ1O7nSh
fJ+cTEDkzzSYR7GKQAQQ2U3mzrPAFtWhak+d7riW+iKQfbz6SHcxEg6RXOqqS0UO
QoJO/IjNgV14mnWgxYzGoeZ14ctF2Lv8W2YjB3uXdIIGZTYLVbwLixELpCwuC7Ai
Os5nDKYH5TwTf7b7r1TJ
=vMz6
-----END PGP SIGNATURE-----

--4mUolEm2oNas7DxE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
