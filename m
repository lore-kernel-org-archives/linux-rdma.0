From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] RDMA/hns: Fix endian problems around imm_data and
 rkey
Date: Mon, 15 Jan 2018 16:31:10 +0800
Message-ID: <6aca077a-eecd-8374-d602-12d4a6f3cd3e@huawei.com>
References: <20180111214307.501-1-jgg@ziepe.ca>
 <20180111214307.501-3-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111214307.501-3-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2018/1/12 5:43, Jason Gunthorpe Ð´µÀ:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This matches the changes made recently to the userspace hns
> driver when it was made sparse clean.
> 
> See rdma-core commit bffd380cfe56 ("libhns: Make the provider sparse
> clean")
> 
> wc->imm_data is not used in the kernel so this change has no practical
> impact.
> 
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 7 ++++---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 +++---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 5 ++++-
>  3 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index 939355ede14ab7..833a305085efe1 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -2311,15 +2311,16 @@ static int hns_roce_v1_poll_one(struct hns_roce_cq *hr_cq,
>  		case HNS_ROCE_OPCODE_RDMA_WITH_IMM_RECEIVE:
>  			wc->opcode = IB_WC_RECV_RDMA_WITH_IMM;
>  			wc->wc_flags = IB_WC_WITH_IMM;
> -			wc->ex.imm_data = le32_to_cpu(cqe->immediate_data);
> +			wc->ex.imm_data =
> +				cpu_to_be32(le32_to_cpu(cqe->immediate_data));
>  			break;
>  		case HNS_ROCE_OPCODE_SEND_DATA_RECEIVE:
>  			if (roce_get_bit(cqe->cqe_byte_4,
>  					 CQE_BYTE_4_IMM_INDICATOR_S)) {
>  				wc->opcode = IB_WC_RECV;
>  				wc->wc_flags = IB_WC_WITH_IMM;
> -				wc->ex.imm_data = le32_to_cpu(
> -						  cqe->immediate_data);
> +				wc->ex.imm_data = cpu_to_be32(
> +					le32_to_cpu(cqe->immediate_data));
>  			} else {
>  				wc->opcode = IB_WC_RECV;
>  				wc->wc_flags = 0;
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index 2ca35e341d0912..34f13c3cb088c7 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -1709,7 +1709,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
>  		case HNS_ROCE_V2_OPCODE_RDMA_WRITE_IMM:
>  			wc->opcode = IB_WC_RECV_RDMA_WITH_IMM;
>  			wc->wc_flags = IB_WC_WITH_IMM;
> -			wc->ex.imm_data = le32_to_cpu(cqe->rkey_immtdata);
> +			wc->ex.imm_data = cqe->immtdata;
>  			break;
>  		case HNS_ROCE_V2_OPCODE_SEND:
>  			wc->opcode = IB_WC_RECV;
> @@ -1718,12 +1718,12 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
>  		case HNS_ROCE_V2_OPCODE_SEND_WITH_IMM:
>  			wc->opcode = IB_WC_RECV;
>  			wc->wc_flags = IB_WC_WITH_IMM;
> -			wc->ex.imm_data = le32_to_cpu(cqe->rkey_immtdata);
> +			wc->ex.imm_data = cqe->immtdata;
>  			break;
>  		case HNS_ROCE_V2_OPCODE_SEND_WITH_INV:
>  			wc->opcode = IB_WC_RECV;
>  			wc->wc_flags = IB_WC_WITH_INVALIDATE;
> -			wc->ex.invalidate_rkey = cqe->rkey_immtdata;
> +			wc->ex.invalidate_rkey = le32_to_cpu(cqe->rkey);
>  			break;
>  		default:
>  			wc->status = IB_WC_GENERAL_ERR;
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
> index 463edab9b7193f..cbf61ad2539c78 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
> @@ -762,7 +762,10 @@ struct hns_roce_v2_qp_context {
>  
>  struct hns_roce_v2_cqe {
>  	u32	byte_4;
> -	u32	rkey_immtdata;
> +	union {
> +		__le32 rkey;
> +		__be32 immtdata;
> +	};
>  	u32	byte_12;
>  	u32	byte_16;
>  	u32	byte_cnt;
> 
 I am awared the question with endian format in kernel when fix the code in user mode.
And I plan to fixed it systemic in next future refer to the patch bffd380cfe56 .

Thanks. It is good to me.

Lijun Ou

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
