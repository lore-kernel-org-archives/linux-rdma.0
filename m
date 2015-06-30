From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V2 4/5] RDMA/iser: support iWARP devices
Date: Tue, 30 Jun 2015 13:42:14 -0500
Message-ID: <004901d0b364$7b7151f0$7253f5d0$@opengridcomputing.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int> <20150629213624.4188.94135.stgit@build.ogc.int> <559260BE.6060301@dev.mellanox.co.il> <002201d0b341$b706b2a0$251417e0$@opengridcomputing.com> <20150630164501.GC30149@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FFB028@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FFB028-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'infinipath' <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, June 30, 2015 12:04 PM
> To: Jason Gunthorpe; Steve Wise
> Cc: 'Sagi Grimberg'; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; infinipath;
> eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> Subject: RE: [PATCH V2 4/5] RDMA/iser: support iWARP devices
> 
> > > I prefer to decouple the iSER changes with this core work.
> > > Jason/Sean... thoughts?  I could do the iSER w/o patch 3, and the
> > > follow up with a series that includes our final solution on
> > > transport independent memory registration and change all the TI
> > > kernel users (iser and nfsrdma) along with it.
> >
> > There has a been a big push lately to drop the strange transport
> > specific stuff - if you are comitted to seeing the access flag clean
> > up series through then I don't see a problem with using whatever order
> > you like.
> 
> I agree.

Ok, then I'll do this:

1) series with iser changes to enable iwarp including mlx/ipath/qib patches to set max_sge_rd
2) series on transport independent access flags / memory reg - updating the kernel ULPs too.

Thanks,

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
