Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022028;
	b=EaExbUCIKB/3IplwGipP5UgvwIUZHhxPqS/n+lwyF4f7a1wUOPvCbcqzutosQKLPvnCJ
	 DuwmuqOavzjENQLOjcc6fdsxlY4ff0xTv3UUyvambP6BJz1YoY8iqipfs5JEKIQxj38Dj
	 Sl4aGhbp9n1iS2ws1Es1h89DEILTdWPSwe2Qse2lqkajf35wae69Rkrx9NMkMNRHUzgjQ
	 aR6gGTs+/t40yefXMPydUbgjYs/dPUOBODu26zp/9yHlBt5UWmlwJ74QtDmexUwza35TZ
	 UXscgajJ94rT/1oRkyV4gI93yfGUlpw60bKYJdMsaOGOTOKeEUz/ZO0wFp0i+MfLbqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022028;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5+Sq0tM6O5PhRnsCHEVzgjdbIuNog0voqrWlOKYmocA=;
	b=o1H7dWzayx1x/HObccZJHrLqJAPUPEu01Ek2YLtEbTN77PdUi9SFGXLEaZa2b5FLgmXh
	 nWJEqL328Jhs4CON6Z2IlP24yMMmDv/0hFEU5qIDf7XnVectFWy8zPRXCHV/+w7CCYfC4
	 Ewg5xVtWUWFP6/HmbCWfbFM2qlnqBwb93hHPX5HxvBk6FBIT7pcJex6/bl/sx+mqxmPwX
	 puXlgpq/3K/NOKr3DbbRLJa3HE1y0m5h6lcgSIxcr9h5DQ473Fsgq0JazAVmTXjZ7hTlL
	 3wY23lsVYiKCbLi9dxrlTqcAQ+mEfdxN+Y6UIdcZ8aoN7bTc80vRP0MmTRgjVp5ZEpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEEjCEg0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEEF606A33A
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEEjCEg0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D94C1F000C6;
	Wed, 18 Nov 2026 17:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022028;
	bh=5+Sq0tM6O5PhRnsCHEVzgjdbIuNog0voqrWlOKYmocA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QEEjCEg0vMoBVQEud3f79BRmTdeQyjqO4dQ770ApORT2yUIa58LJbI4AwI/0cEp4I
	 0vx46YrtvTqMQLnTNxFOjXzQK0JnR7TCw+rYeIFs14ONuxZPcj4tODwc3J8J4Bf9U6
	 W/D7pA7dWZX6JgMrXE7+KrbGDhHzINoMSvc2f1hiehYgQpd0bjVJjaj85qev+PFgm/
	 FnMH1k/+XM5xUAO6xAzE+62uMAB1HnFYGsZ94P/XfSr4cXf9EN7iw2okbpemCxF2bp
	 mWyAzIthNmlTO1gp3/4LAFQorORLL6AtgQGG8Y/1+GAg3BQlNFJgDhwNPE6jYSqK9Q
	 tM4a1H2K6uUJg==
Message-ID: <sashiko-outbox-221613@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 12/21] RDMA/mlx5: Verify UMR CQ polling
 against a hostile NIC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-13-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-13-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] RDMA/mlx5: incomplete umrc->state checks in
  mlx5_ib_poll_one_umr()
- [High] RDMA/mlx5: deadlock and lost flush on forged CQE in
  mlx5_ib_poll_one_umr()
- [Medium] RDMA/mlx5: CQ re-arm loop in mlx5_ib_arm_cq() when umr_verify
  is false
--

commit d8d114091f7d4e4fa6dc6263146eaffadede67be
Author: Yishai Hadas <yishaih@nvidia.com>

RDMA/mlx5: Verify UMR CQ polling against a hostile NIC

This commit adds a dedicated UMR CQ poller for adversarial mode that
validates CQEs against a shadow FIFO of posted UMR requests and triggers
forced health recovery if a forged CQE is detected.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5=
/cq.c
> index 2581a7693585b..a5197318d96f8 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c

[ ... ]

