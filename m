From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: using same IP subnet on multiple interfaces (was: dual HCAs with upstream kernel)
Date: Sun, 15 Aug 2010 10:59:46 -0600
Message-ID: <20100815165946.GA2861@obsidianresearch.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9687B2B@orsmsx501.amr.corp.intel.com> <4C679C39.8060709@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C679C39.8060709-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 15, 2010 at 10:50:17AM +0300, Or Gerlitz wrote:

> the echo requests go on the wire, the replies not, probably (...)
> internally, Patrick?

What all these settings do is let a socket that is bound to a device
resolve the local host's address through ARP. The socket that is bound
to a device will then use its device for sending, but other sockets
not bound to devices will do route lookups and use the lo device.

Do:
ip route get 192.168.20.100 dev ib0
ip route get 192.168.20.1 src 192.168.20.100

To see the difference in each side.

To really effect a full external loopback you need to have both sides
bound to their respective devices. Note that binding to a device and
binding to a source IP are not the same thing in Linux.

In the RDMA CM case the listening side doesn't do any IP
routing operations at all so a device bind isn't necessary.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
