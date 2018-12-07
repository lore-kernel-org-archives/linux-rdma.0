From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/3]  Packet based credit mode
Date: Fri, 7 Dec 2018 08:04:26 +0200
Message-ID: <20181207060426.GC3845@mtr-leonro.mtl.com>
References: <20181130112206.19870-1-leon@kernel.org>
 <20181207032706.GA20134@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181207032706.GA20134@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Danit Goldberg <danitg@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 06, 2018 at 08:27:06PM -0700, Jason Gunthorpe wrote:
> On Fri, Nov 30, 2018 at 01:22:03PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > >From Danit,
> >
> > Packet based credit mode is an alternative end-to-end credit mode for QPs
> > set during their creation. Credits are transported from the responder
> > to the requester to optimize the use of its receive resources.
> > In packet-based credit mode, credits are issued on a per packet basis.
> >
> > The advantage of this feature comes while sending large RDMA messages
> > through switches that are short in memory.
> >
> > The first commit exposes QP creation flag and the HCA capability. The
> > second commit adds support for a new DV QP creation flag. The last
> > commit report packet based credit mode capability via the MLX5DV device
> > capabilities.
> >
> > Thanks
> >
> > Danit Goldberg (3):
> >   net/mlx5: Expose packet based credit mode
> >   IB/mlx5: Add packet based credit mode support
> >   IB/mlx5: Report packet based credit mode device capability
>
> This looks fine to me, can you update the shared branch please

Done, thanks
3fd3c80acc17 net/mlx5: Expose packet based credit mode

>
> Thanks,
> Jason

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcCg1qAAoJEORje4g2clin3nUP/R+qESfML/vuHO0bYunj+r8o
EYo3sfEDDafuUqvKXZRnbyWEHDHd+5erlLoot/z3zbciPdGONIGGjWsOHI42wKjM
qwvhEKs9W7t3d/898ss6IuiyJTVQ8ERciLSgC1kDEsuH/R+Hhxdfvcz4EiiBPYe3
IVqdJnEErYUZFhGuPEZC0VxCvdHao89mMcyD/FLiSfExEMZfidryFPetS46J2L2E
8mxBBonL2CCI4bqIFarRJdmdQEssYPy/n9nhfPgQi1DOCVgyKPJlnsEDC1B5jPJ/
935o4BgSr3XqHxaBitLKf1i1TbyscKONm1yJisxrkIWtFvJn1Zy+KJ0zTCtwIpou
6MG4nCIASvIiEGKg1jiqA3tBCkV3ei2jrCcnFET5ZVIR0H3iZZeoGVGqoApcGX2p
Axs6GWffhDp6kSp8ofcmw5p+JvyhNp8POiphABxGVLxI6VFBPiIXhgJYQnu2Mk3W
Ev7vPCMSEBznlUpUbKUpxD5UktTEiHHe1IhvB0DN4uOIXxrrlUGTsQARVYR3ujxH
4eThH5oT7akCZyZ9s3P+5fgHuVFZNlQ4Vbyy1AgsuJgjnMoA81jNJ3KoQXeLcPG3
Q0LJrWRLHKjhpLFw07VdceffQ0s7vgt6wyM//GRUqoFgrx9KT5Mt2bCCybEDmvSA
E2nmO8uIKvNnaYpXXTYC
=77Rm
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
