From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/5] Cleanup of
 CONFIG_INFINIBAND_ON_DEMAND_PAGING usage
Date: Sat, 22 Dec 2018 11:18:30 +0200
Message-ID: <20181222091830.GK3940@mtr-leonro.mtl.com>
References: <20181220092318.32672-1-leon@kernel.org>
 <20181221033235.GA771@ziepe.ca>
 <20181221135954.GF3940@mtr-leonro.mtl.com>
 <20181221165912.GB13168@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n83H03bbH672hrlY"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181221165912.GB13168@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--n83H03bbH672hrlY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 21, 2018 at 09:59:12AM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 21, 2018 at 03:59:54PM +0200, Leon Romanovsky wrote:
>
> > > diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> > > index c6144df47ea47e..c2615b6bb68841 100644
> > > +++ b/drivers/infiniband/core/umem.c
> > > @@ -95,6 +95,9 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
> > >  	struct scatterlist *sg, *sg_list_start;
> > >  	unsigned int gup_flags = FOLL_WRITE;
> > >
> > > +	if ((access & IB_ACCESS_ON_DEMAND) && !context->invalidate_range)
> > > +		return ERR_PTR(-EOPNOTSUPP);
> > > +
> >
> > My expectation that we won't be in this state because it is too far away
> > from entry where we could check and prevent unsupported access.
> >
> > uverbs entry point -> driver code -> ib_umem_get
> >   ^^^^ this is better place to check right flags.
>
> I view umem as the proper core entry point here. We should never
> allow to create an ODP umem without driver support.

And drivers should never ask ODP umem if they don't support it.
You are requesting to add by definition unreachable code.

>
> > > @@ -3607,13 +3606,15 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
> > >
> > >  	copy_query_dev_fields(ucontext, &resp.base, &attr);
> > >
> > > -	resp.odp_caps.general_caps = attr.odp_caps.general_caps;
> > > -	resp.odp_caps.per_transport_caps.rc_odp_caps =
> > > -		attr.odp_caps.per_transport_caps.rc_odp_caps;
> > > -	resp.odp_caps.per_transport_caps.uc_odp_caps =
> > > -		attr.odp_caps.per_transport_caps.uc_odp_caps;
> > > -	resp.odp_caps.per_transport_caps.ud_odp_caps =
> > > -		attr.odp_caps.per_transport_caps.ud_odp_caps;
> > > +	if (ib_dev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING) {
> > > +		resp.odp_caps.general_caps = attr.odp_caps.general_caps;
> > > +		resp.odp_caps.per_transport_caps.rc_odp_caps =
> > > +			attr.odp_caps.per_transport_caps.rc_odp_caps;
> > > +		resp.odp_caps.per_transport_caps.uc_odp_caps =
> > > +			attr.odp_caps.per_transport_caps.uc_odp_caps;
> > > +		resp.odp_caps.per_transport_caps.ud_odp_caps =
> > > +			attr.odp_caps.per_transport_caps.ud_odp_caps;
> > > +	}
> >
> > "attr" is initialized to zero, there is no need to place those odp_caps under "if",
>
> It is not zero, it is the result of query_device - and broken drivers
> should not be allowed to put non-zero values here..

Do you have real example in mind? Because if we have such broken drivers
in subsystem, we would see it already, because ODP config is enabled by
default in many distributions.

>
> > >  	resp.timestamp_mask = attr.timestamp_mask;
> > >  	resp.hca_core_clock = attr.hca_core_clock;
> > > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > > index ff131e4c874ec5..df8366fb0142d6 100644
> > > +++ b/drivers/infiniband/hw/mlx5/main.c
> > > @@ -923,9 +923,11 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
> > >  	props->hca_core_clock = MLX5_CAP_GEN(mdev, device_frequency_khz);
> > >  	props->timestamp_mask = 0x7FFFFFFFFFFFFFFFULL;
> > >
> > > -	if (MLX5_CAP_GEN(mdev, pg))
> > > -		props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
> > > -	props->odp_caps = dev->odp_caps;
> > > +	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
> > > +		if (MLX5_CAP_GEN(mdev, pg))
> > > +			props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
> > > +		props->odp_caps = dev->odp_caps;
> > > +	}
> >
> > I accepted your claim about odp_caps being SW properties, but why did
> > you place device_cap_flags under CONFIG_INFINIBAND_ON_DEMAND_PAGING?
> > Especially when it is set based on HW capability.
>
> My claim was about device_cap_flags, it indicates the SW capability
> for ODP, it has nothing to do with HW.

ODP doesn't exist without HW support.

