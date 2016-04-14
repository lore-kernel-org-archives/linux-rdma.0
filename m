From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 14 Apr 2016 20:35:53 +0000
Message-ID: <9C6B67F36DCAFC479B1CF6A967258A8C7DDAA860@ORSMSX115.amr.corp.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160414180540.GA12554@obsidianresearch.com>
 <20160414184200.GA10416@phlsvsds.ph.intel.com>
 <20160414185659.GB12997@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB041C34@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB041C34-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> As for the 'one char device', I actually think it would be really 
>> simple.
>> 
>> Add a new uverbs ioctl:
>> 
>>  int hfi1_fd = ioctl(uverbs_fd, RDMA_GET_DRIVER_OPS_FD, 
>> "psm2.intel.com");
>> 
>>  ioctl(hfi1_fd, HFI1_IOCTL_ASSIGN_CTXT, ...);  write(hfi1_fd, ...);
>> 
>> At least that gives us far better options for discovery and versioning 
>> of this stuff than a driver-specific char device.

>I think it would help the discussion if the advantages/disadvantages of this approach were described over just opening a driver specific file.  Because trying >to form an application interface that's the union of hardware interfaces seems problematic.  We _may_ be better thinking in terms if an Infiniband Core + >iWarp Core + PSM Core (with appropriate code re-use between them), than viewing the entire world as RDMA Core.  I say may because I haven't thought >through the details.  But from a high level, the IB core and PSM core appear to have basically no overlap.

Seems to me that routing all PSM ioctls through the IB core makes about as much sense as sending all netlink packets through the SCSI mid-layer to get to a netdev driver. As Sean points out, there is basically no overlap between IB core and PSM capabilities, so there is no value added in passing PSM ioctls through the IB core. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
