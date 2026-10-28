Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199002;
	b=RvrheqVY36uE8R2iP04OkQmcT5HitQ+LEc8t7eoJBJOz8GdtV0ghbeoSyPWVR1fH5wr2
	 wuSMLH6Ti2OV+taeiuOtOY8hb3sVzSSVu/PN2aRBw1q8jkwFEvLVWb1AGIjRxIjDZO+9G
	 nN0doLf+Ytlk78MRwzCY/gBzcy0LJIMGlVsMt8i81oIhejBkLnvKhO24BhUEKhOeg8NXh
	 nTKQhSOy2UlEKedfcT/p2hR0o9QXTspA8GWIO6+atLrG5abKa9I/IWXsaefWaM1vt94Rx
	 CWybR1iY4x5MfufBMBAVBc3z+/ADqUfDNIhHixRMwpdMIeyQHhZMTW23jbwkCbkBcBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199002;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=9q11DNs176bYYMFUR11AeQaBpGiT4ivxtJoclTadRk4=;
	b=vyISYVVinmxmy8hyccvWcytAJdsFfLK8X5gow2XC8spLLhpOC42ISeSepgCpLdTKZuX7
	 YdJL7G4sXR7uaa6TxYF7RlMd6LfItZPGEOIEFqXAI0HYpnY3b9YDoujX/SxTGucptvnr5
	 0FvCnx7napj9wTJ2/y2Sp/WVOpWHyR4QuP4gCvzbXqbOSw+9lbmIBwVKckyf3gDiTk4bm
	 B+zeo8nhUSkh5SPb3IJcRyDBNmySJ6wqPu96JqD3Ghxg7J0f9MSRH81jdU2H+SU5DRQ8D
	 yGBg+2kCwEV6MJDC+vw0vof9sw/nYdWEvLx5nDp5ZSNEHlYCCTO4qEqHcP4qh2dGJCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE04606A31D
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 14:50:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BE04606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 75A2468DDD; Wed, 28 Oct 2026 15:49:53 +0100 (CET)
Date: Wed, 28 Oct 2026 15:49:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrei-Alexandru Bleortu <me@andrei-z.com>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 1/1] nvme-rdma: post the command capsule inline when it
 fits
Message-ID: <20261028144951.GA14583@lst.de>
References: <20261015124823.2962700-1-me@andrei-z.com> <20261015124823.2962700-2-me@andrei-z.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015124823.2962700-2-me@andrei-z.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Can you reworkd the commit log to be concise?  Also I find it really
annoying that a ULP would have to decide this.  Doing inline submission
should really be something the core/LLDD takes care of.

On Thu, Oct 15, 2026 at 03:48:23PM +0300, Andrei-Alexandru Bleortu wrote:
> nvme_rdma_post_send() posts the 64-byte command capsule by reference,
> so the HCA has to DMA-read the capsule from host memory before it can
> send the command. That read is on the latency path of every I/O.
> 
> Ask for sizeof(struct nvme_command) bytes of inline data when creating
> the queue pair, and create it without inline data if the device refuses.
> Post a capsule that has no in-capsule data with IB_SEND_INLINE when it
> fits in the granted inline size. The CPU then copies the capsule into
> the send WQE and the HCA no longer reads it.
> 
> Providers copy inline data from sg_list[].addr as a kernel virtual
> address, but nvme-rdma keeps the capsule's DMA address there. On the
> inline path the SGE therefore points at qe->data. The capsule stays
> DMA-mapped for the by-reference path.
> 
> An earlier version of this patch was measured with fio doing 4 KiB
> random reads at queue depth 1 against a null_blk namespace exported by
> nvmet-rdma. Both host pairs ran a 6.8 kernel over RoCEv2 at 100 Gb/s.
> The mean completion latency fell by 0.998 us (95% CI 0.943-1.049)
> between two AMD EPYC 7452 hosts with ConnectX-5 Ex, and by 0.589 us
> (0.558-0.618) between two Xeon Platinum 8360Y hosts with ConnectX-6 Dx.
> IOPS rose by 3.3% on the EPYC pair. A run there that asked for inline
> data but kept posting by reference showed no change. That version asked
> for 220 bytes and had no fallback, but it inlined the same capsules.
> 
> Assisted-by: LLM
> Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
> ---
>  drivers/nvme/host/rdma.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 5b9b540693b5..517098ebffb1 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -106,6 +106,7 @@ struct nvme_rdma_queue {
>  	bool			pi_support;
>  	int			cq_size;
>  	struct mutex		queue_lock;
> +	u32			max_inline_data;
>  };
>  
>  struct nvme_rdma_setup_ctx {
> @@ -265,7 +266,7 @@ static int nvme_rdma_wait_for_cm(struct nvme_rdma_queue *queue)
>  static int nvme_rdma_create_qp(struct nvme_rdma_queue *queue, const int factor)
>  {
>  	struct nvme_rdma_device *dev = queue->device;
> -	struct ib_qp_init_attr init_attr;
> +	struct ib_qp_init_attr init_attr, attr;
>  	int ret;
>  
>  	memset(&init_attr, 0, sizeof(init_attr));
> @@ -284,9 +285,21 @@ static int nvme_rdma_create_qp(struct nvme_rdma_queue *queue, const int factor)
>  		init_attr.create_flags |= IB_QP_CREATE_INTEGRITY_EN;
>  	init_attr.qp_context = queue;
>  
> -	ret = rdma_create_qp(queue->cm_id, dev->pd, &init_attr);
> +	/*
> +	 * Ask for enough inline data to carry the command capsule in the send
> +	 * WQE (see nvme_rdma_post_send()).  If the device cannot provide it,
> +	 * create the QP without inline data and post the capsule by reference.
> +	 */
> +	attr = init_attr;
> +	attr.cap.max_inline_data = sizeof(struct nvme_command);
> +	ret = rdma_create_qp(queue->cm_id, dev->pd, &attr);
> +	if (ret) {
> +		attr = init_attr;
> +		ret = rdma_create_qp(queue->cm_id, dev->pd, &attr);
> +	}
>  
>  	queue->qp = queue->cm_id->qp;
> +	queue->max_inline_data = ret ? 0 : attr.cap.max_inline_data;
>  	return ret;
>  }
>  
> @@ -1641,6 +1654,17 @@ static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
>  	wr.opcode     = IB_WR_SEND;
>  	wr.send_flags = IB_SEND_SIGNALED;
>  
> +	/*
> +	 * Post a capsule without in-capsule data inline if it fits in the
> +	 * granted inline size, so the HCA does not have to DMA-read it from
> +	 * host memory.  The CPU copies inline data from a kernel virtual
> +	 * address, so point the SGE at qe->data.
> +	 */
> +	if (num_sge == 1 && sge->length <= queue->max_inline_data) {
> +		sge->addr = (uintptr_t)qe->data;
> +		wr.send_flags |= IB_SEND_INLINE;
> +	}
> +
>  	if (first)
>  		first->next = &wr;
>  	else
> -- 
> 2.56.0
> 
---end quoted text---
