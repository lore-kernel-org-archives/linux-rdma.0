From: Brandon Falk <bfalk-kQ3ioHgQxLs9XoPSrs7Ehg@public.gmane.org>
Subject: Infiniband Adapter with Documentation
Date: Mon, 22 Jun 2015 18:04:32 -0400
Message-ID: <CAK9+cJVe+z_eWTsf6nVR-Gaqs2KeiCxXak-vXpBO23G5pWZ-gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Heya,

I have a compute cluster which uses a completely custom OS (not binary
or source compatible with Linux by any means), and I'm really
interested in Infiniband support. Are there any adapters out there
that have development guides for system level stuff (such as PCI
BAR/MMIO space, etc). I'd ideally implement for the Mellanox
ConnectX-4, but I'm willing to go where the documentation is.

I just want to make a limited driver capable of RDMA writes and reads,
not planning on supporting much more beyond that. How feasible is
that? I've written multiple 1GbE drivers and a 10GbE driver
(specifically for the X540) which was a 8 hour project thanks to good
documentation. Is documentation of this sort available for Infiniband?

I'd be looking for the Infiniband equivalent of this
https://www-ssl.intel.com/content/dam/www/public/us/en/documents/datasheets/ethernet-x540-datasheet.pdf
.

-B
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
