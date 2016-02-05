From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 08/10] svcrdma: Remove close_out exit path
Date: Fri, 5 Feb 2016 16:11:43 +0530
Message-ID: <CANjDDBhK9OnuyAiBDdu25wkTtqVdip2wKn2OfCnWay14L1RWcA@mail.gmail.com>
References: <20160203154411.13868.48268.stgit@klimt.1015granger.net> <20160203155227.13868.21062.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203155227.13868.21062.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks good.

On Wed, Feb 3, 2016 at 9:22 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Clean up: close_out is reached only when ctxt == NULL and XPT_CLOSE
> is already set.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> index f8b840b..d3718e9 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
> @@ -641,8 +641,7 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
>                  * transport list
>                  */
>                 if (test_bit(XPT_CLOSE, &xprt->xpt_flags))
> -                       goto close_out;
> -
> +                       goto defer;
>                 goto out;
>         }
>         dprintk("svcrdma: processing ctxt=%p on xprt=%p, rqstp=%p, status=%d\n",
> @@ -700,15 +699,6 @@ out_err:
>         svc_rdma_put_context(ctxt, 0);
>         return 0;
>
> - close_out:
> -       if (ctxt)
> -               svc_rdma_put_context(ctxt, 1);
> -       dprintk("svcrdma: transport %p is closing\n", xprt);
> -       /*
> -        * Set the close bit and enqueue it. svc_recv will see the
> -        * close bit and call svc_xprt_delete
> -        */
> -       set_bit(XPT_CLOSE, &xprt->xpt_flags);
>  defer:
>         return 0;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
