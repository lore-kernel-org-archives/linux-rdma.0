Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA534EA37A
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 11:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789557652; cv=none; b=m5EOEKTE2PxGPj5LA4rbrHV8+ZsoSFqAngDCu8QsoH/5aMHgIQw2afhgLKLCZQt3xESI+3AH3CoGvXsDql2q2c9QWW/qdGb9MYJdTb1VWvy5Up8B7YLJU9JPpJD8nciaTN98SgXezp6R8g5OWMZyjDA++6MPcoPd6bQXGUih+Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789557652; c=relaxed/simple;
	bh=2Ptk+zE8iHfCdpqGsXqvE9rcVaS6is/aeszx25Czvaw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kVx7VZie/7h0FHse/r1SaCOQhm+ejYwa5sMGV1t9PBAt4GNvqQWUrxKuxYps54ZMYjtRLQlP3hlAXr1zVoziZNHRRIuCOMX+1/x37fkc76Icf4Y1vsBQVA/QJ97Ad0e3e896i55HxstGcIYNqyBamsl02RgcOTidrDqFAvHRavQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4jzBSF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4jzBSF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145DD1F00899;
	Wed, 16 Sep 2026 11:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789557630;
	bh=PugFxO6q/KEhZtn7htfEEQb8niUxZ+OgOtmIRmtKdok=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a4jzBSF3sN3KE8aVYcCfcXEMBbBT0VJ8Twc3behXt5w75S6hV/2OLUd6roYZHs4D0
	 3k1SqiBwpy/BfgwcBRU756uvFFM9DKHfElbpvUNRSiNMb7falG7Q+JKQKJ97JvNaAz
	 ND78uKwlUq+R05+ssA8K9ld5a5wEFaJiU5aeKtvnT9MZPmvxjoX9HtMPOp5wpBNmEZ
	 +gXqea+ELcrKzV+6/9rrg2Go0/UfGVb6rHAkNbazzcoX0MdGUH3Mt1PoFX3iKNRfDK
	 ztPnjtVOfmIredMHnRFeep25ywo2mrfdWeaWdi59rLMYL/XzmVg6xMMRI6rMRNn8k0
	 r17937OHm9tmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 4/6] net/mlx5: HWS, Add timeout mechanism to
 draining send queues
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915111912.3926585-5-tariqt@nvidia.com>
References: <20260915111912.3926585-1-tariqt@nvidia.com>
 <20260915111912.3926585-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 11:20:29 +0000
Message-Id: <20260916112030.145DD1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mlx5: HW UAF when queue drain timeout leaves pending WQEs
- [Medium] mlx5: false timeout error when send queue drains exactly at time=
out boundary
--

commit 61f83bb352e1062985b4a65a41c453e002f769ea
Author: Yevgeny Kliteynik <kliteyn@nvidia.com>

net/mlx5: HWS, Add timeout mechanism to draining send queues

This commit introduces a timeout mechanism for draining send queues in the
hardware steering (HWS) layer, returning an error if polling exceeds the
timeout limit.

[ ... ]
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> index 49dee44d0bef5..9ff109fc8230a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
[ ... ]
> @@ -1213,9 +1215,18 @@ int mlx5hws_send_queue_action(struct mlx5hws_conte=
xt *ctx,
>  			mlx5hws_send_engine_flush_queue(queue);
> =20
>  		/* Poll queue until empty */
> -		while (wait_comp && !mlx5hws_send_engine_empty(queue))
> +		while (wait_comp && !mlx5hws_send_engine_empty(queue)) {
>  			hws_send_engine_poll_cq(queue, NULL, &polled, 0);
> =20
> +			if (unlikely(time_after(jiffies, timeout))) {

[Severity: Medium]
If the queue successfully drains on this exact iteration, or if the thread
is preempted after polling and before the timeout check, does this
unconditionally return -ETIMEDOUT?

Since hws_send_engine_poll_cq() processes the completions, checking the
timeout immediately without verifying if the queue is now empty might
cause callers to improperly abort and roll back fully successful operations.

> +				mlx5hws_err(ctx,
> +					    "Error draining send queue %d - TIMEOUT (%d sec)\n",
> +					    queue_id,
> +					    MLX5HWS_BWC_POLLING_TIMEOUT);
> +				return -ETIMEDOUT;

[Severity: High]
When returning -ETIMEDOUT here, the send queue still contains pending
hardware WQEs that are not cleared or aborted. Can this lead to a
hardware use-after-free?

Callers react to this error by destroying the allocated hardware resources.
For example, if mlx5hws_arg_create() receives the timeout error:

mlx5hws_arg_create()
    mlx5hws_arg_write_inline_arg_data()
        mlx5hws_send_queue_action()  <-- times out
    if (err)
        mlx5hws_cmd_arg_destroy(ctx->mdev, id); // id is freed

Because the hardware queue is not stopped and the pending WQEs are not
aborted, couldn't the firmware later process the stuck WQE and write to
the freed resource ID, potentially corrupting firmware state or crashing?

> +			}
> +		}
> +
>  		break;
>  	default:
>  		return -EINVAL;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915111912.3926=
585-1-tariqt@nvidia.com?part=3D4
