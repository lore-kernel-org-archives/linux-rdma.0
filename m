From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
Date: Thu, 16 Apr 2015 17:05:31 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC8BFFA@CRSMSX101.amr.corp.intel.com>
References: <20150413192701.GA19112@obsidianresearch.com>
 <20150413194602.GA21467@phlsvsds.ph.intel.com>
 <20150413200138.GC19112@obsidianresearch.com>
 <20150414141806.GA7354@phlsvsds.ph.intel.com>
 <20150414172514.GB7682@obsidianresearch.com>
 <20150414174311.GA28111@phlsvsds.ph.intel.com>
 <20150414175904.GB13896@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC127C@ORSMSX109.amr.corp.intel.com>
 <20150414182137.GD7682@obsidianresearch.com>
 <552E1A1A.4090704@profitbricks.com>
 <20150416164418.GC22946@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150416164418.GC22946-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Wed, Apr 15, 2015 at 09:58:18AM +0200, Michael Wang wrote:
> 
> > We can give client->add() callback a return value and make
> > ib_register_device() return -ENOMEM when it failed, just wondering why
> > we don't do this at first, any special reason?
> 
> No idea, but having ib_register_device fail and unwind if a client fails to attach
> makes sense to me.

Yes that is what we should do _but_ 

I think we should tackle that in a different series.

As you said in another email, this series is getting very long and hard to review/prove is correct.  This is why I was advocating keeping a check at the top of cm_add_one which verified all Ports supported the CM.  This is the current logic today and is proven to work for the devices/use cases out there.

We can clean up the initialization code and implement support for individual ports in follow on patches.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
