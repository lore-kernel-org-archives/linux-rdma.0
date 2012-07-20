From: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: qle7322 and rhel5.8
Date: Fri, 20 Jul 2012 16:22:58 -0400
Message-ID: <CABOsP2P=7FG4zJy12x442pV=Hk3SkeBg5qTOtGy41GSFQLsBHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

i'm trying to use redhat 5.8 with a qle7322 qdr infiniband card.  i've
loaded the requisite openfabrics rpm's through yum, but i can't seem
to get ipoib going

even when i run ibv_devinfo or ibv_devices the system doesn't see the card

is there something missing somewhere?  i'm only interested in getting
ipoib working, but i don't want to install the vendor stack on this
machine if possible

lspci does see the card (and with a proper name) and i have a bunch of
identical machines that all behave the same, so i know it's not a
hardware problem
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
