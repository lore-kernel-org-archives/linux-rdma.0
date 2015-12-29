From: Wenda Ni <wonda.ni-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SoftRoCE V1
Date: Tue, 29 Dec 2015 11:01:02 -0500
Message-ID: <CAEnvTt1KBHXYzjfHKmWkQtUs1J-ABhY_maQibR5LE9t+F25sYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi experts,

We have several Mellanox RoCE V1 NIC cards, and would like to try
communicating with SoftRoCE V1.

We are using branch rxe-3.0 from https://github.com/SoftRoCE/rxe-dev
according to the Soft-RoCE README Rev 1.0 issued from Mellanox last
year.


Testing using pingpong examples from libibverbs (hardware RoCE <->
SoftRoCE) already shows a bug in Ethernet CRC generation. We expect
further bugs along the way.

So we would like to know for SoftRoCE V1, are we using the latest
branch? Also, is it still tied to SLES11 SP3 OS?

There are very few documentations we can find, so we hope this is the
right place to ask such questions.

Cheers,

Wenda Ni, Ph.D.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
