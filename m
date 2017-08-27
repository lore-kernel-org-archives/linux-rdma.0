From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 01/11] IB/rxe: Move refcounting earlier in rxe_send()
Date: Sun, 27 Aug 2017 15:01:29 +0300
Message-ID: <20170827120128.GB10450@yuvallap>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-2-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503687956-7110-2-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 25, 2017 at 03:05:46PM -0400, Andrew Boyer wrote:
> The network stack will call nskb's destructor, rxe_skb_tx_dtor(), if the
> packet gets dropped by ip_local_out()/ip6_local_out(). Thus we need to add
> the QP ref before output to avoid extra dereferences during network
> congestion. This could lead to unwanted destruction of the QP.
> 
> Fix up the skb_out accounting, too.
> 
> Fixes: fda85ce91240 ("IB/rxe: Fix kernel panic from skb destructor")
> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_net.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 08f3f90..0810f38 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -460,12 +460,17 @@ int rxe_send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt, struct sk_buff *skb)
>  	nskb->destructor = rxe_skb_tx_dtor;
>  	nskb->sk = pkt->qp->sk->sk;
>  
> +	rxe_add_ref(pkt->qp);
> +	atomic_inc(&pkt->qp->skb_out);
> +
>  	if (av->network_type == RDMA_NETWORK_IPV4) {
>  		err = ip_local_out(dev_net(skb_dst(skb)->dev), nskb->sk, nskb);
>  	} else if (av->network_type == RDMA_NETWORK_IPV6) {
>  		err = ip6_local_out(dev_net(skb_dst(skb)->dev), nskb->sk, nskb);
>  	} else {
>  		pr_err("Unknown layer 3 protocol: %d\n", av->network_type);
> +		atomic_dec(&pkt->qp->skb_out);
> +		rxe_drop_ref(pkt->qp);
>  		kfree_skb(nskb);
>  		return -EINVAL;
>  	}
> @@ -475,10 +480,7 @@ int rxe_send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt, struct sk_buff *skb)
>  		return -EAGAIN;
>  	}

Shouldn't we also dec and drop ref in case that net_xmit_eval returns
error?

>  
> -	rxe_add_ref(pkt->qp);
> -	atomic_inc(&pkt->qp->skb_out);
>  	kfree_skb(skb);
> -
>  	return 0;
>  }
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
