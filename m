From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 4/5] RDMA/iser: support iWARP devices
Date: Tue, 30 Jun 2015 10:45:01 -0600
Message-ID: <20150630164501.GC30149@obsidianresearch.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int>
 <20150629213624.4188.94135.stgit@build.ogc.int>
 <559260BE.6060301@dev.mellanox.co.il>
 <002201d0b341$b706b2a0$251417e0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <002201d0b341$b706b2a0$251417e0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 30, 2015 at 09:33:21AM -0500, Steve Wise wrote:

> I prefer to decouple the iSER changes with this core work.
> Jason/Sean... thoughts?  I could do the iSER w/o patch 3, and the
> follow up with a series that includes our final solution on
> transport independent memory registration and change all the TI
> kernel users (iser and nfsrdma) along with it.

There has a been a big push lately to drop the strange transport
specific stuff - if you are comitted to seeing the access flag clean
up series through then I don't see a problem with using whatever order
you like.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
