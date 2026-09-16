Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FA04A0EFE
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 23:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789599649; cv=none; b=kkVnppChgl65pH0uObyn7K+e2FGbXRah2dIv0FSj6v0yuw6SgDhfK3B7JtP0cFyEvoAMWVfs0UbGffI4ap5EJWjqOQGAr23lUQWWlyKUbzoNPJ8O8J/NVuu2VIAkstqjvAKdyVvPtq2gvDtPU2jBxOMi3oNY/GHb6pVFEh7wOnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789599649; c=relaxed/simple;
	bh=4lRP0phCJA3IjcgdC83YxhjQYcotVvk1QPb7VYPLboc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bsI4G9c0FtqjsWrbvKUrw0y9Nljyl5uiKQtX/hDtcgAs8VZa1QjbOt2m9NJ6mQaRNb7lx2eGvwLnXRw/QI/Lzd9u8w+BsI6rZnvs3olQJq2MmUBQCLLyTFDz5ClJy9mGfhIWVvXvF8gH1Ce3bDDlhWRVSCoK2jhszRmi3SErHrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJ3evgos; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJ3evgos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BD21F00893;
	Wed, 16 Sep 2026 23:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789599642;
	bh=cJnpBFjeaCcAf57N8UHLuOq2JIOqgTSxb3Y6R7+nnKs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oJ3evgoszj3pHTEE7aB2pG2+KSrfSbvDuqOlFsqv3Qm5Z6KuM39PmRx4NXiOJU1Ey
	 KmwSeoMeearF3oRFyAgaQmlk5/BFKUPfq28Ap3tbpF5TOzezx4sRrYAHzvDkQolTFt
	 tH+YRJGxfmBAMk9pw5tFQdUWYVW+s0s4bW2M74ypIEjz8/DXZxY0DNc20Is8JvDg6m
	 KfMIHj9j+N7EkyGhBvqKzRl0XzqVVPFHLmSJvSgSswP3I5VdkOXuP84Oyn1Q/6Irjm
	 Zen+1ocIwR067UY83lvUNiSBbAGRnDVdnFiI7vgJVsrAiLLNa6iqIVRITZ4VL2eqS7
	 UIw4eYFp3kOrQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 2/2] net/mlx5: Don't return firmware-owned command
 mailboxes to the DMA pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Danielle Costantino" <dcostantino@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915225941.554568-3-dcostantino@meta.com>
References: <20260915225941.554568-1-dcostantino@meta.com>
 <20260915225941.554568-3-dcostantino@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:00:41 +0000
Message-Id: <20260916230041.E1BD21F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] net/mlx5: data race on own_msgs causes DMA pool UAF
--

commit 0cea3fb4e0d198ed012c8154db5a71dcabb95879
Author: Danielle Costantino <dcostantino@meta.com>

net/mlx5: Don't return firmware-owned command mailboxes to the DMA pool

This commit transfers ownership of timed-out command mailboxes to the comma=
nd
entry rather than returning them to the DMA pool. This prevents late firmwa=
re
completions from overwriting the pool's free list pointers. The mailboxes a=
re
later leaked or freed during teardown.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/=
ethernet/mellanox/mlx5/core/cmd.c
> index 571ed540957b1..890a2a2613ca0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
[ ... ]
> @@ -207,6 +214,15 @@ static void cmd_ent_put(struct mlx5_cmd_work_ent *en=
t)
>  	}
>  	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
> =20
> +	/* These were withheld from dev->cmd.pool because firmware still owned
> +	 * them.  Nothing references the entry any more, so whoever dropped the
> +	 * last reference has established that firmware is done with them.
> +	 */
> +	if (ent->own_msgs) {
> +		mlx5_free_cmd_msg(dev, ent->out);
> +		free_msg(dev, ent->in);
> +	}
> +
>  	cmd_free_ent(ent);
>  }

[Severity: Critical]
If mlx5_cmd_invoke() and cmd_reclaim_stalled_ents() race to update
ent->own_msgs without synchronization, this block in cmd_ent_put() might
execute.

Does this risk freeing mailboxes into an already destroyed DMA pool,
leading to a use-after-free?

[ ... ]
> @@ -1313,7 +1335,19 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *d=
ev, struct mlx5_cmd_msg *in,
>  		return 0; /* mlx5_cmd_comp_handler() will put(ent) */
> =20
>  	err =3D wait_func(dev, ent);
> -	if (err =3D=3D -ETIMEDOUT || err =3D=3D -ECANCELED || err =3D=3D -EBUSY)
> +	if (err =3D=3D -ETIMEDOUT) {
> +		/* The command was posted to firmware and firmware never
> +		 * completed it.  Unless the device is already down,
> +		 * mlx5_cmd_comp_handler(forced) keeps this entry and its
> +		 * queue slot allocated because firmware may still complete
> +		 * it, so ent->lay->{in_ptr,out_ptr} keep referencing the
> +		 * mailboxes.  Take ownership of them so that cmd_exec()
> +		 * cannot hand them back to dev->cmd.pool.
> +		 */
> +		ent->own_msgs =3D true;
> +		goto out_free;
> +	}

[Severity: Critical]
If a synchronous firmware command times out, the thread wakes up from wait_=
func()
and sets ent->own_msgs =3D true without synchronization in mlx5_cmd_invoke(=
).

This could overwrite the ent->own_msgs =3D false set concurrently by the te=
ardown
process.

Can the issuer thread clobber the safe leak configuration set during teardo=
wn?

[ ... ]
> +static void cmd_reclaim_stalled_ents(struct mlx5_core_dev *dev, bool fw_=
stopped)
> +{
> +	struct mlx5_cmd_work_ent *ent;
> +	struct mlx5_cmd *cmd =3D &dev->cmd;
> +	unsigned long flags;
> +	int i;
> +
> +	for (i =3D 0; i < (1 << cmd->vars.log_sz); i++) {
[ ... ]
> +		/* The entry itself is never visible to firmware - the only
> +		 * addresses it is ever given are the mailbox and command
> +		 * queue DMA addresses - so it can always be retired.  Its
> +		 * mailboxes are a different matter: hand those back only once
> +		 * firmware has acknowledged it released the function.  If it
> +		 * has not, drop ownership without freeing.  dma_pool_destroy()
> +		 * then reports the pool busy and skips dma_free_coherent(),
> +		 * so the pages stay mapped and are never handed back to the
> +		 * allocator; a late write lands there harmlessly.
> +		 */
> +		if (!fw_stopped)
> +			ent->own_msgs =3D false;

[Severity: Critical]
Teardown correctly attempts to leak the mailboxes to prevent memory corrupt=
ion by
setting ent->own_msgs =3D false in cmd_reclaim_stalled_ents().

However, if the issuer thread concurrently sets ent->own_msgs =3D true, the
mailboxes will be incorrectly freed.

Is it possible for the teardown process to be raced by the issuer thread?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915225941.5545=
68-1-dcostantino@meta.com?part=3D2
