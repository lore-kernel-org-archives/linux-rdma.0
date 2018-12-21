From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/5] Cleanup of
 CONFIG_INFINIBAND_ON_DEMAND_PAGING usage
Date: Fri, 21 Dec 2018 15:59:54 +0200
Message-ID: <20181221135954.GF3940@mtr-leonro.mtl.com>
References: <20181220092318.32672-1-leon@kernel.org>
 <20181221033235.GA771@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wtjvnLv0o8UUzur2"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181221033235.GA771@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--wtjvnLv0o8UUzur2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 20, 2018 at 08:32:35PM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 20, 2018 at 11:23:13AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > As a followup to Jason's request to rethink CONFIG_INFINIBAND_ON_DEMAND=
_PAGING
> > usage, this series cleans mlx5_ib and RDMA/core code and it is based on=
 already
> > sent but not yet accepted patch https://patchwork.kernel.org/patch/1073=
5547/
> >
> > It is under extensive testing now, but I wanted to raise awareness as s=
oon
> > as possible for the patch "RDMA/core: Don't depend device ODP capabilit=
ies
> > on kconfig option", which changes behavior for mlx5 devices with
> > CONFIG_INFINIBAND_ON_DEMAND_PAGING set to no.
> >
> > Thanks
> >
> > Leon Romanovsky (5):
> >   RDMA: Clean structures from CONFIG_INFINIBAND_ON_DEMAND_PAGING
> >   RDMA/core: Don't depend device ODP capabilities on kconfig option
> >   RDMA/mlx5: Introduce and reuse helper to identify ODP MR
> >   RDMA/mlx5: Embed into the code flow the ODP config option
> >   RDMA/mlx5: Delete declaration of already removed function
>
> I'm imagining something like this integrated into these patches, what
> do you think?

See my comments below.

>
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/ume=
m.c
> index c6144df47ea47e..c2615b6bb68841 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -95,6 +95,9 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context=
, unsigned long addr,
>  	struct scatterlist *sg, *sg_list_start;
>  	unsigned int gup_flags =3D FOLL_WRITE;
>
> +	if ((access & IB_ACCESS_ON_DEMAND) && !context->invalidate_range)
> +		return ERR_PTR(-EOPNOTSUPP);
> +

My expectation that we won't be in this state because it is too far away
=66rom entry where we could check and prevent unsupported access.

uverbs entry point -> driver code -> ib_umem_get
  ^^^^ this is better place to check right flags.


