From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 4/7] libibverbs: Add support for XRC QPs
Date: Sun, 17 Mar 2013 15:41:52 +0200
Message-ID: <5145C820.9090801@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A981A0@FMSMSX151.amr.corp.intel.com> <1363394326-908-4-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363394326-908-4-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 16/03/2013 02:38, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>   
> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index d7dfcd3..f321866 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -475,6 +478,26 @@ struct ibv_qp_init_attr {
>   	int			sq_sig_all;
>   };
>   
> +enum ibv_qp_init_attr_mask {
> +	IBV_QP_INIT_ATTR_PD		= 1 << 0,
> +	IBV_QP_INIT_ATTR_XRCD		= 1 << 1,
> +	IBV_QP_INIT_ATTR_RESERVED	= 1 << 2
> +};
> +
> +struct ibv_qp_init_attr_ex {
> +	void		       *qp_context;
> +	struct ibv_cq	       *send_cq;
> +	struct ibv_cq	       *recv_cq;
> +	struct ibv_srq	       *srq;
> +	struct ibv_qp_cap	cap;
> +	enum ibv_qp_type	qp_type;
> +	int			sq_sig_all;
> +
> +	uint32_t		comp_mask;
> +	struct ibv_pd	       *pd;
> +	struct ibv_xrcd	       *xrcd;
> +};
> +
>   enum ibv_qp_attr_mask {
>   	IBV_QP_STATE			= 1 << 	0,
>   	IBV_QP_CUR_STATE		= 1 << 	1,
> @@ -590,6 +613,11 @@ struct ibv_send_wr {
>   			uint32_t	remote_qpn;
>   			uint32_t	remote_qkey;
>   		} ud;
> +		struct {
> +			uint64_t	reserved[3];
> +			uint32_t	reserved2;
> +			uint32_t	remote_srqn;
> +		} xrc;
>   	} wr;
>   };

these added reserved fields ofcourse don't enlarge the union size, 
correct? so why have it, maybe you
want to make sure no one will srink the union size in the future?

>   
> @@ -771,11 +799,14 @@ struct ibv_context {
>   enum verbs_context_mask {
>   	VERBS_CONTEXT_XRCD	= 1 << 0,
>   	VERBS_CONTEXT_SRQ	= 1 << 1,
> -	VERBS_CONTEXT_RESERVED	= 1 << 2
> +	VERBS_CONTEXT_QP	= 1 << 2,
> +	VERBS_CONTEXT_RESERVED	= 1 << 3
>   };
>   
>   struct verbs_context {
>   	/*  "grows up" - new fields go here */
> +	struct ibv_qp *		(*create_qp_ex)(struct ibv_context *context,
> +						struct ibv_qp_init_attr_ex *qp_init_attr_ex);
>   	

I easily think on 3-4 more use cases for a create_qp extended verb that 
allows the app to
specify QP creation flags e.g in the same manner we have them in the 
kernel, for example:

1. suport blocking of multicast self-loopback (kernel 
IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
2. support TCP segementation (kernel IB_QP_CREATE_IPOIB_UD_LSO)
3. support some HPC optimizations whose patches are now under the works
4. etc more

Can we re-define this verb such that it can serve for both XRC QPs and 
non-XRC QPs for which creation flags are desired?
maybe add creation flags and IBV_QP_CREATE_XRC as a value that tells to 
create XRC QP, and we can add other flags on top of.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
