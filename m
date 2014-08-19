From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/8] IPoIB: fix MCAST_FLAG_BUSY usage
Date: Tue, 19 Aug 2014 11:08:26 -0700
Message-ID: <CABgxfbH-Dt3CpxJKwCAZeHTUyupaA9y_WXVXuxgiPMet26PTQw@mail.gmail.com>
References: <cover.1407885724.git.dledford@redhat.com>
	<a410e80dc5ca7cfa64229bbbf50c1337317e3bd8.1407885724.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a410e80dc5ca7cfa64229bbbf50c1337317e3bd8.1407885724.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 12, 2014 at 4:38 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Commit a9c8ba5884 (IPoIB: Fix usage of uninitialized multicast objects)
> added a new flag MCAST_JOIN_STARTED, but was not very strict in how it
> was used.  We didn't always initialize the completion struct before we
> set the flag, and we didn't always call complete on the completion
> struct from all paths that complete it.  This made it less than totally
> effective, and certainly made its use confusing.  And in the flush
> function we would use the presence of this flag to signal that we should
> wait on the completion struct, but we never cleared this flag, ever.
> This is further muddied by the fact that we overload the MCAST_FLAG_BUSY
> flag to mean two different things: we have a join in flight, and we have
> succeeded in getting an ib_sa_join_multicast.
>

[snip]

> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index 7e9cd39b5ef..f5e8da530d9 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -271,16 +271,27 @@ ipoib_mcast_sendonly_join_complete(int status,
>         struct ipoib_mcast *mcast = multicast->context;
>         struct net_device *dev = mcast->dev;
>
> +       /*
> +        * We have to take the mutex to force mcast_sendonly_join to
> +        * return from ib_sa_multicast_join and set mcast->mc to a
> +        * valid value.  Otherwise we were racing with ourselves in
> +        * that we might fail here, but get a valid return from
> +        * ib_sa_multicast_join after we had cleared mcast->mc here,
> +        * resulting in mis-matched joins and leaves and a deadlock
> +        */
> +       mutex_lock(&mcast_mutex);
> +
>         /* We trap for port events ourselves. */
>         if (status == -ENETRESET)
> -               return 0;
> +               goto out;
>

[snip]


> +out:
> +       clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
> +       if (status)
> +               mcast->mc = NULL;
> +       complete(&mcast->done);
> +       if (status == -ENETRESET)
> +               status = 0;
> +       mutex_unlock(&mcast_mutex);
>         return status;
>  }
>

I have not gone thru the whole patch yet. However, here is something quick ...

Would this "return 0 if (status == -ENETRESET)" be wrong in the
original code ?  Say ..... when it returns to process_group_error(),
without proper error return code, it'll skip ib_sa_free_multicast().
Should we worry about it ?

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
