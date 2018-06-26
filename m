From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 00/12] RDMA fixes 2018-06-24
Date: Tue, 26 Jun 2018 07:21:26 +0300
Message-ID: <20180626042126.GM17747@mtr-leonro.mtl.com>
References: <20180624082353.16138-1-leon@kernel.org>
 <20180625213438.GA19857@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EqVOK5mkaJAMmtSx"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180625213438.GA19857@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--EqVOK5mkaJAMmtSx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 25, 2018 at 03:34:38PM -0600, Jason Gunthorpe wrote:
> On Sun, Jun 24, 2018 at 11:23:41AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > This is bunch of patches trigged by running syzkaller internally.
> >
> > I'm sending them based on rdma-next mainly for two reasons:
> > 1, Most of the patches fix the old issues and it doesn't matter when
> > they will hit the Linus's tree: now or later in a couple of weeks
> > during merge window.
> > 2. They interleave with code cleanup, mlx5-next patches and Michael's
> > feedback on flow counters series.
> >
> > Thanks
> >
> > Leon Romanovsky (12):
> >   RDMA/uverbs: Protect from attempts to create flows on unsupported QP
> >   RDMA/uverbs: Fix slab-out-of-bounds in ib_uverbs_ex_create_flow
>
> I applied these two to for-rc
>
> >   RDMA/uverbs: Check existence of create_flow callback
> >   RDMA/verbs: Drop kernel variant of create_flow
> >   RDMA/verbs: Drop kernel variant of destroy_flow
> >   net/mlx5: Rate limit errors in command interface
> >   RDMA/uverbs: Don't overwrite NULL pointer with ZERO_SIZE_PTR
> >   RDMA/umem: Don't check for negative return value of dma_map_sg_attrs()
> >   RDMA/uverbs: Remove redundant check
>
> These to for-next

Jason,

We would like to see patch "[PATCH mlx5-next 05/12] net/mlx5:
Rate limit errors in command interface" in out mlx5-next. Is it possible
at this point to drop it from for-next, so I'll be able to take it into
mlx5-next?

Thanks

>
> >   overflow.h: Add arithmetic shift helper
> >   RDMA/mlx5: Fix shift overflow in mlx5_ib_create_wq
> >   RDMA/mlx5: Reuse existed shift_overlow helper
>
> And these will have to be respun.
>
> Thanks,
> Jason

--EqVOK5mkaJAMmtSx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbMb9GAAoJEORje4g2clinbHQP/0RWIMw8eeYRHR3VkApXVHdV
i+y828vXb0Ez8VZvt5LY2cZ4gcVjSfRWeJaduWNxuRX3QhwFszY3aNLKc6qGEnT3
mzYdmCweG8Q0xoVu9mMV1b1nt6pUQg/zRittEvEId08ZXFMKiQvG8MhsQVdufz+a
KKGNghZzf7rJ2BvafmkSKTzfQLlve8v0APwqSfxZpj7WOlJONpSBMrcsN6bmWBQi
1oxTd8HVKjHNszbHaL7Mdu1Z7CLRua8bX+Po8ASP0ZyEUQC0PIeG89lx0zZl/ZDI
9Tm4e6ij3ccZs9Yq3N84g1bCJ/AVL3rX707JAd5I6r910svYn03/cNynIKzlACmS
6lc1CvOqc6iDAK5RMYaNRDJbtxiGeS99gjz0zGGkVSXCJQmHDk56GC/1qnORgOcL
TKC2meo4d3R+nEIQlVF+P/K4u+5nf+/qkPZKFyTIasSBs9L1muwtpTyjbSK6mJrU
CF5iSqYdb45BVsFJs0KM0wQiO6eibwD8vC+XdyH2HFyAZ5T3zoUgeAY6nAxJHPyd
/mZZhqnvU4WrAJ0TXlD6OQQ24JIlSDVL/0HrbnGpeF3Z8RKBLqPYwwGBtDBQe6GW
enXgmW0oO1gOk82hnPnJr1H9584iOWs8qv2H8Mk+Tlk9cOAwBrqd2FQYK2028vHj
jN0Y6VdAHySL2TweQhLs
=P9Mt
-----END PGP SIGNATURE-----

--EqVOK5mkaJAMmtSx--
