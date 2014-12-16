From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/cma: fix first byte overwritten for AF_IB
Date: Tue, 16 Dec 2014 21:29:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399E2DE69@ORSMSX110.amr.corp.intel.com>
References: <1418744596-25251-1-git-send-email-jinpu.wang@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418744596-25251-1-git-send-email-jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If user attach private data for AF_IB, the first byte will
> be overwritten, because we always set the cma version no matter
> family is AF_IB, so move the version set inside if condition.
> 
> Reported-by: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index d570030..22a22e2 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -2618,10 +2618,10 @@ static int cma_format_hdr(void *hdr, struct
> rdma_id_private *id_priv)
>  	struct cma_hdr *cma_hdr;
> 
>  	cma_hdr = hdr;
> -	cma_hdr->cma_version = CMA_VERSION;
>  	if (cma_family(id_priv) == AF_INET) {
>  		struct sockaddr_in *src4, *dst4;
> 
> +		cma_hdr->cma_version = CMA_VERSION;
>  		src4 = (struct sockaddr_in *) cma_src_addr(id_priv);
>  		dst4 = (struct sockaddr_in *) cma_dst_addr(id_priv);
> 
> @@ -2632,6 +2632,7 @@ static int cma_format_hdr(void *hdr, struct
> rdma_id_private *id_priv)
>  	} else if (cma_family(id_priv) == AF_INET6) {
>  		struct sockaddr_in6 *src6, *dst6;
> 
> +		cma_hdr->cma_version = CMA_VERSION;
>  		src6 = (struct sockaddr_in6 *) cma_src_addr(id_priv);
>  		dst6 = (struct sockaddr_in6 *) cma_dst_addr(id_priv);

I don't think this is sufficient.  The RDMA CM private data header is defined by the IB spec.  If the service ID starts with the prefix 0x0000000001, it's reasonable to assume that the header is part of the private data.  The receive side should probably even check the version and discard any unknown values.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
