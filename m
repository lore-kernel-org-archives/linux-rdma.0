From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user access
Date: Mon, 18 Apr 2016 14:15:36 -0400
Message-ID: <20160418181535.GB7596@phlsvsds.ph.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB041C34@ORSMSX109.amr.corp.intel.com> <20160414212702.GA14137@obsidianresearch.com> <20160415000242.GA18400@rhel.sc.intel.com> <20160415044124.GA16805@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373AB0422AE@ORSMSX109.amr.corp.intel.com> <20160415181811.GA22322@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373AB042530@ORSMSX109.amr.corp.intel.com> <20160415220340.GB24204@obsidianresearch.com> <20160416162203.GA6279@rhel> <20160418175559.GC13865@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418175559.GC13865-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 18, 2016 at 11:55:59AM -0600, Jason Gunthorpe wrote:
>Basically, no maintainer would take a networking driver that doesn't
>live in one of the networking subsystems. Drivers generally don't just
>get to opt-out of the established common APIs. This is why is so
>tasteless to propose a hfi1 eeprom cdev, for instance.

Point taken on eprom cdev. We should be able to simply drop the last two 
patches of this series. We are also looking into Christoph's suggestion that 
the right place to plug in the eprom stuff is drivers/nvmem [1].

[1] http://marc.info/?l=linux-rdma&m=146098495706509&w=2

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
