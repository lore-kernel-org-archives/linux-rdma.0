From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next] IB/mlx5: Prevent allocating UMEM and UCTX as
 some general object
Date: Thu, 20 Dec 2018 19:13:19 +0200
Message-ID: <20181220171319.GB3940@mtr-leonro.mtl.com>
References: <20181219142815.21480-1-leon@kernel.org>
 <20181219191406.GX30567@mellanox.com>
 <20181220062133.GH13943@mtr-leonro.mtl.com>
 <20181220170205.GD29267@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181220170205.GD29267@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Achiad Shochat <achiad@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 20, 2018 at 05:02:12PM +0000, Jason Gunthorpe wrote:
> On Thu, Dec 20, 2018 at 08:21:33AM +0200, Leon Romanovsky wrote:
> > On Wed, Dec 19, 2018 at 07:14:12PM +0000, Jason Gunthorpe wrote:
> > > On Wed, Dec 19, 2018 at 04:28:15PM +0200, Leon Romanovsky wrote:
> > > > From: Yishai Hadas <yishaih@mellanox.com>
> > > >
> > > > The driver needs to prevent a user space application to create a
> > > > UMEM and UCTX via the general object command.
> > > >
> > > > The UMEM must go through the kernel UMEM_REG method to prevent the =
user
> > > > from setting physical addresses by himself.  The UCTX is some inter=
nal
> > > > kernel object and shouldn't be exposed.
> > > >
> > > > As of not being any more part of the general object the caps bits w=
ere
> > > > moved to be some log_xxx indication in the general HCA caps, 0 mean=
s not
> > > > supported.
> > > >
> > > > The firmware code was adapted as well to match the above.
> > >
> > > This commit message is a bit wonky.. how about
> > >
> > > IB/mlx5: Use the correct commands for UMEM and UCTX allocation
> > >
> > > During testing the command format was changed to close a security
> > > hole. Revise the driver to use the command format that will actually
> > > be supported in GA firmware.
> > >
> > > Both the UMEM and UCTX are intended only for use by the kernel and
> > > cannot be executed using a general command.
> > >
> > > Since the UMEM and CTX are not part of the general object the caps
> > > bits were moved to be some log_xxx location in the general HCA caps.
> >
> > I'm fine with this description too.
> >
> > >
> > > > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > > > Reviewed-by: Achiad Shochat <achiad@mellanox.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Also add a fixes line please, any kernel with the devx needs this
> > > patch to work with GA firmware.
> >
> > Fixes: a8b92ca1b0e5 ("IB/mlx5: Introduce DEVX")
> >
> > >
> > > >  drivers/infiniband/hw/mlx5/devx.c | 34 ++++++++---------
> > > >  drivers/infiniband/hw/mlx5/main.c |  3 +-
> > > >  include/linux/mlx5/mlx5_ifc.h     | 62 +++++++++++++++++++++------=
----
> > > >  3 files changed, 58 insertions(+), 41 deletions(-)
> > >
> > > Otherwise the patch looks fine, please apply to the shared branch..
> >
> > Jason,
> >
> > I have procedural question. This patch is based on rdma-next and there
> > is diversion in both devx.c and main.c in those areas, enough do not
> > apply cleanly. Will it be easier if you take this patch to rdma-next,
> > instead me applying different patch to mlx5-next and you hitting merge
> > conflict later on while trying to merge it into rdma-next?
>
> Sure, but it has the unsplit _ifc update...

If it was possible, I wouldn't bother you. This change should be as one
piece otherwise we will have failed to build patch.

>
> I think we are at the end of the cycle so this probably won't make a
> conflict - lets just go in RDMA then.

=46rom what I see in queues, you are right, merge conflict is unlikely to h=
appen.

Thanks

>
> Jason

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcG82vAAoJEORje4g2clinvuEQAID3fGrd1ZwiywBjRUPg76/q
Zf8KmegZIFMd998SvFpezmrhxwS40gWSF51eWSlFRsB/ufVc7rS+MnaV8YqdVwXr
ydIK3HLW7Z6OU6gSqt2L4fWVWjLXFyTn5S8MOmCcc7ThWD3YtWnRANWgCD6JpifU
U1dUMz8Sxrn3FAR8/1YcPfX+0G6HSps0cgLauMaqPe8lRCckNNq6gP06qMtI0FNT
jFU4UGYtWVnWPiDti5cEOH8re4OxlOLNz76ZGTeoVYT0Ya9+HJ0zJJ+2buearuDl
HKCET4OUCYKn6JtUEVRZ+e6vdKe423MPCsDRwmwJ5DxAEgCvvFruNn4PBzymm9Kf
/kQaos9lxGmrjJA+RfUDAJ45gE10leumm7TrYroEEzKXrj+695+cfLsDEwk9y1Y8
R2nUzY44wVeLJ7xZku3tsrjyxJTca+6+qVHvgsSmUBQ5nxNt1Kjn6v2LMr2nmAg7
iWIvVkg9hoLswUBa7xGz3JU9fM3vRM//Rhcs60xL8MwXpl+hrgU38EHqGAPhyGvn
Rsd9M8PIrIBfJSVNEE36x711pkrxyC50D+5uJQwjpoaHHUOpb7WAIznCFE/U1RKW
WlC4j0MA5BvuWEcOBDFHhOqymH6/IWRUXwT7GX/x5yHz5IGRVeb4hPPOcIFgyzsw
P6EPy4gfgeEhsrAgJEyN
=ui/T
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
