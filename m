From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: using same IP subnet on multiple interfaces
Date: Mon, 16 Aug 2010 18:30:04 +0300
Message-ID: <4C69597C.2040008@Voltaire.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9687B2B@orsmsx501.amr.corp.intel.com>	<4C679C39.8060709@Voltaire.com> <20100815165946.GA2861@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100815165946.GA2861-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> [...] The socket that is bound to a device will then use its device for sending, 
> but other sockets not bound to devices will do route lookups and use the lo device.
> Do: [...] To see the difference in each side.

sure, makes sense, the ping-reply code does route lookup and will use the loopback device.

I took a 2nd look on ping w.r.t to various sysctl states, and when rp_filter is set to its default

> # sysctl -a | grep -wE "accept_local|rp_filter|arp_ignore" | grep ib
> net.ipv4.conf.ib0.rp_filter = 1
> net.ipv4.conf.ib0.accept_local = 1
> net.ipv4.conf.ib0.arp_ignore = 1
> net.ipv4.conf.ib1.rp_filter = 1
> net.ipv4.conf.ib1.accept_local = 1
> net.ipv4.conf.ib1.arp_ignore = 1

ping isn't working since there's no arp reply

> # ping -I ib0 192.168.20.100
> PING 192.168.20.100 (192.168.20.100) from 192.168.20.1 ib0: 56(84) bytes of data.
> From 192.168.20.1 icmp_seq=2 Destination Host Unreachable
> From 192.168.20.1 icmp_seq=3 Destination Host Unreachable
> From 192.168.20.1 icmp_seq=4 Destination Host Unreachable

> # tcpdump -ni ib0
> 18:04:39.492306 ARP, Request who-has 192.168.20.100 tell 192.168.20.1, length 56
> 18:04:40.492541 ARP, Request who-has 192.168.20.100 tell 192.168.20.1, length 56

> # tcpdump -ni ib1
> 18:04:42.497039 ARP, Request who-has 192.168.20.100 tell 192.168.20.1, length 56
> 18:04:43.497268 ARP, Request who-has 192.168.20.100 tell 192.168.20.1, length 56

Once I'm setting net.ipv4.conf.ib1.rp_filter=0 arps replies are generated and ping
is working as you explained, echo-request externally, echo-reply internally

> # tcpdump -ni ib1
> 18:06:33.103248 ARP, Request who-has 192.168.20.100 tell 192.168.20.1, length 56
> 18:06:33.103281 ARP, Reply 192.168.20.100 is-at 80:00:00:49:fe:80:00:00:00:00:00:00:00:02:c9:03:00:02:6b:e8, length 56
> 18:06:33.103369 ARP, Reply 192.168.20.100 is-at 80:00:00:49:fe:80:00:00:00:00:00:00:00:02:c9:03:00:02:6b:e8, length 56
> 18:06:33.103461 IP 192.168.20.1 > 192.168.20.100: ICMP echo request, id 26906, seq 1, length 64
> 18:06:34.107465 IP 192.168.20.1 > 192.168.20.100: ICMP echo request, id 26906, seq 2, length 64

Now, If I return rp_filter to 1, ping keeps working using the neighbour previously created. ping 
even keeps working when I set net.ipv4.conf.ib1.accept_local to 0, which is a bit weird unless 
this sysctl is made to act in the neigbour level (i.e control arp replies and not any packet xmit).

> To really effect a full external loopback you need to have both sides
> bound to their respective devices. Note that binding to a device and
> binding to a source IP are not the same thing in Linux.

Even without being fully into the details of what does binding to a source IP 
actually translates to, I understand there's a difference. 

> In the RDMA CM case the listening side doesn't do any IP
> routing operations at all so a device bind isn't necessary.

Yes, indeed. As for the active side, the RDMA CM doesn't have a BINDTODEVICE equivalent.

As for the original issue we were discussing here, Sean - the conclusion is that with 
upstream 2.6.35 bits for the rdma connection to go from hca1 port1 to hca1 port2 (or from 
hca1 port1 to hca2 port1), the rdma-cm needs a neighbour, similarly to a ping -I ib0 to 
ib1 address.

A neighbour isn't created unless the responding NIC (ib1 in my example) has both rp_filter 
set to 0 and accept_local set to 1, Jason, does this makes sense?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
