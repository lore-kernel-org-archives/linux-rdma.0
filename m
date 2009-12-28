From: "Robert P. J. Day" <rpjday-L09J2beyid0N/H6P543EQg@public.gmane.org>
Subject: erroneous CONFIG variable in infiniband code?
Date: Mon, 28 Dec 2009 11:58:29 -0500 (EST)
Message-ID: <alpine.LFD.2.00.0912281157340.12771@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


drivers/infiniband/core/cma.c:2086:#if defined(CONFIG_IPv6) || defined(CONFIG_IPV6_MODULE)

  notice the difference in case there, "IPv6" versus "IPV6".  someone
want to check that out?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
