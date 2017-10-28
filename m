From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/4] xprtrdma: Put Send CQ in IB_POLL_WORKQUEUE mode
Date: Sat, 28 Oct 2017 13:02:09 +0530
Message-ID: <CANjDDBiVPTjEqnoUHGkkDndfHOa=viS7mQT0odNi0PX=mL3WSQ@mail.gmail.com>
References: <20171027164014.10826.10151.stgit@manet.1015granger.net> <20171027164354.10826.314.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171027164354.10826.314.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks good
Reviewed-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

On Fri, Oct 27, 2017 at 10:13 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Lift the Send and LocalInv completion handlers out of soft IRQ mode
> to make room for other work. Also, move the Send CQ to a different
> CPU than the CPU where the Receive CQ is running, for improved
> scalability.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/verbs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 22128a8..4cfa893 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -558,7 +558,7 @@
>
>         sendcq = ib_alloc_cq(ia->ri_device, NULL,
>                              ep->rep_attr.cap.max_send_wr + 1,
> -                            0, IB_POLL_SOFTIRQ);
> +                            1, IB_POLL_WORKQUEUE);
>         if (IS_ERR(sendcq)) {
>                 rc = PTR_ERR(sendcq);
>                 dprintk("RPC:       %s: failed to create send CQ: %i\n",
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
