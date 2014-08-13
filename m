From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/8] IB/srp: Use P_Key cache for P_Key lookups
Date: Tue, 12 Aug 2014 21:56:32 -0700
Message-ID: <CAG4TOxM5xUh3gLx5wEixuhro7131JxfZHviPm1EgZArJy7+Y4w@mail.gmail.com>
References: <cover.1407885084.git.dledford@redhat.com> <6555e716eda21a03577e5e1e0bfb6bbadbb592d3.1407885084.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6555e716eda21a03577e5e1e0bfb6bbadbb592d3.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 12, 2014 at 4:20 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> -       ret = ib_find_pkey(target->srp_host->srp_dev->dev,
> -                          target->srp_host->port,
> -                          be16_to_cpu(target->path.pkey),
> -                          &attr->pkey_index);
> +       ret = ib_find_cached_pkey(target->srp_host->srp_dev->dev,
> +                                 target->srp_host->port,
> +                                 be16_to_cpu(target->path.pkey),
> +                                 &attr->pkey_index);

I consider the "cached" operations to be a deprecated interface, and
I'd rather remove uses than add new ones.  I have a vague dream of
fixing everything up so the normal interfaces (ib_find_pkey() etc)
don't sleep and are usable everywhere, although that dream will
probably never come true.

But is there any practical benefit to this change?  I don't think
saving a few milliseconds at log in time counts -- I would think it's
lost in the noise of how long it takes to actually log in, scan for
LUNs, etc.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
