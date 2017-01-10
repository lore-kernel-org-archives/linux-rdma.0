From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Missing Patches in Linux Kernel RDMA
Date: Tue, 10 Jan 2017 11:51:35 -0500
Message-ID: <1484067095.2149.12.camel@redhat.com>
References: <20170110143018.GM7218@mtr-leonro.local>
         <20170110143658.GA26753@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-nEaw+o2091TSJSoByIpW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110143658.GA26753-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-nEaw+o2091TSJSoByIpW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-10 at 15:36 +0100, Christoph Hellwig wrote:
> On Tue, Jan 10, 2017 at 04:30:18PM +0200, Leon Romanovsky wrote:
> >=20
> > The first patch which brought my attention was Christoph's change
> > "IB: merge struct ib_device_attr into struct ib_device" [1].
>=20
> Doug decided to not kill off ib_device_attr entirely and just
> embedded
> it into the ib_device structure.

Correct, I believe it was Or's patch that did that.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-nEaw+o2091TSJSoByIpW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYdREXAAoJELgmozMOVy/dvJ4P+wTCDoo08KRq09AVToyZp8B8
EUW51bWJIVmBPHTpqFOhY4n3izPt3J6wyNT6n3uOUxyuPEEobPvpFqZ4RZWJkCEA
i0N8MN3JzUVGFLlmSJWMJjzU2Q9/7YYQHuBpCqgA4rb/oqIMEGZkIB+SbpV3yfvQ
PirebsZggtZugajmlPoe0XLjdEzTpr6+yw6r9DkZc5Fm1jH/zVshKSE6SP/UMhtx
0SuDy358aM5vXJRHoSF7ItT4rmOKj4K9TiC1ZHSB3UxyoLZiVImMB4Hx+CwBPHDP
sZBZkmeQ62tMonExuVX3JHvGQCDfdrVJFm4ss3v4ve+maMuuCQ09QWgjrXI3+aTB
YFnt9CrE/GzQsv9kj+22TQN5BCLaTht20Ikj3a5juuHYeTGZ+tKkLXHNW/Uy5hVd
DqbZnCh2E1x5Frh/oe6PBjzS0VF/sS/iqZTRWkKzAjVkwWvJZdT5K12vn+GcKD5l
Bvg8Yac+b7rimW5Jyj7Uk2vCtfCYpwCsdzAduuSrZOZoAES0Wzs8zLdPms6ZEXCF
NdozHo1lBaGPoSKn4cfMjguzG/un4sQN2MschPG/3yeb9JjVupR+2vjoLfJd/AVb
pgs8+cQHeBY+hz57Au7ZLz7sAY1WJiEUcdMrxN/89NWHqSjwfdVVsKDIA2IBX4YT
A+fXjyhumSb5ezplSezt
=xbE3
-----END PGP SIGNATURE-----

--=-nEaw+o2091TSJSoByIpW--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
