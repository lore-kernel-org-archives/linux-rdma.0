From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] rsocket UDP support
Date: Thu, 4 Oct 2012 21:19:43 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A9928F@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm looking for brilliant ideas on the best way to support UDP type applications over rsockets.  The specific problem that needs to be address is how to convert:

sendto( ... dest_addr ..)

into

resolve IP address to IB address (rdma_resolve_addr)
obtain path record (rdma_resolve_route)
convert UDP port to SID and resolve remote QPN
	(IB service resolution via rdma_listen, rdma_connect, rdma_accept)
create address handle
post send

in an efficient manner.  Bonus points if you can handle the UDP server stopping and restarting.

- Sean 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
