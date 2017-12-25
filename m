From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/15] net/mlx5: Fix race for multiple RoCE enable
Date: Mon, 25 Dec 2017 11:21:17 +0200
Message-ID: <CAJ3xEMg0mJM8MnOFk4C=HY8QtyoG3Qu17t-WU2Kb_XQ1+4KYMw@mail.gmail.com>
References: <20171224125741.25464-1-leon@kernel.org> <20171224125741.25464-2-leon@kernel.org>
 <CAJ3xEMg8U_4DpYEWa8t1QpccNzjU6f0shEtQ7fRWg-EtGupy+w@mail.gmail.com> <20171225055916.GU2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171225055916.GU2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 25, 2017 at 7:59 AM, Leon Romanovsky wrote:
> On Sun, Dec 24, 2017 at 11:53:16PM +0200, Or Gerlitz wrote:

>> Dan, please send this to net as a fix

> we will proceed with our initial plan and continue to submit this as part of our original dual-port-roce
> series.

This is a patch to the core driver which is maintained @ netdev. The
netdev maintainer stated clearly
to us that fixes should go to net or to rdma-rc if you want to get
that through the rdma tree. Note that
you should not loose a cycle just b/c you stepped on a bug during a
feature development, unfortunately
it happens a lot... we sent a net patch and then rebase the net-next
submission on top of it, you can do
the same for rdma rc/next.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
