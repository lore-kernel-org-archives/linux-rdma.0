From: "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH libmlx4 1/8] Add raw packet QP support
Date: Fri, 21 Sep 2012 00:51:43 +0000
Message-ID: <4AF12E8016D2BF46BCDFCE8FAA77A3580315252C@fmsmsx109.amr.corp.intel.com>
References: <1348173067-12116-1-git-send-email-ogerlitz@mellanox.com>
 <1348173067-12116-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348173067-12116-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
> Sent: Thursday, September 20, 2012 3:31 PM
> To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Or Gerlitz
> Subject: [PATCH libmlx4 1/8] Add raw packet QP support
> 
> Implement raw packet QPs for Ethernet ports.
> 
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  src/qp.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/src/qp.c b/src/qp.c
> index 40a6689..90c4e80 100644
> --- a/src/qp.c
> +++ b/src/qp.c
> @@ -286,6 +286,10 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct
> ibv_send_wr *wr,
>  			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
>  			break;
> 
> +		case IBV_QPT_RAW_PACKET:
> +			/* For raw eth, the MLX4_WQE_CTRL_SOLICIT flag is
> used
> +			 * to indicate that no icrc should be calculated */
> +			ctrl->srcrb_flags |=
> htonl(MLX4_WQE_CTRL_SOLICIT);
>  		default:
>  			break;
>  		}

Add a break for the new case?  While the above code works as expected, it is inconsistent from what it was before, and could lead to problems if the default case starts doing something.


Dean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
