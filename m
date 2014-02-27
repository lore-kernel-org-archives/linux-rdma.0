From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Query regarding HCR mellanox mlx4
Date: Fri, 28 Feb 2014 00:15:54 +0530
Message-ID: <CANwwZzWrKvU3k-JQvgLK+FWC9_E5zfGw_TfcwRGCriZ=kU27_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I was looking to understand the mlx4 driver for the Mellanox adapter.

I just had a query which I was not able to resolve on my own.

Can anyone please help me understand that:

does the HCR(HCA Configuration Register) reside in the Config Space or
MMIO space?

I guess the kernel uses ioremap for all I/O access whether it is PCI
config space of MMIO

I really appreciate your help.

Thanks

Marc
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
