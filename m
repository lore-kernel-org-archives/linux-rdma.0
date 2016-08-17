From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH libmlx5] Add TSO support for RAW Ethernet QP
Date: Wed, 17 Aug 2016 17:42:36 +0300
Message-ID: <50e8e02d-e770-8cdc-39cf-0c0187fd400d@grimberg.me>
References: <1469710139-17063-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469710139-17063-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> diff --git a/src/mlx5.h b/src/mlx5.h
> index feb095c..5833339 100644
> --- a/src/mlx5.h
> +++ b/src/mlx5.h
> @@ -209,7 +209,7 @@ enum {
>  	MLX5_OPCODE_RDMA_WRITE_IMM	= 0x09,
>  	MLX5_OPCODE_SEND		= 0x0a,
>  	MLX5_OPCODE_SEND_IMM		= 0x0b,
> -	MLX5_OPCODE_LSO			= 0x0e,
> +	MLX5_OPCODE_TSO			= 0x0e,

Same opcode? was this a typo?

Other than that, looks pretty straight forward,

Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
