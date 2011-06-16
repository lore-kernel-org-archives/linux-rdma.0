From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb
 routines
Date: Thu, 16 Jun 2011 19:27:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823730218F4@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com>
	<4DFA1DDD.5020508@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823730217E1@ORSMSX101.amr.corp.intel.com>
 <BANLkTimwTs4EK19PiTq6yMzPCQrLt0bALw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimwTs4EK19PiTq6yMzPCQrLt0bALw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Basically, I wasn't referring to such new verbs as vendor extensions,
> but rather as new verbs we want to add at this and/or future points of
> time which didn't exist at the time the IB stack and specifically its
> kernel/user ABIs/APIs were written (couple of years ago...).

To be clear, there are 2 sides to ibverbs - the app side, and the provider library.

On the app side, new functionality would be added directly to libibverbs.  I would reuse what's there if possible, and provide direct API calls where needed.  For example, the xrc patch adds:

ibv_create_xsrq()
ibv_open_xrcd()
ibv_close_xrcd()

as new APIs.  On the provider side, the necessary calls are obtained by ibverbs calling get_ext_ops().

I haven't come up with another way of extended verbs that would be as easy for an application to use, given that most of the calls and data structures are reusable.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