>
> > >
> > >  	if (MLX5_CAP_GEN(mdev, cd))
> > >  		props->device_cap_flags |= IB_DEVICE_CROSS_CHANNEL;
> > > @@ -1761,7 +1763,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
> > >  	if (err)
> > >  		goto out_sys_pages;
> > >
> > > -	context->ibucontext.invalidate_range = &mlx5_ib_invalidate_range;
> > > +	if (ibdev->attrs.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING)
> > > +		context->ibucontext.invalidate_range = &mlx5_ib_invalidate_range;
> >
> > We are not supposed to call to invalidate_range() if umem is not ODP.
> > It means that the below "if" is redundant.
>
> I want to see all function pointers the driver does not implement set
> to NULL... I suppose this needs to have an IS_ENABLED too since
> mlx5_ib_invalidate_range is in odp.c

No problem

>
> > > diff --git a/drivers/infiniband/hw/mlx5/mem.c b/drivers/infiniband/hw/mlx5/mem.c
> > > index 9f90be296ee0f7..22827ba4b6d8eb 100644
> > > +++ b/drivers/infiniband/hw/mlx5/mem.c
> > > @@ -150,7 +150,7 @@ void __mlx5_ib_populate_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
> > >  	struct scatterlist *sg;
> > >  	int entry;
> > >
> > > -	if (umem->is_odp) {
> > > +	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && umem->is_odp) {
> >
> > How can we have is_odp == True and CONFIG_INFINIBAND_ON_DEMAND_PAGING = n?
> > mlx5 code expects that if CONFIG_INFINIBAND_ON_DEMAND_PAGING is not set,
> > all occurrences of is_odp are false.
>
> Whenver you see the IS_ENABLED it is just size optimizing code. The
> compiler can't know that is_odp == FALSE, so the extra check is
> needed.a

It is always correct, but why is it important in this path and why
is_odp being in processor cache wouldn't enough? IMHO, you are saving
first cache miss only.

>
> > > diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> > > index 65d07c111d42a7..8183e94da5a1ea 100644
> > > +++ b/drivers/infiniband/hw/mlx5/mr.c
> > > @@ -1332,12 +1332,14 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
> > >  	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx, access_flags 0x%x\n",
> > >  		    start, virt_addr, length, access_flags);
> > >
> > > -	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && !start &&
> > > -	    length == U64_MAX) {
> > > +	if (!start && length == U64_MAX) {
> > >  		if (!(access_flags & IB_ACCESS_ON_DEMAND) ||
> > >  		    !(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
> > >  			return ERR_PTR(-EINVAL);
> > >
> > > +		if (!IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
> > > +			return ERR_PTR(-EOPNOTSUPP);
> > > +
> >
> > I tried to preserve previous behavior and that piece of code was simply
> > skipped if CONFIG_INFINIBAND_ON_DEMAND_PAGING is not set. You will
> > return -EOPNOTSUPP in new code. It can be right, it can be wrong, but
> > that change should be standalone.
>
> Sure - it is a bug that it checks arguments differently depending on
> compile options.

I'll take a look on it later and will send followup if needed.

Regarding rest of your comments, how will we converge?

I disagree with most of your points and believe that you are proposing
to fix non-existing problems with dead code. If you insist, I'll add
your code as long as it helps us to progress here, should I.

Thanks

>
> Jason

--n83H03bbH672hrlY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcHgFmAAoJEORje4g2clinraMP/jkpzRlAkfSHVLNEHnOcd9iH
29zVEhhHyzu8ndfrb8TAun2uAZTTmndg7Hy0UC1cESRM6y/+cFDutWqdNn1PZ/+l
va/M3+P2938+nGdc7yhLiVKuUSV/Tjgh8nEa1ezth3llhW4VBt1wzv4LZZ4muZMe
zegNnfB3TY3ozWsbDVcVebLpaatuyOTMENtfqh2eOuq+1LaysrbxqdQ77SB71/NR
lduMdxc+JsDbe/DuvvoQP0V1F3Kxv0DthxbbbEedmUItYyXbioOFinrw1BQ0Evp7
H7paTkadCe5KrleBRM/Bzqn3qbBNVta/daH2Vn0XFhkxZv3/kOi3TgTuB72ZAlqS
zsXoYoIdZCYRCUCwYhPOn31Mv+4nYEN/EI1o/V9TPK627/k90Xsa618MrEwQDS3L
2jYGrXTsCvQI5jdm7P7ckDIH5WcKl2AEW0PTVfFHUgQ08vLZjXvmabigvvxEwWIZ
IOYhzahZ9Yvd1R/UpV0E/kp570KhbXCPGSlTKw8dW4n8ktAadTny4Uwq7iQxZxWd
UREU1cNWKl8VYWyKJhafahalrcV03QXaGgc1hRV3fwF5QiLbhnejOmG3/O67EitV
oEHmfw0RDfInA8FXui7GX+PCg+moBXK4b7Mc2asMWGm5SPY8xHfWJ6eBfzVug12S
AwXt8bpN4VlBi7uQP+2t
=olrI
-----END PGP SIGNATURE-----

--n83H03bbH672hrlY--
