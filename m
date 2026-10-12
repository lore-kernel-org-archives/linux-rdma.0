Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2D436C0D6;
	Mon, 12 Oct 2026 13:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812024; cv=none; b=vE+MW/10nxbmFAtj3kqvwmE7P9J3m0YR9oe9gDMm8puZ7WA92A+p1U4gtF0fTUphJMvpvAAzEyNabcbgqRPqiTfVRV8jBFcudTiC2+CUUVQdGuvpKwk0fmQbnXxbhM/A5ZQbdFQtXL52D7i+SGXioWywmMV2Av3FPldHW32a2WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812024; c=relaxed/simple;
	bh=JqUgXWON+6+bntjWTf83yFZJzED4XjpGxZwD1jCOx+U=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=UNLor6SxC/esER8jcN3FgnVdZTtfRGtvdSbAP/gm/cA2tKFmm40tpEkUYtdHmr0YG2RcpR5QBJpu1anW0fnNgNzn1WyhmIVpRtI4POS14Mz5imwTa2GvrxMu9tLG9zwfLFMzDo31dhdnXNsRmn5dE+x5+6WmR3aCjx6DkTBKMo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/ehTtty; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/ehTtty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE9B1F0089B;
	Mon, 12 Oct 2026 13:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791812022;
	bh=D15LDEeqeI9N/bgW/pCjTxRVQlTpy79Ogy+0e1U5DQs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g/ehTttyT/xX5YzNlw0hR75xfZ296OokJ17p6HZGYVva+IxMtOBBryXcVR35JQGzq
	 ukhlN3dcIakuqW1/iHU0WhaBhjjwt9DgfFOHJGwZzkGnNHemNGVDpLagPhphzk8Qzs
	 YM+TCt6U8ciiexwViMCbptULyD4/XeQEoHtTzC+DwGCrwgJ11z7Hwlh6lfH5r1iTUb
	 4uISkb8NIEv997qQ2RZzFsgf3EN6GZrk9wen+j55InLlYDsmXoqyyRy+58s90Z2u0m
	 ydqLy69eYQGkNWdPBMishiw5vcOiAN3vUG3sM3t1BkzA7iR5lgfVs/AYyIPGB8aF4V
	 P3po6lYouMi+g==
Message-ID: <sashiko-outbox-168187@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/2] net/mlx5e: Batch ICOSQ trigger RCU
 synchronization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261011133212.807979-3-tariqt@nvidia.com>
References: <20261011133212.807979-1-tariqt@nvidia.com>
 <20261011133212.807979-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:33:41 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] net/mlx5e: Lock bypass in mlx5e_trigger_napi_icosq due to prematur=
e flag clear
- [High] net/mlx5e: race condition in ICOSQ NAPI trigger due to unordered c=
lear_bit
--

commit dcc196ca7d5ea35aa83767536fe42c5734f5a395
Author: Carolina Jubran <cjubran@nvidia.com>

net/mlx5e: Batch ICOSQ trigger RCU synchronization

This commit splits mlx5e_trigger_napi_icosq() to mark ICOSQs as requiring
locking, waits for a single RCU grace period, and then triggers all of them
during channel activation. It also retains the existing synchronization
semantics for standalone callers.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index fe4e5d0b2e9a9..58e4874b664f1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -2837,14 +2837,11 @@ static int mlx5e_channel_stats_alloc(struct mlx5e=
_priv *priv, int ix, int cpu)
[ ... ]
> -void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
> +static void mlx5e_trigger_napi_icosq_post_sync(struct mlx5e_channel *c)
>  {
>  	struct mlx5e_icosq *sq =3D &c->icosq;
>  	bool locked;
> =20
> -	set_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &sq->state);
> -	synchronize_net();
> -
>  	locked =3D mlx5e_icosq_sync_lock(sq);
>  	mlx5e_trigger_irq(sq);
>  	mlx5e_icosq_sync_unlock(sq, locked);
> @@ -2852,6 +2849,13 @@ void mlx5e_trigger_napi_icosq(struct mlx5e_channel=
 *c)
>  	clear_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &sq->state);

[Severity: High]
Can the unconditional clearing of this bit break the lock bypass mechanism
for concurrent callers that have already waited for the RCU grace period?

If concurrent devlink health recoveries for TX and RX reporters run on the
same channel (e.g., mlx5e_tx_reporter_err_cqe_recover() and
mlx5e_rx_reporter_err_rq_cqe_recover()), both will call
mlx5e_trigger_napi_icosq() and set the MLX5E_SQ_STATE_LOCK_NEEDED bit
before calling synchronize_net().

If the first thread to wake up executes mlx5e_trigger_napi_icosq_post_sync(=
),
acquires the lock, and unconditionally clears the bit here, would the second
thread then bypass the lock?

When the second thread executes mlx5e_trigger_napi_icosq_post_sync(), it
calls mlx5e_icosq_sync_lock(). Since the bit was cleared by the first
thread, mlx5e_icosq_sync_lock() would see the bit cleared:

drivers/net/ethernet/mellanox/mlx5/core/en.h:mlx5e_icosq_sync_lock() {
    if (likely(!test_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &sq->state)))
        return false;
    ...
}

Will this cause the second thread to call mlx5e_trigger_irq() without the
lock, racing with NAPI softirq operations and leading to queue corruption?

[Severity: High]
Does this clear_bit() execution lack a memory barrier, allowing it to be
reordered before the doorbell write in mlx5e_trigger_irq()?

spin_unlock_bh() in mlx5e_icosq_sync_unlock() provides RELEASE semantics,
which prevents preceding memory operations from being reordered after the
release. However, it allows subsequent operations, like this clear_bit(),
to be reordered before the release.

If the CPU reorders the clear_bit() operation before the I/O doorbell write
in mlx5e_trigger_irq(), and is delayed, could a concurrent NAPI poll write
new WQEs and its own doorbell, followed by this CPU writing its older
doorbell and corrupting the queue?

>  }
> =20
> +void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
> +{
> +	set_bit(MLX5E_SQ_STATE_LOCK_NEEDED, &c->icosq.state);
> +	synchronize_net();
> +	mlx5e_trigger_napi_icosq_post_sync(c);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011133212.8079=
79-1-tariqt@nvidia.com?part=3D2
