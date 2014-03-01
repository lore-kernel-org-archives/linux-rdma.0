From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: issues with the rdma-cm server side mapping of IP to GID
Date: Sat, 1 Mar 2014 23:50:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D1F0BD@ORSMSX109.amr.corp.intel.com>
References: <530C51EF.2000509@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530C51EF.2000509-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Such situation can happen in the following cases:
> 
> 1. net.ipv4.conf.default.arp_ignore equals 0 (the default)
> 2. server side bonding/teaming fail-over when the Gratitous ARP sent was
> lost
> 3. re-order of ibM net-devices mapping to HCA PCI devices after server
> boot/crash
> 4. etc more
> 
> Basically, when the rdma-cm observes difference between the destination
> GID as present in the IB path within
> the CM REQ to the one resolved locally,  we should at least print a
> warning. Perhaps, we should reject the connection request? (in that
> case, I wasn't sure what would be the appropriate reject reason), any
> more ideas?

I'm not sure that this results in a single error case.

Can the kernel rdma_cm check for net.ipv4.default.arp_ignore on startup and at least print a warning if that is wrong?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
