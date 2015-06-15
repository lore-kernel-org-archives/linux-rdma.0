From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v5 1/4] IB/netlink: Add defines for local service
 requests through netlink
Date: Mon, 15 Jun 2015 19:02:11 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1109D7DF@CRSMSX101.amr.corp.intel.com>
References: <1434042225-4975-2-git-send-email-kaike.wan@intel.com>
 <20150611175803.GC20142@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD2CD@CRSMSX101.amr.corp.intel.com>
 <20150611185136.GC20779@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD33C@CRSMSX101.amr.corp.intel.com>
 <20150611195154.GB24457@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABE5EE@CRSMSX101.amr.corp.intel.com>
 <20150612002133.GA17666@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABE6B3@CRSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E1109C1F6@CRSMSX101.amr.corp.intel.com>
 <20150615180648.GA1089@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150615180648.GA1089-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Fri, Jun 12, 2015 at 05:24:32AM +0000, Weiny, Ira wrote:
> >
> > PATH_USE_* is a better name.  But I think the defines should be:
> >
> > PATH_USE_ANY (or ALL?)
> 
> How about PATH_USE_CONNECTED?

I don't want to bikeshed this too much as I'm not really good on names but...

How does "Connected" relate to wanting all available Path options?

Can't a connected transport use a reversible "GMP" path?

I guess that is where I am getting hung up.

Ira

> 
> > Why not treat unknown type as "ANY/ALL" and return all 6 if possible.
> > If not possible/supported (ie like ibacm) return GMP which is always
> > valid.
> 
> Make sense to me..
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
