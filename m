Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010655;
	b=YxLbRV/lHhbSy7dIFqU6i8R0RB5M7JRsNeGOY5Opgz7h8yRTc12yYBECo5hUSqDKv7o+
	 lm6AQ8RorrxfgxPFMNPVRLXPAgJzOEtgT02wuKwzukpOn0sWM0yXs865ZvoLSIl6H7vpE
	 C6CI86vO7btOXljwEkP9c8Alk/nbteczj295u935vSWtIJj/P3sTwDNdXlq+rRqmuS/zW
	 5hVras92lEpJRyTkJ9IQkVLu6ZsLWoNZbZRDFzgN286/Tiq5hljDWJhyjSMCtZOoRXw4L
	 5WLOzAcZzHjm2md/2P2WW9pivutcGhgImHQPGkzjNoWlsGmHt62x51+6A7FQxOcU+fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010655;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EQOQZFrkvwo1zsHF/5mHhzSx5Q7iG+U/S/puwp3Egu8=;
	b=nTujE9xtlYm4hAzirbffPcVXJLERcPGPh2r6L9ipUNI2lhjlCDcXVex9K/In9o2Te9aD
	 Y5wgkHAswY5Ta72AZdObbks9PuwcA2wAnK1AAnxC02cuUVRbV1QzZye77tNQdiU/qYbD5
	 p9c9LtjPB/P/72ZkcFOWrKOAZgLAyvLiUIsH3PBKe8cj/pt3NfBPVlQncUlau1lqau92v
	 nycuklNJfpymmff+2fs6oH+roVpOVn2ALf6UEnMsc0uo0QEZjLMwWdUUAH3tb3/iRKd3j
	 IXgXG6u+OgeKccBz2KDIS7dGs1KVwsE6oVd2179lNJM8uRh1Lz/51JTliIRWpafxSKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YrV2fjNT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E01606A320
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YrV2fjNT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65F61F000C4;
	Wed, 18 Nov 2026 14:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010654;
	bh=EQOQZFrkvwo1zsHF/5mHhzSx5Q7iG+U/S/puwp3Egu8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YrV2fjNTAvpiNz6XONrxESFJQdHVIkRzd6cjyv/n0olc7tdYqbQdnDdkcBL3gHW9o
	 cEr6N/sGmVTwLIyESuwdl+1pXEyhoGddzyPYTz+HV00HEM2XpODfQ+WYwPXnPienUQ
	 bpdPLESBxd+ZGK7FlnI5P6CNZ0VbfDYBTV2LZnbtwsnhLAw6JOrwBgpbb2LgijtYdY
	 Y+KbimiNyOWXxoRVOVSDgP+LKiZJ7VizXfwornP8i2HL0evg1tGLHF/nxslP76PctL
	 DHn9aUCwNKpwZwLyDk6XqW6WjVJM3cuE7HTfFM7zTvFspgsxkRkljQj5EqWKHJ7aJp
	 3k3jV5ST2jBng==
Message-ID: <sashiko-outbox-221130@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 01/11] RDMA/mlx5: Enforce dev/mdev naming for
 device pointers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-mlx5-sd-prep-v1-1-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-1-8efd124c7895@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:04:14 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 2 related pre-existing issues it does not
introduce:
- [Medium] RDMA/mlx5: out-of-bounds read in devx_get_obj_id() on short
  commands [1]
- [High] RDMA/mlx5: deadlock in mlx5_poll_one() [2]
--

commit 3bdcdff9fe049e25d51894257ec6c6716c3a9770
Author: Akiva Goldberger <agoldberger@nvidia.com>

RDMA/mlx5: Enforce dev/mdev naming for device pointers

This commit renames variables, parameters, and struct fields across mlx5_ib=
 so
that dev exclusively refers to struct mlx5_ib_dev pointers and mdev
exclusively refers to struct mlx5_core_dev pointers.

> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/ml=
x5/devx.c
> index fc6f793dcc658..7e84dd15ac1f9 100644
> --- a/drivers/infiniband/hw/mlx5/devx.c
> +++ b/drivers/infiniband/hw/mlx5/devx.c

[ ... ]

> @@ -1652,7 +1652,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_M=
ODIFY)(
>  							  MLX5_IB_ATTR_DEVX_OBJ_MODIFY_HANDLE);
>  	struct mlx5_ib_ucontext *c =3D rdma_udata_to_drv_context(
>  		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
> -	struct mlx5_ib_dev *mdev =3D to_mdev(c->ibucontext.device);
> +	struct mlx5_ib_dev *dev =3D to_mdev(c->ibucontext.device);
>  	void *cmd_out;
>  	int err, err2;
>  	int uid;
> @@ -1677,7 +1677,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_M=
ODIFY)(
>  	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
>  	devx_set_umem_valid(cmd_in);
> =20
> -	err =3D mlx5_cmd_do(mdev->mdev, cmd_in,
> +	err =3D mlx5_cmd_do(dev->mdev, cmd_in,
>  			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_IN),
>  			  cmd_out, cmd_out_len);

[Severity: Medium]
This problem wasn't introduced by this patch, but can devx_get_obj_id() read
past the end of cmd_in [1] when called from
MLX5_IB_METHOD_DEVX_OBJ_MODIFY, MLX5_IB_METHOD_DEVX_OBJ_QUERY, or
MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY?

The uverbs attribute spec only enforces a 16-byte minimum
(general_obj_in_cmd_hdr) on cmd_in, and these handlers call
devx_is_valid_obj_id() -> devx_get_obj_id() without checking that the buffer
is large enough for the opcode-specific object ID field.  For an opcode such
as MLX5_CMD_OP_MODIFY_FLOW_TABLE, reading table_id in modify_flow_table_in =
at
byte offset 20 performs a 4-byte out-of-bounds read when userspace supplies=
 a
16-byte cmd_in.

[ ... ]

> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/ml=
x5/main.c
> index 65455aedd559b..1ecd79929f8cf 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c

[ ... ]

> @@ -4483,7 +4483,7 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_d=
ev *dev)
>  	atomic_set(&dev->mkey_var, 0);
> =20
>  	spin_lock_init(&dev->dm.lock);
> -	dev->dm.dev =3D mdev;
> +	dev->dm.mdev =3D mdev;

[Severity: High]
This problem wasn't introduced by this patch, but can dev->sig_mrs deadlock
in mlx5_poll_one() [2] because mlx5_ib_stage_init_init() initializes
it with xa_init() instead of xa_init_flags(..., XA_FLAGS_LOCK_IRQ)?

Process-context callers such as mlx5_alloc_integrity_descs() and
__mlx5_ib_dereg_mr() take xa_lock on dev->sig_mrs via xa_store() or
xa_erase() with local interrupts enabled, while mlx5_poll_one() takes the
same xa_lock from CQ interrupt context on a MLX5_CQE_SIG_ERR completion:

mlx5_alloc_integrity_descs()
  xa_store(&dev->sig_mrs, ...)
    spin_lock(&xa->xa_lock)
    <hardirq>
      ...
        mlx5_poll_one()
          xa_lock(&dev->sig_mrs)  <-- spins forever

[1] https://sashiko.dev/#/bug/linux-2b4a0b34-fea8-4d2a-87be-350c461b8f4f
[2] https://sashiko.dev/#/bug/linux-4a13b647-d8f7-45a3-8a1e-c17db57fefbb

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-mlx5-sd-pr=
ep-v1-0-8efd124c7895@nvidia.com?part=3D1
