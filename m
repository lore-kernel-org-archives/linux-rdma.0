From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH v1 01/18] xprtrdma: Enable swap-on-NFS/RDMA
Date: Mon, 21 Sep 2015 14:28:05 +0530
Message-ID: <CANjDDBgtVuV1o4jyqEiTcz1TXyY3cuSaOAoRcCxTFhSrT8PVHg@mail.gmail.com>
References: <20150917202829.19671.90044.stgit@manet.1015granger.net> <20150917204418.19671.49594.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150917204418.19671.49594.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks Good.

On Fri, Sep 18, 2015 at 2:14 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> After adding a swapfile on an NFS/RDMA mount and removing the
> normal swap partition, I was able to push the NFS client well
> into swap without any issue.
>
> I forgot to swapoff the NFS file before rebooting. This pinned
> the NFS mount and the IB core and provider, causing shutdown to
> hang. I think this is expected and safe behavior. Probably
> shutdown scripts should "swapoff -a" before unmounting any
> filesystems.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/transport.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
> index 41e452b..e9e5ed7 100644
> --- a/net/sunrpc/xprtrdma/transport.c
> +++ b/net/sunrpc/xprtrdma/transport.c
> @@ -676,7 +676,7 @@ static void xprt_rdma_print_stats(struct rpc_xprt *xprt, struct seq_file *seq)
>  static int
>  xprt_rdma_enable_swap(struct rpc_xprt *xprt)
>  {
> -       return -EINVAL;
> +       return 0;
>  }
>
>  static void
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
