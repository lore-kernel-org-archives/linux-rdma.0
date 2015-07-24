From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] RDMA/cxgb3: fail get_dma_mr if the memory footprint can exceed 32b
Date: Fri, 24 Jul 2015 09:50:03 -0500
Message-ID: <008b01d0c620$05dce480$1196ad80$@opengridcomputing.com>
References: <20150722191417.9306.17387.stgit@build2.ogc.int> <55B15D7D.3090601@redhat.com> <00d501d0c599$84afdb50$8e0f91f0$@opengridcomputing.com> <55B24F65.5040103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B24F65.5040103-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
> Sent: Friday, July 24, 2015 9:45 AM
> To: Steve Wise
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] RDMA/cxgb3: fail get_dma_mr if the memory footprint can exceed 32b
> 
> On 07/23/2015 06:47 PM, Steve Wise wrote:
> >> -----Original Message----- From: Doug Ledford
> >> Should this be a static check of the pointer size versus installed
> >> memory?  Would it be possible to have this work for machines with
> >> less than 4GB of physical memory even if they have 64bit pointers,
> >> or are you concerned that hotplug memory could take us over the
> >> limit after registration and cause problems?
> >
> > NFSRDMA doesn't need dma-mrs for T3 since it has FRMR + local dma
> > lkey support.  And since the deficiency really can cause problems on
> > 64b systems if the memory grows > 4GB after dma-mr allocation, I
> > decided to just not allow them for potential large memory systems.
> 
> Ok.  I've pulled this for 4.2-rc then.
> 

The problem has been there since day one, so it doesn't represent a regression.  It is your call, but I think 4.3 is fine.

Thanks,

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
