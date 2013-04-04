From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs 1/3] Add raw packet QP type
Date: Thu, 4 Apr 2013 08:58:23 +0300
Message-ID: <515D167F.9070701@mellanox.com>
References: <1348173034-11929-1-git-send-email-ogerlitz@mellanox.com> <1348173034-11929-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348173034-11929-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/09/2012 22:30, Or Gerlitz wrote:
> IB_QPT_RAW_PACKET allows applications to build a complete packet,
> including L2 headers, when sending; on the receive side, the HW will
> not strip any headers.

Hi Roland,

I happily saw that you've finally picked the libmlx4 patches to support 
RAW QP, so we're making progress... any reason not to pick this series?

Or.

>
> This QP type is designed for userspace direct access to Ethernet; for
> example by applications that do TCP/IP themselves.  Only processes
> with the NET_RAW capability are allowed to create raw packet QPs (the
> name "raw packet QP" is supposed to suggest an analogy to AF_PACKET /
> SOL_RAW sockets).
>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   include/infiniband/verbs.h |    3 ++-
>   man/ibv_create_qp.3        |    2 +-
>   man/ibv_modify_qp.3        |   10 ++++++++++
>   3 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index 6acfc81..8ed8a66 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -399,7 +399,8 @@ struct ibv_srq_init_attr {
>   enum ibv_qp_type {
>   	IBV_QPT_RC = 2,
>   	IBV_QPT_UC,
> -	IBV_QPT_UD
> +	IBV_QPT_UD,
> +	IBV_QPT_RAW_PACKET = 8
>   };
>   
>   struct ibv_qp_cap {
> diff --git a/man/ibv_create_qp.3 b/man/ibv_create_qp.3
> index 5301ad8..7feeab2 100644
> --- a/man/ibv_create_qp.3
> +++ b/man/ibv_create_qp.3
> @@ -28,7 +28,7 @@ struct ibv_cq          *send_cq;        /* CQ to be associated with the Send Que
>   struct ibv_cq          *recv_cq;        /* CQ to be associated with the Receive Queue (RQ) */
>   struct ibv_srq         *srq;            /* SRQ handle if QP is to be associated with an SRQ, otherwise NULL */
>   struct ibv_qp_cap       cap;            /* QP capabilities */
> -enum ibv_qp_type        qp_type;        /* QP Transport Service Type: IBV_QPT_RC, IBV_QPT_UC, or IBV_QPT_UD */
> +enum ibv_qp_type        qp_type;        /* QP Transport Service Type: IBV_QPT_RC, IBV_QPT_UC, IBV_QPT_UD or IBV_QPT_RAW_PACKET */
>   int                     sq_sig_all;     /* If set, each Work Request (WR) submitted to the SQ generates a completion entry */
>   .in -8
>   };
> diff --git a/man/ibv_modify_qp.3 b/man/ibv_modify_qp.3
> index 9eabcdf..cb3faaa 100644
> --- a/man/ibv_modify_qp.3
> +++ b/man/ibv_modify_qp.3
> @@ -159,6 +159,16 @@ RTR  \fB          IBV_QP_STATE, IBV_QP_AV, IBV_QP_PATH_MTU, \fR
>   RTS  \fB          IBV_QP_STATE, IBV_QP_SQ_PSN, IBV_QP_MAX_QP_RD_ATOMIC, \fR
>        \fB          IBV_QP_RETRY_CNT, IBV_QP_RNR_RETRY, IBV_QP_TIMEOUT \fR
>   .fi
> +.PP
> +.nf
> +For QP Transport Service Type \fB IBV_QPT_RAW_PACKET\fR:
> +.sp
> +Next state     Required attributes
> +\-\-\-\-\-\-\-\-\-\-     \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-
> +Init \fB          IBV_QP_STATE, IBV_QP_PORT\fR
> +RTR  \fB          IBV_QP_STATE\fR
> +RTS  \fB          IBV_QP_STATE\fR
> +.fi
>   .SH "SEE ALSO"
>   .BR ibv_create_qp (3),
>   .BR ibv_destroy_qp (3),

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
