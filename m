Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BCB37CD47
	for <linux-rdma@vger.kernel.org>; Sat, 19 Sep 2026 10:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789813022; cv=none; b=dtgxBq9yB3r8EN7SRN2vx39GSkjT2QxGzSrDbcYueSFsLM2Udhr0rrnXvGKlacMfYv6m/56yCxk8zJWatpR+E2m+7GFImSHF6qVCdiaBvYP4DF46QCiBi6ZqrqUIqf3JRCWze8tVBWaGMh1NlUk2Me1X3XaR0nERpBMU58pD3UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789813022; c=relaxed/simple;
	bh=T9NuK5S1Mr8vwFy3xHM3wkGVpFzw9w43q8ponFnA9gM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=O/fG7yPxYMrUvRQy1tcgVbGjRcmYZkBvRq76bck5XddOWgFiuCy1pdI4zbG+KD368w/uBuYF9nTAmXRPFPV0cXJrstK/XIYUDL+lq0pJpjgPj9HOcwYAdu7c17cFcqVO5eMRkmTtz3vFEr224HvDKJfg2azYf5rNZyriTboBpWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gxuQlOzE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gxuQlOzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1241C1F000FF;
	Sat, 19 Sep 2026 10:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789813021;
	bh=/ewkryq0Zet45ynYUozqhX2UiVjG5C6rgT/at3RF+sk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gxuQlOzEDpTk4Dp+p84QwTSm4QlcglSpskkcOkHYi8UjHsbK+n0mzKhMgD49+hkFT
	 NzDndhJx7U6UzXxcv68fGUhgdpgpqqOhLVW6r1hl9zHsxOBCshROHbEFmp/0z2gMmC
	 BDU/XoN6tRScPXnTjyioddNWH0BjPTWaPIajsXiH9OQoh5fYhffN2B+pN93pCLlVzc
	 rgJO24bfzHiyVK+arvPdCe5fuiJsMVC10HcU/BCd6exlmHAMKZxiaCfxln5dtz6Vp6
	 3cVZ44HTIO1XbBLogkZ4nkgtAWZ9e8EXBkuhR2VJF2DemYAQqJuN+5fVo4g6bJcfTY
	 hZfzRMpVlClfA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Check SIG_ERR CQE mkey lookup before
 dereferencing
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919100806.2320-1-lirongqing@baidu.com>
References: <20260919100806.2320-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 10:17:00 +0000
Message-Id: <20260919101701.1241C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] rdma/mlx5: un-ratelimited warning in CQ polling loop causes log =
flood
--

commit c105d16aafdc1a586e27b8a4c8ea42b5926b0203
Author: Li RongQing <lirongqing@baidu.com>

RDMA/mlx5: Check SIG_ERR CQE mkey lookup before dereferencing

This commit adds a NULL check after looking up a signature context in
mlx5_poll_one() to prevent a crash when a memory region is concurrently
deregistered. If the lookup fails, it drops the lock, logs a warning, and
fetches the next completion.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5=
/cq.c
> index 49b4bf148a4a0..b0b1177077aa0 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -563,6 +563,13 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
>  		xa_lock(&dev->sig_mrs);
>  		sig =3D xa_load(&dev->sig_mrs,
>  				mlx5_base_mkey(be32_to_cpu(sig_err_cqe->mkey)));
> +		if (!sig) {
> +			xa_unlock(&dev->sig_mrs);
> +			mlx5_ib_warn(dev, "CQN: 0x%x Got SIGERR on unknown mkey: 0x%x\n",
> +				     cq->mcq.cqn,
> +				     be32_to_cpu(sig_err_cqe->mkey));
> +			goto repoll;

[Severity: Medium]
Could this un-ratelimited warning lead to console flooding and CPU soft
lockups?

A stream of MLX5_CQE_SIG_ERR completions with unknown mkeys (which can be
triggered by remote peers sending invalid data to a registered memory regio=
n)
causes mlx5_poll_one() to repeatedly call mlx5_ib_warn() and jump to the
repoll label.

Because goto repoll fetches the next completion queue entry without returni=
ng,
it bypasses the CQ polling budget entirely. This could allow a remote attac=
ker
to intentionally stream invalid packets to flood the queue, weaponizing the
loop into a denial of service vector.

Should this use a ratelimited print, and possibly avoid bypassing the polli=
ng
budget?

> +		}
>  		get_sig_err_item(sig_err_cqe, &sig->err_item);
>  		sig->sig_err_exists =3D true;
>  		sig->sigerr_count++;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919100806.2320=
-1-lirongqing@baidu.com?part=3D1
