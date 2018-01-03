From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH V5 for-next 3/6] RDMA/hns: Set access flags of hip08 RoCE
Date: Wed, 3 Jan 2018 14:19:18 -0700
Message-ID: <20180103211918.GK11348@ziepe.ca>
References: <1514947448-40475-1-git-send-email-oulijun@huawei.com>
 <1514947448-40475-4-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514947448-40475-4-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 03, 2018 at 10:44:05AM +0800, Lijun Ou wrote:
> +static void set_access_flags(struct hns_roce_qp *hr_qp,
> +			     struct hns_roce_v2_qp_context *context,
> +			     struct hns_roce_v2_qp_context *qpc_mask,
> +			     const struct ib_qp_attr *attr, int attr_mask)
> +{
> +	u8 dest_rd_atomic;
> +	u32 access_flags;
> +
> +	dest_rd_atomic = !!(attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) ?
> +			 attr->max_dest_rd_atomic : hr_qp->resp_depth;
> +
> +	access_flags = !!(attr_mask & IB_QP_ACCESS_FLAGS) ?
> +		       attr->qp_access_flags : hr_qp->atomic_rd_en;

These !! are un-needed when used in a boolean context like ?:

> +	if (!dest_rd_atomic)
> +		access_flags &= IB_ACCESS_REMOTE_WRITE;
> +
> +	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_RRE_S,
> +		     !!(access_flags & IB_ACCESS_REMOTE_READ));
> +	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_RRE_S, 0);
> +
> +	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_RWE_S,
> +		     !!(access_flags & IB_ACCESS_REMOTE_WRITE));
> +	roce_set_bit(qpc_mask->byte_76_srqn_op_en, V2_QPC_BYTE_76_RWE_S, 0);
> +
> +	roce_set_bit(context->byte_76_srqn_op_en, V2_QPC_BYTE_76_ATE_S,
> +		     !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));

And having something called 'set_bit' that does not accept a bool is
just asking for bugs. You should fix the macro to do the !! and remove
it from all the callers.

I took this as is, you can send a cleanup someday.

Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
