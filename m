From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Sun, 15 Nov 2015 11:40:02 +0200
Message-ID: <564852F2.5080602@dev.mellanox.co.il>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1447422410-20891-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> +/**
> + * ib_process_direct_cq - process a CQ in caller context
> + * @cq:		CQ to process
> + *
> + * This function is used to process all outstanding CQ entries on a
> + * %IB_POLL_DIRECT CQ.  It does not offload CQ processing to a different
> + * context and does not ask from completion interrupts from the HCA.
> + */
> +void ib_process_cq_direct(struct ib_cq *cq)
> +{
> +	WARN_ON_ONCE(cq->poll_ctx != IB_POLL_DIRECT);
> +
> +	__ib_process_cq(cq, INT_MAX);
> +}

I doubt INT_MAX is useful as a budget in any use-case. it can easily
hog the CPU. If the consumer is given access to poll a CQ, it must be
able to provide some way to budget it. Why not expose a budget argument
to the consumer?
