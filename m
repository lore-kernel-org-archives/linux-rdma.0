Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336047;
	b=SMqX6LZlD/qJYdH51+KeQJ8Ej/dQMQqSsxWps2ZK9fFKoJqUKqf07vAO6xb8CF3s3dW/
	 nJkgRaVXFs6FhiOfFdIkPhvPH7RgJGfVPJlQVIKopVoYX4JVV5TgDIczu5tami4zPDXcf
	 UAbsvYkU1DSmRLbaDaHp9qGh1c/yhnghnm11KSzm6PeBqoF+WSNXu5NML/u0USLUsVwaM
	 A+ap4K2ORKQA0SIDuFq4YWSKByxVMoNoEayEFwXC1EwdBJgg1HNSBbVxhG8yBpO0pCUv6
	 SEx2+qGKPnXSaQepImMLIHKpoHy8UkIHAIMCnO8RYpyGL7g/S6Si2pXW+0FbeLSVqMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336047;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cBex81e0yFizMSixzjyQPt2pLS5gx4uroBWLUxGmOvU=;
	b=1+kBbx3/aRS+PAHFwbJr5Nfo1YVAFNIjATSQ2EBw9EXVtyjYkutiyAyCj1h+8gLXsQyS
	 54uFT3m9UsRlfYrHo/rwzP5EvrHaO8PZq8A8bc2yqOXNGLaM05XM5cl5sw9NguTP1LL4s
	 bTRAkSUYGj6Vv1j7ZodP1HPmM5OnQxwHsbTvvx8VqHwCviCJm9CpweKJJia6UeIQfB6gG
	 yehcx3OJu1+ynnNYeHAtVCCp15wUqC9l6QFW2P51BtrohIi/QTOV4Qt1QkXRyVRerWzZQ
	 0m963JrK5ZFuhX16IEs3VQ2djosBMfj40iNJr92hHpHt5JJcyoni8o2UwZj255OHeMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FNUcEYxw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F859606A320
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FNUcEYxw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C031F0093A;
	Fri, 30 Oct 2026 04:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336047;
	bh=cBex81e0yFizMSixzjyQPt2pLS5gx4uroBWLUxGmOvU=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=FNUcEYxw4ovXOeWGvmFqM9CVlDR6BH3zr+vjgFhMT6IUk/X3B9GVLLWiy4LsavSED
	 hSWtoW7ZKCgqh0K0Et60w6XxOP3XdM+XjUmm7/yHUMODWgsm6WqJ37xYiRjO5oPxsq
	 3WQ+FYuo56w1AxeMVk+3kR/WH+NHx8co4JbSS0250YSqIJy8GwW8dW6eH/vxdvcrBX
	 K6KWKJfot6pCZdxLTwq9V6A8ddKzq1l+FS66bZSkUaXgmhpJFL1JoN0xN1sfpenuzv
	 MIFEKEau7lt5ZNS8KI90ux2W8hiTkmCL9xehjafDzi/VF0xyD+O/4v0GRuLONHUQXb
	 UHRquo+9A8Whw==
Message-ID: <sashiko-outbox-190403@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 net-next 9/9] octeontx2-af: npc: cn20k: Allocate
 npc_priv and dstats dynamically.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ratheesh Kannoth" <rkannoth@marvell.com>, intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260508034912.4082520-10-rkannoth@marvell.com>
References: <20260508034912.4082520-10-rkannoth@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Critical] Global file-scope pointers (`npc_priv` and `dstats`) are overw=
ritten by per-device dynamic allocations, leading to memory leaks and Use-A=
fter-Free crashes in multi-device systems.
- [High] Unconditional memory leak of `npc_priv` during the `npc_priv_init(=
)` error path.
- [High] Unconditional memory leak of `npc_priv` and all its allocations if=
 `npc_setup_mcam_section()` fails.
- [High] Missing NULL pointer checks for `npc_priv` in debugfs and asynchro=
nous handlers leads to NULL pointer dereferences.
- [High] Out-of-bounds array access due to unvalidated hardware geometry ex=
ceeding static array capacities.
- [High] Pre-existing memory leak of `defrag_lh` nodes during `npc_cn20k_de=
init()`.
- [High] Pre-existing out-of-bounds write in `npc_create_srch_order()` when=
 `num_subbanks` is 1.
--

