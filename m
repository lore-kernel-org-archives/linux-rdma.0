From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next 4/4] IB/sa: Use nlmsg_free instead of kfree_skb
Date: Wed, 4 May 2016 10:42:01 -0500
Message-ID: <019e01d1a61b$7ffab680$7ff02380$@opengridcomputing.com>
References: <1462340165-16067-1-git-send-email-leon@kernel.org> <1462340165-16067-5-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462340165-16067-5-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> Sent: Wednesday, May 04, 2016 12:36 AM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org;
> matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; Leon Romanovsky
> Subject: [PATCH rdma-next 4/4] IB/sa: Use nlmsg_free instead of kfree_skb
> 
> From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Fixes a direct call to kfree_skb when nlmsg_free should be used.
> 
> Fixes: 2ca546b92a02 ('IB/sa: Route SA pathrecord query through netlink')
> Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/sa_query.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/sa_query.c
b/drivers/infiniband/core/sa_query.c
> index 24c2aac..5050c61 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -536,7 +536,7 @@ static int ib_nl_send_msg(struct ib_sa_query *query, gfp_t
> gfp_mask)
>  	data = ibnl_put_msg(skb, &nlh, query->seq, 0, RDMA_NL_LS,
>  			    RDMA_NL_LS_OP_RESOLVE, NLM_F_REQUEST);
>  	if (!data) {
> -		kfree_skb(skb);
> +		nlmsg_free(skb);
>  		return -EMSGSIZE;
>  	}
> 

Looks good.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
