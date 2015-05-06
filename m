From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH v1 02/14] xprtrdma: Warn when there are orphaned IB objects
Date: Wed, 6 May 2015 17:07:05 +0530
Message-ID: <CANjDDBicLDb7K=RZB5Gqv+oACaAG8DANJX3ML971jnXd_5KEuQ@mail.gmail.com>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net>
	<20150504175700.3483.57728.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150504175700.3483.57728.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 4, 2015 at 11:27 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> Print an error during transport destruction if ib_dealloc_pd()
> fails. This is a sign that xprtrdma orphaned one or more RDMA API
> objects at some point, which can pin lower layer kernel modules
> and cause shutdown to hang.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/verbs.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 4870d27..0cc4617 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -710,8 +710,8 @@ rpcrdma_ia_close(struct rpcrdma_ia *ia)
>         }
>         if (ia->ri_pd != NULL && !IS_ERR(ia->ri_pd)) {
>                 rc = ib_dealloc_pd(ia->ri_pd);
> -               dprintk("RPC:       %s: ib_dealloc_pd returned %i\n",
> -                       __func__, rc);

Should we check for EBUSY explicitly? other then this is an error in
vendor specific ib_dealloc_pd()

> +               if (rc)
> +                       pr_warn("rpcrdma: ib_dealloc_pd status %i\n", rc);
>         }
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




-- 
-Regards
Devesh
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
