From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Trust model for raw QPs
Date: Wed, 15 Aug 2012 10:47:01 -0600
Message-ID: <20120815164701.GD30810@obsidianresearch.com>
References: <502BA406.2060409@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <502BA406.2060409-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 15, 2012 at 04:28:38PM +0300, Or Gerlitz wrote:

> Suppose we allow to user to provide source mac+vlan when creating
> the QP or when modifying its state, and the HW can enforce that --
> in that case I think its OK to remove that restriction e.g ala what
> is allowed today with user space UD QPs when the fabric is IB.

This is still not safe, letting userspace inject raw ethernet packets,
even with a set smac and vlan tag will still allow it to disrupt TCP
communications, send privileged ICMPs, send packets from privileged
ports, etc.

UD QPs have an enforced SQPN, which AFAIK, is very different from how
raw ethernet QPs work. To fix it properly you'd have to make them less
'raw', enforce a certain eth/IPv4/TCP/UDP header stack on rx and tx,
for instance.

Not sure about receive? What packets do the raw QPs receive? That
needs to be pretty narrow too.

Can you fix this by elevating the process with SELinux?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
