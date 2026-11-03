Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745306;
	b=M4MUNrn09g31h31wySsraDf0ISYtnTQR0x2eo//tx6s7sLlAL75RNlgGEzmxG5NWJdlu
	 bdNHqODElE/OTa+Z8+bQgaWa3BKB3XDG09MN9tJvPgiIKhhgBkNT3pvhSw6fxSp4UFJjn
	 QkpnOHD/qXi7VZjooMjM5DCX1uXHVeuDfGZuWZu/p/FkSMJKlYFm34B4gUnGY11ExR5sF
	 PB+wf7Iy+Bg3BUql6Ttws3YjrNbk8YAQvs8ASFqXu2x9S/idpA2H7x1XC0K1gKlDJmqKQ
	 p+Jx+96ENOjSBQJS6yRMnpC9uV/QMnGP+HxUI34ixPZMhAXIm3Aoit1/Jl/QhasM8Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745306;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cdBZw+dfxiWIXnURhPxctfuOyJ/xFpKYwYJ9vwTEOhc=;
	b=lx3eM97wmz6XMAgpidtece5y0/d39xbCJDFBFjW9/0jrNk0OeOmPam2bB3N1GB7YMhVm
	 6gex1JSEUCB3MbRj6Ty1JVZjXenxONRQGBpPqaSLmdO0jO/cJUw66E7DpCS11MTNLN8NR
	 5EJpQNi5Jf+FMKNbnWxBPuhvRxEwzzrQ6wQaiueOhhuTZDlAAbEkzIZFZRCtFunn1yIea
	 O+6pScfgahDhPJ7pVeSKClaudktELhVJ4I8kERHvlELX7QKCMsfKialtEcqvLAS7NCni4
	 Ks61t/PraWj+15HIWAuQwWCjnfJvNEzPovkKIJ7hXVnZvHqsvwO1Ia1hJ6x+Yw43Sgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QNABUiC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816AA606A326
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QNABUiC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067FD1F0093A;
	Tue,  3 Nov 2026 22:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793745306;
	bh=cdBZw+dfxiWIXnURhPxctfuOyJ/xFpKYwYJ9vwTEOhc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=QNABUiC4//jYhY93YsbS/QB48EtcfiTaWjFHNERFzppMjsZj+Kb23UugKK4H3DC5g
	 rFJeHPvipG9qfzGmF1qXym2ghMK7gQ9G1g2MODzKZSlAplefCrZ5pwLZ0HY2F4QryS
	 6nvE+V4i1WpgQ9G6W3Eit2Cxf/Kp/+QByuSxWJfZYu6vyg6AYmHJSVW22MY44j/uoW
	 5AadZZ6evnABIQ4W/eS1767M0lOJQ7hN8XNoRVPouVcRwt1KAXDMlf/3iGxXQphVIz
	 SGyu5Pr9XbSDxbRM8Zz1Xj1Bf3kzhucJosb8hyZdFnGirhTH8iyVzsuXHnGVNNv8L/
	 2nb5Em2/XjYJQ==
Message-ID: <sashiko-outbox-196140@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 15/15] RDMA/mlx5: Enforce relaxed ordering
 when HW requires it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Gur" <michaelgur@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261102223325.2115128-16-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-16-michaelgur@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:35:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] RDMA/mlx5: stripped RO flag in FRMR key breaks mlx5r_create_mkeys()
- [High] RDMA/mlx5: ordering check bypass in reg_user_mr_dmabuf_by_data_dir=
ect()
--

commit 939d1d09c02a86f15171e7a38c5bf57aaefbee3f
Author: Michael Gur <michaelgur@nvidia.com>

RDMA/mlx5: Enforce relaxed ordering when HW requires it

This commit adds validate_ordering_access() to reject MR registrations and
FRMR pool requests that do not specify IB_ACCESS_RELAXED_ORDERING or
IB_ACCESS_UNORDERED when the hardware sets
mkc_order_write_after_write_ro_only.

> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5=
/mr.c
> index 6848515e06d77..7952d80349dc6 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -78,6 +78,16 @@ static void set_mkc_access_pd_addr_fields(void *mkc, i=
nt acc, u64 start_addr,
>  	MLX5_SET64(mkc, mkc, start_addr, start_addr);
>  }
> =20
> +static int validate_ordering_access(struct mlx5_ib_dev *dev, int acc)
> +{
> +	/* If HW disallows Strong Ordered writes, RO/UNORDERED must be set */
> +	if (MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro_only)) {
> +		if (!(acc & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED)))
> +			return -EOPNOTSUPP;
> +	}
> +	return 0;
> +}
> +
>  static void assign_mkey_variant(struct mlx5_ib_dev *dev, u32 *mkey, u32 =
*in)
>  {
>  	u8 key =3D atomic_inc_return(&dev->mkey_var);
> @@ -288,6 +298,7 @@ static int mlx5r_build_frmr_key(struct ib_device *dev=
ice,
>  				struct ib_frmr_key *out)
>  {
>  	struct mlx5_ib_dev *dev =3D to_mdev(device);
> +	int err;
> =20
>  	/* check HW capabilities of users requested frmr key */
>  	if ((in->ats && !MLX5_CAP_GEN(dev->mdev, ats)) ||
> @@ -297,6 +308,10 @@ static int mlx5r_build_frmr_key(struct ib_device *de=
vice,
>  	if (in->vendor_key & ~MLX5_FRMR_POOLS_KEY_VENDOR_KEY_SUPPORTED)
>  		return -EOPNOTSUPP;
> =20
> +	err =3D validate_ordering_access(dev, in->access_flags);
> +	if (err)
> +		return err;
> +
>  	out->ats =3D in->ats;
>  	out->access_flags =3D
>  		mlx5r_umr_get_unchangeable_access_flags(dev, in->access_flags);

[Severity: High]
Can this cause mkey creation to fail when mkc_order_write_after_write_ro_on=
ly
is set and the device supports modifying relaxed ordering via UMR?

In mlx5r_build_frmr_key() (as well as _mlx5_frmr_pool_alloc() and
mlx5_mr_cache_alloc()), out->access_flags is filtered through
mlx5r_umr_get_unchangeable_access_flags():

drivers/infiniband/hw/mlx5/umr.h:mlx5r_umr_get_unchangeable_access_flags() {
	unsigned int ret =3D access_flags & IB_ACCESS_UNORDERED;
	...
	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
	    MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro) &&
	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
		ret |=3D IB_ACCESS_RELAXED_ORDERING;

	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
	    (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
		ret |=3D IB_ACCESS_RELAXED_ORDERING;

	return ret;
}

When order_write_after_write_umr and pci_relaxed_ordered_read_umr are
supported, IB_ACCESS_RELAXED_ORDERING is stripped from key.access_flags.

When ib_frmr_pools_set_pinned() or ib_frmr_pool_pop() later calls
mlx5r_create_mkeys(), it passes that stripped key->access_flags to
set_mkc_access_pd_addr_fields():

drivers/infiniband/hw/mlx5/mr.c:mlx5r_create_mkeys() {
	...
	set_mkc_access_pd_addr_fields(mkc, key->access_flags, 0, dev->umrc.pd);
	MLX5_SET(mkc, mkc, free, 1);
	MLX5_SET(mkc, mkc, umr_en, 1);
	...
}

Because neither IB_ACCESS_RELAXED_ORDERING nor IB_ACCESS_UNORDERED remains =
in
key->access_flags, mlx5r_access_to_mkey_order(key->access_flags) returns
MLX5_MKEY_ORDER_STRICT, leaving order_write_after_write as 0 in mkc on
hardware that requires relaxed ordering.

In addition, because the stored pool->key.access_flags has
IB_ACCESS_RELAXED_ORDERING stripped, querying a pool via
RDMA_NLDEV_CMD_FRMR_POOLS_GET and passing that key back to
RDMA_NLDEV_CMD_FRMR_POOLS_SET will fail validate_ordering_access() in
mlx5r_build_frmr_key() with -EOPNOTSUPP.

Should mlx5r_create_mkeys() ensure free mkeys are created with relaxed
ordering (similar to how mlx5_set_umr_free_mkey() passes
IB_ACCESS_RELAXED_ORDERING), or should mlx5r_umr_get_unchangeable_access_fl=
ags()
and mlx5r_build_frmr_key() account for mkc_order_write_after_write_ro_only?

[ ... ]

> @@ -1028,6 +1052,10 @@ struct ib_mr *mlx5_ib_reg_user_mr_dmabuf(struct ib=
_pd *pd, u64 offset,
>  		    "offset 0x%llx, virt_addr 0x%llx, length 0x%llx, fd %d, access_fla=
gs 0x%x, mlx5_access_flags 0x%x\n",
>  		    offset, virt_addr, length, fd, access_flags, mlx5_access_flags);
> =20
> +	err =3D validate_ordering_access(dev, access_flags);
> +	if (err)
> +		return ERR_PTR(err);
> +
>  	/* dmabuf requires xlt update via umr to work. */
>  	if (!mlx5r_umr_can_load_pas(dev, length))
>  		return ERR_PTR(-EINVAL);

[Severity: High]
As reported by Sashiko on v1 [1], if MLX5_IB_UAPI_REG_DMABUF_ACCESS_DATA_DI=
RECT
is set in mlx5_ib_reg_user_mr_dmabuf(), doesn't
reg_user_mr_dmabuf_by_data_direct() bypass this ordering check when
mkey_ro_valid is false?

In mlx5_ib_reg_user_mr_dmabuf(), validate_ordering_access() checks
access_flags before calling reg_user_mr_dmabuf_by_data_direct():

drivers/infiniband/hw/mlx5/mr.c:reg_user_mr_dmabuf_by_data_direct() {
	...
	if (!dev->mdev->data_direct->mkey_ro_valid)
		access_flags &=3D ~IB_ACCESS_RELAXED_ORDERING;
	crossed_mr =3D reg_user_mr_dmabuf(pd, &data_direct_dev->pdev->dev,
					offset, length, virt_addr, fd,
					access_flags, MLX5_MKC_ACCESS_MODE_KSM,
					NULL);
	...
	crossing_mr =3D reg_create_crossing_vhca_mr(pd, virt_addr, length,
						  crossed_mr->ibmr.lkey,
						  access_flags);
	...
}

If the user passes IB_ACCESS_RELAXED_ORDERING and mkey_ro_valid is false,
IB_ACCESS_RELAXED_ORDERING is cleared after validate_ordering_access() has
already succeeded, so reg_user_mr_dmabuf() and reg_create_crossing_vhca_mr()
proceed with strong-ordered access_flags.

Furthermore, if the user passes IB_ACCESS_UNORDERED (without
IB_ACCESS_RELAXED_ORDERING), validate_ordering_access() succeeds, but
_mlx5r_umr_update_mr_pas() only checks IB_ACCESS_RELAXED_ORDERING when
selecting between mdd->mkey_ro and the strong-ordered mdd->mkey:

drivers/infiniband/hw/mlx5/umr.c:_mlx5r_umr_update_mr_pas() {
	...
			if (mr->access_flags & IB_ACCESS_RELAXED_ORDERING &&
			    mdd->mkey_ro_valid)
				cur_ksm->key =3D cpu_to_be32(mdd->mkey_ro);
			else
				cur_ksm->key =3D cpu_to_be32(mdd->mkey);
	...
}

Should validate_ordering_access() also be checked after adjusting
access_flags in reg_user_mr_dmabuf_by_data_direct(), and should the Data
Direct path also handle IB_ACCESS_UNORDERED consistently with
IB_ACCESS_RELAXED_ORDERING?

[1] https://lore.kernel.org/r/20260726092943.2880176-16-michaelgur@nvidia.c=
om

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102223325.2115=
128-1-michaelgur@nvidia.com?part=3D15
