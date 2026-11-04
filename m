Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810628;
	b=2M6c9EwJ4f4FQ40KCFIzcPjPO9qJ+8eP+8WJHO1BBAV7OLaV5XdUPEsQym4Jdo7GVFlR
	 nZSLDF+9MXOiEtbUQqE9zUCrn0uFrmz608KbV1MN/1OXQ8nj5Vw8TCbz5ZHfDS0EEwWUg
	 BOUqGZdKKbHLSX2KkYI4hgZZVSZF8lOctDrlMdclM80h8b7fi0xz0/2KYYXEy67hLgVEH
	 Ml3gRm7ojdVoTLgFd7OnDo+kxzQkxonK4Ba1qGad8yU+NkNIO8m74y1kWUMyCGR3jGUSj
	 5Qfo0pfAegYhMUTYFZ2bHIUzD9O8TZVNUhw2w9v9BYcbx/5O7WE+B5KIbtI1fzcGCzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810628;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hKZfKBPVhdVjPpI8D6uZjoENDn8UjeOdlwwJIdEv9/Y=;
	b=03xfe8EqLpunqWAKJYozq7AG2GMoz3GcgwnD4iQZr1WXkqmFghRwhbazay95OK855Kxq
	 0anmFfA6Pe1ZHCtpfKl2VG44GbhdFSEgJwP9UHFnrFLthRqw1aeu2OZ+1JHOoI4oqlf80
	 h54YQQBBwT6VqpS6N3upSv+G5eTfkwWmLMpOK18zqdnt4uX1yDI2LtzSabDL0vJChtY0z
	 RiF7qaKWIN8VnkrZZg041oVVTNf0jlwFCia7AUG3/VpmLY6q/VegLc+Pc+kKuhLBeb6CZ
	 Cnzi0btfvfdLjVMjUaYtHFdQ7e8zBSwnXM4Yv5z0wkLxHnsheHEuFsWmhC//DeM6KIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MsHyl7Z3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DAB606A336
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MsHyl7Z3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80D21F00A02;
	Wed,  4 Nov 2026 16:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810628;
	bh=hKZfKBPVhdVjPpI8D6uZjoENDn8UjeOdlwwJIdEv9/Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MsHyl7Z3SW290R4XQwHd4Pj3+iIQoYr2oqr34tTDLB2EMshemGydqpZll3nNwJPMa
	 eVjlx8eGPjX3IoQHuCQwDIZ3ECQVvQu0aCxAPJsi0zaT78EEkPECS8DTRdGvKh2OW+
	 oS2sKjXZ/PVuR62j5a6j+R7v/gUag5/KwKPXiiVYbDYZT0Iwz7XRKlBQ3qUuiGRtlB
	 g8GL+smJwN6LvRpvTBwzZ7I62nhlC9k2j10rzETVbs8HBo7N5gQnZrN7lzEyBINUHI
	 /DE4dmn7RETGpMy1ypwsGjWt7YgaiB4BzvOcwsg0/KjOkfgz8W4oXHatg/P6odduBy
	 +//KwCwjjpfLg==
Message-ID: <sashiko-outbox-197665@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 12/23] RDMA/mlx5: Verify UMR CQ polling
 against a hostile NIC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-13-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-13-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] RDMA/mlx5: unvalidated error CQE syndromes in mlx5_ib_poll_one=
_umr()
- [High] RDMA/mlx5: hung UMR waiters in mlx5_ib_poll_one_umr() on teardown
--

commit da9b5d87a1b071b4bd6eacadaf91a72df89f8c23
Author: Yishai Hadas <yishaih@nvidia.com>

RDMA/mlx5: Verify UMR CQ polling against a hostile NIC

This commit adds a dedicated UMR CQ polling handler in adversarial mode
that validates incoming CQEs against a shadow FIFO of posted UMR requests
and triggers forced health recovery if a forged CQE is detected.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5=
/cq.c
> index 11c1153747c24..1a98263ec3111 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c

[ ... ]

> @@ -608,6 +609,161 @@ static int poll_soft_wc(struct mlx5_ib_cq *cq, int =
num_entries,
>  	return npolled;
>  }
> =20
> +static int mlx5_ib_poll_one_stopped(struct mlx5_ib_cq *cq,
> +				    struct mlx5_ib_qp **cur_qp, struct ib_wc *wc)
> +{
> +	return -EAGAIN;
> +}

[ ... ]

