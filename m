Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793398939;
	b=gA7/ee3XJP3HanehTCfKhPCrzmXQzlT33pa6BiIrPg3N9y+mwoMQNU9QbVgUtxsNbTAJ
	 RNFEoRzJDPjPROvSSIZRkSZfYot8SStsrUbtHRQoPGvcFx1vZB9I6sLJcAO6kKIx5C2yQ
	 YhC91O0v5idzM0JNN5OIZ6qz94FoPCNDPPyD4PYlcmaArIVnKM+rCR25csrCuP6Oq6Jnk
	 9aK3SnECsZ5G0tv7o4mE7Yl7yHHYuAQiobRZOsx1X9YlY7YzbAQajMNCYau6AzolNrqRf
	 RiO2qVYPCMzvUaOLya2cQhKhy6N4eP3F6Adz1u5JIRZL/bNZlYLx5/wHjXQMm6vQz+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793398939;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=sa7oV1bl27yybiZzNZaGYnkxcu2X3BApkAYGHhGPD9A=;
	b=yDOSsCMN/FLpOTvDH12chmlEe4ZSZKR91Tu3huuGeGh3s7FV1xvQDsB+MinQlbjgSf+n
	 0Khu5Zp6pJLQyKC6n2HHLqdyv74AudHIRKx7EOCYCzvAkCF1R6od6AWqAVOIDU+kwn6C3
	 eZ3v39xOJC80VRb8ZFGT6caxYortb/R7Yt5n/6cDvgRJyMl3l8DodSVcCxaVO+MfbGTUB
	 kGN4YwRIfHXmDvB/k3UWXLtbFc+yDtrQzC6t4zLy09OgmVYvySShUL723XCqi2F3SIwNs
	 gQEixecHQE16LGo2ZjobNLrlFo8Ejf3Zjlo2tK7IpWc+EnNunILv7rT2a6l0A3CgDRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SSfSHRmT;
	arc=none smtp.remote-ip=91.218.175.132
Received: from mta0.migadu.com (out-132.mta0.migadu.com [91.218.175.132])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A123606A320
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 22:22:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A123606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SSfSHRmT
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kK+YrNJ0tvUtbIYHIRYWrmhjs6I028lXavAaA+50fcs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793398935; v=1; x=1794003735;
 b=SSfSHRmTWB1B8AJNb/9iUqXM3uWLU/hZ1XEdpTj3a9jIB1nS5i2f7/1NauFEDcHHcA8w0lr0
 zw5cEBQppCZxqvzU0MbP3UMdXjMUWVADdZZ6105BVXACSTFxv6Fdvi1VyMXNUHlSIF8W3jg69ve
 eCrz5EdaZXKDVK5SmSOtW+3U=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b49b9d4af26656b2;
	Fri, 30 Oct 2026 22:22:15 +0000
X-Mizu-Trace-ID: b49b9d4af26656b2
X-Migadu-Flow: FLOW_OUT
Message-ID: <25034e61-9d01-44e8-a5a4-1921aac6f64a@linux.dev>
Date: Fri, 30 Oct 2026 15:22:10 -0700
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
Subject: Re: [PATCH v10 2/2] RDMA/rxe: copy send WQE to kernel buffer in
 completer path
To: Tristan Madani <tristmd@gmail.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Tristan Madani <tristan@talencesecurity.com>
References: <20261030193235.3470653-1-tristan@talencesecurity.com>
 <20261030193235.3470653-3-tristan@talencesecurity.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261030193235.3470653-3-tristan@talencesecurity.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/10/30 12:32, Tristan Madani 写道:
> The completer reads send WQEs from the same userspace-mapped shared
> queue as the requester. Even after the requester copies the WQE to a
> kernel-private buffer (previous patch), the completer still reads
> directly from shared memory, leaving it exposed to the same TOCTOU
> races.
> 
> Fix by copying the WQE in get_wqe() to a completer-private buffer
> using the full queue element data size. The local copy is reused
> when the same WQE is being processed with unchanged state, which
> preserves DMA progress across multi-packet RDMA READ responses.
> A fresh copy is taken when the state changes or a new WQE appears.
> 
> After copying, reject invalid opcodes (above IB_WR_REG_MR), out-of-
> bounds num_sge, and invalid cur_sge by transitioning the QP to error
> state through COMPST_ERROR. This prevents invalid SGE walks in
> copy_data() from corrupted DMA indices.
> 
> The state read from the shared queue is preserved via smp_load_acquire()
> and restored after the memcpy to prevent a concurrent userspace write
> from overwriting it with a stale value.
> 
> DMA progress (resid, cur_sge, sge_offset) is written back alongside
> completion status and rd_atomic state on completion, after each
> intermediate response packet, and before retry invalidation. The
> per-packet writeback in COMPST_UPDATE_COMP ensures the shared queue
> always reflects the latest DMA offset, so a forced cache re-read (from
> a state change in the shared queue) picks up current progress rather
> than stale initial values.
> 
> The cache is invalidated on QP reset, when a completion advances to
> the next WQE, on error retry, and on RNR retry to ensure fresh state
> after the requester retransmits. The requester retry path also clears
> the completer cache so the completer re-reads from the shared queue
> after retransmission with updated PSN bounds.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>

