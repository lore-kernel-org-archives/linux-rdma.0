From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rdma UAPI: Use __kernel_sockaddr_storage
Date: Mon, 31 Oct 2016 08:06:27 +0200
Message-ID: <20161031060627.GX3617@leon.nu>
References: <1477587077-15410-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SqGHvGqRphKoTacN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477587077-15410-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--SqGHvGqRphKoTacN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 27, 2016 at 10:51:17AM -0600, Jason Gunthorpe wrote:
> The kernel side is #ifdef'd to this type, and the UAPI header
> should use it directly. It has slightly different alignment
> requirments from the usual user space version.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
>  include/uapi/rdma/rdma_user_cm.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
> index 01923d463673..d71da36e3cd6 100644
> --- a/include/uapi/rdma/rdma_user_cm.h
> +++ b/include/uapi/rdma/rdma_user_cm.h
> @@ -110,7 +110,7 @@ struct rdma_ucm_bind {
>  	__u32 id;
>  	__u16 addr_size;
>  	__u16 reserved;
> -	struct sockaddr_storage addr;
> +	struct __kernel_sockaddr_storage addr;
>  };
>
>  struct rdma_ucm_resolve_ip {
> @@ -126,8 +126,8 @@ struct rdma_ucm_resolve_addr {
>  	__u16 src_size;
>  	__u16 dst_size;
>  	__u32 reserved;
> -	struct sockaddr_storage src_addr;
> -	struct sockaddr_storage dst_addr;
> +	struct __kernel_sockaddr_storage src_addr;
> +	struct __kernel_sockaddr_storage dst_addr;
>  };
>
>  struct rdma_ucm_resolve_route {
> @@ -164,8 +164,8 @@ struct rdma_ucm_query_addr_resp {
>  	__u16 pkey;
>  	__u16 src_size;
>  	__u16 dst_size;
> -	struct sockaddr_storage src_addr;
> -	struct sockaddr_storage dst_addr;
> +	struct __kernel_sockaddr_storage src_addr;
> +	struct __kernel_sockaddr_storage dst_addr;
>  };
>
>  struct rdma_ucm_query_path_resp {
> @@ -257,7 +257,7 @@ struct rdma_ucm_join_mcast {
>  	__u32 id;
>  	__u16 addr_size;
>  	__u16 join_flags;
> -	struct sockaddr_storage addr;
> +	struct __kernel_sockaddr_storage addr;
>  };
>
>  struct rdma_ucm_get_event {
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--SqGHvGqRphKoTacN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYFt9jAAoJEORje4g2clinlgAQALF5PSlX8m9P01Y52xyNM2v+
CN7A94gH3eI3TjQweCopo2axisNBLM995A6/vEfq+n0t5NwndCuUrF8U3KIPdh7n
Jtn4zJ5INx+BUS3fHu6JiH2KH4havxFWu9+scZ22ZNgPw1Aq5pX+gzcIDEFM76vs
OnDc/DnMebnejo2tgof1hvu2Rag8nRDo5i1VuOi3jVwJnD9DSpOLkmu4H8iM8/b8
unEZ5wZXQ7dma/Oyxwoq0x1Un4xS+QPKcEqKrEhuta3xaHcz1Lrp4HxO6dsttlfb
eXiAtfyn1ap00oImzhrsktAQxgwZa4LCsqPeg8JQD3B4/phninUbbJ4kw5wojwJd
yAP0Y6MZzR2+RXqogUl/nTr+RxrXCHgvpE9xcQ6DwLJXX2IEKtJa0VVjvwX+dPr7
lljjLuzxh3GxxwdiII2C+yXqpIeUo0jkHxF7z261cWfldEC7PwjuO22OsEPxkkSs
S9I40vuk4M4G0b7pF+UG1hYBxg3tb1w+PcGPKsCB+U814l7JIpI1lhdha26zXUm6
fgg0qh3AIWlpa6oLyVLhNUMtPNc3c+kXD8MjCb1mauIS/KJD9xSG/PHFkKyihnyZ
9s0O8/ect2DIjVwpB+fi7mrMT9ctmceKiUyqesivkkzOgv/FPE9AptUGC6ewfhHW
S2HDFYcUH0rCPbdoI4Nl
=vPJG
-----END PGP SIGNATURE-----

--SqGHvGqRphKoTacN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
