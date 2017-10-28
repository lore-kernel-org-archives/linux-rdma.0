From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/4] xprtrdma: Remove include for linux/prefetch.h
Date: Sat, 28 Oct 2017 13:06:20 +0530
Message-ID: <CANjDDBj0vq+FPFNgHU2DdMUpkJx8ho_jjjW-ur_Gt6wL03h7GA@mail.gmail.com>
References: <20171027164014.10826.10151.stgit@manet.1015granger.net> <20171027164410.10826.94955.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171027164410.10826.94955.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

looks good,

Reveiwed-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

On Fri, Oct 27, 2017 at 10:14 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Clean up. This include should have been removed by
> commit 23826c7aeac7 ("xprtrdma: Serialize credit accounting again").
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/verbs.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 4cfa893..be61c29 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -49,7 +49,6 @@
>
>  #include <linux/interrupt.h>
>  #include <linux/slab.h>
> -#include <linux/prefetch.h>
>  #include <linux/sunrpc/addr.h>
>  #include <linux/sunrpc/svc_rdma.h>
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
