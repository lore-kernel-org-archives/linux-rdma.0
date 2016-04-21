From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ANNOUNCE] Shared Topic Branch For ABI Changes
Date: Thu, 21 Apr 2016 18:17:18 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB04435E@ORSMSX109.amr.corp.intel.com>
References: <20160420055221.GT6349@leon.nu>
 <20160420152924.GA25424@obsidianresearch.com>
 <20160421065847.GC12730@leon.nu> <20160421173815.GB5102@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160421173815.GB5102-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Doug was ambivalent, Steve was against. There was a concern the natual
> release schedual of the parts was different, so why link them.
> 
> My counter was that isn't really important, the goal is is to reduce
> developer time when working on this mess.
> 
> Since we are looking at changing *everything* developer time seems
> more important right now.

FWIW, I moved the librdmacm and libibacm into a single guthub project.  Even if we don't share a single git tree, this enables multiple maintainers for the code.  I would really like to see libibcm dropped entirely, and think libibverbs and librdmacm should merge.

In the past I would have been in favor of more closely associating libibumad with libibverbs, but now that OPA uses IB-like management, I'm not so sure.  I think OPA management could be done outside of any verbs emulation.  Ira might know for sure.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
