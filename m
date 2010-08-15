From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: using same IP subnet on multiple interfaces (was: dual HCAs with
 upstream kernel)
Date: Sun, 15 Aug 2010 10:50:17 +0300
Message-ID: <4C679C39.8060709@Voltaire.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9687B2B@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9687B2B-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
> Does anyone have a system with multiple HCAs that's running a recent upstream kernel?
> Oracle has reported a bug connecting between two HCAs in the same system using the rdma_cm 

Sean,

With 2.6.35, I was hitting the reported failure (address error event, status -ETIMEDOUT) with 
simpler configuration of two ports belonging to the same HCA. I used ucmatose and not 
rping as the former allows to specify local binding wheres the latter doesn't (see below).

Next, I realized that similar test with ping(8) doesn't work either, the arp request was xmitted 
through one interface (ib0) and received on the other (ib1) but no reply was generated. At this 
point, I thought that maybe one of the arp/related sysctls could effect that, and I got an initial 
hit... following commit 8153a10, once I have set net.ipv4.conf.ib1.accept_local to 1 I could 
# ping -I ib0 to ib1's address where before that, I couldn't, ucmatose got to work either, no problem.

> commit 8153a10c08f1312af563bb92532002e46d3f504a
> Author: Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>
> Date:   Thu Dec 3 01:25:58 2009 +0000
[...]
> Change fib_validate_source() to accept packets with a local source address when
> the "accept_local" sysctl is set for the incoming inet device. Combined with the
> previous patches, this allows to communicate between multiple local interfaces over the wire.

> # ip r s
> 192.168.20.0/24 dev ib0  proto kernel  scope link  src 192.168.20.1
> 192.168.20.0/24 dev ib1  proto kernel  scope link  src 192.168.20.100

before net.ipv4.conf.ib1.accept_local was set to 1, ping isn't working

> # ping -I ib0 192.168.20.100 -q &
> # PING 192.168.20.100 (192.168.20.100) from 192.168.20.1 ib0: 56(84) bytes of data.

> # tcpdump -ni ib0
> 10:12:14.679101 ARP, Request who-has 192.168.20.100 tell 192.168.20.1, length 56
> 10:12:15.679337 ARP, Request who-has 192.168.20.100 tell 192.168.20.1, length 56

> # tcpdump -ni ib1
> 10:13:35.798332 ARP, Request who-has 192.168.20.100 tell 192.168.20.1, length 56
> 10:13:36.798569 ARP, Request who-has 192.168.20.100 tell 192.168.20.1, length 56

> # ip n s
> 192.168.20.100 dev ib0  INCOMPLETE

after net.ipv4.conf.ib1.accept_local to 1, ping (and ucmatose) work, but

> # tcpdump -ni ib0
> 10:29:32.196866 ARP, Request who-has 192.168.20.100 tell 192.168.20.1, length 56
> 10:29:32.197047 ARP, Reply 192.168.20.100 is-at 80:00:00:49:fe:80:00:00:00:00:00:00:00:02:c9:03:00:02:6b:e8, length 56
> 10:29:32.197058 IP 192.168.20.1 > 192.168.20.100: ICMP echo request, id 33038, seq 1, length 64
> 10:29:32.197125 IP 192.168.20.1 > 192.168.20.100: ICMP echo request, id 33038, seq 1, length 64
> 10:29:33.197013 IP 192.168.20.1 > 192.168.20.100: ICMP echo request, id 33038, seq 2, length 64

> # tcpdump -ni ib1
> 10:29:32.196920 ARP, Request who-has 192.168.20.100 tell 192.168.20.1, length 56
> 10:29:32.196944 ARP, Reply 192.168.20.100 is-at 80:00:00:49:fe:80:00:00:00:00:00:00:00:02:c9:03:00:02:6b:e8, length 56
> 10:29:32.197029 ARP, Reply 192.168.20.100 is-at 80:00:00:49:fe:80:00:00:00:00:00:00:00:02:c9:03:00:02:6b:e8, length 56
> 10:29:32.197136 IP 192.168.20.1 > 192.168.20.100: ICMP echo request, id 33038, seq 1, length 64
> 10:29:33.197023 IP 192.168.20.1 > 192.168.20.100: ICMP echo request, id 33038, seq 2, length 64
> 10:29:34.197357 IP 192.168.20.1 > 192.168.20.100: ICMP echo request, id 33038, seq 3, length 64

the echo requests go on the wire, the replies not, probably (...) internally, Patrick?

I noted that the neighbour on the NIC which is replying quickly gets stale and later aged out

> # ip  n s
> 192.168.20.100 dev ib0 lladdr 80:00:00:49:fe:80:00:00:00:00:00:00:00:02:c9:03:00:02:6b:e8 REACHABLE
> 192.168.20.1   dev ib1 lladdr 80:00:00:48:fe:80:00:00:00:00:00:00:00:02:c9:03:00:02:6b:e7 STALE

Or.

This is my related configuration, I tried changing rp_filter to 0 but it didn't change things either

> # sysctl -a | grep accept_local | grep ib[0,1]
> net.ipv4.conf.ib0.accept_local = 1
> net.ipv4.conf.ib1.accept_local = 1

> # sysctl -a | grep rp_ | grep ib[0,1]
> net.ipv4.conf.ib0.rp_filter = 1
> net.ipv4.conf.ib0.arp_filter = 0
> net.ipv4.conf.ib0.arp_announce = 0
> net.ipv4.conf.ib0.arp_ignore = 1
> net.ipv4.conf.ib0.arp_accept = 0
> net.ipv4.conf.ib0.arp_notify = 0
> net.ipv4.conf.ib0.proxy_arp_pvlan = 0
> net.ipv4.conf.ib1.rp_filter = 1
> net.ipv4.conf.ib1.arp_filter = 0
> net.ipv4.conf.ib1.arp_announce = 0
> net.ipv4.conf.ib1.arp_ignore = 1
> net.ipv4.conf.ib1.arp_accept = 0
> net.ipv4.conf.ib1.arp_notify = 0
> net.ipv4.conf.ib1.proxy_arp_pvlan = 0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