Thanks a lot.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> ---
> 
> Changes since v9:
>    - Bisection fix: move qp->comp.comp_wqe_valid invalidation from
>      patch 1/2 into this patch where the field is defined, so each
>      commit compiles independently (sashiko finding).
> 
> Changes since v8:
>    - Write back DMA progress in COMPST_UPDATE_COMP after each
>      intermediate response packet, so a forced cache re-read picks up
>      current progress instead of stale initial values (sashiko finding).
> 
> Changes since v7:
>    - Write back DMA progress before invalidating completer cache on
>      error retry, so req_retry() resumes multi-packet reads from the
>      correct offset (sashiko finding).
>    - Invalidate completer cache in COMPST_RNR_RETRY to prevent stale
>      PSN comparison after RNR timer fires (sashiko finding).
> 
> Changes since v6:
>    - Fixed all sashiko review findings (2 Critical + 9 High).
>    - FORTIFY_SOURCE: memcpy into enclosing struct, not inner member.
>    - Copy size: max(max_sge * sizeof(ib_sge), max_inline).
>    - Opcode bound: IB_WR_REG_MR (was IB_WR_ATOMIC_WRITE).
>    - Validate num_sge + cur_sge, preserve smp_load_acquire state.
>    - DMA progress writeback (resid, cur_sge, sge_offset).
>    - *wqe_p = NULL for posted state, invalidate on retry.
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
>   drivers/infiniband/sw/rxe/rxe_comp.c  | 76 ++++++++++++++++++++++++++-
>   drivers/infiniband/sw/rxe/rxe_qp.c    |  1 +
>   drivers/infiniband/sw/rxe/rxe_req.c   |  1 +
>   drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
>   4 files changed, 82 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
> index 1390e861bd1d7..2021e7301c8a9 100644
> --- a/drivers/infiniband/sw/rxe/rxe_comp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_comp.c
> @@ -137,22 +137,87 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb)
>   	rxe_sched_task(&qp->send_task);
>   }
>   
> +/* Write back completer WQE fields to shared memory */
> +static void rxe_comp_writeback_wqe(struct rxe_qp *qp)
> +{
> +	struct rxe_send_wqe *shared = qp->comp.shared_wqe;
> +	struct rxe_send_wqe *local = &qp->comp.comp_wqe.wqe;
> +
> +	if (!qp->comp.comp_wqe_valid || !shared)
> +		return;
> +
> +	WRITE_ONCE(shared->status, local->status);
> +	WRITE_ONCE(shared->has_rd_atomic, local->has_rd_atomic);
> +	WRITE_ONCE(shared->dma.resid, local->dma.resid);
> +	WRITE_ONCE(shared->dma.cur_sge, local->dma.cur_sge);
> +	WRITE_ONCE(shared->dma.sge_offset, local->dma.sge_offset);
> +}
> +
>   static inline enum comp_state get_wqe(struct rxe_qp *qp,
>   				      struct rxe_pkt_info *pkt,
>   				      struct rxe_send_wqe **wqe_p)
>   {
>   	struct rxe_send_wqe *wqe;
> +	u32 state;
>   
>   	/* we come here whether or not we found a response packet to see if
>   	 * there are any posted WQEs
>   	 */
>   	wqe = queue_head(qp->sq.queue, QUEUE_TYPE_FROM_CLIENT);
> -	*wqe_p = wqe;
>   
>   	/* no WQE or requester has not started it yet */
> -	if (!wqe || wqe->state == wqe_state_posted)
> +	if (!wqe) {
> +		*wqe_p = NULL;
>   		return pkt ? COMPST_DONE : COMPST_EXIT;
> +	}
> +
> +	/* Pairs with smp_store_release() in rxe_req_writeback_wqe() */
> +	state = smp_load_acquire(&wqe->state);
> +	if (state == wqe_state_posted) {
> +		*wqe_p = NULL;
> +		return pkt ? COMPST_DONE : COMPST_EXIT;
> +	}
> +
> +	/* Reuse existing local copy if still processing same WQE
> +	 * with unchanged state (preserves DMA progress for multi-packet ops)
> +	 */
> +	if (qp->comp.comp_wqe_valid && qp->comp.shared_wqe == wqe &&
> +	    qp->comp.comp_wqe.wqe.state == state) {
> +		wqe = &qp->comp.comp_wqe.wqe;
> +		*wqe_p = wqe;
> +		goto check_state;
> +	}
> +
> +	/* Copy shared WQE to kernel-private buffer.
> +	 * Copy size matches the queue element data area.
> +	 */
> +	qp->comp.shared_wqe = wqe;
> +	memcpy(&qp->comp.comp_wqe, wqe,
> +	       sizeof(*wqe) + max_t(int,
> +				qp->sq.max_sge * sizeof(struct ib_sge),
> +				qp->sq.max_inline));
> +	qp->comp.comp_wqe_valid = true;
> +
> +	/* Preserve the state we observed via smp_load_acquire()
> +	 * since memcpy may have overwritten it with a stale read.
> +	 */
> +	qp->comp.comp_wqe.wqe.state = state;
> +
> +	/* Reject corrupted opcode or SGE indices, error the QP */
> +	if (unlikely(qp->comp.comp_wqe.wqe.wr.opcode > IB_WR_REG_MR) ||
> +	    qp->comp.comp_wqe.wqe.dma.num_sge > qp->sq.max_sge ||
> +	    (qp->comp.comp_wqe.wqe.dma.resid &&
> +	     qp->comp.comp_wqe.wqe.dma.cur_sge >= qp->sq.max_sge)) {
> +		qp->comp.comp_wqe.wqe.status = IB_WC_LOC_QP_OP_ERR;
> +		wqe = &qp->comp.comp_wqe.wqe;
> +		*wqe_p = wqe;
> +		return COMPST_ERROR;
> +	}
> +
> +	wqe = &qp->comp.comp_wqe.wqe;
> +	*wqe_p = wqe;
>   
> +check_state:
>   	/* WQE does not require an ack */
>   	if (wqe->state == wqe_state_done)
>   		return COMPST_COMP_WQE;
> @@ -454,6 +519,8 @@ static void do_complete(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
>   	if (post)
>   		make_send_cqe(qp, wqe, &cqe);
>   
> +	rxe_comp_writeback_wqe(qp);
> +	qp->comp.comp_wqe_valid = false;
>   	queue_advance_consumer(qp->sq.queue, QUEUE_TYPE_FROM_CLIENT);
>   
>   	if (post)
> @@ -736,6 +803,7 @@ int rxe_completer(struct rxe_qp *qp)
>   				qp->req.again = 1;
>   			}
>   
> +			rxe_comp_writeback_wqe(qp);
>   			state = COMPST_DONE;
>   			break;
>   
> @@ -788,6 +856,8 @@ int rxe_completer(struct rxe_qp *qp)
>   							RXE_CNT_COMP_RETRY);
>   					qp->req.need_retry = 1;
>   					qp->comp.started_retry = 1;
> +					rxe_comp_writeback_wqe(qp);
> +					qp->comp.comp_wqe_valid = false;
>   					qp->req.again = 1;
>   				}
>   				goto done;
> @@ -809,6 +879,8 @@ int rxe_completer(struct rxe_qp *qp)
>   				 * rnr timer has fired
>   				 */
>   				qp->req.wait_for_rnr_timer = 1;
> +				rxe_comp_writeback_wqe(qp);
> +				qp->comp.comp_wqe_valid = false;
>   				rxe_dbg_qp(qp, "set rnr nak timer\n");
>   				// TODO who protects from destroy_qp??
>   				mod_timer(&qp->rnr_nak_timer,
> diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
> index 77606c4a039b1..450254a131017 100644
> --- a/drivers/infiniband/sw/rxe/rxe_qp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_qp.c
> @@ -582,6 +582,7 @@ static void rxe_qp_reset(struct rxe_qp *qp)
>   	qp->req.wait_for_rnr_timer = 0;
>   	qp->req.noack_pkts = 0;
>   	qp->req.send_wqe_valid = false;
> +	qp->comp.comp_wqe_valid = false;
>   	qp->resp.msn = 0;
>   	qp->resp.opcode = -1;
>   	qp->resp.drop_msg = 0;
> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
> index dd8ad19ed1d86..b226b9cec3a16 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -752,6 +752,7 @@ int rxe_requester(struct rxe_qp *qp)
>   		req_retry(qp);
>   		qp->req.need_retry = 0;
>   		qp->req.send_wqe_valid = false;
> +		qp->comp.comp_wqe_valid = false;
>   	}
>   
>   	wqe = req_next_wqe(qp);
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
> index a22dfc6e5ae3c..6205dbc29dff6 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.h
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
> @@ -130,6 +130,12 @@ struct rxe_comp_info {
>   	int			started_retry;
>   	u32			retry_cnt;
>   	u32			rnr_retry;
> +	struct rxe_send_wqe	*shared_wqe;
> +	bool			comp_wqe_valid;
> +	struct {
> +		struct rxe_send_wqe	wqe;
> +		struct ib_sge		sge[RXE_MAX_SGE];
> +	} comp_wqe;
>   };
>   
>   /* responder states */

