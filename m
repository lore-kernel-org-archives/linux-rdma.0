From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Fri, 15 Apr 2016 17:30:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0422AE@ORSMSX109.amr.corp.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160414180540.GA12554@obsidianresearch.com>
 <20160414184200.GA10416@phlsvsds.ph.intel.com>
 <20160414185659.GB12997@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB041C34@ORSMSX109.amr.corp.intel.com>
 <20160414212702.GA14137@obsidianresearch.com>
 <20160415000242.GA18400@rhel.sc.intel.com>
 <20160415044124.GA16805@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160415044124.GA16805-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I'm not excited about changing the rdma_cm and uverbs char names, we
> have a big investment in training and userspace around that. I'd
> rather have something that does more than what its name implies,
> so imagine uverbs as hfi if that helps...

Changing from write to ioctl breaks everything.  IMO, a name change hardly matters, and makes it trivial to see which interface should be used.

> > int uverbs_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "verbs");
> > int psm2_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "psm2.intel.com");
> 
> Again the *DRIVER* word is key, it really is only for driver specific
> stuff.

One _could_ argue that this should be "verbs.[device|vendor|technology]", since we ultimately end up dropping into device specific calls, and this just changes where the multiplexing is done.  I'm just brainstorming at this point, but I think there's merit to examining the possibility.  This would reflect reality of the "common" verbs, and enable disjoint communities to progress their interfaces independently.

> I see no big problem with somewhat orthogonal interfaces as groups of
> ioctls on the same fd. libfabric shows that is basically a workable
> model. Sharing security/discovery/etc is a reasonable enough commonality.

If we consider a completely non-verbs device, what unrelated code and modules must be loaded for that device to export its interfaces to user space?  Force loading the infiniband stack for a non-IB device seems like the wrong approach.  Maybe we just need 2 interfaces - one for IB verbs and one for everything else.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
