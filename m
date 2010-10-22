From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Using RDMA CM without IPoIB?
Date: Fri, 22 Oct 2010 14:32:31 -0700
Message-ID: <aday69pvrps.fsf@cisco.com>
References: <AANLkTino+6q_o_U=eOett8MzthBF2hH95yMkDwyWBi5L@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTino+6q_o_U=eOett8MzthBF2hH95yMkDwyWBi5L-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Adit Ranadive's message of "Fri, 22 Oct 2010 17:25:25 -0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <adit.262-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Is there a way to use the rdma connection manager library without the
 > IPoIB up and running?

Use IBoE or an iWARP adapter? ;)

More seriously, on IB, no, you must configure IPoIB to use the RDMA CM.
The whole point of the RDMA CM is to use IP addressing and ARP to
resolve addresses, which is not possible without IPoIB.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
