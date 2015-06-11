From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 1/1] ibacm: Add support for pathrecord query through
 netlink
Date: Thu, 11 Jun 2015 13:27:19 -0600
Message-ID: <20150611192719.GA24457@obsidianresearch.com>
References: <1434042265-5066-1-git-send-email-kaike.wan@intel.com>
 <20150611175940.GD20142@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD2BD@CRSMSX101.amr.corp.intel.com>
 <20150611184641.GB20779@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD316@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CABD316-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 06:52:19PM +0000, Wan, Kaike wrote:
> > From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> > Sent: Thursday, June 11, 2015 2:47 PM
> > To: Wan, Kaike
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Fleck, John; Weiny, Ira
> > Subject: Re: [PATCH v5 1/1] ibacm: Add support for pathrecord query
> > through netlink
> > 
> > On Thu, Jun 11, 2015 at 06:31:53PM +0000, Wan, Kaike wrote:
> > > 1. all mandatory attributes must be present in the message. Otherwise,
> > > the request is invalid.
> > 
> > All mandatory attributes that are present must be supported or the user
> > space side cannot answer the request.
> 
> Then I will define all mandatory attribute types and check against them on the user space side.

You need to handle the case where a new kernel gains a new mandatory
attribute type. A list in user space does not seem to handle that.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
