Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5FE3E3C4F
	for <linux-rdma@vger.kernel.org>; Sun, 16 Aug 2026 21:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786916709; cv=none; b=m5G+hgYFO0LEgrB5G39FwD3htJdIIfMyDDubFr1mXi9pEy+WaGi+yQ0qXYCXyleeN+edaxoi2Ua78gj5QYm3PfOLcC2I9Njrq8d9f7dk2gXunF9iWiea1WEpKxNXawmNYf+Do7syyr8bSVsVH6a5SxTQJ4CR6c3eE+zUDHxj9HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786916709; c=relaxed/simple;
	bh=mNO74oi8yh6Pq1I2jmraMnHrjznHRP7lLpSh+N+aPWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HKQKD8JSTOT/5Hv9O3Rr8nidC8IcefdnszXobIUrgpvcu45QmIRCrKxhiHsJxIxOqIi5ionG9XIaRvw39yy2Ybn8IRHfiiraqw+KxRIZS/0sacXt/tKG2IbDBYQP2pORLi9eJ8WECsfrXLQThavBccyw+G1URjBBaiZRkdiqY5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q/hdBoLB; arc=none smtp.client-ip=91.218.175.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q/hdBoLB"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mNO74oi8yh6Pq1I2jmraMnHrjznHRP7lLpSh+N+aPWg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786916705; v=1; x=1787521505;
 b=Q/hdBoLBBw00SHPTFMbNRiqZJ3LaPO5S9ArwH1IC8G6IqYRG43BV/CYhRiNvYU9FaSG+ppuH
 aBnU28NiqYflxuO0LwD4M3ZWGFYXXUeTrA2ofm8I/EMmisaj2ykoY4zLvLWvplP/feHjMxWK0t5
 3umW06HdjNp7jmH6kZ8OemNI=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from [IPV6:2601:647:6300:a030:dd46:d520:270e:1608] (2601:647:6300:a030:dd46:d520:270e:1608)
	by smtp.migadu.com with ESMTPS id f42f421dbd52d924;
	Sun, 16 Aug 2026 21:45:01 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <2063d67f-27c5-4329-aaf5-39823f9de6ff@linux.dev>
Date: Sun, 16 Aug 2026 14:44:54 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] RDMA/rxe: copy send WQE to kernel buffer before
 processing
To: Tristan Madani <tristmd@gmail.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Moni Shoua <monis@mellanox.com>, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org, Tristan Madani <tristan@talencesecurity.com>
References: <20260816104432.849996-1-tristmd@gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260816104432.849996-1-tristmd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/8/16 3:44, Tristan Madani 写道:
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
> to preserve DMA progress state (cur_sge, sge_offset, resid). State
> changes are written back to the shared queue so the completer can observe
> them (e.g., wqe_state_pending for RC acknowledgment processing).
>
> The copy is invalidated when:
>   - The WQE index advances (last packet sent, error, local ops, UD oversized)
>   - A retry occurs (req_retry resets WQE state in shared memory)
>
> The num_sge field is validated against qp->sq.max_sge on copy-in to
> reject corrupted values early.
>
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
> ---
>   drivers/infiniband/sw/rxe/rxe_req.c   | 55 ++++++++++++++++++++++++++-
>   drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
>   2 files changed, 60 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
> index 12d03f390b097..499f398b674c7 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -161,6 +161,20 @@ static void req_check_sq_drain_done(struct rxe_qp *qp)
>   	spin_unlock_irqrestore(&qp->state_lock, flags);
>   }
>   
> +/* Write local WQE copy back to shared queue so the completer
> + * can observe state transitions (e.g., wqe_state_pending).
> + */
> +static void rxe_req_writeback_wqe(struct rxe_qp *qp)
> +{
> +	if (qp->req.send_wqe_valid && qp->req.shared_wqe) {
> +		unsigned int num_sge = qp->req.send_wqe.wqe.dma.num_sge;
> +		size_t size = sizeof(struct rxe_send_wqe) +
> +			      num_sge * sizeof(struct rxe_sge);
> +
> +		memcpy(qp->req.shared_wqe, &qp->req.send_wqe.wqe, size);
> +	}
> +}
> +
rxe_req_writeback_wqe() uses memcpy() to write the local WQE state back
to qp->req.shared_wqe in user-mapped memory without synchronization.

This introduces two data race hazards:
1. Malicious or concurrent userspace writes during memcpy() can race
    with the kernel writeback, causing tearing or inconsistent shared state.
2. The kernel completer tasklet concurrently reads shared_wqe without
    holding a lock, risking torn reads of intermediate WQE states (e.g.
    wqe_state_pending) and triggering state machine corruption.

Writebacks to shared user-mapped memory must update state fields atomically
or execute under appropriate lock serialization rather than performing an

uncontrolled bulk memcpy().

Please fix the above problem with appropriate synchronize methods.

Thanks a lot.

Yanjun.Zhu

>   static struct rxe_send_wqe *__req_next_wqe(struct rxe_qp *qp)
>   {
>   	struct rxe_queue *q = qp->sq.queue;
> @@ -178,6 +192,8 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
>   {
>   	struct rxe_send_wqe *wqe;
>   	unsigned long flags;
> +	unsigned int num_sge;
> +	size_t copy_size;
>   
>   	req_check_sq_drain_done(qp);
>   
> @@ -193,6 +209,29 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
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
> +	 * buffer. Userspace can concurrently modify num_sge, SGE entries,
> +	 * or inline data offsets, leading to inconsistent state in
> +	 * copy_data(). This is the send-path variant of the receive-path
> +	 * fix in rxe_get_recv_wqe().
> +	 */
> +	num_sge = wqe->dma.num_sge;
> +	if (unlikely(num_sge > qp->sq.max_sge)) {
> +		rxe_dbg_qp(qp, "invalid num_sge in send WQE\n");
> +		return NULL;
> +	}
> +	copy_size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
> +	memcpy(&qp->req.send_wqe.wqe, wqe, copy_size);
> +	qp->req.shared_wqe = wqe;
> +	qp->req.send_wqe_valid = true;
> +
> +	wqe = &qp->req.send_wqe.wqe;
>   	wqe->mask = wr_opcode_mask(wqe->wr.opcode, qp);
>   	return wqe;
>   }
> @@ -582,9 +621,14 @@ static void update_state(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
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
> @@ -635,6 +679,7 @@ static int rxe_do_local_ops(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
>   	wqe->state = wqe_state_done;
>   	wqe->status = IB_WC_SUCCESS;
>   	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
> +	qp->req.send_wqe_valid = false;
>   
>   	return 0;
>   }
> @@ -695,6 +740,7 @@ int rxe_requester(struct rxe_qp *qp)
>   	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
>   		req_retry(qp);
>   		qp->req.need_retry = 0;
> +		qp->req.send_wqe_valid = false;
>   	}
>   
>   	wqe = req_next_wqe(qp);
> @@ -761,6 +807,7 @@ int rxe_requester(struct rxe_qp *qp)
>   						       qp->req.wqe_index);
>   			wqe->state = wqe_state_done;
>   			wqe->status = IB_WC_SUCCESS;
> +			qp->req.send_wqe_valid = false;
>   			goto done;
>   		}
>   		payload = mtu;
> @@ -820,12 +867,18 @@ int rxe_requester(struct rxe_qp *qp)
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

-- 
Best Regards,
Yanjun.Zhu

