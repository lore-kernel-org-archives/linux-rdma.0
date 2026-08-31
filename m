Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11353B0AD4
	for <linux-rdma@vger.kernel.org>; Mon, 31 Aug 2026 06:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158473; cv=none; b=Us3JuxiggPNLwak2YftkKw4Y2NTV5alsPcmKdENOmuWKGNLu92W2fT/1JRg0jBKHNdWF1IeT9I+cBS2nM4KVvFLbpCcL2qIqEiLLM5VrP0WR5rmF+bmLtXdub36aLzG4Z2ByBZWIpZFVWvKwzmTcN2zuSojMSeGnEcHuY/VcDaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158473; c=relaxed/simple;
	bh=c5oRAggTVo+gw/65uvjn1lIIVMhTGTPPNLB+8IPeHmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Krzk+9ZLmb7fUsLNKqWASy5IY5h2Kj3/+aVPNnnP1FORPZYyEYsETTt6+8HRWlYMPknPN7gQafNL/asZtxXZ5QAka2ChyynXUvSI+HDQxzaBGhsIagNdmz/e9cNXVo3cbkRpdGOEH85zhtTg7FLXmX075NA9W875rsGFLYb1cYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l8pmRu6E; arc=none smtp.client-ip=91.218.175.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l8pmRu6E"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=c5oRAggTVo+gw/65uvjn1lIIVMhTGTPPNLB+8IPeHmk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788158467; v=1; x=1788763267;
 b=l8pmRu6ELgQ7fDEBTFFqB+df6pBgz2Fu8wGRt1alaqQasSLnNzfoveVVZhPXFclO8P5Jpure
 HNHKhh62Z7fOo9SarUsUJiNJN6aCOS+99kuv0drnlAC13xJh7SQ4Cua0ML/WnrqmdXAcDtPxwGJ
 UFjN0BpKuKrdJIRvmuYXWDi4=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 41af01eb8da8fcf1;
	Mon, 31 Aug 2026 06:41:07 +0000
X-Mizu-Trace-ID: 41af01eb8da8fcf1
X-Migadu-Flow: FLOW_OUT
Message-ID: <c5a513f5-004b-4905-bae2-d3ddc284bcce@linux.dev>
Date: Sun, 30 Aug 2026 23:41:04 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
To: Tristan Madani <tristmd@gmail.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Moni Shoua <monis@mellanox.com>, Ibrahim Hashimov
 <security@auditcode.ai>, linux-rdma@vger.kernel.org, stable@vger.kernel.org,
 Tristan Madani <tristan@talencesecurity.com>
References: <20260816104432.849996-1-tristmd@gmail.com>
 <20260830191344.2026524-1-tristmd@gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260830191344.2026524-1-tristmd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/8/30 12:13, Tristan Madani 写道:
