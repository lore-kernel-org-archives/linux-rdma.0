From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/4] IB/mlx4: add Raw Packet QP support
Date: Wed, 18 Jan 2012 18:47:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823732DC04E97@ORSMSX101.amr.corp.intel.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1201171338430.26871@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201171338430.26871-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +enum {
> +	MLX4_RAW_QP_MTU		= 7,

Is there any special meaning for MTU 7 that should be standardized in ib_verbs.h?

In other places, the code uses IB_MTU_4096 (5):

> @@ -1042,6 +1054,8 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
> 
>  	if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI)
>  		context->mtu_msgmax = (IB_MTU_4096 << 5) | 11;
> +	else if (ibqp->qp_type == IB_QPT_RAW_PACKET)
> +		context->mtu_msgmax = (MLX4_RAW_QP_MTU << 5) | MLX4_RAW_QP_MSGMAX;
>  	else if (ibqp->qp_type == IB_QPT_UD) {
>  		if (qp->flags & MLX4_IB_QP_LSO)
>  			context->mtu_msgmax = (IB_MTU_4096 << 5) |
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
