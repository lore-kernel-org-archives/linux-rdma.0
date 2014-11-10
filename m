From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 06/10] xprtrdma: Enable pad optimization
Date: Mon, 10 Nov 2014 09:36:03 -0500
Message-ID: <5460CD53.1080301@Netapp.com>
References: <20141109010328.8806.5861.stgit@manet.1015granger.net> <20141109011453.8806.31817.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141109011453.8806.31817.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Chuck,


On 11/08/2014 08:14 PM, Chuck Lever wrote:
> The Linux NFS/RDMA server used to reject NFSv3 WRITE requests when
> pad optimization was enabled. That bug was fixed by commit
> e560e3b510d2 ("svcrdma: Add zero padding if the client doesn't send
> it").

Do we need to worry about backwards compatibility with servers that don't have this patch?

Anna

>
> We can now enable pad optimization on the client, which helps
> performance and is supported now by both Linux and Solaris servers.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/transport.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
> index cfe9a81..8ed2576 100644
> --- a/net/sunrpc/xprtrdma/transport.c
> +++ b/net/sunrpc/xprtrdma/transport.c
> @@ -73,7 +73,7 @@ static unsigned int xprt_rdma_max_inline_read = RPCRDMA_DEF_INLINE;
>  static unsigned int xprt_rdma_max_inline_write = RPCRDMA_DEF_INLINE;
>  static unsigned int xprt_rdma_inline_write_padding;
>  static unsigned int xprt_rdma_memreg_strategy = RPCRDMA_FRMR;
> -                int xprt_rdma_pad_optimize = 0;
> +		int xprt_rdma_pad_optimize = 1;
>  
>  #ifdef RPC_DEBUG
>  
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
