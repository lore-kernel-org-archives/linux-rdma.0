From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: NULL pointer dereference in rdma_ucm
Date: Tue, 20 Jul 2010 13:52:28 -0700
Message-ID: <adazkxlq3jn.fsf@roland-alpha.cisco.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Josh England's message of "Mon, 19 Jul 2010 16:20:58 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I'm experimenting with an rdma_cm application to push data around
 > between nodes on an ~1000 node cluster (CentOS-5.3 with 2.6.18-128.el5
 > and OFED-1.4.2).  Under heavy load, I'm seeing several nodes per day
 > kernel panic due to a NULL pointer dereference.  It may be that the
 > in-kernel field cm_id_priv has a NULL ->alt_av.port , causing the
 > Oops, but I don't know for sure.  Any ideas on how to debug this?

You have a pretty unsupportable combination of ancient kernel and old
OFED stack.  Is there any way you can test this with a recent mainline
kernel?

If I were debugging this I guess I would try to find out for sure where
the NULL dereference occurs -- I guess ib_cm_init_qp_attr() has all the
leaf functions (cm_init_qp_init_attr etc) inlined, so the first step
would be to figure out which one of those functions you're crashing in
(and also confirm that it's always the same one).  You could do that by
marking them noinline, or just put a WARN_ON(!<ptr>) before every
pointer dereference (does 2.6.18 even have WARN_ON?).

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
