From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 4/4] RDMA/isert: Support iWARP transport
Date: Thu, 2 Jul 2015 10:39:37 -0600
Message-ID: <20150702163937.GB4642@obsidianresearch.com>
References: <20150701162936.6501.45512.stgit@build.ogc.int>
 <20150701163058.6501.39171.stgit@build.ogc.int>
 <CAJ3xEMjWVwbW0sgVsMj3hPLMRZgJ8srMG89gYzUEbvQAHBaUEw@mail.gmail.com>
 <009a01d0b43f$f5fa8640$e1ef92c0$@opengridcomputing.com>
 <CAJ3xEMhehOBvmFBFNwZEda3Wc3UyyyK8iH6HrYfVbD0=8MUa-A@mail.gmail.com>
 <5594DA1E.7040604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5594DA1E.7040604-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 02, 2015 at 09:28:46AM +0300, Sagi Grimberg wrote:

> Or has a good point.
> The DMA mkey in target mode is discrete and not sent to any peer.

That doesn't mean the peer cannot guess it.

Using the right permission is clearly a stronger protection, we
shouldn't weaken IB just to accommodate iWarp's limitations.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
