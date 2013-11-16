From: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IB/CMA: Fix to handle global/non-linklocal IPv6 address
 in cma_check_linklocal()
Date: Sat, 16 Nov 2013 04:00:29 +0000
Message-ID: <7F44EA5110810A40B7DAFB605C41975D2C8ABEC5@CMEXMB1.ad.emulex.com>
References: <1384492032-17288-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384492032-17288-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Please ignore this , re-sending this as I forgot to mark this patch as V1 and mention the fact that this was a re-spin born out of review comments from Philip and Sean Hefty.

Thanks
Som

> -----Original Message-----
> From: Somnath Kotur
> Sent: Friday, November 15, 2013 10:37 AM
> To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Somnath Kotur
> Subject: [PATCH] IB/CMA: Fix to handle global/non-linklocal IPv6 address in
> cma_check_linklocal()
> 
> Even if the addr is not a linklocal address, the code treats it as such and
> assigns the bound dev addr to the scope id of the address which is invalid.
> Fix by checking if it's a link local address first and return 0 if not.
> 
> Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index dab4b41..7f8ee93 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -2466,8 +2466,11 @@ static int cma_check_linklocal(struct
> rdma_dev_addr *dev_addr,
>  		return 0;
> 
>  	sin6 = (struct sockaddr_in6 *) addr;
> -	if ((ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
> &&
> -	    !sin6->sin6_scope_id)
> +
> +	if (!(ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL))
> +		return 0;
> +
> +	if (!sin6->sin6_scope_id)
>  			return -EINVAL;
> 
>  	dev_addr->bound_dev_if = sin6->sin6_scope_id;
> --
> 1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
