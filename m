From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use vmalloc for WR buffers when needed
Date: Thu, 24 Sep 2015 14:57:31 +0300
Message-ID: <CAJ3xEMgN4_gk4_hVXOW2GhcfnXxgPnm=Lrc7JwkxBAeKv4KRAQ@mail.gmail.com>
References: <1443091747-13881-1-git-send-email-wen.gang.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443091747-13881-1-git-send-email-wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 24, 2015 at 1:49 PM, Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> @@ -786,8 +787,14 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
>                 if (err)
>                         goto err_mtt;
>
> -               qp->sq.wrid  = kmalloc(qp->sq.wqe_cnt * sizeof (u64), gfp);
> -               qp->rq.wrid  = kmalloc(qp->rq.wqe_cnt * sizeof (u64), gfp);
> +               qp->sq.wrid = kmalloc(qp->sq.wqe_cnt * sizeof(u64), gfp);
> +               if (!qp->sq.wrid)
> +                       qp->sq.wrid = __vmalloc(qp->sq.wqe_cnt * sizeof(u64),
> +                                               gfp, PAGE_KERNEL);

On other spots of mlx4, we're using vmalloc and not __vmalloc, any
pros/cons for going that way too here?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
