From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: NULL deref in addr6_resolve()
Date: Sat, 16 Jul 2011 13:23:38 -0700 (PDT)
Message-ID: <20110716.132338.2137018887326151061.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


In drivers/infiniband/core/addr.c:

	neigh = dst->neighbour;
	if (!neigh || !(neigh->nud_state & NUD_VALID)) {
		neigh_event_send(dst->neighbour, NULL);
		ret = -ENODATA;
		goto put;
	}

neigh_event_send() can be passed a NULL pointer, and it will
OOPS when this happens.

Probably you want to just guard the neigh_event_send() call with a
NULL check, and actually use 'neigh' instead of reloading
dst->neighbour unnecessarily.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
