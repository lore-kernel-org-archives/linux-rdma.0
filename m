From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH librdmacm] Fixed build problem due to missing macro
Date: Mon, 3 Dec 2012 19:48:40 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346ADC43A@ORSMSX101.amr.corp.intel.com>
References: <1354449863-20990-1-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346ADC3F3@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZJVgUdmXPd6t6ias27vTrc8LieX4J=YnVQbLTMmo8A3RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJVgUdmXPd6t6ias27vTrc8LieX4J=YnVQbLTMmo8A3RQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "esalomon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <esalomon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I'm using a locally modified version of verbs, so I don't end up seeing this
> error.
> 
> could this be related to different results while running netperf .w
> fork in our setup vs. yours?

I was referring to the build issue, not the fork problem.

According to my notes, I ran netperf with fork support using this:

server
------
export RDMAV_FORK_SAFE=1
LD_PRELOAD=/usr/local/lib/rsocket/librspreload.so netserver

client
------
export RDMAV_FORK_SAFE=1
LD_PRELOAD=/usr/local/lib/rsocket/librspreload.so netperf -H <ip-address>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
