From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Trust model for raw QPs
Date: Wed, 15 Aug 2012 12:20:08 -0600
Message-ID: <20120815182008.GA2593@obsidianresearch.com>
References: <502BA406.2060409@mellanox.com>
 <20120815164701.GD30810@obsidianresearch.com>
 <000001392b589827-3d77568e-495d-4463-ab69-05b20205b7f5-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <000001392b589827-3d77568e-495d-4463-ab69-05b20205b7f5-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 15, 2012 at 05:33:10PM +0000, Christoph Lameter wrote:
> On Wed, 15 Aug 2012, Jason Gunthorpe wrote:
> 
> > Can you fix this by elevating the process with SELinux?
> 
> Can SELinux be used to compromise security? How?

Not 100% familiar with SELinux, but they do support ping and other
tools which do operate with elevated priviliages, so it must be
possible.

A how-to document on this subject and a dedicated SELinux capability
might be the way to go..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
