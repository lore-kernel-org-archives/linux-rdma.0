From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/3] rdma/cm: Listen on specific address family
Date: Thu, 14 Jun 2012 02:49:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A315DD@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A3152A@ORSMSX101.amr.corp.intel.com>
 <20120613232343.GB2225@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120613232343.GB2225-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Match socket behavior.  Restrict listens on IPv4 addresses
> > to only IPv4 addresses.  If a listen is on an IPv6 address,
> > allow it to receive either IPv4 or IPv6 addresses.
> 
> Can you match the IP stack and incorporate /proc/sys/net/ipv6/bindv6only

I'll check

> and socket option IPV6_V6ONLY?

Patch 3 in this series is intended to provide this capability.  I also have patches to the librdmacm.

- Sean 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
