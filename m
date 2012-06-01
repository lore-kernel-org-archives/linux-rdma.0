From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: do not crash when peer address is 0.0.0.0
Date: Fri, 01 Jun 2012 10:51:01 -0500
Message-ID: <4FC8E4E5.7060501@opengridcomputing.com>
References: <1337287913-7294-1-git-send-email-cascardo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337287913-7294-1-git-send-email-cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thadeu Lima de Souza Cascardo <cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/17/2012 03:51 PM, Thadeu Lima de Souza Cascardo wrote:
> When using rping -c -a 0.0.0.0 with iw_cxgb4, the system crashes when
> rdma_connect is called. ip_dev_find will return NULL, but pdev is
> accessed anyway.
>
> Checking that pdev is NULL and returning -ENODEV prevents the system
> from crashing.
>
> Signed-off-by: Thadeu Lima de Souza Cascardo<cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>   drivers/infiniband/hw/cxgb4/cm.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 92b4c2b..0e75e30 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -1572,6 +1572,10 @@ static int import_ep(struct c4iw_ep *ep, __be32 peer_ip, struct dst_entry *dst,
>   		struct net_device *pdev;
>
>   		pdev = ip_dev_find(&init_net, peer_ip);
> +		if (!pdev) {
> +			err = -ENODEV;
> +			goto out;
> +		}
>   		ep->l2t = cxgb4_l2t_get(cdev->rdev.lldi.l2t,
>   					n, pdev, 0);
>   		if (!ep->l2t)

This patch seems good, but I'm curious why the cm passed this down to 
the iwarp driver?  0.0.0.0 shouldn't have mapped to any device, eh?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
