From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Wed, 1 Jun 2016 14:18:49 +0300
Message-ID: <20160601111849.GG7477@leon.nu>
References: <20160526172244.GC27115@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BB5D@ORSMSX109.amr.corp.intel.com>
 <20160526233612.GA4396@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05BC0C@ORSMSX109.amr.corp.intel.com>
 <20160527131956.GY25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB05BD12@ORSMSX109.amr.corp.intel.com>
 <20160529081646.GA25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB05CA92@ORSMSX109.amr.corp.intel.com>
 <20160531181012.GD7477@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB05CBD5@ORSMSX109.amr.corp.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vSsTm1kUtxIHoa7M"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB05CBD5-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vSsTm1kUtxIHoa7M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 31, 2016 at 08:01:31PM +0000, Hefty, Sean wrote:
> > If I understand your proposal correctly, the proposed IOCTL framework w=
ill be
> > able to handle all types of objects without any limitations in order an=
d locking,
> > everything is going to be processed by the driver, which will decide if
> > such object/method is supported or not.
>=20
> For the core ioctl framework - yes.
>=20
> An ioctl can be dispatched to some other common handling, which can valid=
ate object ordering and type.

Agree and IMHO it is where we should be focused.

>=20
> > What will stop the GPU with DRMs to use it?
>=20
> It would have to hook into the same file.  But if it's generic enough, no=
thing would prevent other subsystems (e.g. Xeon Phi or NVM) from re-using t=
he code.  I don't see this as a negative.

It is not negative, just out of the scope of RDMA subsystem.

>=20
> - Sean

--vSsTm1kUtxIHoa7M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXTsSZAAoJEORje4g2clin+pwP/12tjlzttXgC0cWG/zLAQot7
QtwtEORPk000AkTkK6Wd9F4bOC/Jx3YAswG1J48hRrIocBLyhVZpPSw8Pk1J0oQw
Fl9Bd1qMo9UqSuREOarXdFBDw4D/AvrTpigIWsVF5XqSR4x03gTz/0CYRxLm/i/c
rxunZ5UwzNYyPiM/iBnU1URZ0NRdKaChPdBj9zxmPABkd2tiMa3EG/LYLENC6BeN
HoSOWiEwwrwHWEt5AiwHY4iKoiC7gYjGxUJ+ZwoP6owL/Xxf8PT6cIC5upzARSTf
Qg7L6e9YrWax18S4eDfr/Qk/fij1mZ4ZXEXabEeWfTROF+be/7rmEYlDdu0l8gYM
WKlsxrM9p6nWYokRv/0FttSCi5OfKlJDJHJyYuFV3DFZlxkg0SOuxsSbzDFSDSdD
GG7dsS4HGjgfcJdVHJIanxONU+S2FrQmh5iFBFBuRBlWEz54N47Sqm1TzaRDgubW
GuiYxH0s/vJ+1yV0nsMrB4w+wVJXkkqN/N2rCvqHpUdynEd7aHn4vuhMrWe3zayD
F9/zqrWgSjMtwxK50u2wcHJpTOkV4Bq+yuhZ0RgUeikFjzc4aA25tXYzUIri4G8B
ssOCiyKWBOX53i7H3SXMeVYPfFnO9q/27lTUJ07dtdfTCbhrDLjY4KZ7WMTXp+Hb
1bw7rA1BT6JOhPD//cA5
=sYY2
-----END PGP SIGNATURE-----

--vSsTm1kUtxIHoa7M--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
