From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/addr: Improve address resolution callback scheduling
Date: Sun, 14 Dec 2014 22:25:55 +0200
Message-ID: <CAJ3xEMhcFXMb_vcUSPtt3LiD-sojg5DiiDcK+8GbRWtr7wLjig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 29, 2014 at 4:32 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
[...]
> Using one jiffie as the minimum delay value results in a less optimized
> scheduling of executing this work item by the workqueue, which on the
> below testbed costs about 3-4ms out of 12ms total time.

Hi Roland,

Hope the merge window work goes well, it's a bit hard for me to
realize where things are since your public clone of the IB tree is
inactive...

Just to make sure, Sean acked this patch (see [1]) and another IB core
patch from Jack ([2] below), please make sure to pick them for the
3.19 merge window.

Also, there's 3rd patch, from Moni ([3] below), don't miss it. As for
ODP, we should be ready to go after spending so long on the list and
addressing the feedback provided during the review, the V3 post ([4]
below) contains the last fixes and also a pointer to git tree where
you can pull the patches

Or.

[1] http://marc.info/?l=linux-rdma&m=141508254631768&q=raw
[2] http://marc.info/?l=linux-rdma&m=141748196100745&q=raw
[3] http://marc.info/?l=linux-rdma&m=141638933930273&w=2
[4] http://marc.info/?l=linux-rdma&m=141831118019827&q=raw


> To fix that, we let the minimum delay to be zero. Note that the
> connect step times change too, as there are address resolution
> calls from that flow.
>
> The results were taken from running both client and server on the
> same node, over mlx4 RoCE port.
>
> before -->
> step              total ms     max ms     min us  us / conn
> create id    :        0.01       0.01       6.00       6.00
> resolve addr :        4.02       4.01    4013.00    4016.00
> resolve route:        0.18       0.18     182.00     183.00
> create qp    :        1.15       1.15    1150.00    1150.00
> connect      :        6.73       6.73    6730.00    6731.00
> disconnect   :        0.55       0.55     549.00     550.00
> destroy      :        0.01       0.01       9.00       9.00
>
> after -->
> step              total ms     max ms     min us  us / conn
> create id    :        0.01       0.01       6.00       6.00
> resolve addr :        0.05       0.05      49.00      52.00
> resolve route:        0.21       0.21     207.00     208.00
> create qp    :        1.10       1.10    1104.00    1104.00
> connect      :        1.22       1.22    1220.00    1221.00
> disconnect   :        0.71       0.71     713.00     713.00
> destroy      :        0.01       0.01       9.00       9.00
>
> Signed-off-by: Or Kehati <ork-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/addr.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> index 8172d37..f80da50 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -176,8 +176,8 @@ static void set_timeout(unsigned long time)
>         unsigned long delay;
>
>         delay = time - jiffies;
> -       if ((long)delay <= 0)
> -               delay = 1;
> +       if ((long)delay < 0)
> +               delay = 0;
>
>         mod_delayed_work(addr_wq, &work, delay);
>  }
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
