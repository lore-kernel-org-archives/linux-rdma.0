From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [linux-rdma and rdma-core]: Unable to perform rdma_connect in
 loopbacked configuration
Date: Mon, 18 Sep 2017 14:59:59 -0600
Message-ID: <20170918205959.GC7059@obsidianresearch.com>
References: <59792242-F2C8-431A-BEDA-996844EDE4C5@raithlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <59792242-F2C8-431A-BEDA-996844EDE4C5-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 18, 2017 at 06:18:25PM +0000, Stephen  Bates wrote:

> Using a NAT approach discussed in [1] I can setup IPv4 addresses on
> both HCAs such that I avoid a local loopback (the addresses I use
> are a little different to the ones in that reference but the
> approach is identical). This allows ping, iperf and other IP based
> applications to work just fine. For example:

The RDMA stuff ignores everything in iptables.

IIRC, you need to make 'ip route get blah' not return lo. This is done
with some combination of policy routing and sysfs tweaking.

IMHO, it is also a bug if loopback roce doesn't just work out of the
box, fully internally to the NIC. :\

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
