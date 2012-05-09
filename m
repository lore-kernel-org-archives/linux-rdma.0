From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 4/7] IB/core: Add RSS and TSS QP groups
Date: Wed, 9 May 2012 18:06:34 +0300
Message-ID: <4FAA87FA.3060908@mellanox.com>
References: <1336494151-31050-1-git-send-email-ogerlitz@mellanox.com> <1336494151-31050-5-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336494151-31050-5-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/8/2012 7:22 PM, Or Gerlitz wrote:
> --- a/drivers/infiniband/hw/ehca/ehca_qp.c
> +++ b/drivers/infiniband/hw/ehca/ehca_qp.c
> @@ -464,6 +464,9 @@ static struct ehca_qp *internal_create_qp(
>   	int is_llqp = 0, has_srq = 0, is_user = 0;
>   	int qp_type, max_send_sge, max_recv_sge, ret;
>
> +	if (init_attr->qpg_type != IB_QPG_NONE)
> +		return ERR_PTR(-ENOSYS);
> +
>   	/* h_call's out parameters */
>   	struct ehca_alloc_qp_parms parms;
>   	u32 swqe_size = 0, rwqe_size = 0, ib_qp_num;
> @@ -980,6 +983,9 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
>   	if (srq_init_attr->srq_type != IB_SRQT_BASIC)
>   		return ERR_PTR(-ENOSYS);
>
> +	if (srq_init_attr->qpg_type != IB_QPG_NONE)
> +		return ERR_PTR(-ENOSYS);
> +
>
oops, this setting is wrong, will send fixed patch (mark it as V0.1 to 
allow room for sending V1 later...)

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
