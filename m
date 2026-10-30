Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793398857;
	b=INoao6Cn+QyQYSTO8AN7m7In9nBm1REwIbHlcG2BvZHspPQA2QKMMp0Z0P0l99gwI501
	 bkzywa5XgDB5YJhHT64ioyZOd1SNnMp8svk8rUdnSNrcTruYcc5x6xQh+G+L+tr+zVp+3
	 TOJK66jv2wobbPYdCfmrX/JCXEAhSjnC5F7F10pgPVh+Xgg3jpB9UiwUzT3htIlfsHD65
	 v3RoGcI/Ju/z/U6Z3QjdDxLyOD3rxa9h8b4xsWBflBHoaBHCh6zOSt1aS8Z5eXKhwxb+5
	 7ixQOeKIpIrrXyoRJfdV46h5KSHf8/psp/pFT7vFUhWMzZd/VafgdLmuOkp3k+Gj/VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793398857;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=W0wF84cKpgfwLnOYrXZw6pCJweTT8rbeu0cwvvIFrYs=;
	b=3MbaS5eELeZgUCEDZhJLMOG31NDTYkifnfZkUApsKLU6zKboB6JrJPgZz3sFPrSynjx3
	 EHmQdDP6KFJuuYFenaJeqJn34CQ78C7b7TkJ75Jnc3jwiGs3f5qmcfghQMxSw/BYeAxuF
	 ElWfWlpuiXLnxOO2/QcrGqmK2CGnIryqYbdJUhzNqai+4NhLALtSR/LULMhJGbA5U7LW/
	 vyKw1o/OHyPASDCkbGLBz631eevEyLQn/tfn0QTVKC/WrSL4DPsw2OIcG97c2YRPUA2oj
	 gbEueqmmLfLJj6eDeHqf9LIcIH+L8N5ubKTTgGM8Ovy8yCg/g3YNYPjiC4YGBujxUPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xojG2C+o;
	arc=none smtp.remote-ip=91.218.175.125
Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE5C606A31E
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 22:20:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EE5C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xojG2C+o
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rfrLPOew4oTV1/b/ZMN6ioBLKrmDuQ240tTpCfS2G5M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793398853; v=1; x=1794003653;
 b=xojG2C+osOxpuXu3L3Kb5K+9FpYCrA/6gnJN2FDJAJn/JJoThywPQq1eqsnyJJ01KdLM3wNm
 e9ZVsIhGqE1MBvPO2DhDBdzddv2Wq5fBLm7qUu4YUpVJZw5uZGX6eakxwLH0Hf1BQ0Zs0gn5Ob6
 m7MqbpvO0UnTVtwpi+hOsECY=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 47fb9eebfd2a40a4;
	Fri, 30 Oct 2026 22:20:53 +0000
X-Mizu-Trace-ID: 47fb9eebfd2a40a4
X-Migadu-Flow: FLOW_OUT
Message-ID: <f04883fc-563b-41f9-988f-9b8f22c3129c@linux.dev>
Date: Fri, 30 Oct 2026 15:20:46 -0700
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
To: Tristan Madani <tristmd@gmail.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Tristan Madani <tristan@talencesecurity.com>
References: <20261030193235.3470653-1-tristan@talencesecurity.com>
 <20261030193235.3470653-2-tristan@talencesecurity.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261030193235.3470653-2-tristan@talencesecurity.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/10/30 12:32, Tristan Madani 写道:
