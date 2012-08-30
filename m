From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver
 CQ completion handler
Date: Fri, 31 Aug 2012 01:17:54 +0300
Message-ID: <CAJZOPZJOWuoBQx49-O2WLk240GWGRsqfJpCXfhxRV6Cmdw7W0w@mail.gmail.com>
References: <1346323085-2665-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346323085-2665-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier =E2=80=8E<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>  wrote:

> Can you be explicit about the race you're worried about?

few

1. on the  time CQ A is deleted an interrupt that relates to CQ B
takes place and a radix
tree lookup is running while an element is being deleted from the
tree, looking on the radix tree API, I don't see that this is allowed.

2. while a CQ is being freed an interrupt takes place and the driver
attempts to run the comp handler which can turn to use after free,
null pointer deref, etc. This can happen even if the ULP made sure to
consume all the WCs related to flushed/etc, e.g an "empty"
interrupt

BTW, your email missed the list somehow

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
