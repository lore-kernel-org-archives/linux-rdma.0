From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 08/12] IB/mlx5: Wait for all async command
 completions to complete
Date: Fri, 28 Oct 2016 16:04:25 +0300
Message-ID: <CAJ3xEMjrL=u8sTicrywEOysv3wJngEg45s4gOLVVcyfcxs3U-A@mail.gmail.com>
References: <1477575407-20562-1-git-send-email-leon@kernel.org> <1477575407-20562-9-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575407-20562-9-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 27, 2016 at 4:36 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:


> +static void wait_for_async_commands(struct mlx5_ib_dev *dev)
> +{
> +       struct mlx5_mr_cache *cache = &dev->cache;
> +       struct mlx5_cache_ent *ent;
> +       int total = 0;
> +       int i;
> +       int j;
> +
> +       for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
> +               ent = &cache->ent[i];
> +               for (j = 0 ; j < 1000; j++) {
> +                       if (!ent->pending)
> +                               break;
> +                       msleep(50);
> +               }

you had another patch on this series which change a hard coded
constant into a define, why this patch add two new hard coded
constants, so all to all, we're not making progress on that
no-hard-coded-constants front... better decide where you want to go
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
