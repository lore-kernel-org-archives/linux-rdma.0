From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ANNOUNCE] Shared Topic Branch For ABI Changes
Date: Thu, 21 Apr 2016 20:29:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB044439@ORSMSX109.amr.corp.intel.com>
References: <20160420055221.GT6349@leon.nu>
 <20160420152924.GA25424@obsidianresearch.com>
 <20160421065847.GC12730@leon.nu>
 <20160421173815.GB5102@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04435E@ORSMSX109.amr.corp.intel.com>
 <20160421200102.GB6258@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160421200102.GB6258-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I would call the combined repo 'rdma-plumbing' or something, intended
> to cover the user space side for all the kernel interfaces.
> 
> I saw libfabric was having success with this model - is that accurate?

Libfabric integrated the provider code directly into the same repo.  I would say that that model is working well.  It's allowing greater code sharing and makes it much easier to test multiple providers.  So I would say there's significant benefits for merging.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
