From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 3/8] rpcrdma: Add RPCRDMA_HDRLEN_ERR
Date: Mon, 15 Feb 2016 19:58:07 +0530
Message-ID: <CANjDDBj+Psb=mSTutaLWfHY66NALF7J8vdzGBUbbSWSXL_X-ag@mail.gmail.com>
References: <20160212205107.5278.55938.stgit@manet.1015granger.net> <20160212210618.5278.28591.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160212210618.5278.28591.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks good.

On Sat, Feb 13, 2016 at 2:36 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Error headers are shorter than either RDMA_MSG or RDMA_NOMSG.
>
> Since HDRLEN_MIN is already used in several other places that would
> be annoying to change, add RPCRDMA_HDRLEN_ERR for the one or two
> spots where the shorter length is needed.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/sunrpc/rpc_rdma.h |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/sunrpc/rpc_rdma.h b/include/linux/sunrpc/rpc_rdma.h
> index f33c5a4..8c6d23c 100644
> --- a/include/linux/sunrpc/rpc_rdma.h
> +++ b/include/linux/sunrpc/rpc_rdma.h
> @@ -102,6 +102,7 @@ struct rpcrdma_msg {
>   * Smallest RPC/RDMA header: rm_xid through rm_type, then rm_nochunks
>   */
>  #define RPCRDMA_HDRLEN_MIN     (sizeof(__be32) * 7)
> +#define RPCRDMA_HDRLEN_ERR     (sizeof(__be32) * 5)
>
>  enum rpcrdma_errcode {
>         ERR_VERS = 1,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
