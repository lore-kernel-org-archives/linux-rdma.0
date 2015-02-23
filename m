From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/9] IB/ipoib: Use dedicated workqueues per interface
Date: Mon, 23 Feb 2015 18:48:54 +0200
Message-ID: <CAJ3xEMggQCzn2LfuvjeinC9pFR7nFXRaxST-J-Pu_8wJSobogg@mail.gmail.com>
References: <cover.1424562072.git.dledford@redhat.com>
	<1cfdf15058cea312f07c2907490a1d7300603c40.1424562072.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1cfdf15058cea312f07c2907490a1d7300603c40.1424562072.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 22, 2015 at 2:27 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> @@ -236,12 +247,19 @@ out_free_send_cq:
>  out_free_recv_cq:
>         ib_destroy_cq(priv->recv_cq);
>
> +out_cm_dev_cleanup:
> +       ipoib_cm_dev_cleanup(dev);
> +
> +out_free_wq:
> +       destroy_workqueue(priv->wq);
> +       priv->wq = NULL;
> +
>  out_free_mr:
>         ib_dereg_mr(priv->mr);
> -       ipoib_cm_dev_cleanup(dev);
>
>  out_free_pd:
>         ib_dealloc_pd(priv->pd);
> +
>         return -ENODEV;
>  }

just quick initial feedback to get fixed for V1 of the reworked
series: please avoid random addition/deletion of blank lines as part
of patch that fix bug X or introduce feature Y

>
> @@ -265,11 +283,18 @@ void ipoib_transport_dev_cleanup(struct net_device *dev)
>
>         ipoib_cm_dev_cleanup(dev);
>
> +       if (priv->wq) {
> +               flush_workqueue(priv->wq);
> +               destroy_workqueue(priv->wq);
> +               priv->wq = NULL;
> +       }
> +
>         if (ib_dereg_mr(priv->mr))
>                 ipoib_warn(priv, "ib_dereg_mr failed\n");
>
>         if (ib_dealloc_pd(priv->pd))
>                 ipoib_warn(priv, "ib_dealloc_pd failed\n");
> +
>  }

here too
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
