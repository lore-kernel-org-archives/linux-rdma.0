From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Please add mlx5-next tree
Date: Mon, 18 Jun 2018 08:07:59 +1000
Message-ID: <20180618080759.528b3525@canb.auug.org.au>
References: <20180606192500.GZ2958@mtr-leonro.mtl.com>
        <20180608074726.5b3883e2@canb.auug.org.au>
        <20180610054128.GG12407@mtr-leonro.mtl.com>
        <20180617185253.GA7393@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=X4x6njnBngG4eYYIfSgoe3"; protocol="application/pgp-signature"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617185253.GA7393@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, "David S. Miller" <davem@davemloft.net>, linux-netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--Sig_/=X4x6njnBngG4eYYIfSgoe3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Leon,

On Sun, 17 Jun 2018 21:52:53 +0300 Leon Romanovsky <leon@kernel.org> wrote:
>
> On Sun, Jun 10, 2018 at 08:41:28AM +0300, Leon Romanovsky wrote:
> > On Fri, Jun 08, 2018 at 07:47:26AM +1000, Stephen Rothwell wrote: =20
> > > Hi Leon,
> > >
> > > On Wed, 6 Jun 2018 22:25:00 +0300 Leon Romanovsky <leon@kernel.org> w=
rote: =20
> > > >
> > > > Can you please add the branch "mlx5-next" from the following tree t=
o the
> > > > linux-next integration tree?
> > > >
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/
> > > >
> > > > The mlx5-next branch is used to send shared pull requests to both n=
etdev
> > > > and RDMA subsystems and it is worth to have linux-next coverage on =
it
> > > > before. =20
> > >
> > > I try hard not to add new trees during the merge window, sorry.  If I
> > > forget to add it after -rc1 has been released, please remind me. =20
> >
> > Thanks Stephen, I'll do.
> > =20
>=20
> This is reminder.

I have added it from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgement of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/=X4x6njnBngG4eYYIfSgoe3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlsm278ACgkQAVBC80lX
0Gyw0Af/UZjyXvpBi7/6D62OuQIPHTSdlekvGZQwu4cKo/EyfNXewR5gqF/aNZje
K2PAFwVUbvY7+xoJjfGJ3JI7iFvRPZCCRd59JKObY7OUYn+YMrli04S243fu0JtJ
tBOkxDiSbOImhUlTkKupWVOm4cqvBBDG5lLpFS+kb3nD3sALxC9s8kTCaO+/v9my
OSGyrycbM6xfCyhsniE2wRmOhgj2d3AvnAobLUbnl2aJQ7j3IKRWaJfmzHWRZwCq
KQ4H4E3psbUjpdJ7LcncXwdLlo+M+axHjmJTQnqiQm+OHRArjW8K3GhP7q5Yj3FK
HOd5bB5vVL+5BkUcLkqBrDjSIhLAUA==
=cUHO
-----END PGP SIGNATURE-----

--Sig_/=X4x6njnBngG4eYYIfSgoe3--
