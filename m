Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083101;
	b=so/EFM+ywFd+wzf1aR5MrnNFnt/mLc19TcMgXSysF23KB4MkEEYtfHj7DzPOM9VJS2PE
	 3XYOM0hFOasooo3f9SA0zdZqzcEkpItHSvWg+rFy+alDDLsnFtr2MoeC1ppETe1NiXbhF
	 59RUOhbY8dsTEiCPmSE/Ante1MuStio6GaCsH7FCvKEw9Y+fX3iQtY0wVQlNlIMt/0ZDZ
	 GC7hxku0qCGDpuexWZWuYqe2NaeItHhicRongC3yOcjyuHCjo8QpvN00h6cjLmUrIZSQB
	 gXchfpag5I1OPX19fbze/wTGg1eVLVWkQq+QLSUod4c66Y+Jp/r/3IKkKnLiHhmb4FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083101;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=f8GU+sP+q8ND79iloh1HAh5OiA/V8hlelNxHwQ+8kqI=;
	b=0eD0f7PUmQxcSp57+ljZRRscEgznE2SOVQulfxHLPJv09wnncggIwh/QqUHHOj6FTMe6
	 NPrOLi8B6Nc5dbviwEIreWE2dsCENbn7bOe3vuR2xf5TVo6qGxUAeopLENOfaUP1JAw4N
	 Vk/bg6iguSKQUjcumtWinT5lZiUCmbIEGCW7O2cRUFcPTIyFP+AvvSIjh8PFZCwuoPohE
	 KpUe33BXnD0+jcouYqoMpk+arN9cPwXKqL/q9RvUJNMIMad0reLKQKbuF1uwVxJ8rnGoH
	 eIt0yXdZVREs00MPF2Aeuv1fWxOQfzp1+381a5gVRrz+qfE7jrPG/HRvz+/jEoNCA7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQkkaFaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8C4606D80E;
	Sat,  7 Nov 2026 20:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQkkaFaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9FC1F008A5;
	Sat,  7 Nov 2026 20:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083095;
	bh=f8GU+sP+q8ND79iloh1HAh5OiA/V8hlelNxHwQ+8kqI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=TQkkaFaWqc0E2T17vYoJ9BuSvyANELIhNPdNAzRX7n+LWzx+N2EMX4MgBePb+0M0h
	 s+MvsnPTxhLCRVd+IAM5AnKHGKflx4zz65XQ51QoO9yqa6YOM5TmaLOHxKPhfPjacE
	 s6ODudp6Rt8K+502t1WOcRGLdv+EpFHDjQtjd8oC14bCkg9Ep65mtnRV2kZ/xkR8OA
	 Fyi/NJjVj9xuzjbSoGLyFPfouhPtExho6vOvLxrb4fr8ce8KMCs06ORQp+HFemVvqz
	 N1NGYekeT6Sl+L3FyniZgE7K/6lwZ3YQTtHVE1U1D2g/F30dEHJ+8fJVbcjuWxjYB2
	 jl0QS5e4w+Few==
Subject: Re: [PATCH rdma-next 12/23] RDMA/mlx5: Verify UMR CQ polling against
 a hostile NIC
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:54 +0000
Message-ID: <179408309434.994134.3459380801419463957@kernel.org>
In-Reply-To: <20261103163949.1554-13-yishaih@nvidia.com>
References: <20261103163949.1554-13-yishaih@nvidia.com>
X-sashiko-severity: Critical
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

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 1 · High: 0 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] RDMA/mlx5: unvalidated error CQE syndromes in
  mlx5_ib_poll_one_umr()
- [Medium] When a forged CQE is detected, the waiters are only woken if
  the forced health work runs, and on the unload and remove paths it…
- [Medium] mlx5_ib_poll_one_umr() treats a CQE as forged if the top byte
  of sop_drop_qpn is not MLX5_OPCODE_UMR.
- [Low] After the forged-CQE path sets cq->poll_one =
  mlx5_ib_poll_one_stopped, the UMR CQ's consumer index never advances…
- [Low] The kernel-doc of mlx5_ib_cq_stop_polling() says that on return
  'no CQE is looked at again'.

--

RDMA/mlx5: Verify UMR CQ polling against a hostile NIC

In adversarial mode, this installs a dedicated poll_one for the UMR CQ.
A CQE is accepted only if its opcode, QPN and wqe_counter match the oldest
entry in a shadow FIFO of posted UMR requests, and the completion context
is then taken from that FIFO. A CQE that fails validation marks the UMR
path permanently failed, stops polling the CQ and forces the mlx5_core
health recovery; teardown also stops polling before the UMR QP is
destroyed.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index 11c1153747c24..1a98263ec3111 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c

