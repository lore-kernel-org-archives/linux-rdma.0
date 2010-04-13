From: Mike M <mike060677-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: RDMA CM problems, ib_find_cached_gid() fails
Date: Tue, 13 Apr 2010 17:26:52 -0500
Message-ID: <g2i3d2745531004131526gcfec6bc2pccbae15d55997e95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm debugging an issue in trying to use the RDMA CM.

IPoIB is enabled, OpenSM running. =A0I'm trying to use the "rping"
example program as a test. =A0I get the RDMA_CM_EVENT_REJECTED on the
client.

Putting in lots of printk messages, I see that the server machine
indeed gets a connection request MAD, but that the
ib_find_cached_gid() call inside of cma_acquire_dev() fails.

Any ideas?

Thanks,
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
