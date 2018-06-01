From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 0/2] Mellanox, mlx5 new device events
Date: Fri, 01 Jun 2018 12:48:33 -0400
Message-ID: <e28570f04bc9aee25b348d6973e1e76bb87e44ef.camel@redhat.com>
References: <20180530175950.9488-1-saeedm@mellanox.com>
         <20180531.153603.45475041396194381.davem@davemloft.net>
         <82ddad11b6a77aa07238ff50ae8769360bfb583b.camel@redhat.com>
         <20180601.114558.569563972122502762.davem@davemloft.net>
         <20180601162126.GB2843@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Gp5kgPiBUuTTc3Jmc49N"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180601162126.GB2843@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, David Miller <davem@davemloft.net>
Cc: saeedm@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, jgg@mellanox.com
List-Id: linux-rdma@vger.kernel.org


--=-Gp5kgPiBUuTTc3Jmc49N
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-06-01 at 19:21 +0300, Leon Romanovsky wrote:
> On Fri, Jun 01, 2018 at 11:45:58AM -0400, David Miller wrote:
> > From: Doug Ledford <dledford@redhat.com>
> > Date: Fri, 01 Jun 2018 11:08:24 -0400
> >=20
> > > On Thu, 2018-05-31 at 15:36 -0400, David Miller wrote:
> > > > From: Saeed Mahameed <saeedm@mellanox.com>
> > > > Date: Wed, 30 May 2018 10:59:48 -0700
> > > >=20
> > > > > The following series is for mlx5-next tree [1], it adds the suppo=
rt of two
> > > > > new device events, from Ilan Tayari:
> > > > >=20
> > > > > 1. High temperature warnings.
> > > > > 2. FPGA QP error event.
> > > > >=20
> > > > > In case of no objection this series will be applied to mlx5-next =
tree
> > > > > and will be sent later as a pull request to both rdma and net tre=
es.
> > > > >=20
> > > > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linu=
x.git/log/?h=3Dmlx5-next
> > > > >=20
> > > > > v1->v2:
> > > > >   - improve commit message of the FPGA QP error event patch.
> > > >=20
> > > > Series applied, thanks.
> > >=20
> > > Hi Dave,
> > >=20
> > > Although in this case it doesn't really matter and we can work around
> > > it, this was supposed to be a case of the new methodology that Saeed =
and
> > > Jason had worked out with you.  Specifically, when Saeed says in the
> > > cover letter:
> > >=20
> > > > In case of no objection this series will be applied to mlx5-next tr=
ee>
> > > > and will be sent later as a pull request to both rdma and net trees=
.
> > >=20
> > > then it is intended for you to ack the original patch series, not app=
ly
> > > it, and when acks from both the net and rdma side have been received,
> > > then we will get a pull request of just that series.
> >=20
> > Sorry, I saw your ACK and misinterpreted the situation.
> >=20
> > I'll be more careful next time.
>=20
> Doug, Dave
>=20
> I would like to clarify this point, we intend to send pull request to onl=
y
> one maintainer, who actually needs the accepted patches.
>=20
> Let's take the RDMA flow counters series as an example:
> https://www.spinics.net/lists/linux-rdma/msg65620.html
>=20
> This series includes 12 patches for RDMA and 2 shared code
> (mlx5-next). Those two patches, the RDMA side will receive as part
> of specific pull request and netdev will get them if some netdev
> feature down the road will need mlx5-next branch.
>=20
> Of course, it is harmless for both of you to pull, but it looks like
> extra work which is not needed for you.

Ok, thanks for the clarification Leon.


--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-Gp5kgPiBUuTTc3Jmc49N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlsReOEACgkQuCajMw5X
L93zXxAAv90EBx/WlgFXx+NMydoGhwUrDjq09Dv4tbRctMA+hXyDSh5MTB3XyIbA
oUiDPXO1AbBNcVXpeng32zzrggQmLlzk35Zl17Lna/lM8lY4wGo0n+s+Vjv9sg0D
tSYOEwWmMmYqYQsg79PWBWPKH+ZKafU/5wBC9gn9kpocKBcxgI+x/4IYS5MN+DjB
KP2o5fRuHnxxK1dJ7ZSDo5HALFaJTR9AkgOM563A+lmreIkiHoIglY+gKhwubA1J
Ji8hVkAzhpVnAOwnRixwhgB7YkPokEF1ygB6xIh7abru1sPPZseyrkRtP20GHuLx
bJq9chdG0NdRJ+7mWwTDV87SOQN4tmn2/JpmzI2nsyg8kIvq/7ERQ4BIezK5onnX
iSyTJV4OFhr+wRtUQBrH3ZMuX89znkC5tGtAWNZ+2MHh+bwPCgk0hJ+lGu5SruUb
s6vn2PZhfbgMhkS7vzzfXR7qkiMICYK4rLYKwDuBhNxhCctqHPDWRrwIEssCJ2bT
lrscLxQjufbA1lDZ7AQVPs1232BJjIKD6S6mLCO47Qy1Z6+a0HsGU0/D8XwzAD8s
SM3V+zSVtNRIAKaarvZ8AWtuAqhmowQrdjea0RmBIkQO90HKHRCH6QdvE+DfE7hn
ruf69vGpvTP5OZcVY7ggt79v2Q9/A3VE6ZexdoXqkOSL5R2zQao=
=Fwwu
-----END PGP SIGNATURE-----

--=-Gp5kgPiBUuTTc3Jmc49N--