[ ... ]

> @@ -608,6 +609,161 @@ static int poll_soft_wc(struct mlx5_ib_cq *cq, int num_entries,
>  	return npolled;
>  }
>  
> +static int mlx5_ib_poll_one_stopped(struct mlx5_ib_cq *cq,
> +				    struct mlx5_ib_qp **cur_qp, struct ib_wc *wc)
> +{
> +	return -EAGAIN;
> +}

[Severity: Low]
After the forged_cqe path in mlx5_ib_poll_one_umr() installs this
function, can the UMR CQ get stuck in a re-arm loop?

mlx5_ib_poll_one_stopped() never advances cq->mcq.cons_index. Other UMR
WQEs, up to MAX_UMR_WR of them, can still be outstanding, and their real
CQEs land past that index. ib_poll_handler() sees 0 completions and
re-arms the CQ:

drivers/infiniband/core/cq.c:ib_poll_handler() {
    ...
	if (completed < budget) {
		irq_poll_complete(&cq->iop);
		if (ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0) {
    ...
}

mlx5_ib_arm_cq() then arms it with the stale consumer index:

drivers/infiniband/hw/mlx5/cq.c:mlx5_ib_arm_cq() {
    ...
	mlx5_cq_arm(&cq->mcq,
		    (flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
		    MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT,
		    uar_page, to_mcq(ibcq)->mcq.cons_index);
    ...
}

With mlx5 arm semantics, an armed CQ that still holds unconsumed CQEs
raises an event right away. Each re-arm would then produce another EQE,
another interrupt and another irq_poll pass that does nothing. Does this
continue until the forced health work tears the device down?

In the unload windows described further below, that work never runs, so
the loop would not stop.

> +
> +/**
> + * mlx5_ib_cq_stop_polling - stop interpreting CQEs on a CQ
> + * @ibcq: the CQ
> + *
> + * Takes cq->lock, which mlx5_ib_poll_cq() holds while polling, so no poll
> + * is in flight on return and no CQE is looked at again.
> + */

[Severity: Low]
Is "no CQE is looked at again" accurate? The commit message makes a
similar claim:

  On teardown, stop polling the CQ before destroying the UMR QP, so a CQE
  for the destroyed QP, or for a reused QPN, is never interpreted.

mlx5r_umr_resource_cleanup() calls mlx5_ib_cq_stop_polling() and then
ib_destroy_qp(dev->umrc.qp). For a kernel QP that path reaches:

ib_destroy_qp()
  destroy_qp_common()
    __mlx5_ib_cq_clean(recv_cq, base->mqp.qpn, ...)

__mlx5_ib_cq_clean() scans every software-owned CQE on the UMR CQ,
starting at cons_index. It reads each QPN and compacts the remaining
entries, without going through cq->poll_one.

The same thing happens in mlx5r_umr_recover() during the RESET
transition:

mlx5r_umr_recover()
  ib_modify_qp(RESET)
    __mlx5_ib_modify_qp()
      mlx5_ib_cq_clean(recv_cq, base->mqp.qpn, ...)

On that path, any leftover CQE carrying the UMR QPN is silently dropped.
It is never checked against the shadow FIFO and never reaches the
forged_cqe handling.

There is no memory-safety impact here, because __mlx5_ib_cq_clean() is
bounded by cq->ibcq.cqe and dispatches no wr_cqe. Could the comment and
the commit message be changed to describe only what the code actually
guarantees?

> +void mlx5_ib_cq_stop_polling(struct ib_cq *ibcq)
> +{

[ ... ]

> +int mlx5_ib_poll_one_umr(struct mlx5_ib_cq *cq, struct mlx5_ib_qp **cur_qp,
> +		      struct ib_wc *wc)
> +{

[ ... ]

> +	qp = to_mqp(ibqp);
> +	wq = &qp->sq;
> +	idx = wqe_ctr & (wq->wqe_cnt - 1);
> +
> +	if (unlikely((opcode != MLX5_CQE_REQ && opcode != MLX5_CQE_REQ_ERR) ||
> +		     qpn != umrc->qpn || sop != MLX5_OPCODE_UMR)) {
> +		mlx5_ib_err(dev,
> +			    "Unexpected CQE on UMR CQ: opcode 0x%x sop 0x%x qpn 0x%x\n",
> +			    opcode, sop, qpn);
> +		goto forged_cqe;
> +	}

[Severity: Medium]
Could this check flag a legitimate UMR error recovery as forgery?

The sop check also runs on MLX5_CQE_REQ_ERR CQEs, including WR_FLUSH_ERR
ones, before the syndrome is examined. In the error CQE layout, this byte
is the top byte of s_wqe_opcode_qpn in struct mlx5_err_cqe.

Elsewhere in the tree, handle_good_req() reads it only for successful REQ
CQEs. Nothing reads s_wqe_opcode for error or flush CQEs.

The device may not report the UMR opcode in flush CQEs for WQEs it never
executed. Examples are the WQEs queued behind a failed UMR and the
barrier WR posted by mlx5r_umr_recover().

In that case, an honest NIC that hits a recoverable error such as
LOCAL_PROT_ERR would get the UMR path disabled for good, with -EFAULT for
every later UMR, plus a forced health recovery.

This depends on hardware behavior that nothing in the tree confirms or
rules out. Would it be safer to apply the sop check only to MLX5_CQE_REQ,
and rely on the full wqe_counter match against the shadow FIFO for error
CQEs?

[ ... ]

> +forged_cqe:
> +	/* mlx5_ib_poll_cq() updates the CI only for a returned completion */
> +	mlx5_cq_set_ci(&cq->mcq);
> +	/*
> +	 * The NIC forged a CQE. Fail the UMR path for good, ignore any later
> +	 * CQE and force the health recovery, as the fatal sensors still read
> +	 * clean. The internal error flush then completes the waiters. Return
> +	 * an error, not -EAGAIN, as a CQE was consumed.
> +	 */
> +	umrc->state = MLX5_UMR_STATE_ERR;
> +	cq->poll_one = mlx5_ib_poll_one_stopped;
> +	mlx5_trigger_health_work_force(dev->mdev);
> +	return -EIO;
> +}

[Severity: Medium]
What wakes the pending UMR waiters if the forced health work cannot run?
The commit message says:

  Recovery moves the device to the internal error state, and the existing
  flush then completes the pending requests in software and wakes their
  waiters, so this path does not complete them itself.

The forced work ends up in mlx5_fw_fatal_reporter_err() in
drivers/net/ethernet/mellanox/mlx5/core/health.c:

mlx5_fw_fatal_reporter_err() {
    ...
	mutex_lock(&dev->intf_state_mutex);
	if (test_bit(MLX5_DROP_HEALTH_WORK, &health->flags)) {
		mlx5_core_err(dev, "health works are not permitted at this stage\n");
		mutex_unlock(&dev->intf_state_mutex);
		return;
	}
    ...
}

Both checks stop it during teardown:

- remove_one() calls mlx5_drain_health_wq(), which sets
  MLX5_DROP_HEALTH_WORK, before it calls mlx5_uninit_one().

- mlx5_uninit_one() and mlx5_unload_one_devl_locked() hold
  intf_state_mutex while mlx5_unregister_device() or
  mlx5_detach_device() deletes the mlx5_ib aux device. mlx5r_driver has
  no .suspend, so the device is always deleted.

In that window, ib_unregister_device() destroys user MRs, and pooled or
cacheable mkeys are revoked through UMR:

mlx5r_handle_mkey_cleanup()
  mlx5_umr_revoke_mr_with_lock()
    mlx5r_umr_revoke_mr()
      mlx5r_umr_post_send_wait()
        wait_for_completion(&umr_context.done);

Suppose a forged CQE is detected during this window. The UMR CQ is never
polled again and the device never enters the internal error state. Is
anything left that can complete this uninterruptible wait?

In the intf_state_mutex case, isn't this a deadlock?

- Unload holds intf_state_mutex and the devlink lock while it waits for
  the UMR.
- The UMR waits for the forced health work.
- The forced health work waits for intf_state_mutex.

[ ... ]

> @@ -608,6 +609,161 @@ static int poll_soft_wc(struct mlx5_ib_cq *cq, int num_entries,
>  	return npolled;
>  }
>  
> +static int mlx5_ib_poll_one_stopped(struct mlx5_ib_cq *cq,
> +				    struct mlx5_ib_qp **cur_qp, struct ib_wc *wc)
> +{
> +	return -EAGAIN;
> +}
> +
> +/**
> + * mlx5_ib_cq_stop_polling - stop interpreting CQEs on a CQ
> + * @ibcq: the CQ
> + *
> + * Takes cq->lock, which mlx5_ib_poll_cq() holds while polling, so no poll
> + * is in flight on return and no CQE is looked at again.
> + */
> +void mlx5_ib_cq_stop_polling(struct ib_cq *ibcq)
> +{
> +	struct mlx5_ib_cq *cq = to_mcq(ibcq);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&cq->lock, flags);
> +	cq->poll_one = mlx5_ib_poll_one_stopped;
> +	spin_unlock_irqrestore(&cq->lock, flags);
> +}
> +
> +/*
> + * poll_one of the UMR CQ in adversarial_mode. A CQE is accepted only if it
> + * matches the oldest request in the shadow FIFO, otherwise the device is
> + * treated as compromised.
> + */
> +int mlx5_ib_poll_one_umr(struct mlx5_ib_cq *cq, struct mlx5_ib_qp **cur_qp,
> +		      struct ib_wc *wc)
> +{
> +	struct mlx5_ib_dev *dev = to_mdev(cq->ibcq.device);
> +	struct mlx5r_umr_context *expected;
> +	struct umr_common *umrc = &dev->umrc;
> +	struct mlx5_err_cqe err_cqe;
> +	struct mlx5_cqe64 *cqe64;
> +	struct mlx5_ib_wq *wq;
> +	struct mlx5_ib_qp *qp;
> +	struct ib_qp *ibqp;
> +	u16 wqe_ctr;
> +	u8 opcode;
> +	u32 head;
> +	u32 sop_qpn;
> +	u32 qpn;
> +	u8 sop;
> +	int idx;
> +	void *cqe;
> +
> +	cqe = next_cqe_sw(cq);
> +	if (!cqe)
> +		return -EAGAIN;
> +
> +	cqe64 = (cq->mcq.cqe_sz == 64) ? cqe : cqe + 64;
> +	++cq->mcq.cons_index;
> +	/*
> +	 * Read each field once, so a NIC rewriting the CQE cannot change it
> +	 * between validation and use.
> +	 */
> +	rmb();
> +	opcode  = READ_ONCE(cqe64->op_own) >> 4;
> +	sop_qpn = ntohl(READ_ONCE(cqe64->sop_drop_qpn));
> +	qpn     = sop_qpn & 0xffffff;
> +	sop     = sop_qpn >> 24;
> +	wqe_ctr = be16_to_cpu(READ_ONCE(cqe64->wqe_counter));
> +
> +	/*
> +	 * This poll_one is installed before the UMR QP is published, so a CQE
> +	 * seen while the QP is NULL is forged. Teardown stops polling before
> +	 * the QP is destroyed.
> +	 */
> +	ibqp = smp_load_acquire(&dev->umrc.qp);
> +	if (unlikely(!ibqp)) {
> +		mlx5_ib_err(dev, "CQE on the UMR CQ before its QP is published\n");
> +		goto forged_cqe;
> +	}
> +	qp = to_mqp(ibqp);
> +	wq = &qp->sq;
> +	idx = wqe_ctr & (wq->wqe_cnt - 1);
> +
> +	if (unlikely((opcode != MLX5_CQE_REQ && opcode != MLX5_CQE_REQ_ERR) ||
> +		     qpn != umrc->qpn || sop != MLX5_OPCODE_UMR)) {
> +		mlx5_ib_err(dev,
> +			    "Unexpected CQE on UMR CQ: opcode 0x%x sop 0x%x qpn 0x%x\n",
> +			    opcode, sop, qpn);
> +		goto forged_cqe;
> +	}
> +
> +	/* Pairs with smp_store_release() in mlx5r_umr_post_send() */
> +	head = umrc->pending_head;
> +	expected = smp_load_acquire(&umrc->pending[head & (MLX5_UMR_MAX_WR - 1)]);
> +
> +	if (unlikely(!expected)) {
> +		mlx5_ib_err(dev,
> +			    "UMR CQE wqe_ctr 0x%x with an empty shadow FIFO, possible NIC forgery\n",
> +			    wqe_ctr);
> +		goto forged_cqe;
> +	}
> +
> +	if (unlikely(wqe_ctr != expected->wqe_ctr)) {
> +		mlx5_ib_err(dev,
> +			    "UMR wqe_ctr 0x%x mismatch with expected context, possible NIC forgery\n",
> +			    wqe_ctr);
> +		goto forged_cqe;
> +	}
> +
> +	/*
> +	 * A WQE records wq->head when posted, and mlx5r_ring_db() then advances
> +	 * wq->head. If they are still equal, mlx5r_ring_db() was not reached
> +	 * yet, so the WQE was never handed to the NIC.
> +	 */
> +	if (unlikely(wq->wqe_head[idx] == READ_ONCE(wq->head))) {
> +		mlx5_ib_err(dev,
> +			    "UMR CQE wqe_ctr 0x%x for an uncommitted WQE, possible NIC forgery\n",
> +			    wqe_ctr);
> +		goto forged_cqe;
> +	}
> +
> +	/* Pop the shadow FIFO head: validated, dispatch to its waiter */
> +	WRITE_ONCE(umrc->pending[head & (MLX5_UMR_MAX_WR - 1)], NULL);
> +	umrc->pending_head = head + 1;
> +	wc->wr_cqe = &expected->cqe;
> +
> +	wc->qp = &qp->ibqp;
> +	wq->tail = wq->wqe_head[idx] + 1;
> +	/* Advance wq->last_poll, the internal error flush starts from it */
> +	handle_atomics(qp, cqe64, wq->last_poll, idx);
> +
> +	if (opcode == MLX5_CQE_REQ) {
> +		wc->status = IB_WC_SUCCESS;
> +	} else {
> +		/* Copy the CQE, so its syndrome is read once */
> +		err_cqe = *(struct mlx5_err_cqe *)cqe64;
> +		mlx5_handle_error_cqe(dev, &err_cqe, wc);
> +		/* As in the generic path, a real failure starts the recovery */
> +		if (wc->status != IB_WC_WR_FLUSH_ERR)
> +			umrc->state = MLX5_UMR_STATE_RECOVER;
> +	}
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
> +	umrc->state = MLX5_UMR_STATE_ERR;
> +	cq->poll_one = mlx5_ib_poll_one_stopped;
> +	mlx5_trigger_health_work_force(dev->mdev);
> +	return -EIO;
> +}
> +
>  int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
>  {
>  	struct mlx5_ib_cq *cq = to_mcq(ibcq);

[Severity: Critical]
Can a hostile NIC push the UMR path into an invalid state with error
CQEs that still pass the shadow FIFO match?

The CQE is checked against the oldest pending context. Its syndrome is
then taken at face value, whatever umrc->state is. Two cases look
reachable by the NIC this patch defends against.

The first case is a WR_FLUSH_ERR CQE while umrc->state is
MLX5_UMR_STATE_ACTIVE. An honest QP only flushes after an earlier error
CQE has moved the state to MLX5_UMR_STATE_RECOVER. Here the flush is
accepted and the state is left alone. mlx5r_umr_post_send_wait() sees
IB_WC_WR_FLUSH_ERR, takes the continue, still finds the state ACTIVE
and reposts the same WQE. If the NIC flushes every repost, the caller
never returns and keeps its umrc->sem slot.

The second case is a non-flush error for more than one pending WQE.
Each matching CQE sets MLX5_UMR_STATE_RECOVER and wakes its waiter with
a non-flush status, so several waiters call mlx5r_umr_recover().
mlx5r_umr_recover() drops umrc->lock before it posts the barrier WR and
resets the QP. The recoveries therefore run concurrently, and each one
posts its own barrier.

When the first barrier completes, ib_modify_qp(IB_QPS_RESET) reaches
__mlx5_ib_modify_qp(), which zeroes qp->sq.head, sq.tail, sq.cur_post
and sq.last_poll. It clears neither umrc->pending nor qp->sq.wqe_head[],
so the second barrier is still at the head of the shadow FIFO.

Suppose the NIC now completes that barrier with its old wqe_ctr. The
uncommitted-WQE check compares a stale wq->wqe_head[idx] with the reset
wq->head and passes. wq->tail becomes wq->wqe_head[idx] + 1 while
wq->head is 0.

A later forged CQE then forces the health recovery. Once the device is
in the internal error state, mlx5_ib_poll_cq() completes the SQ in
software. sw_comp() computes wq->head - wq->tail, which has wrapped,
and walks wq->wrid[]. The entries it dispatches point at
mlx5r_umr_context structures on the stacks of callers that have
already returned. mlx5r_umr_done() then writes the status and completes
the done field in that freed stack memory.

Should a flush seen in MLX5_UMR_STATE_ACTIVE take the forged_cqe path
instead? The same question applies to a second non-flush error once the
state is already MLX5_UMR_STATE_RECOVER.

Separately, should mlx5r_umr_recover() be serialized? And should the
shadow FIFO be reset together with the SQ counters on the RESET
transition?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
