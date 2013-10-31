From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC v2 08/10] IB/mlx5: Support IB_WR_REG_SIG_MR
Date: Thu, 31 Oct 2013 14:01:39 +0100
Message-ID: <527254B3.5010005@gmail.com>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <1383222255-22699-9-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383222255-22699-9-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/31/2013 01:24 PM, Sagi Grimberg wrote:
> +{
> +	struct ib_mr *sig_mr = wr->wr.sig_handover.sig_mr;
> +	u32 sig_key = sig_mr->rkey;
> +
> +	memset(seg, 0, sizeof(*seg));
> +
> +	seg->status = 0x4; /*set free*/
> +	seg->flags = get_umr_flags(wr->wr.sig_handover.access_flags) |
> +				   MLX5_ACCESS_MODE_KLM;
> +	seg->qpn_mkey7_0 = cpu_to_be32((sig_key & 0xff) | 0xffffff00);
> +	seg->flags_pd = cpu_to_be32(MLX5_MKEY_REMOTE_INVAL |
> +				    MLX5_MKEY_BSF_EN | pdn);
> +	seg->start_addr = 0;
Already memset, no need to set start_addr here.

Jack

> +	seg->len = cpu_to_be64(length);
> +	seg->xlt_oct_size = cpu_to_be32(be16_to_cpu(get_klm_octo(nelements)));
> +	seg->bsfs_octo_size = cpu_to_be32(MLX5_MKEY_BSF_OCTO_SIZE);
> +}
> +

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
