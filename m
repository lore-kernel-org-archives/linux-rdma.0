From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: issues with the rdma-cm server side mapping of IP to GID
Date: Mon, 3 Mar 2014 14:46:18 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D1F39F@ORSMSX109.amr.corp.intel.com>
References: <530C51EF.2000509@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237388D1F0BD@ORSMSX109.amr.corp.intel.com>
 <5312F107.2000404@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5312F107.2000404-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> 1. net.ipv4.conf.default.arp_ignore equals 0 (the default)
> >> 2. server side bonding/teaming fail-over when the Gratitous ARP sent was
> >> lost
> >> 3. re-order of ibM net-devices mapping to HCA PCI devices after server
> >> boot/crash
> >> 4. etc more
> >>
> >> Basically, when the rdma-cm observes difference between the destination
> GID as present in the IB path within the CM REQ to the one resolved
> locally,  we should at least print a warning. Perhaps, we should reject the
> connection request? (in that case, I wasn't sure what would be the
> appropriate reject reason), any more ideas?
> > I'm not sure that this results in a single error case.
> 
> Sorry... I'm not sure to follow, can you elaborate a bit more?

We don't know what type of device responds to the ARP query.  It could come from an ethernet device.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
