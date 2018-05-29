From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v1 11/13] IB/mlx5: Add flow counters binding
 support
Date: Tue, 29 May 2018 10:11:19 +0300
Message-ID: <20180529071119.GC3697@mtr-leonro.mtl.com>
References: <20180527102346.15149-1-leon@kernel.org>
 <20180527102346.15149-12-leon@kernel.org>
 <20180528172752.GD17505@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180528172752.GD17505@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 28, 2018 at 11:27:52AM -0600, Jason Gunthorpe wrote:
> On Sun, May 27, 2018 at 01:23:44PM +0300, Leon Romanovsky wrote:
>
> > +	if (!mcounters->hw_cntrs_hndl) {
> > +		mcounters->hw_cntrs_hndl =
> > +			(void *)mlx5_fc_create(to_mdev(ibcounters->device)->mdev,
> > +					       false);
>
> No unnecessary casts

hw_cntrs_hndl was intended to be generic enough to be connected with
different type of counters and not only mlx5_fc. However, i don't see
any coming feature are using this generic interface, so I'll remove.

>
> > +struct mlx5_ib_flow_counters_data {
> > +	__aligned_u64   counters_data;
>
> I think this is supposed to use RDMA_UAPI_PTR() these days.

It is a little bit problematic,
1. That RDMA_UAPI_PTR is declared in ib_user_ioctl_verbs.h, while
mlx5_ib_flow_counters_data in mlx5-abi.h.
2. Other similar __aligned_u64 needs to be updated in other mlx5-abi.h structures.

Thanks

>
> Jason

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbDP0XAAoJEORje4g2clinkpEP/AyPqfqZafaxyf9r8269IKdD
bLjf4b/xguoZvZ65gbu/q4u1Odlj60ETEzEHw3lUElUItKDVICpRK8jzeiJ0j/Gc
uF0u+6/Ar4fNjNORHnQpukVMKw5EFXYrcXxqfFr33tdRfB9uJX0PPqwEZmonOsBi
igI+WdnA+853KDVJfNoMb+2LCVohVd/b30RVl5EJPU8kgUp6vUvfmfSFDpV5rUOU
cNy50ouwRPdd6U67izj9YhwAqJkku7IS2bgZsL372QfXrHajVgAvzh+LUfwVpF9m
Pa7Ws5pNELYHIMc77qaySYpYzGRfLWNXJPDv3Sy1HZvrZWUj8dsjLDvL34/tIX+p
08IfKR9/8ZPjxyc/kn62wpQx/R2G4wbiSrjod59nPSk0ci930fvcJ8qKaw7RZLvF
2w5qUSr3UiXqs4eRECfdNTeHz2rfwyeInYqN5BNjgWNxcxIRdGBsQgjdwGZP0NhA
Twaz1kjaFUb7ZgtvmbSmXRi+PtXd8jo+xLRueE+OkuG4qrX9LJXeWJRLmDlqeoPn
kpHhrp7THrpVA6e2rfVjrsX2k31ymU7YJS4l+I2AsNZXOt7/pHDUmbCBKZPbw/8L
OwVgRIUvZJu1LvJtnF7F4PmKsdeZxE0clcY+X7JlNKmfFfrccIzFo0BlAh97mBM2
sUwhf4wPB8I3wQO3J4c2
=Zq3q
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
