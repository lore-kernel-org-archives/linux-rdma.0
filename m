From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibmad: To handle null dev_name in madrpc_init
Date: Wed, 20 Mar 2013 15:41:54 -0700
Message-ID: <CAMLCd9K5o0Uv2zC5xrZJ-2qma0rmX45kB2YkrmOXa-GZ14M0oQ@mail.gmail.com>
References: <513F844C.9060906@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <513F844C.9060906-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 12, 2013 at 12:38 PM, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> From: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> Signed-off-by: Brendan Doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks applied,
Ira

> ---
> src/rpc.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/src/rpc.c b/src/rpc.c
> index 6312d42..cb224fd 100644
> --- a/src/rpc.c
> +++ b/src/rpc.c
> @@ -360,7 +360,8 @@ madrpc_init(char *dev_name, int dev_port, int
> *mgmt_classes, int num_classes)
>                 IBPANIC("can't init UMAD library");
>
>         if ((fd = umad_open_port(dev_name, dev_port)) < 0)
> -               IBPANIC("can't open UMAD port (%s:%d)", dev_name, dev_port);
> +               IBPANIC("can't open UMAD port (%s:%d)",
> +               dev_name ? dev_name : "(nil)", dev_port);
>
>         if (num_classes >= MAX_CLASS)
>                 IBPANIC("too many classes %d requested", num_classes);
> --
> 1.7.1
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
