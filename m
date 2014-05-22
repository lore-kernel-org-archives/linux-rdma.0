From: Trond Myklebust <trondmy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 20/24] xprtrdma: Reset connection timeout after
 successful reconnect
Date: Wed, 21 May 2014 22:07:03 -0400
Message-ID: <CAABAsM5m_CT7qUv4Xbm+LKoSZaia55APO3kgnt7Ti1x24gsrbg@mail.gmail.com>
References: <20140522004505.27190.58897.stgit@manet.1015granger.net>
	<20140522005707.27190.2035.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140522005707.27190.2035.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 21, 2014 at 8:57 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> If the new connection is able to make forward progress, reset the
> re-establish timeout. Otherwise it keeps growing even if disconnect
> events are rare.
>
> The same behavior as TCP is adopted: reconnect immediately if the
> transport instance has been able to make some forward progress.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>
>  net/sunrpc/xprtrdma/rpc_rdma.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
> index dc4a826..1334646 100644
> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
> @@ -770,6 +770,8 @@ repost:
>
>         /* from here on, the reply is no longer an orphan */
>         req->rl_reply = rep;
> +       if (xprt->reestablish_timeout)
> +               xprt->reestablish_timeout = 0;

What's the point of making this conditional?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
