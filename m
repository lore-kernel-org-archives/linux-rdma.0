From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Slow performance with librspreload.so
Date: Wed, 28 Aug 2013 15:50:07 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA937E@ORSMSX109.amr.corp.intel.com>
References: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXgf2LeMH+1L290w_KZ5tTN7NWpQxntF58Z506G3h_qKVw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Gandalf Corvotempesta' <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> i've connected just one port between two hosts.
> Ports is detected properly as 20Gb/s  (4x DDR) but i'm unable to reach
> speed over 5Gbit/s:

It's possible that this is falling back to using normal TCP sockets.

Can you run the rstream test program to verify that you can get faster than 5 Gbps?

rstream without any options will use rsockets directly.  If you use the -T s option, it will use standard TCP sockets.  You can use LD_PRELOAD with -T s to verify that the preload brings your per performance to the same level as using rsockets directly.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
