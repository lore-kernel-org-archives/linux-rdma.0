From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 4/7] svcrdma: Clean up backchannel send header encoding
Date: Wed, 1 Feb 2017 10:29:57 -0800
Message-ID: <20170201182957.GC32532@infradead.org>
References: <20170131184623.14185.35480.stgit@klimt.1015granger.net>
 <20170131185318.14185.90053.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170131185318.14185.90053.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 31, 2017 at 01:53:18PM -0500, Chuck Lever wrote:
> Replace C structure-based XDR decoding with pointer arithmetic.
> Pointer arithmetic is considered more portable.
> 
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
> index 288e35c..abfce04 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
> @@ -200,19 +200,20 @@ static int svc_rdma_bc_sendto(struct svcxprt_rdma *rdma,
>  {
>  	struct rpc_xprt *xprt = rqst->rq_xprt;
>  	struct rpcrdma_xprt *r_xprt = rpcx_to_rdmax(xprt);
> -	struct rpcrdma_msg *headerp = (struct rpcrdma_msg *)rqst->rq_buffer;
> +	__be32 *p;
>  	int rc;
>  
>  	/* Space in the send buffer for an RPC/RDMA header is reserved
>  	 * via xprt->tsh_size.
>  	 */
> +	p = (__be32 *)rqst->rq_buffer;

Why not move the assignment onto the same line as the declaration
of p?  Also rq_buffer is a void pointer, so the case shouldn't be
needed.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
