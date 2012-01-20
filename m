From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: memory region limit at 32 GB?
Date: Fri, 20 Jan 2012 10:00:58 -0800
Message-ID: <CAL1RGDV8R1S3L-RH-fWH=LfFegJzwNZPhdNyoQG0ZBEtQQwPjQ@mail.gmail.com>
References: <CALfB72D_bp-XEBtAyntZzxF6RvxGyHJjsmsVEzjP8LyVxgAi7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALfB72D_bp-XEBtAyntZzxF6RvxGyHJjsmsVEzjP8LyVxgAi7A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 20, 2012 at 9:39 AM, Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Is there some kind of limit that would prevent me from registering
> more than 32 GiB worth of memory regions with ibv_reg_mr in
> libibverbs?

Yes, by default mlx4 allocates a limited amount of adapter resources
for tracking memory regions.  I forget the exact limits but 32GB looks
reasonable...

In mlx4/main.c, there is

static struct mlx4_profile default_profile = {
        .num_qp         = 1 << 18,
        .num_srq        = 1 << 16,
        .rdmarc_per_qp  = 1 << 4,
        .num_cq         = 1 << 16,
        .num_mcg        = 1 << 13,
        .num_mpt        = 1 << 19,
        .num_mtt        = 1 << 20,
};

and I think if you bump num_mtt up a few powers of 2 (eg
1 << 22) then you should be able to register more.

(num_mpt controls the number of MRs but I guess 33 is
not near the limit of 512K yet ;)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
