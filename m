From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/sa: Add cached attribute containing SM
 information to SA port
Date: Tue, 5 Jul 2016 13:37:00 +0300
Message-ID: <CAJ3xEMg81RgPM5RTRSaANBW87LDOBSUrvWVwqAywe+Wiap1aRg@mail.gmail.com>
References: <1467550074-24061-1-git-send-email-leon@kernel.org> <1467550074-24061-2-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467550074-24061-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 3, 2016 at 3:47 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c

>  struct ib_sa_port {
> -       struct ib_mad_agent *agent;
> -       struct ib_sa_sm_ah  *sm_ah;
> -       struct work_struct   update_task;
> -       spinlock_t           ah_lock;
> -       u8                   port_num;
> +       struct ib_mad_agent             *agent;
> +       struct ib_sa_sm_ah              *sm_ah;
> +       struct work_struct              update_task;

please avoid re-spacing/tabbing/moving existing structure fields around when
you introduce new fields

> +       struct ib_sa_classport_cache    classport_info;
> +       spinlock_t                      classport_lock; /* protects class port info set */
> +       spinlock_t                      ah_lock;
> +       u8                              port_num;
>  };
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