>  	if (dmasync)
>  		dma_attrs |=3D DMA_ATTR_WRITE_BARRIER;
>
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/co=
re/uverbs_cmd.c
> index 4d28db23f53955..241376bae09540 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -236,8 +236,7 @@ static int ib_uverbs_get_context(struct uverbs_attr_b=
undle *attrs)
>
>  	mutex_init(&ucontext->per_mm_list_lock);
>  	INIT_LIST_HEAD(&ucontext->per_mm_list);
> -	if (!IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) ||
> -	    !(ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
> +	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
>  		ucontext->invalidate_range =3D NULL;

No problem

>
>  	resp.num_comp_vectors =3D file->device->num_comp_vectors;
> @@ -3607,13 +3606,15 @@ static int ib_uverbs_ex_query_device(struct uverb=
s_attr_bundle *attrs)
>
>  	copy_query_dev_fields(ucontext, &resp.base, &attr);
>
> -	resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
> -	resp.odp_caps.per_transport_caps.rc_odp_caps =3D
> -		attr.odp_caps.per_transport_caps.rc_odp_caps;
> -	resp.odp_caps.per_transport_caps.uc_odp_caps =3D
> -		attr.odp_caps.per_transport_caps.uc_odp_caps;
> -	resp.odp_caps.per_transport_caps.ud_odp_caps =3D
> -		attr.odp_caps.per_transport_caps.ud_odp_caps;
> +	if (ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING) {
> +		resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
> +		resp.odp_caps.per_transport_caps.rc_odp_caps =3D
> +			attr.odp_caps.per_transport_caps.rc_odp_caps;
> +		resp.odp_caps.per_transport_caps.uc_odp_caps =3D
> +			attr.odp_caps.per_transport_caps.uc_odp_caps;
> +		resp.odp_caps.per_transport_caps.ud_odp_caps =3D
> +			attr.odp_caps.per_transport_caps.ud_odp_caps;
> +	}

"attr" is initialized to zero, there is no need to place those odp_caps und=
er "if",

>
>  	resp.timestamp_mask =3D attr.timestamp_mask;
>  	resp.hca_core_clock =3D attr.hca_core_clock;
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/ml=
x5/main.c
> index ff131e4c874ec5..df8366fb0142d6 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -923,9 +923,11 @@ static int mlx5_ib_query_device(struct ib_device *ib=
dev,
>  	props->hca_core_clock =3D MLX5_CAP_GEN(mdev, device_frequency_khz);
>  	props->timestamp_mask =3D 0x7FFFFFFFFFFFFFFFULL;
>
> -	if (MLX5_CAP_GEN(mdev, pg))
> -		props->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
> -	props->odp_caps =3D dev->odp_caps;
> +	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
> +		if (MLX5_CAP_GEN(mdev, pg))
> +			props->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
> +		props->odp_caps =3D dev->odp_caps;
> +	}

I accepted your claim about odp_caps being SW properties, but why did
you place device_cap_flags under CONFIG_INFINIBAND_ON_DEMAND_PAGING?
Especially when it is set based on HW capability.

>
>  	if (MLX5_CAP_GEN(mdev, cd))
>  		props->device_cap_flags |=3D IB_DEVICE_CROSS_CHANNEL;
> @@ -1761,7 +1763,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(s=
truct ib_device *ibdev,
>  	if (err)
>  		goto out_sys_pages;
>
> -	context->ibucontext.invalidate_range =3D &mlx5_ib_invalidate_range;
> +	if (ibdev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING)
> +		context->ibucontext.invalidate_range =3D &mlx5_ib_invalidate_range;

We are not supposed to call to invalidate_range() if umem is not ODP.
It means that the below "if" is redundant.

>
>  	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX) {
>  		err =3D mlx5_ib_devx_create(dev, true);
> diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx=
5/mem.c
> index 9f90be296ee0f7..22827ba4b6d8eb 100644
> --- a/drivers/infiniband/hw/mlx5/mem.c
> +++ b/drivers/infiniband/hw/mlx5/mem.c
> @@ -150,7 +150,7 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, =
struct ib_umem *umem,
>  	struct scatterlist *sg;
>  	int entry;
>
> -	if (umem->is_odp) {
> +	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && umem->is_odp) {

How can we have is_odp =3D=3D True and CONFIG_INFINIBAND_ON_DEMAND_PAGING =
=3D n?
mlx5 code expects that if CONFIG_INFINIBAND_ON_DEMAND_PAGING is not set,
all occurrences of is_odp are false.

>  		WARN_ON(shift !=3D 0);
>  		WARN_ON(access_flags !=3D (MLX5_IB_MTT_READ | MLX5_IB_MTT_WRITE));
>
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5=
/mr.c
> index 65d07c111d42a7..8183e94da5a1ea 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1332,12 +1332,14 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *p=
d, u64 start, u64 length,
>  	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx, access=
_flags 0x%x\n",
>  		    start, virt_addr, length, access_flags);
>
> -	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && !start &&
> -	    length =3D=3D U64_MAX) {
> +	if (!start && length =3D=3D U64_MAX) {
>  		if (!(access_flags & IB_ACCESS_ON_DEMAND) ||
>  		    !(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
>  			return ERR_PTR(-EINVAL);
>
> +		if (!IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
> +			return ERR_PTR(-EOPNOTSUPP);
> +

I tried to preserve previous behavior and that piece of code was simply
skipped if CONFIG_INFINIBAND_ON_DEMAND_PAGING is not set. You will
return -EOPNOTSUPP in new code. It can be right, it can be wrong, but
that change should be standalone.

>  		mr =3D mlx5_ib_alloc_implicit_mr(to_mpd(pd), access_flags);
>  		if (IS_ERR(mr))
>  			return ERR_CAST(mr);

--wtjvnLv0o8UUzur2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcHPHaAAoJEORje4g2clina7wQAKSH/dQWWcKWEgpCqKYlKCJA
iCeOHkOIvwQBzlvLou/Q6OCB8tSwts/LNekWFc2V8eeYYL7dXOB41rSX2tvcs5qy
MQNPwQa25xfr6x6cfSxt5HiaxSWox//ipqsQjcekJhwzeX7Ypr5Ahl6qtYSGFax6
2vRRk0KcmOLy0WmjzKHnvBM3S4x6bM3gyG61Vt75dUdoHsafwZ4EtKvDwtEbk/PB
F2tmEV8m0Hewvd46SZ7pOA9BkiQuf3LmNUg/anaSviXv1wHWQpM5icO8J/52+d3f
swtDdbRedm1P2uIYaOzlC890vDJfsvHwkqLoaEY7G48dV5O78B4NZkkqcY88dIZ7
/tDo6MAtxJYS5Z68C15TTVgc+7cVcgxP6pOO+Yplarc7+zTjxG1xkK5iI78qQqJc
K0QMnCB63r9RGMxnMTFiXdxxha4BQsteoxoJlrkFhlsl7LIOLIntAC6t1yOhXEP0
HvbKyfijcwppXmTj/SXT+Tgdz7QD3egTWt8vi8k3jEouU45613cuxoIpqhkXUIDs
8pIiH0fogCNPi6V4vX3SeeD4oPww2NFjJxAx2iYqee0ubqdN7YK6F/0akw6adQsN
oiabx2YTe13BGJFJVirdvXZj1+x0NYLiXd+p2b5DW2Cvvx2Ctz/ZA9p9Ab7SYTxB
otqUfl1kSGrl1yeDHPKA
=14MH
-----END PGP SIGNATURE-----

--wtjvnLv0o8UUzur2--
