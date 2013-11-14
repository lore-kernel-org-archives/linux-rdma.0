From: "Prindeville, Philip" <philip.prindeville-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH] IB/CMA: Fix to handle global/non-linklocal IPv6 address
 in cma_check_linklocal()
Date: Thu, 14 Nov 2013 20:42:12 +0000
Message-ID: <03234339-6425-4D1A-A4E6-775887EF6463@hp.com>
References: <c469605a-bda9-4248-82f0-0da03bf3ce3d@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c469605a-bda9-4248-82f0-0da03bf3ce3d-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Content-ID: <E6CED12B7F5FAC41B11C5E7D6EB45E2F-V1Jw8CMlhmbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Do you need to check it twice?

Is the second test now redundant?

-Philip


On Nov 13, 2013, at 10:28 PM, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:

> Even if the addr is not a linklocal address, the code treats it as such
> and assigns the bound dev addr to the scope id of the address which is invalid.
> Fix by checking if it's a link local address first and return 0 if not.
> 
> Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
> drivers/infiniband/core/cma.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index dab4b41..5c9f1ad 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -2466,6 +2466,9 @@ static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
> 		return 0;
> 
> 	sin6 = (struct sockaddr_in6 *) addr;
> +
> +	if (!(ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL))
> +		return 0;
> 	if ((ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL) &&
> 	    !sin6->sin6_scope_id)
> 			return -EINVAL;
> -- 
> 1.7.1
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
