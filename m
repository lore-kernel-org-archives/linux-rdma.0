From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 1/4] IB/netlink: Add defines for local service
 requests through netlink
Date: Thu, 11 Jun 2015 12:51:36 -0600
Message-ID: <20150611185136.GC20779@obsidianresearch.com>
References: <1434042225-4975-1-git-send-email-kaike.wan@intel.com>
 <1434042225-4975-2-git-send-email-kaike.wan@intel.com>
 <20150611175803.GC20142@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD2CD@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CABD2CD-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 06:32:44PM +0000, Wan, Kaike wrote:
> > From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> > Sent: Thursday, June 11, 2015 1:58 PM
> > To: Wan, Kaike
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Fleck, John; Weiny, Ira
> > Subject: Re: [PATCH v5 1/4] IB/netlink: Add defines for local service requests
> > through netlink
> > 
> > On Thu, Jun 11, 2015 at 01:03:42PM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > > From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > This patch adds netlink defines for SA client, local service group,
> > > local service operations, and related attributes.

> +	LS_NLA_TYPE_REVERSIBLE,
> +	LS_NLA_TYPE_NUMB_PATH,

These need to be combined. It does not make sense to request
numb_paths when the API we have is designed to return APM data.

Recommend a 'QP Type' with options of:
 - RC QP: Return up to the full 6 path tuple with full APM data
 - UD QP: Return a single non-reversible path
 - GMP QP: Return up to two reversible GMP paths.

If it is hard to get accurate information then you can sketch this in
and infer RC QP and GMP QP by the request having the reversible
set bit. But ideally RDMA CM and SRP would request RC QP, IPoIB would
request UD QP.

> +/* Local Service ServiceID attribute */
> +struct rdma_nla_ls_service_id {
> +	__be64		service_id;
> +};

Do not expose BE to userspace, everything should be in cpu order.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
