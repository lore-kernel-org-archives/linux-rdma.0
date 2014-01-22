From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: WQE sizes
Date: Wed, 22 Jan 2014 05:35:41 -0500
Message-ID: <CADPSxAiKg8A=qvTWhURboG5rk94NweY0Dq2N2d__B7WQJSiUkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi.

I'm reading the qp.c file in libmlx4 and I'm trying to figure out the
size of the WQEs created (excluding inlined payload). I thought I'd
ask it on the forum, in case it is known to someone.

So, when a program calls ibv_post_send(), what is the size of the WQE
that is fetched by the HCA? I believe it depends on the verb and the
transport, but any numbers would be really helpful.

Anuj Kalia
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
