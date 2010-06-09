From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: librdma_cm: client example failed
Date: Tue, 8 Jun 2010 17:05:53 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F5DEA42@orsmsx501.amr.corp.intel.com>
References: <AANLkTinzM5AhpctY_psupjvGWcK8io8SwpwsIvYuuiX2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinzM5AhpctY_psupjvGWcK8io8SwpwsIvYuuiX2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joel vennin <joel.vennin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On the same server I execute the rdma_server and rdma_client. The
> first is waiting incoming message. The second one segfault. This is
> the backtrace of the rdma_client:
> #0=A0 0x00007f3de011482d in ?? () from /usr/lib/libmlx4-rdmav2.so
> #1=A0 0x00007f3de011640e in ?? () from /usr/lib/libmlx4-rdmav2.so
> #2=A0 0x00007f3de0a94244 in __ibv_modify_qp (qp=3D0x2458d40, attr=3D0=
x0,
> attr_mask=3D57) at src/verbs.c:474

The attr parameter doesn't look right.  ucma_init_conn_qp calls ibv_mod=
ify_qp using an &attr parameter from the stack.  The attr_mask looks li=
ke it could be correct.

Can you try updating the libmlx4 library and see if you get the same re=
suls?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
