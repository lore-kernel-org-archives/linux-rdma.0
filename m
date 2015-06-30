From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V2 4/5] RDMA/iser: support iWARP devices
Date: Tue, 30 Jun 2015 09:33:21 -0500
Message-ID: <002201d0b341$b706b2a0$251417e0$@opengridcomputing.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int> <20150629213624.4188.94135.stgit@build.ogc.int> <559260BE.6060301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559260BE.6060301-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Tuesday, June 30, 2015 4:26 AM
> To: Steve Wise; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org; infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> Subject: Re: [PATCH V2 4/5] RDMA/iser: support iWARP devices
> 
> On 6/30/2015 12:36 AM, Steve Wise wrote:
> > Limit the sg tablesize based on the device fast reg depth.
> >
> > Use rdma_get_dma_mr() to allocate the DMA MR.
> >
> > Use rdma_fast_reg_access_flags() to set the access_flags for fast
> > register work requests.
> 
> Steve,
> 
> I wander if it would make more sense to get the iser/isert stuff in
> without the mr stuff (I'd like the mr to go in a different direction).
> 
> Whatever you prefer.
>

I prefer to decouple the iSER changes with this core work.  Jason/Sean... thoughts?   I could do the iSER w/o patch 3, and the follow up with a series that includes our final solution on transport independent memory registration and change all the TI kernel users (iser and nfsrdma) along with it.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
