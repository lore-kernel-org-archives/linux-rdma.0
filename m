From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 0/4] mlx5 next misc updates
Date: Sun, 27 Jan 2019 07:51:11 +0000
Message-ID: <20190127075109.GY3604@mtr-leonro.mtl.com>
References: <20190119003313.16711-1-saeedm@mellanox.com>
 <20190124123041.GS3604@mtr-leonro.mtl.com>
 <CALzJLG9hjOZ=+pommPcjP0He_mBSUMK5+q3F9k8qGGhJvmJPQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l8yJEXo8J9fv7OFY"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALzJLG9hjOZ=+pommPcjP0He_mBSUMK5+q3F9k8qGGhJvmJPQw@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

--l8yJEXo8J9fv7OFY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 25, 2019 at 10:08:00AM -0800, Saeed Mahameed wrote:
> On Thu, Jan 24, 2019 at 4:30 AM Leon Romanovsky <leonro@mellanox.com> wrote:
> >
> > On Fri, Jan 18, 2019 at 04:33:09PM -0800, Saeed Mahameed wrote:
> > > Hi all,
> > >
> > > This series includes updates to mlx5-next shared branch.
> > >
> > > 1) from Jason, improve mlx5_cmd_exec_cb async API to be safer
> > > 2) from Maxim Mikityanskiy, cleanups for mlx5_write64 doorbell API
> > > 3) from Michael Guralnik, Add pci AtomicOps request
> > >
> > > Thanks,
> > > Saeed.
> > >
> > > ---
> > >
> > > Jason Gunthorpe (1):
> > >   net/mlx5: Make mlx5_cmd_exec_cb() a safe API
> > >
> > > Michael Guralnik (1):
> > >   net/mlx5: Add pci AtomicOps request
> >
> > Those two were applied to mlx5-next branch.
> >
> > ce4eee5340a9 (mlx5-next) net/mlx5: Add pci AtomicOps request
> > e355477ed9e4 net/mlx5: Make mlx5_cmd_exec_cb() a safe API
> >
> > > Maxim Mikityanskiy (2):
> > >   net/mlx5: Remove unused MLX5_*_DOORBELL_LOCK macros
> > >   net/mlx5: Remove spinlock support from mlx5_write64
> >
> > Those two needs extra work,
>
> What extra work ?

You got two comments for area you are touching:
1. Replace _rww writes to something else.
2. Protect with spinlock 32-bits writes instead of ignoring it.

Both of those changes will touch the same 2-4 lines and there
is very little benefit in creating more than one-two patches
just for that.

Thanks

>
> >
> > Thanks
> >
> > >
> > > --
> > > 2.20.1
> > >

--l8yJEXo8J9fv7OFY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcTWLtAAoJEORje4g2clin2EIQAIlsDxTcUaul4OAHMflt9Ofk
A98hv5+GK1djH/DB1PYDvegHEiRAUKKhbuI0AXSQvFgANqO0lNF96y+3zqidXVRV
K5hX4cBc19ymqdzxqqnCuD2wTisb1r1BEGy12YIqAUpPF2s5jchJuYlFEUqVDfmm
PaZXWKqQmhH/vPZHeZKTK75sct8Pjva/lsHBbwPAMxybERP7TC52carmn4lh2vZj
sQCl4c1xBu15gq8Zjxk+87NkPbxykvRqq09Kz3OreY0Gkia4H/VlDzl7lGXq9po4
pCapW57aOpU7wPi7QII9Lpjq41XhgrEkGYlJDGeyBOs5q5REuRVnPSpzVABcbuS2
sRXiniNWHhvF87nT4Rv7mC3Wx7OTXixcBBcVCFYUXOKJ3NhTX3ZYubRoQVVBp/p/
iyKMgvGWmzK+84g1my1GprPq9cDMbeh1jfO5wg7+PgxHQg10eRKKCtAbMb+uETcn
YqAN7B3fqMZkPvMPyt4R2JpDIOnQ1QsRG9KEt7mfX0xygVGbhd77w4tEXjL/d78x
4Xb4xN7cL1cdyfdoAqJsav7345s3Tkyb/ljRF0jH+g16oUqn90tjq0MiYwqjvZqd
WEGrwGY+BvjMzdyNifHJSPbyLYMmBSuu+DMrJJ+icHn26JL4tR1Z5JDhcJjqx0RC
Ni4CvGCzaFXLxflgCdn4
=Zro/
-----END PGP SIGNATURE-----

--l8yJEXo8J9fv7OFY--
