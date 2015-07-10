From: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org (J. Bruce Fields)
Subject: Re: [PATCH v1 5/5] svcrdma: Boost NFS READ/WRITE payload size maximum
Date: Fri, 10 Jul 2015 10:18:14 -0400
Message-ID: <20150710141814.GA31121@fieldses.org>
References: <20150709204230.8481.45457.stgit@klimt.1015granger.net>
 <20150709204546.8481.65857.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150709204546.8481.65857.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 09, 2015 at 04:45:47PM -0400, Chuck Lever wrote:
> Increased to 1 megabyte.

Why not more or less?

Why do we even have this constant, why shouldn't we just use
RPCSVC_MAXPAYLOAD?

--b.

> 
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> 
>  include/linux/sunrpc/svc_rdma.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
> index 13af61b..1bca6dd 100644
> --- a/include/linux/sunrpc/svc_rdma.h
> +++ b/include/linux/sunrpc/svc_rdma.h
> @@ -172,7 +172,7 @@ struct svcxprt_rdma {
>  #define RDMAXPRT_SQ_PENDING	2
>  #define RDMAXPRT_CONN_PENDING	3
>  
> -#define RPCRDMA_MAX_SVC_SEGS	(64)	/* server max scatter/gather */
> +#define RPCRDMA_MAX_SVC_SEGS	(256)	/* server max scatter/gather */
>  #if RPCSVC_MAXPAYLOAD < (RPCRDMA_MAX_SVC_SEGS << PAGE_SHIFT)
>  #define RPCRDMA_MAXPAYLOAD	RPCSVC_MAXPAYLOAD
>  #else
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