commit dfbf4e512f9599787a56a7a0ecf88e54713d70e8
Author: Ratheesh Kannoth <rkannoth@marvell.com>
Subject: octeontx2-af: npc: cn20k: Allocate npc_priv and dstats dynamically.

This commit modifies the npc_priv and dstats structures to be dynamically
allocated instead of file-scope statics. It handles initialization and
teardown of these allocations and updates usages across the code paths.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/debugfs.c b/=
drivers/net/ethernet/marvell/octeontx2/af/cn20k/debugfs.c
> index 9a4c2ea5b19e4..15af7b0ccea64 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/debugfs.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/debugfs.c
[ ... ]
> -static u64 dstats[MAX_NUM_BANKS][MAX_SUBBANK_DEPTH * MAX_NUM_SUB_BANKS] =
=3D {};
> +static u64 (*dstats)[MAX_NUM_BANKS][MAX_SUBBANK_DEPTH * MAX_NUM_SUB_BANK=
S];
[ ... ]
> @@ -396,6 +396,10 @@ int npc_cn20k_debugfs_init(struct rvu *rvu)
>  	debugfs_create_file("vidx2idx", 0444, rvu->rvu_dbg.npc,
>  			    npc_priv, &npc_vidx2idx_map_fops);
> =20
> +	dstats =3D devm_kzalloc(rvu->dev, sizeof(*dstats), GFP_KERNEL);
> +	if (!dstats)
> +		return -ENOMEM;
> +

Since dstats is a file-scoped static pointer, will it be overwritten if
multiple RVU PCI devices are probed on the same system?

It looks like devm_kzalloc ties the allocation to a specific device. If that
device is unbound, the devres framework will automatically free the memory.
Could this leave the global pointer dangling and cause a use-after-free for
any remaining active devices that try to access the debugfs file?

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c b/driv=
ers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
> index 15b3f29d60ee9..ea8fc43df0902 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.c
> @@ -16,9 +16,7 @@
>  #include "cn20k/reg.h"
>  #include "rvu_npc_fs.h"
> =20
> -static struct npc_priv_t npc_priv =3D {
> -	.num_banks =3D MAX_NUM_BANKS,
> -};
> +static struct npc_priv_t *npc_priv;

Similarly, since npc_priv is also a file-scoped global pointer, could probi=
ng
multiple devices cause previous allocations to be overwritten and leaked?
Should this per-device state be stored within a device-specific context
structure instead of a global pointer?

[ ... ]
> @@ -4185,8 +4183,8 @@ int rvu_mbox_handler_npc_get_pfl_info(struct rvu *r=
vu, struct msg_req *req,
>  		return -EOPNOTSUPP;
>  	}
> =20
> -	rsp->kw_type =3D npc_priv.kw;
> -	rsp->x4_slots =3D npc_priv.bank_depth;
> +	rsp->kw_type =3D npc_priv->kw;
> +	rsp->x4_slots =3D npc_priv->bank_depth;
>  	return 0;
>  }

If a Virtual Function sends a mailbox message before initialization is
complete or after teardown, could npc_priv be NULL here? Does this handler
need a NULL pointer check to prevent a crash?

[ ... ]
> @@ -4599,34 +4597,40 @@ static int npc_priv_init(struct rvu *rvu)
>  		return -EINVAL;
>  	}
> =20
> -	npc_priv.num_subbanks =3D num_subbanks;
> +	npc_priv =3D kcalloc(1, sizeof(*npc_priv), GFP_KERNEL);
> +	if (!npc_priv)
> +		return -ENOMEM;
> +
> +	npc_priv->num_banks =3D num_banks;
> +
> +	npc_priv->num_subbanks =3D num_subbanks;
> =20
>  	subbank_depth =3D	bank_depth / num_subbanks;
> =20
> -	npc_priv.bank_depth =3D bank_depth;
> -	npc_priv.subbank_depth =3D subbank_depth;
> +	npc_priv->bank_depth =3D bank_depth;
> +	npc_priv->subbank_depth =3D subbank_depth;
> =20
>  	/* Get kex configured key size */
>  	cfg =3D rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(0));
> -	npc_priv.kw =3D FIELD_GET(GENMASK_ULL(34, 32), cfg);
> +	npc_priv->kw =3D FIELD_GET(GENMASK_ULL(34, 32), cfg);
> =20
>  	dev_info(rvu->dev,
>  		 "banks=3D%u depth=3D%u, subbanks=3D%u depth=3D%u, key type=3D%s\n",
>  		 num_banks, bank_depth, num_subbanks, subbank_depth,
> -		 npc_kw_name[npc_priv.kw]);
> +		 npc_kw_name[npc_priv->kw]);
> =20
> -	npc_priv.sb =3D kcalloc(num_subbanks, sizeof(struct npc_subbank),
> -			      GFP_KERNEL);
> -	if (!npc_priv.sb)
> +	npc_priv->sb =3D kcalloc(num_subbanks, sizeof(struct npc_subbank),
> +			       GFP_KERNEL);
> +	if (!npc_priv->sb)
>  		return -ENOMEM;

