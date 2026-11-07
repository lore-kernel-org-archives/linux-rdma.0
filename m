Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083097;
	b=ERBr0p4LGRGtxIXR8JrYX5M21YbKoEvfiT0p7wcTNrenWSVADuWHRwAf0Dx+WUbeZr2c
	 wQs7Wi/fFRq4GyHvwazK+CPTsTG7eLSPivgCdWHjbJ1hMEAH5IlogIF5RprQdh2tJdyiV
	 QKEtxcwUH0Pp2t3cpcrOfE5PAAB98B7U8ctp36MeV0dLKfeO1jB19yojahG1uHPffXn7J
	 soeoiYtRt2aQCvFiEmRQ9UEdSzk/DN1JUscqhzmgeMozkuWUuHtZcSnXbgYYhZHP5km7g
	 VP8tfMSZTcXyrVXUxBCRELtdORa9norl+x8FqTmxn9W38mDKqZSCaH5PrRITKrknMYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083097;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=6Dw1YRkgcLO/oD8ddIOC1gEFJ7z5lNWsBJO3xTMRSCU=;
	b=Wl/JiCE46Aqj3/GFtdVE8GNR4/h38JPjtXIuFnCeA1z0Zi2dnd+GGT0O+D+U4oAHq9Yn
	 yzbeDgSyYCB/RtXZEUhm4rgR7ZaHUCDeuK+VZsWdYR+z01ZSfRdXYk/4AM6NnsbUsieda
	 aqqdgCweHVNekz1bKyMeLBq0iVarK89+SHhEHpK7loi0VopR4SKeHdXRVToNMZegMnVFs
	 ECJ1gsS0eWnbYMsZUiPpsa0FjateRbia/mk45XX9AewjwwMrCY2EfX3J+jLGmpK+ZNI0h
	 0crUXPBPUCILJfQ6b0wChBG+hjg2axv7WWOWak9fPeBrlJtIVhrmiU8Zl7PgZ+GxFRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcI3upDF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98120606A332;
	Sat,  7 Nov 2026 20:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcI3upDF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B551F0089F;
	Sat,  7 Nov 2026 20:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083097;
	bh=6Dw1YRkgcLO/oD8ddIOC1gEFJ7z5lNWsBJO3xTMRSCU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=kcI3upDFiTr1hd97C6h5ILfXfTvO/rnn57aYX1Ojhse8SnXm6jR83yceUjjDrcovQ
	 IKahu+NdfsSKa/0cqXJ60OpuAMKDgNzcIr/JqTbXNPKIcAanNqBvRMwOoKuvQ4moe7
	 rvOaf14WltPAyw+wR6eI3+erOwbCsj7i3YgIzlSkYGf5Jv7hHEzNqGF1Xf+NoqulDP
	 nRtGT9RkGpYbXm6jTn/dwee1nZ2EOE/BZnQRHmHexDrXksrU9lIRsSRX1WEd0+HM98
	 BZo1T/PEq03d+1lNq7m3Rt9y01Yujq++esiDrisUElOLK+sf6RbJD/4sS9AysT72wH
	 eiCVgxgynL61g==
Subject: Re: [PATCH rdma-next 13/23] RDMA/mlx5: Keep the UMR QP failed once a
 forged CQE is detected
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:56 +0000
Message-ID: <179408309600.994134.14553230868146108147@kernel.org>
In-Reply-To: <20261103163949.1554-14-yishaih@nvidia.com>
References: <20261103163949.1554-14-yishaih@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In adversarial mode, mlx5r_umr_recover()
  (drivers/infiniband/hw/mlx5/umr.c) checks for MLX5_UMR_STATE_ERR at…
- [Medium] The new comment on mlx5r_umr_move_state() (umr.c:338-343) and
  the commit message both say that in adversarial mode ERR is a final…

--

RDMA/mlx5: Keep the UMR QP failed once a forged CQE is detected

In adversarial mode, this commit changes mlx5r_umr_recover() to move the
UMR state with cmpxchg(): ACTIVE to RECOVER on entry and RECOVER to
ACTIVE at the end. The goal is to stop recovery from overwriting an
MLX5_UMR_STATE_ERR that the CQ poller sets on a forged CQE. Outside
adversarial mode the transitions are unchanged.

> diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
> index b0f00d4bc93ca..086b397b830c6 100644
> --- a/drivers/infiniband/hw/mlx5/umr.c
> +++ b/drivers/infiniband/hw/mlx5/umr.c
> @@ -335,6 +335,23 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey,
>  	return err;
>  }
>  
> +/*
> + * Move the UMR state from @from to @to. In adversarial_mode ERR is a final
> + * state: it can be set concurrently by the CQ poller, so the move is atomic
> + * and does not replace it. Returns false if ERR was found, and true
> + * otherwise. Outside adversarial_mode this is the plain store it always was.
> + */

