From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: rdma-core debian/master branch
Date: Tue, 14 Nov 2017 20:01:06 +0100
Message-ID: <1510686066.4026.43.camel@profitbricks.com>
References: <1510658470.4026.27.camel@profitbricks.com>
         <20171114184725.GH18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-d6K6x0JuGRNP2IVkc1oD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114184725.GH18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-d6K6x0JuGRNP2IVkc1oD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 14.11.2017, 20:47 +0200 schrieb Leon Romanovsky:
> On Tue, Nov 14, 2017 at 12:21:10PM +0100, Benjamin Drung wrote:
> > Hi,
> >=20
> > I have a debian/master branch in my personal rdma-core fork:
> > https://github.com/bdrung/rdma-core/commits/debian/master
> > In addition, I tagged the upload with debian/15-1.
> >=20
> > This branch contains the exact content of the uploaded package to
> > Debian. It would be nice if this branch could be included in the
> > linux-
> > rdma/rdma-core repository.
>=20
> Is it possible to align it with stable-v15 branch?

Not really. This branch is more or less aligned with the master branch
(as long as Debian does not hit the feature freeze), i.e. I will upload
rdma-core 16 to Debian unstable once it is released (instead of 15.1).

And I will do an 15-2 upload to address the build failures. So there is
some divergence (at least in debian/changelog).

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
--=-d6K6x0JuGRNP2IVkc1oD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJaCz1yAAoJEN2M1aXejH56ig8QAKh8EJxK8VgsCItIAORm1hgZ
sTWQyh45hq/RcZPVv0qbGcOvWEl50Jx3eFg5TRiiJlEGndqZFIBlV5pja1/ofAYz
X5Cu7l816UoRvBu5zG9Z2H3m1Wn9lfueyzRZmj0mYWYC+ef5OXJANXj0P0QXTlB9
T+AwGqX/R5UKr0sW8V54F0BI0oK23gZYL+Y1ASKMi0zjFUpMTdNGafPfAzgqSKTN
EyReyktNhjaAOSnt5Is2M59WhvqbPMhWgUdyVxD/y5re0qaJRpCUMj6jhvSd6rb7
pinh5spemZ7rqvg6Juhntxe6/LzyLfPrgZdfyxHIdtY9q1cr7i3N2WYVe1HhBkJk
XbQlBftLJ4Pjs5hwRcsjOZSzYUxEe8LFhOYs1ymmW2eNYH2R8ERoURFpUtSL+E2y
SrW9rAgVeYcaLMtiO88yBFM44rYnse28JeF3cZD+I93GEojY3wTl+Yl8oaiXy3gX
yPLxVbI96OFC46CNQ8zJiqlZBu8AC0o4hty6D14n6I8myZy5r+hwshc3gcEwspWH
lADTL61w/K8GaSmWPBeMxDVhjMHIzMHRpHC7Gpohnb7f7HTMVFehJVW4IsiTMuRG
fVHpo84AkKgRU0+YobPnjidGAhmuw1Xj7Yx8r66PzOaUfuW9W+slkmdIDCL+FTnc
79pVksVHbB0LsxSFKG5Y
=4zzz
-----END PGP SIGNATURE-----

--=-d6K6x0JuGRNP2IVkc1oD--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
