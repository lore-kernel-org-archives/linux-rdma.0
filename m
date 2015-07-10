From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 02/12] xprtrdma: Raise maximum payload size to one
 megabyte
Date: Fri, 10 Jul 2015 15:21:58 -0400
Message-ID: <55A01B56.2020107@Netapp.com>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
 <20150709204159.26247.44592.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709204159.26247.44592.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,

On 07/09/2015 04:41 PM, Chuck Lever wrote:
> The point of larger rsize and wsize is to reduce the per-byte cost
> of memory registration and deregistration. Modern HCAs can typically
> handle a megabyte or more with a single registration operation.
> 
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/xprt_rdma.h |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
> index f49dd8b..abee472 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> @@ -165,8 +165,7 @@ rdmab_to_msg(struct rpcrdma_regbuf *rb)
>   * struct rpcrdma_buffer. N is the max number of outstanding requests.
>   */
>  
> -/* temporary static scatter/gather max */
> -#define RPCRDMA_MAX_DATA_SEGS	(64)	/* max scatter/gather */
> +#define RPCRDMA_MAX_DATA_SEGS	((1 * 1024 * 1024) / PAGE_SIZE)
                                         ^^^
What is the significance of the 1 here?

Thanks,
Anna

>  #define RPCRDMA_MAX_SEGS 	(RPCRDMA_MAX_DATA_SEGS + 2) /* head+tail = 2 */
>  
>  struct rpcrdma_buffer;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
