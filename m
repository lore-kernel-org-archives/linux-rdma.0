From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 10/12] IB/srpt: convert to the generic RDMA READ/WRITE API
Date: Wed, 13 Apr 2016 11:57:57 -0700
Message-ID: <570E96B5.5030002@sandisk.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1460410360-13104-11-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, dledford@redhat.com
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 04/11/2016 02:32 PM, Christoph Hellwig wrote:
>   static int srpt_get_desc_tbl(struct srpt_send_ioctx *ioctx,
> -			     struct srp_cmd *srp_cmd,
> -			     enum dma_data_direction *dir, u64 *data_len)
> +		struct srp_cmd *srp_cmd, enum dma_data_direction *dir,
> +		struct scatterlist **sg, unsigned *sg_cnt, u64 *data_len)
>   {
[ ... ]
>
> -		db = idb->desc_list;
> -		memcpy(ioctx->rbufs, db, ioctx->n_rbuf * sizeof(*db));
>   		*data_len = be32_to_cpu(idb->len);
> +		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
> +				sg, sg_cnt);
> +	} else {
> +		*data_len = 0;
> +		return 0;
>   	}
> -out:
> -	return ret;
>   }

srpt_get_desc_tbl() only has one caller. Have you considered to move 
srpt_alloc_rw_ctxs() from this function to the caller of 
srpt_get_desc_tbl()?

> -	if (srpt_get_desc_tbl(send_ioctx, srp_cmd, &dir, &data_len)) {
> -		pr_err("0x%llx: parsing SRP descriptor table failed.\n",
> -		       srp_cmd->tag);
> +	rc = srpt_get_desc_tbl(send_ioctx, srp_cmd, &dir, &sg, &sg_cnt,
> +			&data_len);
> +	if (rc) {
> +		if (rc != -EAGAIN) {
> +			pr_err("0x%llx: parsing SRP descriptor table failed.\n",
> +			       srp_cmd->tag);
> +		} else {
> +			printk_ratelimited("out of MRs for 0x%llx\n", srp_cmd->tag);
> +		}
>   		goto release_ioctx;
>   	}

Sorry but releasing an I/O context if srpt_alloc_rw_ctxs() returns 
-EAGAIN looks wrong to me. If this happens the I/O context should be 
added to the wait list without releasing it. Additionally, 
srpt_recv_done() will have to be modified such that newly received 
commands are added to the wait list if this list is not empty to prevent 
that starvation of a postponed request occurs due to new incoming requests.

Bart.
