From: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Thu, 26 Oct 2017 12:17:18 -0500
Message-ID: <CALpBJjoMLCqzVe5yKp4wCX-X-sH+=zv1QZfMvOWh2Ukh3c2LFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello linux-rmda,

I recently upgraded one of my boxes to 4.13, and have started
experiencing issues with ib_mthca. To start, my setup is Infiniband
direct between 2 servers using older Mellanox Technologies MT25208
cards for ipoib as well as NFS over RDMA. After upgrading, the
following has been experienced:

1. On my NAS host running OpenSM, as soon as it starts I get a NULL
pointer dereference which makes infiniband unusable. [0] This only
occurs on kernel 4.13 or newer.

2. On my compute host not running OpenSM, connectivity works for a bit
but shortly after dmesg is full of the following message:
infiniband mthca0: ib_post_send_mad error
This occurs when my compute host is on kernel 4.13 or newer.

I went ahead and tested some mainline kernel versions on both of my
nodes, and here are my findings:
4.13.8 = NULL pointer dereference on NAS, IPoIB not working
4.12.14 = Works as expected
4.14.0-rc5 = NULL pointer dereference on NAS, IPoIB not working

I have tried to see if I could find the patch responsible for this,
but sadly I have not had much luck.

As for my systems, the following modules are loaded:
ib_uverbs
ib_umad
rdma_ucm
ib_mthca
ib_ipoib

Let me know if there is anything I can test to help diagnose what is
causing this issue.

Regards,
Chris Blake

[0]: https://gist.github.com/riptidewave93/48595b8bc3bca669251db7d8a8e8a803
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
