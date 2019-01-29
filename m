From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 0/4] mlx5 next misc updates
Date: Tue, 29 Jan 2019 07:58:17 +0000
Message-ID: <20190129075814.GC3604@mtr-leonro.mtl.com>
References: <20190119003313.16711-1-saeedm@mellanox.com>
 <20190124123041.GS3604@mtr-leonro.mtl.com>
 <CALzJLG9hjOZ=+pommPcjP0He_mBSUMK5+q3F9k8qGGhJvmJPQw@mail.gmail.com>
 <20190127075109.GY3604@mtr-leonro.mtl.com>
 <812ce9a19d55ed16af677622a39ee484eb9c508f.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="f6nK9RR+X1IX2pXa"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <812ce9a19d55ed16af677622a39ee484eb9c508f.camel@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>, Jason Gunthorpe <jgg@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--f6nK9RR+X1IX2pXa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 28, 2019 at 07:11:01PM +0000, Saeed Mahameed wrote:
> On Sun, 2019-01-27 at 07:51 +0000, Leon Romanovsky wrote:
> > On Fri, Jan 25, 2019 at 10:08:00AM -0800, Saeed Mahameed wrote:
> > > On Thu, Jan 24, 2019 at 4:30 AM Leon Romanovsky <
> > > leonro@mellanox.com> wrote:
> > > > On Fri, Jan 18, 2019 at 04:33:09PM -0800, Saeed Mahameed wrote:
> > > > > Hi all,
> > > > >
> > > > > This series includes updates to mlx5-next shared branch.
> > > > >
> > > > > 1) from Jason, improve mlx5_cmd_exec_cb async API to be safer
> > > > > 2) from Maxim Mikityanskiy, cleanups for mlx5_write64 doorbell
> > > > > API
> > > > > 3) from Michael Guralnik, Add pci AtomicOps request
> > > > >
> > > > > Thanks,
> > > > > Saeed.
> > > > >
> > > > > ---
> > > > >
> > > > > Jason Gunthorpe (1):
> > > > >   net/mlx5: Make mlx5_cmd_exec_cb() a safe API
> > > > >
> > > > > Michael Guralnik (1):
> > > > >   net/mlx5: Add pci AtomicOps request
> > > >
> > > > Those two were applied to mlx5-next branch.
> > > >
> > > > ce4eee5340a9 (mlx5-next) net/mlx5: Add pci AtomicOps request
> > > > e355477ed9e4 net/mlx5: Make mlx5_cmd_exec_cb() a safe API
> > > >
> > > > > Maxim Mikityanskiy (2):
> > > > >   net/mlx5: Remove unused MLX5_*_DOORBELL_LOCK macros
> > > > >   net/mlx5: Remove spinlock support from mlx5_write64
> > > >
> > > > Those two needs extra work,
> > >
> > > What extra work ?
> >
> > You got two comments for area you are touching:
> > 1. Replace _rww writes to something else.
>
> Not related to this cleanup patchset.
>
> > 2. Protect with spinlock 32-bits writes instead of ignoring it.
>
> Same as above, I already explained this.
>
> >
> > Both of those changes will touch the same 2-4 lines and there
> > is very little benefit in creating more than one-two patches
> > just for that.
> >
>
> Future work, as it needs verification and careful testing.
>
> Leon I would like to move on with those 2 small cleanup patches, no
> functionality change here, please confirm you are ok with them.

At least write large and scary comment that this mode was always broken.

>
> Thanks,
> Saeed.
>
> > Thanks
> >
> > > > Thanks
> > > >
> > > > > --
> > > > > 2.20.1
> > > > >

--f6nK9RR+X1IX2pXa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcUAeWAAoJEORje4g2clindioP/RWWUFn9TaEoqR9boecAd+c/
vr4OgghbeHtUDFn2NEcD2nIAaVXNaSsrBicvzYezK/bxU6oeSNT1GCQroSc7KOba
SaxLiOEWM05Lyd5KmSaiEROrfK1iKoaAsUEiEDjLEfZjrUdn0BvvmVGEJJim9sKM
gzJiKvXrfNF+/2FKqheze7PdJ3l6VwhsMAJDCfrs/O17EyPBEW93Sr+0nQiIdG7F
hr+RZ+3Fy9v/5glIk1GyfvK40ztsS67NXy5uaIfv7IHSmygO9cYEsvFEomRMDjZN
oJA/bQKDpqHGALTpbvbABzYCqwKM+xG1QkrUktB0N6/PanwQLIzsFr9voffpyRHV
LI0qh5ASJ6aewdiPuGpdYf/2SXYVXeXL3aXRvKA1Rdi+2hqmgWJDIpqud9RJKtwM
mE/A0SDEy/plKnYXMXdzHZqE72saZZkIN0NKnjbPo/obyOXisD7RztxC8oBiMFZS
yNFkhUnnwMjRHJDstQjkY+BkczUnO2kjra47ViC/pc4KIVD3WsQwuGseCm7v3zTf
KgMARZHwVTAPexqZxzh5HzPoZLUZKTyNTR1eathULy56IPF8zpEbEo2pO0TpWioy
G1gFGpWNhJGPdj1IbOMM6ZryqCVP60o3992gwnYSD2WoLFGQD6ejcG2DDmJV/AON
W3Z3aSIJG4Na9kddEzk1
=qvIa
-----END PGP SIGNATURE-----

--f6nK9RR+X1IX2pXa--
