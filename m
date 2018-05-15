From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v1 iproute2-next 2/3] rdma: print driver resource
 attributes
Date: Tue, 15 May 2018 14:00:52 -0400
Message-ID: <c74b3331aca2a8a0504fef7b82d3a584a614649f.camel@redhat.com>
References: <cover.1525709213.git.swise@opengridcomputing.com>
         <1a0d146dffb17449aa6d8a6b6d06e865e69226de.1525709213.git.swise@opengridcomputing.com>
         <20180513132447.GF10381@mtr-leonro.mtl.com>
         <c57b8f18-858c-62df-50c6-453933a67913@opengridcomputing.com>
         <13da78012c55e8f224c2226f3c0cfc53bd0522be.camel@redhat.com>
         <20180515165955.GD10381@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-kMxoPhaVr3kauAmaopDX"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180515165955.GD10381@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>, dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-kMxoPhaVr3kauAmaopDX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-15 at 19:59 +0300, Leon Romanovsky wrote:
> On Tue, May 15, 2018 at 12:35:34PM -0400, Doug Ledford wrote:
> > On Mon, 2018-05-14 at 09:51 -0500, Steve Wise wrote:
> > >=20
> > > On 5/13/2018 8:24 AM, Leon Romanovsky wrote:
> > > > On Mon, May 07, 2018 at 08:53:16AM -0700, Steve Wise wrote:
> > > > > This enhancement allows printing rdma device-specific state, if p=
rovided
> > > > > by the kernel.  This is done in a generic manner, so rdma tool do=
esn't
> > > >=20
> > > > Double space between "." and "This".
> > > >=20
> > > > > need to know about the details of every type of rdma device.
> > > > >=20
> > > > > Driver attributes for a rdma resource are in the form of <key,
> > > > > [print_type], value> tuples, where the key is a string and the va=
lue can
> > > > > be any supported driver attribute.  The print_type attribute, if =
present,
> > > >=20
> > > > ditto
> > >=20
> > > I'll fix these.
> >=20
> > Fix it if you want, but don't do it because Leon told you to.  A double
> > space after period is perfectly acceptable.
>=20
> It is very controversial thing [1],
>=20
> "Most style guides indicate that single sentence spacing is proper for
> final or published work today, and most publishers require manuscripts
> to be submitted as they will appear in publication=E2=80=94single
> sentence spaced."
>=20
> [1] https://en.wikipedia.org/wiki/Sentence_spacing

Yes...and the justification is that proportional font systems resolve
the issue of delineating sentences without the need for a second space
(they actually don't because they are improperly implemented, but that's
another issue).  But we don't work on proportional font systems, we work
with git, on command lines, with fixed spacing fonts, all the things
that indicate double spaces are actually preferred even by those people
that are proponents of single spacing.  And on top of that, current
research suggests maybe the single spacers are wrong after all :-o

https://www.theatlantic.com/science/archive/2018/05/two-spaces-after-a-p
eriod/559304/

Anyway, my original point stands.  It's controversial, as you said, so
Steve should do what Steve feels is best and not worry about anyone
else' opinion on the matter.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-kMxoPhaVr3kauAmaopDX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlr7IFQACgkQuCajMw5X
L93hPw//VmGF6IUM9sIDhO/zCTy5Yb3rHlRDOBevYdc2JLOn1+qIkO64p0T7FjSK
b89ppAcy2W8sq3YriGT34BUbZMU4othRvmJp+kjaY+I0eb/YYzrfmwYmelsEDvkG
ESeY7WF8MTURfV0lQEIACBfwrY92PjesZMd6g1PATTG/fKuKRGHv02sJlpJkBgbm
QxftdqgNg0ukuEpeVGtWFhuvZOc0P+OwKnQm8Fp87MaHensjzq/sgmr6aXSqT+3v
m2IqgQkEfNjzpSV+t2jgLrdvacYwxZOamFm7AdgWPOoBVyt5s3TAzoLk+7+/IG7f
GmfXfrC352u8eLRV5cLOfCRR/taNwACaeYOsaTBO9ECImseg4EuF6DF73GGkbNMl
JXGp8Oaliiv+QfzfqZt0+0ePN9Owckv5rmgbiOxhJw9pJyMUUmYurGsmSPuBHMn8
reJ5Vj67auzPXajyw4WURSfpWVREcEBAeGf14HVacgV4egSWTgX01LKrJ3hAvrRV
JJeR4lQOYqbpxMpBVVYpVgk18VgrAZfI1lAIPf29ZQi9AG11/cYWKxTq7ajotj7b
8L0YU38UoTyQN+5jsdyx7sQEAeElbTwIh/QlzoS4IwKeJWF2i/nhfI0aImVCqT66
vR62QHs429rkyaoFT9GQ9vY235SFM3T7EKXlPE+YFjDYNKgBFsU=
=GWSK
-----END PGP SIGNATURE-----

--=-kMxoPhaVr3kauAmaopDX--
