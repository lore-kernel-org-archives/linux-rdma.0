From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 07/14] xprtrdma: Remove logic that constructs RDMA_MSGP
 type calls
Date: Tue, 14 Jul 2015 15:00:51 -0400
Message-ID: <55A55C63.50403@talpey.com>
References: <20150713160617.17630.97475.stgit@manet.1015granger.net> <20150713163048.17630.86326.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150713163048.17630.86326.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/13/2015 12:30 PM, Chuck Lever wrote:
> RDMA_MSGP type calls insert a zero pad in the middle of the RPC
> message to align the RPC request's data payload to the server's
> alignment preferences. A server can then "page flip" the payload
> into place to avoid a data copy in certain circumstances. However:
>...
>
> Clean up the marshaling code by removing the logic that constructs
> RDMA_MSGP type calls. This also reduces the maximum send iovec size
> from four to just two elements.
>

> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
> index 8219011..0b50103 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
...>
> +#define RPCRDMA_MAX_IOVS	(4)
> +

So, shouldn't this constant be "2"? The extra 2 iov's were used
only for constructing the pad.



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
