From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v2 0/8] Support mlx5 flow steering with RAW data
Date: Tue, 24 Jul 2018 08:56:09 +0300
Message-ID: <20180724055609.GG3189@mtr-leonro.mtl.com>
References: <20180723122512.20967-1-leon@kernel.org>
 <20180724024236.GA16958@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yH1ZJFh+qWm+VodA"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180724024236.GA16958@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--yH1ZJFh+qWm+VodA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 23, 2018 at 08:42:36PM -0600, Jason Gunthorpe wrote:
> On Mon, Jul 23, 2018 at 03:25:04PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog:
> > v1->v2:
> >  * Fix matcher to use the correct size.
> >  * Rephrase commit log of the first patch.
> > v0->v1:
> >  * Fixed ADD_UVERBS_ATTRIBUTES_SIMPLE macro to pass the real address.
> >  ?* Replaced UA_ALLOC_AND_COPY to regular copy_from
> >  * Added UVERBS_ATTR_NO_DATA new macro for cleaner code.
> >  * Used ib_dev from uobj when it exists.
> >  * ib_is_destroy_retryable was replaced by ib_destroy_usecnt
> >
> > >From Yishai:
> >
> > This series introduces vendor create and destroy flow methods on the
> > uverbs flow object by using the KABI infra-structure.
> >
> > It's done in a way that enables the driver to get its specific device
> > attributes in a raw data to match its underlay specification while still
> > using the generic ib_flow object for cleanup and code sharing.
> >
> > In addition, a specific mlx5 matcher object and its create/destroy
> > methods were introduced. This object matches the underlay flow steering
> > mask specification and is used as part of mlx5 create flow input data.
> >
> > This series supports IB_QP/TIR as its flow steering destination as
> > applicable today via the ib_create_flow API, however, it adds also an
> > option to work with DEVX object which its destination can be both TIR
> > and flow table.
> >
> > Few changes were done in the mlx5 core layer to support forward
> > compatible for the device specification raw data and to support flow
> > table when the DEVX destination is used.
> >
> > As part of this series the default IB destroy handler
> > (i.e. uverbs_destroy_def_handler()) was exposed from IB core to be
> > used by the drivers and existing code was refactored to use it.
> >
> > Thanks
> >
> > Yishai Hadas (8):
> >   net/mlx5: Add forward compatible support for the FTE match data
> >   net/mlx5: Add support for flow table destination number
> >   IB/mlx5: Introduce flow steering matcher object
> >   IB: Consider ib_flow creation by the KABI infrastructure
> >   IB/mlx5: Introduce vendor create and destroy flow methods
> >   IB/mlx5: Support adding flow steering rule by raw data
> >   IB/mlx5: Add support for a flow table destination
> >   IB/mlx5: Expose vendor flow trees
>
> This seems fine to me. Can you send the mlx5 shared branch for the
> first two patches?

I applied two first patches with Acked-by from Saeed to mlx5-next

664000b6bb43 net/mlx5: Add support for flow table destination number
2aada6c0c96e net/mlx5: Add forward compatible support for the FTE match data

Thanks

>
> Thanks,
> Jason

--yH1ZJFh+qWm+VodA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbVr95AAoJEORje4g2clinb00P/00uwCl/SNXCtT3/0v4IKwUO
4xAbwPmB6bElvrKMawfzGLtRxXXNekvHqsJUjMj61uUgz49xALwSYYYoRHOwpqDX
VnALJ1B8fw4EQaZT6QykpLnsnVlOOCBhFaMje2IrG+I6fGgUgRAtX60cpWkuX8gC
2No9VDnZW5Uy2dUjm4hYPC5oFy3TbLBJH/+J9kOP2SJSOuIv6O7sDYLiwfCLpWoh
e0GP/bHVjGl0FrQRp9FFLgsZ1Gj5xFrL40P6yWcQo7+3CCnKjhzq4vJKSKSDlWLd
geajjGG4eXT1dlRQOuxXkqFtTtDVULhkMmfliUI2/WsUaWd0RkCh2I8CGVLbPDIS
UIVWJYtp2eNVmzng64diy10lVQ67ur9T23wyT+ETa/RdatXw6xYnuajwX6uhkRkX
88AiO1ddLiZ+nmwENvkgfD4uPGrg7xq+Ay8AE47kGYW8TOaAuo08nDdIdza+1aoi
5TC6c/ikyuzERatUYqKlRQQO+GTl3rBHb7f2Oxor+8OSMMTe5ppWK6GPysFdaH/t
rhmmhz8qnRp9x8irmowlRVoYC2hpxsHjiHgVaYWK/txEtnigLb9PVJvYKw3frhZP
PxVLtHUUKymEYtPZiWTNi981vF901MKsgYCPyb0oaDvlfObmd7eah5HyEz/Xw45R
c2fWcL111ouYpyHMBept
=R2KV
-----END PGP SIGNATURE-----

--yH1ZJFh+qWm+VodA--
