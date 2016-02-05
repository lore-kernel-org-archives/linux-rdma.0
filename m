From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 04/10] rpcrdma: Add missing XDR union fields for RDMA errors
Date: Fri, 5 Feb 2016 15:53:32 +0530
Message-ID: <CANjDDBgwBBx1G0J8cKPscZVYa5egpqW_PpZb8Bs+6TJjDtGHiw@mail.gmail.com>
References: <20160203154411.13868.48268.stgit@klimt.1015granger.net> <20160203155155.13868.64840.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203155155.13868.64840.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 3, 2016 at 9:21 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Add some infrastructure (shared between xprtrdma and svcrdma) for
> constructing and parsing RPC-over-RDMA error status information.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/sunrpc/rpc_rdma.h |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/sunrpc/rpc_rdma.h b/include/linux/sunrpc/rpc_rdma.h
> index f33c5a4..a5a36c0 100644
> --- a/include/linux/sunrpc/rpc_rdma.h
> +++ b/include/linux/sunrpc/rpc_rdma.h
> @@ -93,6 +93,12 @@ struct rpcrdma_msg {
>                         __be32 rm_pempty[3];    /* 3 empty chunk lists */
>                 } rm_padded;
>
> +               struct {
> +                       __be32 rm_err;
> +                       __be32 rm_vers_low;
> +                       __be32 rm_vers_hi;
> +               } rm_error;
> +

I don't see above members being used or filled with a value, I am
missing the link?

>                 __be32 rm_chunks[0];    /* read, write and reply chunks */
>
>         } rm_body;
> @@ -102,12 +108,16 @@ struct rpcrdma_msg {
>   * Smallest RPC/RDMA header: rm_xid through rm_type, then rm_nochunks
>   */
>  #define RPCRDMA_HDRLEN_MIN     (sizeof(__be32) * 7)
> +#define RPCRDMA_HDRLEN_ERR     (sizeof(__be32) * 5)
>
>  enum rpcrdma_errcode {
>         ERR_VERS = 1,
>         ERR_CHUNK = 2
>  };
>
> +#define err_vers       cpu_to_be32(ERR_VERS)
> +#define err_chunk      cpu_to_be32(ERR_CHUNK)
> +
>  struct rpcrdma_err_vers {
>         uint32_t rdma_vers_low; /* Version range supported by peer */
>         uint32_t rdma_vers_high;
> @@ -118,7 +128,8 @@ enum rpcrdma_proc {
>         RDMA_NOMSG = 1,         /* An RPC call or reply msg - separate body */
>         RDMA_MSGP = 2,          /* An RPC call or reply msg with padding */
>         RDMA_DONE = 3,          /* Client signals reply completion */
> -       RDMA_ERROR = 4          /* An RPC RDMA encoding error */
> +       RDMA_ERROR = 4,         /* An RPC RDMA encoding error */
> +       RDMA_LAST
>  };
>
>  #define rdma_msg       cpu_to_be32(RDMA_MSG)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
