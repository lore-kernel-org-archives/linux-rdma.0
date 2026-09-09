Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F433B14DD
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 06:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936943; cv=none; b=cSYIrwMA+DY9kPaFEiSquHtRTKd/OWUTBw+TlPnn63QgEs75U06Y3CYJ2PCL8BpbirUYUhEI56zCm6Tv29V1UPhV2mPr924rUev4cdPX/aAzbbPgHYBYbVZkmxkMMQphrA1r2a+djXrFTUbdyZoPRUYVd3gpBl4l6I8hzsRZev0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936943; c=relaxed/simple;
	bh=HrZzOPbm2wo3JOpf4A1gbjszUJldekUDGHMWOAFAfPA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iZyd7UQhVMpr05z8ZhPXjZQgtxN+RUM/XxkyGJtE+yfh7/uCqQU4xki5EQ5/vnZSMKoThEHhMJhyNh6CrX0FuvzHw22xz1nenmjjqRdTpx2CD7rs97FukrjX2yB8Gr24B4caDdYN3E13XBgRlBR2g5gG6IJab7EBv5WLqyJMpNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGsHV3ip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGsHV3ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B80D1F00ACA;
	Wed,  9 Sep 2026 06:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936942;
	bh=6MD1KbIPm60biEdyTY6jaq7ewaxkM294UH4cH8FVuTM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PGsHV3ipaBIxXHXb+B7nRtStBw3MD3AdqoMNkdiSm3teJBXQ1KK5gNf2a2pADSDPd
	 v+97QItBbsbGYwiD4/SqIRWPb5ksaGxO4Le4u37pwBfY2b9HQHgTHQlgfwx88vT8Qk
	 /8SxuwEv4vk4yIhBElgRiA1bADunADOKgj+2/47PO5cY3P0ev6+mrfN6V/p03zBtQW
	 G5aEDXjvHfqLoFaFLV+r4Mq2mw9yu4tyJVXZFgsmAk465MVRzi1OYZSN7vxXMumm9E
	 nefMVJRWlDc1WCslBZgqH/gKEcNsg8HSxiX/pG2lFs60q6aeZ7VqIApMZeqV6Ax3Qx
	 M5ntMbYx95MFQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V4 07/14] net/mlx5e: macsec: Move RX marker
 from ft_metadata to flow_tag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908065244.3799142-8-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-8-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:55:41 +0000
Message-Id: <20260909065542.4B80D1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Deterministic NULL pointer dereference in macsec_fs_id_del during =
error recovery.
- [High] The function `macsec_fs_id_del` frees an RCU-protected `struct mlx=
5_fs_id` synchronously with `kfree()` instead of deferring it via RCU, risk=
ing a use-after-free.
--

commit b66a5cce46cf15521232a2fb7c33b033c4391c99
Author: Cosmin Ratiu <cratiu@nvidia.com>
net/mlx5e: macsec: Move RX marker from ft_metadata to flow_tag

This commit changes the MACsec marker from bit 30 of ft_metadata to a
dedicated flow_tag protocol ID. It updates steering rules and helper macros
accordingly to prevent conflicts with PSP SPI values.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
> index efc5167493c12..4ca3a6ded2841 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
> @@ -1803,6 +1805,11 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macse=
c_fs,
> =20
>  		macsec_fs_rx_setup_fte(spec, &flow_act, attrs, false);
> =20
> +		spec->flow_context.flags |=3D FLOW_CONTEXT_HAS_TAG;
> +		spec->flow_context.flow_tag =3D
> +			FIELD_PREP(MLX5E_ACCEL_FLOW_TAG_PROTO_MASK,
> +				   MLX5E_ACCEL_FLOW_TAG_PROTO_MACSEC);
> +
>  		flow_act.modify_hdr =3D modify_hdr;
>  		flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
>  				  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |

[Severity: High]
This isn't a bug introduced by this patch, but later in this function during
error recovery, there is a deterministic NULL pointer dereference:

macsec_fs_rx_add_rule() {
    ...
	err =3D macsec_fs_id_add(&macsec_fs->macsec_devices_list, fs_id,
			       macsec_ctx->secy->netdev,
			       &macsec_fs->fs_id_hash, attrs->sci, false);
	if (err) {
		mlx5_core_err(mdev, "Failed to save fs_id, err=3D%d\n", err);
		goto err;
	}
    ...
err:
	macsec_fs_rx_del_rule(macsec_fs, rx_rule, macsec_ctx->secy->netdev,
			      fs_id);
	macsec_rule =3D NULL;
}

When macsec_fs_id_add() fails (e.g., due to memory allocation failure), it
cleans up by freeing the newly allocated macsec_device and removing it from
the list. However, the err block then unconditionally calls
macsec_fs_rx_del_rule(), which in turn calls macsec_fs_id_del():

macsec_fs_id_del() {
    ...
	fs_id_xa =3D (is_tx) ? &macsec_device->tx_id_xa :
			     &macsec_device->rx_id_xa;
	xa_lock(fs_id_xa);
    ...
}

Since macsec_device was never successfully added, the lookup fails and
returns NULL. Computing fs_id_xa from a NULL macsec_device pointer and
calling xa_lock() on it causes a direct NULL pointer dereference. Could
the error path be updated to avoid calling macsec_fs_id_del() when the
device was not added?

[Severity: High]
This is a pre-existing issue, but macsec_fs_id_del() appears to free
an RCU-protected structure synchronously instead of deferring it via RCU:

macsec_fs_id_del() {
    ...
	rhashtable_remove_fast(fs_id_hash, &fs_id_found->rhash_node,
			       macsec_fs_id_rhash_params);
    ...
	kfree(fs_id_found);
}

Because it does not use kfree_rcu() or wait for an RCU grace period,
concurrent lockless readers running under rcu_read_lock() can access the
freed memory:

mlx5_macsec_fs_get_fs_id_from_hashtable() {
    ...
	mlx5_fs_id =3D rhashtable_lookup(&macsec_fs->sci_hash, sci, rhash_sci);
	if (mlx5_fs_id)
		fs_id =3D mlx5_fs_id->id;
}

If a reader obtains a pointer just before removal, it will dereference it
after the writer has freed it. Should this memory be freed using kfree_rcu()
to prevent use-after-free during concurrent datapath packet processing?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908065244.3799=
142-1-tariqt@nvidia.com?part=3D7