> @@ -608,6 +609,190 @@ static int poll_soft_wc(struct mlx5_ib_cq *cq, int =
num_entries,
> +static int mlx5_ib_poll_one_umr(struct mlx5_ib_cq *cq, struct ib_wc *wc)
> +{

[ ... ]

> +	if (opcode =3D=3D MLX5_CQE_REQ) {
> +		wc->status =3D IB_WC_SUCCESS;
> +	} else {
> +		/* Copy the CQE, so its syndrome is read once */
> +		err_cqe =3D *(struct mlx5_err_cqe *)cqe64;
> +		mlx5_handle_error_cqe(dev, &err_cqe, wc);
> +		/*
> +		 * A real failure during a recovery is forged, the QP
> +		 * only flushes.
> +		 */
> +		if (wc->status !=3D IB_WC_WR_FLUSH_ERR &&
> +		    cmpxchg(&umrc->state, MLX5_UMR_STATE_ACTIVE,
> +			    MLX5_UMR_STATE_RECOVER) !=3D MLX5_UMR_STATE_ACTIVE) {
> +			mlx5_ib_err(dev,
> +				    "UMR error CQE status %d in state %d, possible NIC forgery\n",
> +				    wc->status, READ_ONCE(umrc->state));
> +			goto forged_cqe;
> +		}
> +	}

[Severity: High]
Should mlx5_ib_poll_one_umr() also verify umrc->state for IB_WC_WR_FLUSH_ERR
and MLX5_CQE_REQ completions?

When wc->status is IB_WC_WR_FLUSH_ERR, umrc->state is not checked.  If a
hostile NIC reports MLX5_CQE_SYNDROME_WR_FLUSH_ERR while umrc->state is
MLX5_UMR_STATE_ACTIVE, mlx5_ib_poll_one_umr() accepts the CQE without
changing umrc->state.  The waiter in mlx5r_umr_post_send_wait() then sees
IB_WC_WR_FLUSH_ERR, loops around while umrc->state is still
MLX5_UMR_STATE_ACTIVE, and immediately reposts the WQE without sleeping or
running recovery, allowing repeated flush CQEs to trap the thread in an
unkillable infinite loop.

Conversely, once a non-flush error has moved the QP to error and umrc->state
to MLX5_UMR_STATE_RECOVER, subsequent in-flight WQEs can only flush until
mlx5r_umr_recover() resets the QP, but the MLX5_CQE_REQ branch accepts
completions as IB_WC_SUCCESS without checking that umrc->state is
MLX5_UMR_STATE_ACTIVE.

> +
> +	/* Pop the shadow FIFO head: validated, dispatch to its waiter */
> +	WRITE_ONCE(umrc->pending[head & (MLX5_UMR_MAX_WR - 1)], NULL);
> +	umrc->pending_head =3D head + 1;
> +	wc->wr_cqe =3D &expected->cqe;
> +
> +	wc->qp =3D &qp->ibqp;
> +	wq->tail =3D wq->wqe_head[idx] + 1;
> +	/* Advance wq->last_poll, the internal error flush starts from it */
> +	handle_atomics(qp, cqe64, wq->last_poll, idx);
> +
> +	return 0;
> +
> +forged_cqe:
> +	/* mlx5_ib_poll_cq() updates the CI only for a returned completion */
> +	mlx5_cq_set_ci(&cq->mcq);
> +	/*
> +	 * The NIC forged a CQE. Fail the UMR path for good, ignore any later
> +	 * CQE and force the health recovery, as the fatal sensors still read
> +	 * clean. The internal error flush then completes the waiters. Return
> +	 * an error, not -EAGAIN, as a CQE was consumed.
> +	 */
> +	umrc->state =3D MLX5_UMR_STATE_ERR;
> +	cq->umr_verify =3D false;
> +	mlx5_trigger_health_work_force(dev->mdev);
> +	return -EIO;
> +}

[Severity: High]
Can deferring waiter completion to mlx5_trigger_health_work_force() deadlock
on dev->intf_state_mutex or lose the software flush completion?

During driver teardown, mlx5_uninit_one() and mlx5_unload_one_devl_locked()
hold dev->intf_state_mutex while unregistering mlx5_ib, which deregisters
remaining user MRs via mlx5_ib_dereg_mr() -> mlx5r_umr_revoke_mr() ->
mlx5r_umr_post_send_wait().  If the NIC returns a forged CQE at that point,
stopping CQ polling without completing umrc->pending deadlocks against
force_fatal_report_work:

CPU0                                  CPU1 (health->wq)
----                                  -----------------
mlx5_unload_one_devl_locked()
  mutex_lock(&dev->intf_state_mutex)
  ...
  mlx5r_umr_post_send_wait()
    wait_for_completion(&umr_context.done)
                                      <softirq>
                                      mlx5_ib_poll_one_umr()
                                        mlx5_trigger_health_work_force()

                                      mlx5_fw_fatal_reporter_err()
                                        mutex_lock(&dev->intf_state_mutex)

 *** DEADLOCK ***

In mlx5_uninit_one(), mlx5_unregister_device() has also already set
MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV, so mlx5_dev_is_lightweight() is true and
mlx5_trigger_health_work_force() drops the work item outright.

Even during normal operation, the UMR CQ uses IB_POLL_SOFTIRQ, where
IRQ_POLL_F_SCHED stays set on cq->iop until ib_poll_handler() calls
irq_poll_complete() after __ib_process_cq() returns.  If
mlx5_ib_handle_internal_error() runs on another CPU after mlx5_ib_poll_cq()
checks mdev->state and before ib_poll_handler() calls irq_poll_complete(),
its irq_poll_sched(&cq->iop) call is a no-op, and mlx5_ib_arm_cq() then
returns 0 without rescheduling cq->iop, leaving waiters hung in
wait_for_completion().

> +static int mlx5_ib_poll_cq_adversarial(struct mlx5_ib_cq *cq, int num_en=
tries,
> +				       struct ib_wc *wc)
> +{
> +	int npolled;
> +
> +	if (!cq->umr_verify)
> +		return 0;
> +
> +	for (npolled =3D 0; npolled < num_entries; npolled++) {
> +		if (mlx5_ib_poll_one_umr(cq, wc + npolled))
> +			break;
> +	}
> +
> +	return npolled;
> +}

[Severity: Medium]
Can returning 0 when cq->umr_verify is false cause an interrupt and softirq
re-arm storm via mlx5_ib_arm_cq()?

When forged_cqe sets cq->umr_verify =3D false, it consumes only that single
CQE.  If the NIC placed another CQE behind it in the UMR CQ (or if a CQE
arrives before umr_verify is enabled or after mlx5_ib_cq_stop_polling()
clears it), mlx5_ib_poll_cq_adversarial() returns 0 without advancing
cq->mcq.cons_index.  Because completed < budget, ib_poll_handler() then
calls ib_req_notify_cq() -> mlx5_ib_arm_cq(), which rings the CQ arm
doorbell at the unadvanced cons_index and causes the NIC to fire another
completion EQE immediately in a tight loop.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D12
