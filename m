From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: rdma-core debian/master branch
Date: Thu, 16 Nov 2017 09:58:23 +0100
Message-ID: <1510822703.4026.79.camel@profitbricks.com>
References: <1510658470.4026.27.camel@profitbricks.com>
         <20171114184725.GH18825@mtr-leonro.local>
         <1510686066.4026.43.camel@profitbricks.com>
         <20171116064730.GG18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Aq+QBkEVk3vIOKHqIvQS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116064730.GG18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Aq+QBkEVk3vIOKHqIvQS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 16.11.2017, 08:47 +0200 schrieb Leon Romanovsky:
> On Tue, Nov 14, 2017 at 08:01:06PM +0100, Benjamin Drung wrote:
> > Am Dienstag, den 14.11.2017, 20:47 +0200 schrieb Leon Romanovsky:
> > > On Tue, Nov 14, 2017 at 12:21:10PM +0100, Benjamin Drung wrote:
> > > > Hi,
> > > >=20
> > > > I have a debian/master branch in my personal rdma-core fork:
> > > > https://github.com/bdrung/rdma-core/commits/debian/master
> > > > In addition, I tagged the upload with debian/15-1.
> > > >=20
> > > > This branch contains the exact content of the uploaded package
> > > > to
> > > > Debian. It would be nice if this branch could be included in
> > > > the
> > > > linux-
> > > > rdma/rdma-core repository.
> > >=20
> > > Is it possible to align it with stable-v15 branch?
> >=20
> > Not really. This branch is more or less aligned with the master
> > branch
> > (as long as Debian does not hit the feature freeze), i.e. I will
> > upload
> > rdma-core 16 to Debian unstable once it is released (instead of
> > 15.1).
>=20
> Last question, will this branch be rolling or you will need to create
> new branch for "next" unstable?

This will be a rolling branch which reflects the content of Debian
unstable. There might come some additional branches like debian/stretch
for the stable releases.

Explanation for the naming:
http://dep.debian.net/deps/dep14/

--=20
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg
--=-Aq+QBkEVk3vIOKHqIvQS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJaDVMvAAoJEN2M1aXejH56C44P/A4my9ifOdDNJcXiNvBErD53
ON+1wJMGcGM2PTsF1cS72SaVgc6CNI0Hnh0GKx/62Mowoix1YAQ8wjROdkzbBKMx
Nx8aHiXoUNMeKMYqFRAoPRbqylEvpgo4A9A2tGOhXxyh+7hyTNWQX4glHHe4xIJ8
F+RIp6uLdwvN/VBLJYqjuacDpNDiLdbZKEclTRzxrEOiV+he7J217h9rFaNXSumn
3bLG2kcswLHnNm3yibSmyMGuyjVBbVikqvuRKYexenkbucYUFNd/Icgy0xwUCbH0
3QAMdTPUUjoX2ReG2x53trgOfVYHFz2Xuo5E7J8l2r91dRPUGRvBr0n7pqWWaGh3
tHsk+5WhIj5pxsaG/+W2fELPX3Ez/jiOZKGKVybCgQCKY9UPsAxJjQFhszlIgQgA
TzGPjB+DexPDbZmDimh+Gq8pcy6VpEMj/xVG/gUWPrA5xELGm5h3j9A5XE41ZVYd
EhIN7TqO0DWp1UMf8jtczCYLdlaWnWmTJJyBe88XL0xVVsKjPt9dBTwj/BjenRLR
MQMv1ZNwyr4bDKMjwSt6McUMHJOQ4bvoZbEznPP7lnN/VL/6aBYSd/u5sLuymJKO
9dRanrzDhFr5p5YtXgRXv1uqzZMud/IihnjEgcpSOW/Xn4hHEJamj1XI5rlbEkwy
2GEcOHAyzQFKhd641eIb
=yIkX
-----END PGP SIGNATURE-----

--=-Aq+QBkEVk3vIOKHqIvQS--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
