From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH/libmlx4] Fix generation of IBV_WC_GRH
Date: Wed, 9 Mar 2011 09:48:20 +0200
Message-ID: <4D7730C4.2000109@mellanox.com>
References: <20110305024546.GA29147@obsidianresearch.com> <AANLkTimu6dGc1NcsgP60iPqNmzGR+cmtwGHjsU_c=LWz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimu6dGc1NcsgP60iPqNmzGR+cmtwGHjsU_c=LWz-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> This was fixed in libmlx4 1.0.1 a while ago.  I guess I really need
> to get that version into Debian/Ubuntu.

Roland,

I see now that the below commit of yours dropped the ntohl around the 
GRH flag setting which was added by jack in commit 
b2b26f8a73108f971ade988fac3eb9d0446bbbb6

Or.

> commit e6a3ccdffb36f94ee72b2bc97944a50777ff72e0
> Author: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Date:   Thu Jan 3 19:59:05 2008 -0800
> 
>     Micro-optimize mlx4_poll_one()
> 
>     Rather than byte-swapping cqe->g_mlpath_rqpn each time we extract a
>     field from it, byte-swap it once into a temporary variable.  This
>     results in smaller, better code.
> 
>     Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> 
> diff --git a/src/cq.c b/src/cq.c
> index bc53f9b..06ae9e2 100644
> --- a/src/cq.c
> +++ b/src/cq.c
> @@ -196,6 +196,7 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
>         struct mlx4_cqe *cqe;
>         struct mlx4_srq *srq;
>         uint32_t qpn;
> +       uint32_t g_mlpath_rqpn;
>         uint16_t wqe_index;
>         int is_error;
>         int is_send;
> @@ -314,11 +315,11 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
> 
>                 wc->slid           = ntohs(cqe->rlid);
>                 wc->sl             = cqe->sl >> 4;
> -               wc->src_qp         = ntohl(cqe->g_mlpath_rqpn) & 0xffffff;
> -               wc->dlid_path_bits = (ntohl(cqe->g_mlpath_rqpn) >> 24) & 0x7f;
> +               g_mlpath_rqpn      = ntohl(cqe->g_mlpath_rqpn);
> +               wc->src_qp         = g_mlpath_rqpn & 0xffffff;
> +               wc->dlid_path_bits = (g_mlpath_rqpn >> 24) & 0x7f;
> +               wc->wc_flags      |= g_mlpath_rqpn & 0x80000000 ? IBV_WC_GRH : 0;
>                 wc->pkey_index     = ntohl(cqe->immed_rss_invalid) >> 16;
> -               wc->wc_flags      |= ntohl(cqe->g_mlpath_rqpn) & 0x80000000 ?
> -                       IBV_WC_GRH : 0;
>         }
> 
>         return CQ_OK;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