> The rxe send queue is mapped into userspace via mmap. The requester
> processes Work Queue Entries (WQEs) directly from this shared buffer
> without first copying them to kernel memory. Userspace can modify WQE
> fields (num_sge, sge_offset, SGE entries) between kernel reads,
> leading to inconsistent state in copy_data().
> 
> This is the send-path counterpart to the receive-path fixes:
>    - commit 22b8fbded65b8 ("RDMA/rxe: Fix TOCTOU heap overflow in
>      get_srq_wqe")
>    - commit d6ab440240a04 ("RDMA/rxe: Copy WQE to local buffer in
>      non-SRQ receive path")
> 
> Fix by copying the send WQE to a kernel-private buffer in req_next_wqe()
> before processing. The copy uses the full queue element data size
> (max of max_sge SGEs and max_inline bytes) so that both SGE entries
> and inline data are always captured.
> 
> After copying, reject out-of-range opcodes by setting mask to 0 so that
> next_opcode() transitions the QP to error state. Clamp atomic write
> residual to exactly sizeof(u64) to prevent finish_packet() from reading
> past the WQE buffer or leaking uninitialized pad bytes. The WR-level
> mask (WR_ATOMIC_WRITE_MASK) is checked since wr_opcode_mask() populates
> wqe->mask from enum rxe_wr_mask.
> 
> The local copy is reused across multi-packet sends to preserve DMA
> progress state (cur_sge, sge_offset, resid). Field updates including
> DMA progress are written back to the shared queue using WRITE_ONCE()
> for individual fields and smp_store_release() for state transitions,
> so the completer and userspace observe consistent values without the
> tearing risk of bulk memcpy(). DMA progress writeback ensures retries
> can resume from the correct offset.
> 
> The copy is invalidated when the WQE index advances (last packet sent,
> error, local ops, UD oversized), when a retry resets WQE state, on QP
> reset, or when the QP enters error state for flush.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>

Thanks a lot for your efforts.
I am fine with this.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> ---
> 
> Changes since v9:
>    - Atomic write resid: check != sizeof(u64) instead of just > to also
>      catch undersized resid that would leak uninitialized skb pad bytes
>      (sashiko finding).
>    - Bisection fix: move qp->comp.comp_wqe_valid invalidation from
>      this patch to patch 2/2, since comp_wqe_valid is defined there
>      (sashiko finding).
> 
> Changes since v8:
>    - Fix atomic write resid check: use WR_ATOMIC_WRITE_MASK (WR-level
>      mask) instead of RXE_ATOMIC_WRITE_MASK (packet-level mask) so the
>      condition actually fires for IB_WR_ATOMIC_WRITE WQEs (sashiko
>      finding).
>    - Fix atomic write rejection: clamp dma.resid to sizeof(u64) instead
>      of setting mask to 0, since next_opcode() ignores wqe->mask and
>      uses wqe->wr.opcode directly (sashiko finding).
> 
> Changes since v7:
>    - Reject atomic write WQEs with oversized dma.resid to prevent
>      OOB read in finish_packet() (sashiko finding).
> 
> Changes since v6:
>    - Fixed all sashiko review findings (2 Critical + 9 High).
>    - FORTIFY_SOURCE: memcpy into enclosing struct, not inner member.
>    - Copy size: max(max_sge * sizeof(ib_sge), max_inline).
>    - Opcode bound: IB_WR_REG_MR (was IB_WR_ATOMIC_WRITE).
>    - Removed silent num_sge clamp, use mask=0 for invalid opcodes.
>    - DMA progress writeback (resid, cur_sge, sge_offset).
>    - Addressed Zhu Yanjun review feedback.
> 
> Changes since v5:
>    - Added opcode bounds check and num_sge clamp after copy.
> 
> Changes since v4:
>    - Resent from the correct sender address.
> 
> Changes since v3:
>    - Copy full queue element (max_sge SGEs) instead of per-WQE size.
>    - Invalidate on QP reset, ERR flush, RESET state check.
> 
> Changes since v2:
>    - WRITE_ONCE/smp_store_release for field writeback.
> 
> Changes since v1:
>    - Split into per-path patches. Cache across multi-packet ops.
> 
>   drivers/infiniband/sw/rxe/rxe_qp.c    |  1 +
>   drivers/infiniband/sw/rxe/rxe_req.c   | 71 +++++++++++++++++++++++++--
>   drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
>   3 files changed, 73 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
> index 311f285d78a6b..77606c4a039b1 100644
> --- a/drivers/infiniband/sw/rxe/rxe_qp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_qp.c
> @@ -581,6 +581,7 @@ static void rxe_qp_reset(struct rxe_qp *qp)
>   	qp->req.need_retry = 0;
>   	qp->req.wait_for_rnr_timer = 0;
>   	qp->req.noack_pkts = 0;
> +	qp->req.send_wqe_valid = false;
>   	qp->resp.msn = 0;
>   	qp->resp.opcode = -1;
>   	qp->resp.drop_msg = 0;
> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
> index 24f5c044363f7..dd8ad19ed1d86 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -161,6 +161,26 @@ static void req_check_sq_drain_done(struct rxe_qp *qp)
>   	spin_unlock_irqrestore(&qp->state_lock, flags);
>   }
>   
> +static void rxe_req_writeback_wqe(struct rxe_qp *qp)
> +{
> +	struct rxe_send_wqe *shared = qp->req.shared_wqe;
> +	struct rxe_send_wqe *local = &qp->req.send_wqe.wqe;
> +
> +	if (!qp->req.send_wqe_valid || !shared)
> +		return;
> +
> +	WRITE_ONCE(shared->status, local->status);
> +	WRITE_ONCE(shared->first_psn, local->first_psn);
> +	WRITE_ONCE(shared->last_psn, local->last_psn);
> +	WRITE_ONCE(shared->mask, local->mask);
> +	WRITE_ONCE(shared->has_rd_atomic, local->has_rd_atomic);
> +	WRITE_ONCE(shared->dma.resid, local->dma.resid);
> +	WRITE_ONCE(shared->dma.cur_sge, local->dma.cur_sge);
> +	WRITE_ONCE(shared->dma.sge_offset, local->dma.sge_offset);
> +	/* State must be last so the completer sees prior updates */
> +	smp_store_release(&shared->state, local->state);
> +}
> +
>   static struct rxe_send_wqe *__req_next_wqe(struct rxe_qp *qp)
>   {
>   	struct rxe_queue *q = qp->sq.queue;
> @@ -193,7 +213,35 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
>   	}
>   	spin_unlock_irqrestore(&qp->state_lock, flags);
>   
> -	wqe->mask = wr_opcode_mask(wqe->wr.opcode, qp);
> +	/* Reuse the existing kernel-private copy if still valid */
> +	if (qp->req.send_wqe_valid && qp->req.shared_wqe == wqe)
> +		return &qp->req.send_wqe.wqe;
> +
> +	/* Copy WQE from userspace-mapped shared queue to kernel-private
> +	 * buffer. Copy size matches the queue element data area.
> +	 */
> +	memcpy(&qp->req.send_wqe, wqe, sizeof(*wqe) +
> +	       max_t(int, qp->sq.max_sge * sizeof(struct ib_sge),
> +		    qp->sq.max_inline));
> +	qp->req.shared_wqe = wqe;
> +	qp->req.send_wqe_valid = true;
> +
> +	wqe = &qp->req.send_wqe.wqe;
> +
> +	/* Prevent OOB in wr_opcode_mask() for corrupted opcodes.
> +	 * Mask 0 causes next_opcode() to fail, moving QP to error state.
> +	 */
> +	if (unlikely(wqe->wr.opcode > IB_WR_REG_MR))
> +		wqe->mask = 0;
> +	else
> +		wqe->mask = wr_opcode_mask(wqe->wr.opcode, qp);
> +
> +	/* Atomic writes carry exactly sizeof(u64) payload.
> +	 * Clamp oversized resid to prevent OOB read in finish_packet().
> +	 */
> +	if (unlikely((wqe->mask & WR_ATOMIC_WRITE_MASK) &&
> +		     wqe->dma.resid != sizeof(u64)))
> +		wqe->dma.resid = sizeof(u64);
>   	return wqe;
>   }
>   
> @@ -582,9 +630,13 @@ static void update_state(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
>   {
>   	qp->req.opcode = pkt->opcode;
>   
> -	if (pkt->mask & RXE_END_MASK)
> +	rxe_req_writeback_wqe(qp);
> +
> +	if (pkt->mask & RXE_END_MASK) {
>   		qp->req.wqe_index = queue_next_index(qp->sq.queue,
>   						     qp->req.wqe_index);
> +		qp->req.send_wqe_valid = false;
> +	}
>   
>   	qp->need_req_skb = 0;
>   
> @@ -634,7 +686,9 @@ static int rxe_do_local_ops(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
>   
>   	wqe->state = wqe_state_done;
>   	wqe->status = IB_WC_SUCCESS;
> +	rxe_req_writeback_wqe(qp);
>   	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
> +	qp->req.send_wqe_valid = false;
>   
>   	return 0;
>   }
> @@ -666,6 +720,7 @@ int rxe_requester(struct rxe_qp *qp)
>   		wqe = __req_next_wqe(qp);
>   		spin_unlock_irqrestore(&qp->state_lock, flags);
>   		if (wqe) {
> +			qp->req.send_wqe_valid = false;
>   			wqe->status = IB_WC_WR_FLUSH_ERR;
>   			goto err;
>   		} else {
> @@ -681,6 +736,7 @@ int rxe_requester(struct rxe_qp *qp)
>   		qp->req.wait_psn = 0;
>   		qp->req.need_retry = 0;
>   		qp->req.wait_for_rnr_timer = 0;
> +		qp->req.send_wqe_valid = false;
>   		spin_unlock_irqrestore(&qp->state_lock, flags);
>   		goto exit;
>   	}
> @@ -695,6 +751,7 @@ int rxe_requester(struct rxe_qp *qp)
>   	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
>   		req_retry(qp);
>   		qp->req.need_retry = 0;
> +		qp->req.send_wqe_valid = false;
>   	}
>   
>   	wqe = req_next_wqe(qp);
> @@ -772,10 +829,12 @@ int rxe_requester(struct rxe_qp *qp)
>   			wqe->last_psn = qp->req.psn;
>   			qp->req.psn = (qp->req.psn + 1) & BTH_PSN_MASK;
>   			qp->req.opcode = IB_OPCODE_UD_SEND_ONLY;
> -			qp->req.wqe_index = queue_next_index(qp->sq.queue,
> -						       qp->req.wqe_index);
>   			wqe->state = wqe_state_done;
>   			wqe->status = IB_WC_SUCCESS;
> +			rxe_req_writeback_wqe(qp);
> +			qp->req.wqe_index = queue_next_index(qp->sq.queue,
> +						       qp->req.wqe_index);
> +			qp->req.send_wqe_valid = false;
>   			goto done;
>   		}
>   		payload = mtu;
> @@ -839,8 +898,10 @@ int rxe_requester(struct rxe_qp *qp)
>   	goto out;
>   err:
>   	/* update wqe_index for each wqe completion */
> -	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
>   	wqe->state = wqe_state_error;
> +	rxe_req_writeback_wqe(qp);
> +	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
> +	qp->req.send_wqe_valid = false;
>   	rxe_qp_error(qp);
>   exit:
>   	ret = -EAGAIN;
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
> index 0f5ffd94643f9..a22dfc6e5ae3c 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.h
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
> @@ -114,6 +114,12 @@ struct rxe_req_info {
>   	int			wait_for_rnr_timer;
>   	int			noack_pkts;
>   	int			again;
> +	struct rxe_send_wqe	*shared_wqe;
> +	bool			send_wqe_valid;
> +	struct {
> +		struct rxe_send_wqe	wqe;
> +		struct ib_sge		sge[RXE_MAX_SGE];
> +	} send_wqe;
>   };
>   
>   struct rxe_comp_info {

