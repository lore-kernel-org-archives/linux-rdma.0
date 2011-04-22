From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: RE: rdma_create_qp() and max_send_wr
Date: Fri, 22 Apr 2011 12:20:45 +0200
Message-ID: <1303467645.2243.47.camel@deela.quest-ce.net>
References: <20110421115323.48b52fb35c6f209c51bccbb9807b6df0.f623dc4952.wbe@email17.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110421115323.48b52fb35c6f209c51bccbb9807b6df0.f623dc4952.wbe-L1BP6xego3TShzhksYgB+AejPw4fNl8p@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 21 avril 2011 =C3=A0 11:53 -0700, cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org a =C3=A9crit =
:
> An ENOMEM return does not mean that the subsystem *just* failed to
> allocate system memory.

> The memory that could not be allocated could be device memory.
>        =20

I'm also having some difficulties with system memory allocation.

In my test, a user is allowed to lock 4MBytes of memory, but not all
this memory is available to ibv_reg_mr() since ibv_create_cq() and
ibv_create_qp()/rdma_create_qp() lock memory respectively for CQ and QP=
=2E
The question is how much memory is needed for the CQ and QP queues ?

In my case, the maximum message of size is 4MBytes - 20KBytes, for a CQ
and QP (half duplex) queues length of 1.

Using message size of 128 bytes and less hit the QP WR limit of 16351
length.

When using messages of size 256 bytes, I'm only able to register 260915=
2
bytes, then CQ and QP (half duplex) queues are 10192 entries length. So
they seems to requires about 1585152 bytes. Taking in account a fixed
amount of reserved memory of 20KBytes, this give about 154 bytes per (C=
Q
+ QP (half duplex)) entry.

When doing the same math with size 512 and 1024, the size of (CQ + QP
(half duplex)) is going down.

msg  512 memory 3395584 length 6632
msg 1024 memory 3788800 length 3700
msg 2048 memory 3985408 length 1946

Note that the memory used for the message is allocated as an aligned bi=
g
chunk and registered as whole, and then sliced to be posted in WR.=20

But the memory required for the CQ and QP elements (and other) is also
subject to alignment to a page size.

At least, I known that CQ / QP "overhead" is not going to hurt users, i=
f
they are allocated "modern" memory limits, let's say 1GBytes ;)

Regards.

--=20
Yann Droneaud
OPTEYA



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
