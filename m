From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 08/14] IB/core: Add rdma_max_mad_size helper
Date: Wed, 20 May 2015 19:08:20 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FDDBDA@ORSMSX109.amr.corp.intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
 <1432109615-19564-9-git-send-email-ira.weiny@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDDACE@ORSMSX109.amr.corp.intel.com>
 <20150520180226.GC14309@phlsvsds.ph.intel.com>
 <20150520181928.GE28496@obsidianresearch.com>
 <20150520190352.GA22981@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150520190352.GA22981-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The value is 0 by default (kzalloc) and is why I wrote the comment like I
> did.

My objection with the comment is that it was not describing what the function did, but rather the value that should be stored in the structure.  Basically, it seemed misplaced.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
