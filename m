From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 0/4] Sending kernel pathrecord query to user cache
 server
Date: Wed, 10 Jun 2015 15:37:31 -0600
Message-ID: <20150610213731.GA6441@obsidianresearch.com>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com>
 <55783D84.6040709@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABCC2E@CRSMSX101.amr.corp.intel.com>
 <55784C35.2020401@dev.mellanox.co.il>
 <20150610180020.GC13497@phlsvsds.ph.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE6940@ORSMSX109.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E1109B12A@CRSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE6AD4@ORSMSX109.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E1109B194@CRSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE6B07@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE6B07-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 10, 2015 at 09:34:58PM +0000, Hefty, Sean wrote:

> I agree.  I just wanted to make sure that there wasn't some feature
> regarding PRs, such as unpath, that a kernel client would lose
> (i.e. it is currently implemented) by changing how the PRs are
> retrieved.  Basically nothing breaks with this change.

That is my expectation, I've seen nothing to contradict it...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