> From: Tristan Madani <tristan@talencesecurity.com>
> 
> The rxe send queue is mapped into userspace via mmap. The requester
> processes Work Queue Entries (WQEs) directly from this shared buffer
> without first copying them to kernel memory. Userspace can modify WQE
> fields (num_sge, sge_offset, SGE entries) between kernel reads,
> leading to inconsistent state in copy_data().
> 
> This is the send-path counterpart to the receive-path fixes:
>   - commit 22b8fbded65b8 ("RDMA/rxe: Fix TOCTOU heap overflow in
>     get_srq_wqe")
>   - commit d6ab440240a04 ("RDMA/rxe: Copy WQE to local buffer in
>     non-SRQ receive path")
> 
> Fix by copying the send WQE to a kernel-private buffer in req_next_wqe()
> before processing. The local copy is reused across multi-packet sends
> to preserve DMA progress state (cur_sge, sge_offset, resid). Modified
> fields are written back individually using WRITE_ONCE() with
> smp_store_release() for the state field to ensure the completer
> observes consistent values.
> 
> The copy is invalidated when:
>   - The WQE index advances (last packet sent, error, local ops,
>     UD oversized)
>   - A retry occurs (req_retry resets WQE state in shared memory)
> 
> The num_sge field is validated against qp->sq.max_sge on copy-in to
> reject corrupted values early.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
> ---
> v1 -> v2:
>   - Replace bulk memcpy() writeback with targeted WRITE_ONCE() for
>     individual fields (cur_sge, sge_offset, resid, status) and
>     smp_store_release() for the state field, addressing review feedback
>     from Zhu Yanjun
> 
>   drivers/infiniband/sw/rxe/rxe_req.c   | 60 ++++++++++++++++++++++++++-
>   drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
>   2 files changed, 65 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
> index 12d03f390b097..59b22bb160908 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -161,6 +161,26 @@ static void req_check_sq_drain_done(struct rxe_qp *qp)
>   	spin_unlock_irqrestore(&qp->state_lock, flags);
>   }
>   
> +/* Write back modified WQE fields to the shared queue using
> + * WRITE_ONCE() so the completer observes consistent values.
> + * Only the fields modified by the requester are written back;
> + * state is written last as the publication field.
> + */
> +static void rxe_req_writeback_wqe(struct rxe_qp *qp)
> +{
> +	if (qp->req.send_wqe_valid && qp->req.shared_wqe) {
> +		struct rxe_send_wqe *shared = qp->req.shared_wqe;
> +		struct rxe_send_wqe *local = &qp->req.send_wqe.wqe;
> +
> +		WRITE_ONCE(shared->dma.cur_sge, local->dma.cur_sge);
> +		WRITE_ONCE(shared->dma.sge_offset, local->dma.sge_offset);
> +		WRITE_ONCE(shared->dma.resid, local->dma.resid);
> +		WRITE_ONCE(shared->status, local->status);
> +		/* Ensure fields above are visible before state transition */
> +		smp_store_release(&shared->state, local->state);
> +	}
> +}
> +
>   static struct rxe_send_wqe *__req_next_wqe(struct rxe_qp *qp)
>   {
>   	struct rxe_queue *q = qp->sq.queue;
> @@ -178,6 +198,8 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
>   {
>   	struct rxe_send_wqe *wqe;
>   	unsigned long flags;
> +	unsigned int num_sge;
> +	size_t copy_size;
>   
>   	req_check_sq_drain_done(qp);
>   
> @@ -193,6 +215,28 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
>   	}
>   	spin_unlock_irqrestore(&qp->state_lock, flags);
>   
> +	/* If we already have a valid local copy of this WQE, use it.
> +	 * This preserves DMA progress state across multi-packet sends.
> +	 */
> +	if (qp->req.send_wqe_valid && qp->req.shared_wqe == wqe)
> +		return &qp->req.send_wqe.wqe;
> +
> +	/* Copy WQE from userspace-mapped shared queue to kernel-private
> +	 * buffer to prevent TOCTOU races on num_sge, SGE entries, and
> +	 * inline data offsets. This is the send-path counterpart to
> +	 * rxe_get_recv_wqe().
> +	 */
> +	num_sge = wqe->dma.num_sge;
> +	if (unlikely(num_sge > qp->sq.max_sge)) {
> +		rxe_dbg_qp(qp, "invalid num_sge in send WQE\n");
> +		return NULL;
> +	}

Since wqe->dma.num_sge resides in shared memory, accessing it without 
READ_ONCE() allows compiler re-fetches that create a TOCTOU race 
condition, potentially leading to a kernel buffer overflow if userspace 
modifies the value post-validation.

As such, please use the following.

num_sge = READ_ONCE(wqe->dma.num_sge);

Thanks a lot.
Zhu Yanjun

> +	copy_size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
> +	memcpy(&qp->req.send_wqe.wqe, wqe, copy_size);
> +	qp->req.shared_wqe = wqe;
> +	qp->req.send_wqe_valid = true;
> +
> +	wqe = &qp->req.send_wqe.wqe;
>   	wqe->mask = wr_opcode_mask(wqe->wr.opcode, qp);
>   	return wqe;
>   }
> @@ -582,9 +626,14 @@ static void update_state(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
>   {
>   	qp->req.opcode = pkt->opcode;
>   
> -	if (pkt->mask & RXE_END_MASK)
> +	/* Write back local WQE state before possibly advancing index */
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
> @@ -635,6 +684,7 @@ static int rxe_do_local_ops(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
>   	wqe->state = wqe_state_done;
>   	wqe->status = IB_WC_SUCCESS;
>   	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
> +	qp->req.send_wqe_valid = false;
>   
>   	return 0;
>   }
> @@ -695,6 +745,7 @@ int rxe_requester(struct rxe_qp *qp)
>   	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
>   		req_retry(qp);
>   		qp->req.need_retry = 0;
> +		qp->req.send_wqe_valid = false;
>   	}
>   
>   	wqe = req_next_wqe(qp);
> @@ -761,6 +812,7 @@ int rxe_requester(struct rxe_qp *qp)
>   						       qp->req.wqe_index);
>   			wqe->state = wqe_state_done;
>   			wqe->status = IB_WC_SUCCESS;
> +			qp->req.send_wqe_valid = false;
>   			goto done;
>   		}
>   		payload = mtu;
> @@ -820,12 +872,18 @@ int rxe_requester(struct rxe_qp *qp)
>   	 * will continue looping and return to rxe_requester
>   	 */
>   done:
> +	/* Write back local WQE for paths that skip update_state()
> +	 * (local ops, UD oversized packets).
> +	 */
> +	rxe_req_writeback_wqe(qp);
>   	ret = 0;
>   	goto out;
>   err:
>   	/* update wqe_index for each wqe completion */
>   	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
>   	wqe->state = wqe_state_error;
> +	rxe_req_writeback_wqe(qp);
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

