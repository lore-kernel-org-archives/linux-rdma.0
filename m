From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 5/9] IB/ipoib: rtnl_unlock can not come after free_netdev
Date: Thu, 29 Dec 2016 22:55:34 +0200
Message-ID: <CAJ3xEMg+UuvUqqaFrBXa+S+S2qLg_FowZLrwvhYzaB7JTkn=pQ@mail.gmail.com>
References: <20161228124728.26619-1-leon@kernel.org> <20161228124728.26619-6-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161228124728.26619-6-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 28, 2016 at 2:47 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> The ipoib_vlan_add function calls rtnl_unlock after free_netdev,
> rtnl_unlock not only releases the lock, but also calls netdev_run_todo.
> The latter function browses the net_todo_list array and completes the
> unregistration of all its net_device instances. If we call free_netdev
> before rtnl_unlock, then netdev_run_todo call over the freed device causes
> panic.


RU claiming that we are crashing 100.0% here? since when? ever?

> To fix, move rtnl_unlock call before free_netdev call.
>
> Fixes: 9baa0b036410 ("IB/ipoib: Add rtnl_link_ops support")
> Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> index 9682183..d9dab4a 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> @@ -168,11 +168,11 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
>  out:
>         up_write(&ppriv->vlan_rwsem);
>
> +       rtnl_unlock();
> +
>         if (result)
>                 free_netdev(priv->dev);
>
> -       rtnl_unlock();
> -
>         return result;
>  }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
