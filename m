From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 2/3] rdma: print driver resource
 attributes
Date: Tue, 15 May 2018 19:59:55 +0300
Message-ID: <20180515165955.GD10381@mtr-leonro.mtl.com>
References: <cover.1525709213.git.swise@opengridcomputing.com>
 <1a0d146dffb17449aa6d8a6b6d06e865e69226de.1525709213.git.swise@opengridcomputing.com>
 <20180513132447.GF10381@mtr-leonro.mtl.com>
 <c57b8f18-858c-62df-50c6-453933a67913@opengridcomputing.com>
 <13da78012c55e8f224c2226f3c0cfc53bd0522be.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kZU6r8y0YpRwyDfh"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <13da78012c55e8f224c2226f3c0cfc53bd0522be.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Steve Wise <swise@opengridcomputing.com>, dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--kZU6r8y0YpRwyDfh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 15, 2018 at 12:35:34PM -0400, Doug Ledford wrote:
> On Mon, 2018-05-14 at 09:51 -0500, Steve Wise wrote:
> >
> > On 5/13/2018 8:24 AM, Leon Romanovsky wrote:
> > > On Mon, May 07, 2018 at 08:53:16AM -0700, Steve Wise wrote:
> > > > This enhancement allows printing rdma device-specific state, if pro=
vided
> > > > by the kernel.  This is done in a generic manner, so rdma tool does=
n't
> > >
> > > Double space between "." and "This".
> > >
> > > > need to know about the details of every type of rdma device.
> > > >
> > > > Driver attributes for a rdma resource are in the form of <key,
> > > > [print_type], value> tuples, where the key is a string and the valu=
e can
> > > > be any supported driver attribute.  The print_type attribute, if pr=
esent,
> > >
> > > ditto
> >
> > I'll fix these.
>
> Fix it if you want, but don't do it because Leon told you to.  A double
> space after period is perfectly acceptable.

It is very controversial thing [1],

"Most style guides indicate that single sentence spacing is proper for
final or published work today, and most publishers require manuscripts
to be submitted as they will appear in publication=E2=80=94single
sentence spaced."

[1] https://en.wikipedia.org/wiki/Sentence_spacing

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--kZU6r8y0YpRwyDfh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJa+xILAAoJEORje4g2clintm0P+waoDeOzm723ceLs6+5IvF5J
7hO2s6EXSEc7VD4tJahGULPBu+FzBFcEv01Nqb8XEssUZfd5XN/gVzmLTn5jKAKr
BpK/FnkyOqyZvA4kS1ebQfBmf1Ba2iKHKBtZ93kf9hiNG/5zYEqLWUe6Owg2dD0u
71mClizESnhM/ef5QR7ZH7fI7yfulMNbqzIlh7S/u3tb/Seol0luEXtOO1vTvJbo
cZiUnzv5Q1nrLBk9yZF/GKAJph+oc/7Chsh9wDChxCHbOMuog4yJZO343k3GJ7le
emdpjj77JH4FG7mfChp1JzYsPjHKsXrH8bsGGL5Q4TyAmZdLbRo6EleOEae8Cj6D
jcqsfQAfmVGrIvEGNr/GgCA/n+uB158+dVO1nmQoR5dAgbsuu5c28zK+gw8+VeuI
bA/rUpj1KCA4uwAq7x5P2l3xg//Db25fLtdCcOGIz8ImYc800dLP+IFVukX6EldS
9n3AASWyi8DB0EvWvIUP2S1ghSf61AGSI4KWs61QQ3jIkxL6DF+W0aeGCm90zcAh
B/XK7eyB2TxjR2gZQTQAteQdxfmmwktrzyLy6XcPoGEWFoYxY/FJkDyq/CKZnovD
PEIAH5xpKYcJBTQA2qT6fziebXTCHbDplM+p1OGfpCB4N+OGlYJc8886KJdpVz7J
vRJ/1pgdDQFfIgK3pBv0
=TcxJ
-----END PGP SIGNATURE-----

--kZU6r8y0YpRwyDfh--