If the allocation for npc_priv->sb fails and returns -ENOMEM, does this leak
the newly allocated npc_priv structure? Should there be a cleanup path here=
 to
free npc_priv?

This isn't a bug introduced by your patch, but in this same file under
npc_create_srch_order():

static int npc_create_srch_order(int cnt)
{
        ...
        for (int i =3D 0; i < cnt; i +=3D 2) {
                subbank_srch_order[i] =3D cnt / 2 - val - 1;
                subbank_srch_order[i + 1] =3D cnt / 2 + 1 + val;
                val++;
        }
        ...
}

If the hardware reports num_subbanks as 1, cnt is 1, and the loop executes
once. Could this cause an out-of-bounds write to subbank_srch_order[1] since
the array size is only 1?

[ ... ]
> @@ -4674,25 +4680,30 @@ void npc_cn20k_deinit(struct rvu *rvu)
>  {
>  	int i;
> =20
> -	xa_destroy(&npc_priv.xa_sb_used);
> -	xa_destroy(&npc_priv.xa_sb_free);
> -	xa_destroy(&npc_priv.xa_idx2pf_map);
> -	xa_destroy(&npc_priv.xa_pf_map);
> -	xa_destroy(&npc_priv.xa_pf2dfl_rmap);
> -	xa_destroy(&npc_priv.xa_idx2vidx_map);
> -	xa_destroy(&npc_priv.xa_vidx2idx_map);
> +	if (!npc_priv)
> +		return;
> +
> +	xa_destroy(&npc_priv->xa_sb_used);
[ ... ]
> +	kfree(npc_priv);
> +	npc_priv =3D NULL;
>  }

This might be a pre-existing issue, but during teardown in npc_cn20k_deinit=
(),
does the defrag_lh list need to be cleared? The list appears to contain
dynamically allocated npc_defrag_show_node structures, and they might be
leaked if they are still present when npc_priv is freed.

[ ... ]
> @@ -4730,7 +4741,5 @@ int npc_cn20k_init(struct rvu *rvu)
>  		return err;
>  	}
> =20
> -	npc_priv.init_done =3D true;
> -
>  	return 0;
>  }

Looking at the earlier part of npc_cn20k_init():

int npc_cn20k_init(struct rvu *rvu)
{
        err =3D npc_priv_init(rvu);
        if (err) { ... }

        err =3D npc_setup_mcam_section(rvu, NPC_MCAM_KEY_X2);
        if (err) {
                dev_err(rvu->dev, "%s: mcam section configuration failure\n=
",
                        __func__);
                return err;
        }
        ...
}

If npc_setup_mcam_section() fails, it returns the error without calling
npc_cn20k_deinit(). Does this leak the npc_priv structure and all of its
internal allocations?

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.h b/driv=
ers/net/ethernet/marvell/octeontx2/af/cn20k/npc.h
> index bf030e40fbf96..ee0bbeba7f259 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cn20k/npc.h
> @@ -191,7 +191,7 @@ struct npc_defrag_show_node {
>   */
>  struct npc_priv_t {
>  	int bank_depth;
> -	const int num_banks;
> +	int num_banks;
>  	int num_subbanks;
>  	int subbank_depth;
>  	DECLARE_BITMAP(en_map, MAX_NUM_BANKS *

Since num_banks and bank_depth are now dynamically read from hardware rather
than using strict compile-time constants, is it possible for a device to
advertise geometry larger than the static sizes used for en_map and dstats
(MAX_NUM_BANKS, etc.)?

Could this cause out-of-bounds reads and writes when accessing those
structures?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508034912.4082=
520-1-rkannoth@marvell.com?part=3D9
