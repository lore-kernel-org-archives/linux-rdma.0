From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/3] ibverbs: Add support for packet pacing
Date: Mon, 9 Jan 2017 08:38:56 -0700
Message-ID: <20170109153856.GA29687@obsidianresearch.com>
References: <1483893148-8211-1-git-send-email-yishaih@mellanox.com>
 <1483893148-8211-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483893148-8211-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 08, 2017 at 06:32:27PM +0200, Yishai Hadas wrote:
> +int ibv_cmd_modify_qp_ex(struct ibv_qp *qp, struct ibv_qp_attr *attr,
> +			 int attr_mask, struct ibv_modify_qp_ex *cmd,
> +			 size_t cmd_core_size, size_t cmd_size,
> +			 struct ibv_modify_qp_resp_ex *resp,
> +			 size_t resp_core_size, size_t resp_size)
> +{
> +	if (resp_core_size < offsetof(struct ibv_modify_qp_resp_ex,
> +			     response_length) + sizeof(resp->response_length))
> +		return EINVAL;
> +
> +	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_core_size, cmd_size, MODIFY_QP_EX,
> +			       resp, resp_core_size, resp_size);
> +
> +	copy_modify_qp_fields(qp, attr, attr_mask, &cmd->base);
> +
> +	if (attr_mask & IBV_QP_RATE_LIMIT) {
> +		if (cmd_size >= offsetof(struct ibv_modify_qp_ex, rate_limit) +
> +		    sizeof(cmd->rate_limit))
> +			cmd->rate_limit = attr->rate_limit;
> +		else
> +			return EINVAL;
> +	}

cmd->rate_limit is not being 0'd if it isn't set

> @@ -829,7 +829,8 @@ enum ibv_qp_attr_mask {
>  	IBV_QP_MAX_DEST_RD_ATOMIC	= 1 << 17,
>  	IBV_QP_PATH_MIG_STATE		= 1 << 18,
>  	IBV_QP_CAP			= 1 << 19,
> -	IBV_QP_DEST_QPN			= 1 << 20
> +	IBV_QP_DEST_QPN			= 1 << 20,
> +	IBV_QP_RATE_LIMIT		= 1 << 25,
>  };

Why 25? 21 I think.

>  enum ibv_qp_state {
> @@ -875,6 +876,7 @@ struct ibv_qp_attr {
>  	uint8_t			rnr_retry;
>  	uint8_t			alt_port_num;
>  	uint8_t			alt_timeout;
> +	uint32_t		rate_limit;
>  };

Nope, this is returned by query_qp so you cannot just extend it.

You are supporting query_qp, right?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
