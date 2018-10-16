From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v1 0/4] Scatter to CQE
Date: Tue, 16 Oct 2018 22:00:08 +0300
Message-ID: <20181016190008.GL3606@mtr-leonro.mtl.com>
References: <20181009090515.25223-1-leon@kernel.org>
 <f59c18d5d4d02d93d3e918f93b8a4a81bdf6e5a6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f59c18d5d4d02d93d3e918f93b8a4a81bdf6e5a6.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 16, 2018 at 02:39:01PM -0400, Doug Ledford wrote:
> On Tue, 2018-10-09 at 12:05 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog v0->v1:
> >  * Changed patch #3 to use check_mask function from rdma-core instead define.
> >
> > --------------------------------------------------------------------------
> > From Yonatan,
> >
> > Scatter to CQE is a HW offload feature that saves PCI writes by
> > scattering the payload to the CQE.
> >
> > The feature depends on the CQE size and if the CQE size is 64B, it will
> > work for payload smaller than 32. If the CQE size is 128B, it will work for
> > payload smaller than 64.
> >
> > The feature works for responder and requestor:
> > 1. For responder, if the payload is small as required above, the data
> > will be part of the CQE, and thus we save another PCI transaction the recv buffers.
> > 2. For requestor, this can be used to get the RDMA_READ response and
> > RDMA_ATOMIC response in the CQE. This feature is already supported in upstream.
> >
> > As part of this series, we are adding support for DC transport type and
> > ability to enable the feature (force enable) in the requestor when SQ
> > is not configured to signal all WRs.
> >
> > Thanks
> >
> > Yonatan Cohen (4):
> >   net/mlx5: Expose DC scatter to CQE capability bit
> >   IB/mlx5: Support scatter to CQE for DC transport type
> >   IB/mlx5: Verify that driver supports user flags
> >   IB/mlx5: Allow scatter to CQE without global signaled WRs
> >
> >  drivers/infiniband/hw/mlx5/cq.c      |  2 +-
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +-
> >  drivers/infiniband/hw/mlx5/qp.c      | 93 ++++++++++++++++++++++++++++--------
> >  include/linux/mlx5/mlx5_ifc.h        |  3 +-
> >  include/uapi/rdma/mlx5-abi.h         |  1 +
> >  5 files changed, 79 insertions(+), 22 deletions(-)
> >
> > --
> > 2.14.4
> >
>
>
> Hi Leon,
>
> This series looks fine.  Let me know when the net/mlx5 portion has been
> committed.

Thanks Doug,
I pushed first patch to mlx5-next
94a04d1d3d36 ("net/mlx5: Expose DC scatter to CQE capability bit")

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbxjU4AAoJEORje4g2clinOPQQAMuaG0DdDbL1PLANrvwMpVSg
j56h/OI3V1yXwotDyYPiVN8XIS/QBnitErMNLHT0l0oOck//JWSHr3TphknZF6fr
X+L42NClFbVF4W0p1eLgvkf5Ie0Q+Ym6J7P7eRTckAlWNwbVogIhRR+cmaRC3gV9
PNrMF7ZQxggS3R1CPLxSb5s+5US/AUqaImn4sqwtgIobUh6dOFqd//rMF3tcng6l
N8+NSarH+Tj8JgqeTu3ULWnhTr2CqCLN7gVG+HfHRHsCwaSgVWn4w2xOrShQMACK
TnHvAMsPTr4taiLPQ5zPYXNfzkRsquLi851ng1sjuKNgftH1KX/+8mXzZj351pUX
OLXXVXa9IwbQxt7x0O3RgCP18rnnGQj6Ipfy4c2bFHjvRB23x1KrCDoYw7WfYry0
je9r7706oPRMKxuFMC5eLKrVV9Vr5zuP9BTcOdaHVZgMKCgG0nYsgoTCvh2gSGkZ
C5PC5kp68ko3HDUQxyTKGW//emT+8iGIFeOF3QvvjtwvAuiM3PagEuj+WbH5XJ+N
x2IQoC289dGFdRyG1wwxh5jRy+aeow83tc59K/VA4MY0Qw6DH1Cqe54Sik0oT8lZ
rviBMWf9+yku6uTD6RQ7NTkkjl8rh3uKNc5+iqU0513N+IqLCfPe22XVqMMyD7y9
LHZkQpsx8SQ/K/I+WC9c
=RmaH
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
