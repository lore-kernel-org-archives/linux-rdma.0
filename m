From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v5 1/4] IB/netlink: Add defines for local service
 requests through netlink
Date: Fri, 12 Jun 2015 00:28:44 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CABE6B3@CRSMSX101.amr.corp.intel.com>
References: <1434042225-4975-1-git-send-email-kaike.wan@intel.com>
 <1434042225-4975-2-git-send-email-kaike.wan@intel.com>
 <20150611175803.GC20142@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD2CD@CRSMSX101.amr.corp.intel.com>
 <20150611185136.GC20779@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD33C@CRSMSX101.amr.corp.intel.com>
 <20150611195154.GB24457@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABE5EE@CRSMSX101.amr.corp.intel.com>
 <20150612002133.GA17666@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150612002133.GA17666-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Thursday, June 11, 2015 8:22 PM
> To: Wan, Kaike
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Fleck, John; Weiny, Ira
> Subject: Re: [PATCH v5 1/4] IB/netlink: Add defines for local service requests
> through netlink
> 
> On Thu, Jun 11, 2015 at 11:45:46PM +0000, Wan, Kaike wrote:
> > Apparently, to achieve this goal, we need the following changes:
> 
> I don't expect anything more than a proper hole in the UAPI to make this
> work.
> 
> I already have patches that implement full kernel support for the 6-path
> format, and globally enable APM. With this netlink interface it becomes
> feasible to mainline them. That will require some reworking of what you've
> done, but I don't expect you to do that.
> 
> The only remaining thing we need here is that tiny bit of policy information
> for the kernel to specify what the intended use of the path is:
>  - For connected CM operation (6 path records)
>  - For unidirectional UD (1 path record)
>  - For 'misc' GMP like operation (at least 1 reversible path record)
> 
> I'm happy if you call it PATH_USE_XX
> 
> Testing the reversible bit should be enough to rough this in, if not reversible it
> is PATH_USE_UNIDIRECTIONAL_UD, otherwise it is PATH_USE_GMP.
> 
> Recommend that userspace treat any unknown usage type as GMP (it is the

> most general).

That would be cool. If we add this attribute, should we remove reversible and numb_path attributes?

Kaike

> 
> Ira: Do you like 'path use' better as a name? I think I do..
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
