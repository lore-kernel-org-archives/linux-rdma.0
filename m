From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH net 0/2] IB/ipoib: ip link support
Date: Sun, 31 Dec 2017 14:28:29 +0200
Message-ID: <CAJ3xEMiVHc=E7=uKJ4cRRRDxjNDRKQ17=NxnYsEeXNe6-RUvvQ@mail.gmail.com>
References: <1514718983-466-1-git-send-email-denisd@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514718983-466-1-git-send-email-denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Netdev List <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 31, 2017 at 1:16 PM, Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> IP link was broken due to the changes in IPoIB for the rdma_netdev
> support after commit cd565b4b51e5
> ("IB/IPoIB: Support acceleration options callbacks").

you are approaching stable kernels, right? lets make sure dave is okay
to pick the net (touching
dev.c etc) patch to stable even if the offending patch didn't change
anything there.


> This patchset restores IPoIB pkey creation and removal using rtnetlink.
> The first patch introduces changes in the rtnetlink code in order to allow
> IPOIB allocate and free the netdevice.
>
> The second patch establishes appropriate rtnetlink callbacks for IPoIB
> device and restores IPoIB netlink support
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
