From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc V1 6/9] IB/mlx4: Put non zero value in max_ah
 device attribute
Date: Fri, 11 Nov 2016 11:14:23 +0200
Message-ID: <CAJ3xEMj-f6JYFGHfWFB5q9mNOUUcmHenwEJZbqPGtEOGnBDFZQ@mail.gmail.com>
References: <1478770261-5775-1-git-send-email-leon@kernel.org> <1478770261-5775-7-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478770261-5775-7-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 10, 2016 at 11:30 AM, Leon Romanovsky wrote:

> Use INT_MAX since this is the max value the attribute can hold, though
> hardware capability is unlimited.

> Fixes: 225c7b1feef1 ('IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters')

why this small enhancement to a 10y old commit of Roland must go to
4.9-rc5 or even later? it clearly for -next, if you think differently,
explain.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
