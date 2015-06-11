From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v5 1/1] ibacm: Add support for pathrecord query through
 netlink
Date: Thu, 11 Jun 2015 18:52:19 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CABD316@CRSMSX101.amr.corp.intel.com>
References: <1434042265-5066-1-git-send-email-kaike.wan@intel.com>
 <20150611175940.GD20142@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD2BD@CRSMSX101.amr.corp.intel.com>
 <20150611184641.GB20779@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611184641.GB20779-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Thursday, June 11, 2015 2:47 PM
> To: Wan, Kaike
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Fleck, John; Weiny, Ira
> Subject: Re: [PATCH v5 1/1] ibacm: Add support for pathrecord query
> through netlink
> 
> On Thu, Jun 11, 2015 at 06:31:53PM +0000, Wan, Kaike wrote:
> > 1. all mandatory attributes must be present in the message. Otherwise,
> > the request is invalid.
> 
> All mandatory attributes that are present must be supported or the user
> space side cannot answer the request.

Then I will define all mandatory attribute types and check against them on the user space side.

> 
> > 2. Optional attributes are optional. If they are absent, it is fine.
> > If they are present, they can still be ignored, depending on the
> > application.
> 
> Yes
> 
> > Then what are the mandatory attributes: sgid, dgid, slid, dlid, pkey,
> > reversise, qos, mtu, rate, or anything related to the pathrecord
> > selection (can be used to set comp_mask during a query)?
> 
> Yes
> 
> > What are the optional attributes?
> 
> Future policy decision items, like the net device the query is being made on
> behalf of, or the in-kernel ULP, etc.
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
