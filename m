From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/3] Mellanox ConnectX-3 Diagnostic Counters
Date: Tue, 02 Aug 2016 15:37:02 -0400
Message-ID: <1470166622.18081.38.camel@redhat.com>
References: <1468950898-9674-1-git-send-email-leon@kernel.org>
	 <20160720102217.GT20674@leon.nu> <20160726101521.GA4628@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-s4ZDpPj11T/Dc1q+/QKA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160726101521.GA4628-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-s4ZDpPj11T/Dc1q+/QKA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-07-26 at 13:15 +0300, Leon Romanovsky wrote:
> On Wed, Jul 20, 2016 at 01:22:17PM +0300, Leon Romanovsky wrote:
> >=20
> > On Tue, Jul 19, 2016 at 08:54:55PM +0300, Leon Romanovsky wrote:
> > >=20
> > > Hi Doug,
> > >=20
> > > This patch series adds diagnostic hardware counters for Mellanox
> > > ConnectX-3 which uses the dynamic IB counters infrastructure.
> > >=20
> > > This series includes three patches, the first two add the
> > > necessary
> > > functions to read the counters from the firmware and check for
> > > firmware capability. The third patch exposes the functions needed
> > > for the counter infrastructure.
> > >=20
> > > The counters exposed are applicable for IB and RoCE.
> >=20
> > Hi Doug,
> > Please drop this patch series because we want to update patch #1 to
> > eliminate future conflict in include/linux/mlx4/device.h file
> > between
> > net and RDMA subsystems.
>=20
> Hi Doug,
> I'm hope that you didn't follow my request to drop this patch series.
> Luckily enough, we avoided such conflict by dropping NET patches,
> and we will be glad if you proceed with this patch series.
>=20
> I tested it by applying on Linus's v4.7 code base and it applied
> cleanly.
>=20
> Sorry for the noise and for the inconvenience.
>=C2=A0

No problem, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-s4ZDpPj11T/Dc1q+/QKA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoPZeAAoJELgmozMOVy/dDEUP/jGwZfd/NFxsBMTXdFM+zfYO
kIFodRiicS+qLvYUT+JFj15SwZ7fTkf5soqs8Enem/YeAMZmNbgVCJrM4IVHUZ9e
tm797Xls0Yp7+I+iCJ7TCbdqgl+NyMa6c0C832CT7URqLYZ6v/rliNUg3Y3aukRQ
IGUSMwgx6jHhE9FiW/y2agt6Yy0ubROwLhfRANoJaj8RU0WV4UFk/ORUyQ+O4Jzl
MFrv6tXbxTdZMkHXiHrM1IZfqbGYxDmKBlAaXyhwhZtG9ZCRColmJHYVQgix3y06
sjCOw37OCXaH1PWbBY31Svvrz6+gKc3+PSSxxxetYPpewHA3O5UCuXtYQyjMcnEh
+fENNiaGk+4E/Zk7quNyqLTfNEuBdYWLyfMNQSJ3lfHPbQwPa3JJtfJaFgGeWOF2
ZT8IC19zYDsBVt+ciEGm/7CXTnwIX5NTte2cqwxsXkJevK8fnXsOyI4vEX+IIv9D
5QAFaOxL24b9Kel23HqGPvl0aqOV0Jo5FRaDCUkeaRmR0oROQlvffEGpdsSdi+Ic
ZwoFTI2S0Su8wg+pANFUKLn9O2RhBzPmjfLfVqB1Hnm3SnEvBON0ioLMgP7OCalz
0oGpeNOAkyCjWw8fkL3KMBEwZBeB1zljYsVh9ncTI3eCUUhQPM4HPYqdhfqT2wXn
1xBMyW2OQNKASfUuMO2Z
=wJNQ
-----END PGP SIGNATURE-----

--=-s4ZDpPj11T/Dc1q+/QKA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
