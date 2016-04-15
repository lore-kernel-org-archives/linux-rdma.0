From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Fri, 15 Apr 2016 00:30:45 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB041E4E@ORSMSX109.amr.corp.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160414180540.GA12554@obsidianresearch.com>
 <20160414184200.GA10416@phlsvsds.ph.intel.com>
 <20160414185659.GB12997@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB041C34@ORSMSX109.amr.corp.intel.com>
 <20160414212702.GA14137@obsidianresearch.com>
 <20160415000242.GA18400@rhel.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160415000242.GA18400-no5AT4YuGWKtqXYlAKuG4QC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I think if we are going to merge into a single device it should be a more
> fabric agnostic device.  Perhaps /dev/hsi (for high speed interconnect).
> 
> From there we could use what you are proposing for a truly device agnostic
> interface.  Those devices which export both verbs and psm would result in
> both
> of these calls working.
> 
> int uverbs_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "verbs");
> int psm2_fd = ioctl(hsi_fd, RDMA_GET_DRIVER_OPS_FD, "psm2.intel.com");
> 
> If/when we define commonalities we can define a common interface and
> export
> that or better yet just promote those to the hsi_fd directly.
> 
> Features, once vetted, can be promoted.

I like this approach in general.  As a community, we need to handle devices (e.g. usNIC) that are not be verbs based devices.  I also like the idea of separating the uABI framework from the kernel verbs interfaces.  That more naturally allows us to add the "rdma_cm" to this, depending on the selected scope for this uABI.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
