From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
Date: Thu, 16 Apr 2015 10:02:46 -0700
Message-ID: <CAG4TOxPMaRAR_B69J1_SHaHh8YMW2Unx786t2FbrA8g=05BAgA@mail.gmail.com>
References: <20150413192701.GA19112@obsidianresearch.com> <20150413194602.GA21467@phlsvsds.ph.intel.com>
 <20150413200138.GC19112@obsidianresearch.com> <20150414141806.GA7354@phlsvsds.ph.intel.com>
 <20150414172514.GB7682@obsidianresearch.com> <20150414174311.GA28111@phlsvsds.ph.intel.com>
 <20150414175904.GB13896@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FC127C@ORSMSX109.amr.corp.intel.com>
 <20150414182137.GD7682@obsidianresearch.com> <552E1A1A.4090704@profitbricks.com>
 <20150416164418.GC22946@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150416164418.GC22946-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 16, 2015 at 9:44 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> We can give client->add() callback a return value and make
>> ib_register_device() return -ENOMEM when it failed, just wondering
>> why we don't do this at first, any special reason?

> No idea, but having ib_register_device fail and unwind if a client
> fails to attach makes sense to me.

It seems a bit unfriendly to fail an entire device if one ULP has a
problem.  Let's say you have a system whose main network connection is
IPoIB.  Would you want that connection to come up even if, say, the
NFS/RDMA server fails to find the memory registration type it likes?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
