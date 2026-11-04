Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810629;
	b=EDKTxluwEhmXHF2+mR2TnQSb7gCccQRLEn29bT7nWMC2T4T8ugFNkpxKgVRjWrqRadcR
	 ZRrBshoTpE/l17okhJnA+p+IFSHXVwdOc9wiRZvbvZJMavijCXzrqwnDZ6LoIIGaTPdDL
	 d/wTR8v46U6bNQs68k2/EU+fBkM53bp7PLrDSg9/WCgNJQEyBjIlL++gNUz7WTVwuW60C
	 Y6JLZoUjTGKGICrmsqiyzEpc8M+KrwwvOt3TWrebtxetGmrLnSvaof0pJeUBDznfT66um
	 owV4KjcU1wwYvsog4ZVq1SGTmStl64uYEAfqzpl9mWnruVPR7a2PKG8vBkpIoAUmnlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810629;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rOBb3aSYi9go35zhkOk6thfdMxeDPeJ61QjoueYthOY=;
	b=YY5mdLSlyS5F7HvBfwzaj91/nH2foC/jzBbgMbThvnjrxUvoXD7EZ1GdHhmNvaZWAS+y
	 dRL+l3wk9ygdpgmpz3q/BGN02FaPq8tD9cufcbBVktbRFOSOKPA7UTZ1gK59ZRnKVD5KV
	 MDqZHPVAMsG4xfdHIBETHYEDHT/JuvipLAH4DS2s2cBBRTel9bznYz4KPY7JfETDpqK86
	 WyCALr2fxsSzCxnqdZzj7IY1vZjffGypxbpSp0WvZoFdfEA6ftG5ehEYlfJoVG7a6XiTU
	 flQ7SMvzDxj79SNC0bA4eCdCzhD0La1IXFVVQeD/2jkbo0ddyja+cb7MYEaQHULuuxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2Zo3yxw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00DD606A32E
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2Zo3yxw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B691F00919;
	Wed,  4 Nov 2026 16:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810628;
	bh=rOBb3aSYi9go35zhkOk6thfdMxeDPeJ61QjoueYthOY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=o2Zo3yxwYllHhxAPtbQYNJVdc+MH/RCs4ZwNCah2wa9H5F6ePwlCvFkY2BFvPaVT5
	 zdg8eDix0dMwlddfvz5PWtT3CfNBf1m0Riiy9KxcahiqwIK/Zn2NKcvEQoolgBTmwx
	 U17wRQQUZ/0vsxhwnyK/IIKC3aEttkpbUdvp1K6UW914lNF13w0EXNBji45Vd/8GBj
	 h195Sq4Ccc57CtmUOa4r0mDYnHZZO2RqhLS4rh1O1lej4Dm4oKvaLUrIc68KOqQ2ax
	 vQZ1Mhq5EsxPGGJwOcE9kfjeBXQ3SLY7BsyEwqjhlJxkKePa2VR8dDYJ2229jqP0X2
	 +muebHuvqsULw==
Message-ID: <sashiko-outbox-197666@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 13/23] RDMA/mlx5: Keep the UMR QP failed once
 a forged CQE is detected
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-14-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-14-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/mlx5: unserialized mlx5r_umr_recover() and ERR state overwrite
--

commit a4c9a11e36d34c06e5a6a8bce8ad178d57157c1a
Author: Yishai Hadas <yishaih@nvidia.com>

RDMA/mlx5: Keep the UMR QP failed once a forged CQE is detected

This commit updates mlx5r_umr_recover() to transition umrc->state using
cmpxchg() when mlx5_ib_adversarial_mode is enabled so that a concurrent
transition to MLX5_UMR_STATE_ERR by the CQ poller is not overwritten back to
MLX5_UMR_STATE_RECOVER or MLX5_UMR_STATE_ACTIVE.

> diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx=
5/umr.c
> index b0f00d4bc93ca..086b397b830c6 100644
> --- a/drivers/infiniband/hw/mlx5/umr.c
> +++ b/drivers/infiniband/hw/mlx5/umr.c
> @@ -335,6 +335,23 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u=
32 mkey,
>  	return err;
>  }
> =20
> +/*
> + * Move the UMR state from @from to @to. In adversarial_mode ERR is a fi=
nal
> + * state: it can be set concurrently by the CQ poller, so the move is at=
omic
> + * and does not replace it. Returns false if ERR was found, and true
> + * otherwise. Outside adversarial_mode this is the plain store it always=
 was.
> + */
> +static bool mlx5r_umr_move_state(struct umr_common *umrc, unsigned int f=
rom,
> +				 unsigned int to)
> +{
> +	if (!mlx5_ib_adversarial_mode) {
> +		umrc->state =3D to;
> +		return true;
> +	}
> +
> +	return cmpxchg(&umrc->state, from, to) !=3D MLX5_UMR_STATE_ERR;
> +}
> +
>  static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
>  			     struct mlx5r_umr_context *umr_context,
>  			     struct mlx5r_umr_wqe *wqe, bool with_data)
> @@ -353,7 +370,11 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev=
, u32 mkey,
>  	if (umrc->state !=3D MLX5_UMR_STATE_RECOVER) {
>  		mlx5_ib_warn(dev, "UMR recovery encountered an unexpected state=3D%d\n=
",
>  			     umrc->state);
> -		umrc->state =3D MLX5_UMR_STATE_RECOVER;
> +		if (!mlx5r_umr_move_state(umrc, MLX5_UMR_STATE_ACTIVE,
> +					  MLX5_UMR_STATE_RECOVER)) {
> +			mutex_unlock(&umrc->lock);
> +			return -EFAULT;
> +		}
>  	}
>  	mutex_unlock(&umrc->lock);
> =20
> @@ -387,7 +408,9 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev,=
 u32 mkey,
>  		goto err;
>  	}
> =20
> -	umrc->state =3D MLX5_UMR_STATE_ACTIVE;
> +	if (!mlx5r_umr_move_state(umrc, MLX5_UMR_STATE_RECOVER,
> +				  MLX5_UMR_STATE_ACTIVE))
> +		return -EFAULT;

[Severity: High]
Can a hostile NIC still cause concurrent mlx5r_umr_recover() executions and
overwrite MLX5_UMR_STATE_ERR back to MLX5_UMR_STATE_ACTIVE?

In mlx5_ib_adversarial_mode, up to 64 threads can concurrently post UMR WRs
in mlx5r_umr_post_send_wait() under umrc->sem, placing their contexts into
umrc->pending[]. If a hostile NIC returns valid-header MLX5_CQE_REQ_ERR
completions (matching qpn, sop =3D=3D MLX5_OPCODE_UMR, and sequential wqe_c=
tr)
with a non-flush syndrome (such as MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR, where
wc->status !=3D IB_WC_WR_FLUSH_ERR) for multiple in-flight WRs,
mlx5_ib_poll_one_umr() accepts each CQE and unconditionally writes
MLX5_UMR_STATE_RECOVER:

drivers/infiniband/hw/mlx5/cq.c:mlx5_ib_poll_one_umr() {
	...
	} else {
		/* Copy the CQE, so its syndrome is read once */
		err_cqe =3D *(struct mlx5_err_cqe *)cqe64;
		mlx5_handle_error_cqe(dev, &err_cqe, wc);
		/* As in the generic path, a real failure starts the recovery */
		if (wc->status !=3D IB_WC_WR_FLUSH_ERR)
			umrc->state =3D MLX5_UMR_STATE_RECOVER;
	}
}

Multiple waiters in mlx5r_umr_post_send_wait() then wake up with
umr_context.status !=3D IB_WC_WR_FLUSH_ERR and call mlx5r_umr_recover().
Because mlx5r_umr_recover() only holds umrc->lock across the initial state
check and treats umrc->state =3D=3D MLX5_UMR_STATE_RECOVER as the normal en=
try
state without serializing recovery callers, multiple threads can run
mlx5r_umr_recover() at the same time.

This appears to allow two problems:

1. If one recovery thread fails at the err label in mlx5r_umr_recover(), it
sets umrc->state =3D MLX5_UMR_STATE_ERR without stopping cq->poll_one:

drivers/infiniband/hw/mlx5/umr.c:mlx5r_umr_recover() {
	...
err:
	umrc->state =3D MLX5_UMR_STATE_ERR;
	return err;
}

When mlx5_ib_poll_one_umr() subsequently processes another non-flush error
CQE for an in-flight WR or barrier WR, its plain store overwrites
MLX5_UMR_STATE_ERR back to MLX5_UMR_STATE_RECOVER, allowing a concurrent
recovery thread's mlx5r_umr_move_state(umrc, MLX5_UMR_STATE_RECOVER,
MLX5_UMR_STATE_ACTIVE) call to succeed and reopen the UMR path to
MLX5_UMR_STATE_ACTIVE.

2. When the first recovery thread's barrier WR completes and it calls
ib_modify_qp(umrc->qp, IB_QPS_RESET), __mlx5_ib_modify_qp() resets the QP
and zeroes qp->sq.head, qp->sq.tail, qp->sq.cur_post, and qp->sq.last_poll
while the second recovery thread's barrier WR is still queued in
umrc->pending and sleeping in wait_for_completion(&umr_context->done). Does
that desynchronize umrc->pending from qp->sq and leave the second thread
hung in wait_for_completion() while holding umrc->sem, since even the
internal-error software flush in sw_comp() walks from last_poll to head?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D13
