From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4 01/11] svcrdma: Do not send XDR roundup bytes for a
 write chunk
Date: Mon, 21 Dec 2015 16:07:08 -0500
Message-ID: <20151221210708.GD7869@fieldses.org>
References: <20151214211951.12932.99017.stgit@klimt.1015granger.net>
 <20151214213009.12932.60521.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151214213009.12932.60521.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 14, 2015 at 04:30:09PM -0500, Chuck Lever wrote:
> Minor optimization: when dealing with write chunk XDR roundup, do
> not post a Write WR for the zero bytes in the pad. Simply update
> the write segment in the RPC-over-RDMA header to reflect the extra
> pad bytes.
> 
> The Reply chunk is also a write chunk, but the server does not use
> send_write_chunks() to send the Reply chunk. That's OK in this case:
> the server Upper Layer typically marshals the Reply chunk contents
> in a single contiguous buffer, without a separate tail for the XDR
> pad.
> 
> The comments and the variable naming refer to "chunks" but what is
> really meant is "segments." The existing code sends only one
> xdr_write_chunk per RPC reply.
> 
> The fix assumes this as well. When the XDR pad in the first write
> chunk is reached, the assumption is the Write list is complete and
> send_write_chunks() returns.
> 
> That will remain a valid assumption until the server Upper Layer can
> support multiple bulk payload results per RPC.
> 
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/svc_rdma_sendto.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
> index 969a1ab..bad5eaa 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
> @@ -342,6 +342,13 @@ static int send_write_chunks(struct svcxprt_rdma *xprt,
>  						arg_ch->rs_handle,
>  						arg_ch->rs_offset,
>  						write_len);
> +
> +		/* Do not send XDR pad bytes */
> +		if (chunk_no && write_len < 4) {
> +			chunk_no++;
> +			break;

I'm pretty lost in this code.  Why does (chunk_no && write_len < 4) mean
this is xdr padding?

> +		}
> +
>  		chunk_off = 0;
>  		while (write_len) {
>  			ret = send_write(xprt, rqstp,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