[Severity: Medium]
Is ERR really final here? Only the transitions in mlx5r_umr_recover()
were converted to cmpxchg(). mlx5_ib_poll_one_umr() in cq.c still does a
plain store for every validated non-flush error CQE:

drivers/infiniband/hw/mlx5/cq.c:mlx5_ib_poll_one_umr() {
    ...
		if (wc->status != IB_WC_WR_FLUSH_ERR)
			umrc->state = MLX5_UMR_STATE_RECOVER;
    ...
}

That store can overwrite the ERR written by the err: label in
mlx5r_umr_recover(), and that label does not stop the poller:

err:
	umrc->state = MLX5_UMR_STATE_ERR;
	return err;

Could a hostile NIC reopen the UMR path with a sequence like this?

1. Waiters A and B each post a UMR while the state is ACTIVE.

2. The NIC returns validated non-flush error CQEs for both. A and B enter
   mlx5r_umr_recover(), find the state already RECOVER, skip the entry
   cmpxchg, and post barriers WQE3 and WQE4.

3. The NIC completes WQE3. A moves the QP to RESET, the NIC fails
   RST2INIT, and A's err: label stores ERR.

4. The NIC returns a non-flush error CQE for WQE4. It passes the opcode,
   QPN, sop, wqe_ctr (FIFO head) and wqe_head checks, so the poller
   stores RECOVER over ERR.

5. B's RESET and RST2RTS succeed, and B's cmpxchg(RECOVER->ACTIVE) also
   succeeds, so the UMR path is ACTIVE again.

The generic store of RECOVER in mlx5_poll_one() has the same problem at
this commit. The later commit "RDMA/mlx5: Block generic CQ poll path in
adversarial mode" closes that path by making mlx5_poll_one() return
-EOPNOTSUPP in adversarial mode before the store is reached.

Would a cmpxchg(ACTIVE->RECOVER) in mlx5_ib_poll_one_umr() fix this? If
not, should the comment say that only an ERR set on a forged CQE is
final?

[ ... ]

> @@ -353,7 +370,11 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
>  	if (umrc->state != MLX5_UMR_STATE_RECOVER) {
>  		mlx5_ib_warn(dev, "UMR recovery encountered an unexpected state=%d\n",
>  			     umrc->state);
> -		umrc->state = MLX5_UMR_STATE_RECOVER;
> +		if (!mlx5r_umr_move_state(umrc, MLX5_UMR_STATE_ACTIVE,
> +					  MLX5_UMR_STATE_RECOVER)) {
> +			mutex_unlock(&umrc->lock);
> +			return -EFAULT;
> +		}
>  	}
>  	mutex_unlock(&umrc->lock);

[Severity: Medium]
What happens if the poller detects a forged CQE after this
mutex_unlock()?

mlx5_ib_poll_one_umr() never takes umrc->lock. It sets ERR under cq->lock
and only queues the forced health work:

	umrc->state = MLX5_UMR_STATE_ERR;
	cq->poll_one = mlx5_ib_poll_one_stopped;
	mlx5_trigger_health_work_force(dev->mdev);

After the unlock, mlx5r_umr_recover() does not look at umrc->state again
until the final cmpxchg, so recovery continues:

mlx5r_umr_recover()
  mlx5r_umr_post_send()
    only checks mdev->state, writes the barrier WQE and rings the doorbell
  wait_for_completion()
  ib_modify_qp(umrc->qp, &attr, IB_QP_STATE)  /* RESET */
    __mlx5_ib_modify_qp()->mlx5_ib_cq_clean() sweeps the stopped UMR CQ
  mlx5r_umr_qp_rst2rts()
    RST2INIT/INIT2RTR/RTR2RTS put the hardware UMR QP back in RTS
  mlx5r_umr_move_state(umrc, MLX5_UMR_STATE_RECOVER, MLX5_UMR_STATE_ACTIVE)
    first point where ERR is seen

The NIC controls CQE timing. It can complete the barrier with a valid CQE
and then forge one while recovery is in the RESET/RTS steps. All of this
can happen before the forced health work moves the device to
MLX5_DEVICE_STATE_INTERNAL_ERROR.

umrc->state stays ERR, so mlx5r_umr_post_send_wait() still refuses new
UMRs. Even so, in this window the subject line "Keep the UMR QP failed",
the existing comment "don't revive the QP" in mlx5r_umr_recover(), and
this part of the commit message don't seem fully met:

  This keeps new UMRs away from the NIC until the forced health recovery
  moves the device to MLX5_DEVICE_STATE_INTERNAL_ERROR

In adversarial mode, should ERR be checked again at these points?

- before the barrier post, perhaps inside mlx5r_umr_post_send() under
  qp->sq.lock
- after wait_for_completion()
- before each ib_modify_qp() step

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
