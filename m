From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 0/7] Add support for multicast loopback
 prevention to mlx4
Date: Wed, 14 Oct 2015 10:34:48 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1510141034060.12266@east.gentwo.org>
References: <1440081275-15864-1-git-send-email-eranbe@mellanox.com> <alpine.DEB.2.11.1508251143430.16801@east.gentwo.org> <CAKHjkjnk9sFfr3KhNGBD_LzXUbDdb7_=vF2A3Z5+ousFShfxJw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKHjkjnk9sFfr3KhNGBD_LzXUbDdb7_=vF2A3Z5+ousFShfxJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eran ben elisha <eranlinuxmellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 26 Aug 2015, eran ben elisha wrote:

> > Do you have this in a git tree somewhere for testing?
>
> Yes,
> please pull from https://github.com/eranbenelisha/linux branch
> rebased-for-4.3/lb_prev
>
> If you with to get the user space as well for testing, please use:
> https://github.com/eranbenelisha/libibverbs branch for-linux-rdma-lb_prev
> https://github.com/eranbenelisha/libmlx4 branch for-linux-rdma-lb_prev

This needs to be rebased. Cannot pull on top of current linus tree.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