> +int mlx5_ib_poll_one_umr(struct mlx5_ib_cq *cq, struct mlx5_ib_qp **cur_=
qp,
> +		      struct ib_wc *wc)
> +{

[ ... ]

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
> +	if (opcode =3D=3D MLX5_CQE_REQ) {
> +		wc->status =3D IB_WC_SUCCESS;
> +	} else {
> +		/* Copy the CQE, so its syndrome is read once */
> +		err_cqe =3D *(struct mlx5_err_cqe *)cqe64;
> +		mlx5_handle_error_cqe(dev, &err_cqe, wc);
> +		/* As in the generic path, a real failure starts the recovery */
> +		if (wc->status !=3D IB_WC_WR_FLUSH_ERR)
> +			umrc->state =3D MLX5_UMR_STATE_RECOVER;
> +	}

[Severity: Critical]
Does mlx5_ib_poll_one_umr() need to validate whether the error syndrome in a
MLX5_CQE_REQ_ERR completion is valid for the current umrc->state?

If umrc->state is MLX5_UMR_STATE_ACTIVE and a hostile NIC reports
MLX5_CQE_SYNDROME_WR_FLUSH_ERR for the oldest pending UMR WQE,
mlx5_ib_poll_one_umr() completes the request with IB_WC_WR_FLUSH_ERR while
leaving umrc->state as MLX5_UMR_STATE_ACTIVE. In
drivers/infiniband/hw/mlx5/umr.c:mlx5r_umr_post_send_wait(), the waiter sees
IB_WC_WR_FLUSH_ERR, continues the loop, sees umrc->state is still
MLX5_UMR_STATE_ACTIVE, and reposts the WQE indefinitely.

Conversely, when multiple UMR requests are in flight concurrently and the N=
IC
returns a non-flush error syndrome for more than one of them, each of those
waiters wakes up in mlx5r_umr_post_send_wait() with a status other than
IB_WC_WR_FLUSH_ERR and calls mlx5r_umr_recover(). Because mlx5r_umr_recover=
()
drops umrc->lock before posting the barrier WR and resetting the QP:

drivers/infiniband/hw/mlx5/umr.c:mlx5r_umr_recover()
    mutex_unlock(&umrc->lock);
    err =3D mlx5r_umr_post_send(umrc->qp, mkey, umr_context, wqe, with_data=
);
    ...
    wait_for_completion(&umr_context->done);
    attr.qp_state =3D IB_QPS_RESET;
    err =3D ib_modify_qp(umrc->qp, &attr, IB_QP_STATE);

multiple threads can enter recovery concurrently. When the first thread
resets the QP via __mlx5_ib_modify_qp(), qp->sq.head, qp->sq.tail,
qp->sq.cur_post, and qp->sq.last_poll are zeroed while the second thread's
barrier WR remains in umrc->pending with a non-zero wq->wqe_head[idx].
Completing that second barrier WR then sets wq->tail =3D wq->wqe_head[idx] =
+ 1
while wq->head is 0. If a subsequent forged CQE triggers internal error
flushing, sw_comp() computes cur =3D wq->head - wq->tail (which wraps aroun=
d as
unsigned int) and completes stale wq->wrid[] entries pointing to
stack-allocated mlx5r_umr_context structures of callers that have already
returned.

Should a flush error while active, or a second non-flush error after
entering recovery, be treated as a forged CQE (or should error CQEs on the
UMR QP be disallowed altogether in adversarial mode)?

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
> +	cq->poll_one =3D mlx5_ib_poll_one_stopped;
> +	mlx5_trigger_health_work_force(dev->mdev);
> +	return -EIO;
> +}

[Severity: High]
Can relying solely on mlx5_trigger_health_work_force() to flush pending UMR
requests leave waiters in mlx5r_umr_post_send_wait() hung during device
teardown, reload, or removal?

During teardown or reload, mlx5_unload_one_devl_locked() and
mlx5_uninit_one() in drivers/net/ethernet/mellanox/mlx5/core/main.c hold
dev->intf_state_mutex while unregistering the IB device, which revokes open
MRs through:

  mlx5_ib_dereg_mr()
    -> mlx5r_handle_mkey_cleanup()
      -> mlx5_umr_revoke_mr_with_lock()
        -> mlx5r_umr_revoke_mr()
          -> mlx5r_umr_post_send_wait()

In addition, remove_one(), shutdown(), and
mlx5_sync_reset_set_reset_requested() call mlx5_drain_health_wq() or
mlx5_stop_health_poll(), setting MLX5_DROP_HEALTH_WORK before mlx5_ib
teardown finishes.

If a forged CQE is detected in mlx5_ib_poll_one_umr() during these flows,
cq->poll_one is replaced with mlx5_ib_poll_one_stopped without completing
the entries in umrc->pending. The queued force_fatal_report_work calls
mlx5_fw_fatal_reporter_err() in
drivers/net/ethernet/mellanox/mlx5/core/health.c:

    mutex_lock(&dev->intf_state_mutex);
    if (test_bit(MLX5_DROP_HEALTH_WORK, &health->flags)) {
        mlx5_core_err(dev, "health works are not permitted at this stage\n"=
);
        mutex_unlock(&dev->intf_state_mutex);
        return;
    }

Because dev->intf_state_mutex is held by the thread waiting in
wait_for_completion(&umr_context.done), or because MLX5_DROP_HEALTH_WORK is
already set, enter_error_state() and the software CQ flush cannot run,
leaving the UMR waiters blocked forever. Could forged_cqe drain and complete
the remaining contexts in umrc->pending directly?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D12
