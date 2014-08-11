From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_mad: fix microblaze build issue (PFX macro mistake)
Date: Mon, 11 Aug 2014 14:34:11 -0700
Message-ID: <CAG4TOxNVh6=hJD8PjF5sM013Dd1Ha08CC37fRQvdO-n0Vy31rw@mail.gmail.com>
References: <1407775544-24746-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407775544-24746-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 3c6b228..cc00e4e 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -34,7 +34,7 @@
>   *
>   */
>
> -#define pr_fmt(fmt) PFX fmt
> +#define pr_fmt(fmt) "ib_mad: " fmt
>
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
> --
> 1.8.2
>

Thanks, I had already rolled in a slightly different fix...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
