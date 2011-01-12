From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Variable multicast and patch record queues length.
Date: Wed, 12 Jan 2011 10:59:11 -0800
Message-ID: <adawrma3q4g.fsf@cisco.com>
References: <4D00BC60.8020505@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D00BC60.8020505-smomgflXvOZWk0Htik3J/w@public.gmane.org> (Aleksey Senin's message of "Thu,
	9 Dec 2010 13:24:16 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Currently only 3 packets stored in the send queue before drop take
 > place. Queue's length may be changed at runtime via files mcast_qlen
 > and prec_qlen files under /sys/module/ib_ipoib/parameters/ directory.

Given that we already have module parameters that can be set at runtime,
do we really need a sysctl too?

 > +	if (!ipoib_table_header)
 > +		ipoib_table_header = register_sysctl_table(ipoib_table);

Seems like unneeded duplication of interfaces (and I don't think an
ipoib-specific sysctl seems like the right thing)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
