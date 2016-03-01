From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 9/9] IB/srpt: convert to the generic RDMA READ/WRITE API
Date: Tue, 1 Mar 2016 13:38:42 -0800
Message-ID: <56D60BE2.6010601@sandisk.com>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
 <1456784410-20166-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456784410-20166-10-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: swise@opengridcomputing.com, sagig@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 02/29/2016 02:20 PM, Christoph Hellwig wrote:
 > Replace the homegrown RDMA READ/WRITE code in srpt with the generic API.
 > The only real twist here is that we need to allocate on Linux scatterlist
                                                        ^^
This probably should have been "one" instead of "on"?

> +		ret = target_alloc_sgl(&ctx->sg, &ctx->nents, size, false,
> +				i == nbufs - 1 ? false : true);

Please change "i == nbufs - 1 ? false : true" into "i < nbufs - 1".

> @@ -1832,8 +1626,11 @@ retry:
>   	qp_init->srq = sdev->srq;
>   	qp_init->sq_sig_type = IB_SIGNAL_REQ_WR;
>   	qp_init->qp_type = IB_QPT_RC;
> -	qp_init->cap.max_send_wr = srp_sq_size;
> -	qp_init->cap.max_send_sge = SRPT_DEF_SG_PER_WQE;
> +	qp_init->cap.max_send_wr = srp_sq_size / 2;
> +	qp_init->cap.max_rdma_ctxs = srp_sq_size / 2;
> +	qp_init->cap.max_send_sge = max(sdev->device->attrs.max_sge_rd,
> +					sdev->device->attrs.max_sge);
> +	qp_init->port_num = ch->sport->port;
>
>   	ch->qp = ib_create_qp(sdev->pd, qp_init);
>   	if (IS_ERR(ch->qp)) {

These changes have not been described in the patch description.

Bart.
