From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma_bw fails
Date: Tue, 17 May 2011 16:56:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373F8C7@ORSMSX101.amr.corp.intel.com>
References: <BANLkTik_42DBsd5SdyDcMvpTaw9+dXTr_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTik_42DBsd5SdyDcMvpTaw9+dXTr_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If I run rdma_bw on two nodes with the -c option (use rdma_cm) it
> fails with the error: "4390:pp_client_connect: unexpected CM event 1."
> event 1 is RDMA_CM_EVENT_ADDR_ERROR. I was under the impression that
> it should work if ib0 is configured.

It looks like your eth0 and ib0 are configured as the same IP subnet.  The routing tables are likely resulting in the rdma_cm trying to use the wrong device. 
 
> [kerrg@compute-0-3 rdma]$ /sbin/ifconfig
> eth0      Link encap:Ethernet  HWaddr 00:30:48:BE:D9:84
>           inet addr:10.1.255.251  Bcast:10.1.255.255  Mask:255.255.0.0

10.1.x.x subnet

> ib0       Link encap:InfiniBand  HWaddr
> 80:00:00:48:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
>           inet addr:10.1.1.30  Bcast:10.255.255.255  Mask:255.0.0.0

10.x.x.x subnet

You can try changing IB to a 10.2.x.x subnet with mask 255.255.0.0.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
