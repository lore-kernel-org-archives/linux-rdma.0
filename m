From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1] IB/ipoib: Report SG feature regardless of HW UD CSUM
 capability
Date: Tue, 19 Jul 2016 08:42:04 +0300
Message-ID: <20160719054204.GG20674@leon.nu>
References: <1468827648-17275-1-git-send-email-yuval.shaia@oracle.com>
 <20160718171921.GA3193@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="reI/iBAAp9kzkmX4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160718171921.GA3193-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--reI/iBAAp9kzkmX4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 18, 2016 at 11:19:21AM -0600, Jason Gunthorpe wrote:
> On Mon, Jul 18, 2016 at 12:40:48AM -0700, Yuval Shaia wrote:
> > Decouple SG support from HW ability to do UD checksum.
> > This coupling is for historical reasons and removed with 'commit
> > ec5f06156423 ("net: Kill link between CSUM and SG features.")'
>=20
> Shouldn't this also check that the QP's sg limit is something
> appropriate? At least > 1 ..
>=20
> Presumably things still work if the skb needs more sg's than are
> available?

IMHO, this question is relevant for the code before change as well.

>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--reI/iBAAp9kzkmX4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXjb2sAAoJEORje4g2clinZWcP/jV3XMu7eRFp9lTy8X8NRvb2
dLCj6HIl4YZsvNHHA/oAP68dVxkYf1VICOK7VO238KdXRO5K5kWUJTg3BCHUZcKa
0ZvtzjrFdpVK69O2jIwyeM8oN/YOvA0rVMsUS2UtefE/CQjXFp4UaArzvjqn2MEQ
Kdya/nBd1ze6IgeGkDbQZ2YPqFAuj7sonuDPlcZuvQlayWWhPMKAA21FCkj7GIoU
oSoPewD36+3KklSIQYg1kMee4g6f4LdDoXfQzJHoovZ6IRav99nUdJ9jPgcPvBDV
dEGXkBamutfQ79IFX3aRGg0JE7SwaN3EP70fwVZka+y0iWepd+te4/3OdhPIth6Z
/c22W36tKwnBPyxSGfv+PIjxjYGHdYfI2zjLwbPWFFSsxlSvzU2D6tagVPR9hNdB
kEb2Z6cR/bBR1hbJjJ/m9uAkSX+1ZF5Rx7B0Rzx7h6+Q7l3y+98cpcImnqthNtHx
U1Qnvp7R1GLUz7xVWPJM7EY0loTaV7HTPmjoEBtMr4G8SPMRgYa4mG4SOxLcc2WP
sFJodLj8lgFXDlpR7RIb374+12Ni/xsO59IRmYoptKQwZkjPcz4eeV3X0+7JG99Q
Job5100OIke9UeikxaU7v9aKJZ4ejOydqttYkBW7gpyCqhHArhkVDVRuSgbsdxJQ
mXX1fqxsfqRd/5P/JTSc
=yMIn
-----END PGP SIGNATURE-----

--reI/iBAAp9kzkmX4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
