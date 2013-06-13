From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 0/4] IP based RoCE GID Addressing
Date: Thu, 13 Jun 2013 11:00:11 -0600
Message-ID: <20130613170011.GA21570@obsidianresearch.com>
References: <1371135704-5712-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1371135704-5712-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 13, 2013 at 06:01:40PM +0300, Or Gerlitz wrote:
> Currently, the IB stack (core + drivers) handle RoCE (IBoE) gids as
> they encode related Ethernet net-device interface MAC address and 
> possibly VLAN id.
> 
> This series changes RoCE GIDs to encode IP addresses (IPv4 + IPv6)
> of the that Ethernet interface, under the following reasoning:

Can you talk abit about compatibility please?

What happens when nodes with this patch are on the same network as
nodes without it?

Does this patch remove the encoding of the VLAN from the GID?

How is the destination MAC derived now?

There is a RoCE standard, it doesn't say much, but how the MAC and GRH
GID are related/derived really should be specified...

Not sure about copying the IP/IPv6 address from the interface into the
HW, there has always been pressure to keep verbs separate from the net
stack.. At the very least patch #2 should have its change log updated
to actually reflect what is in the patch.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
