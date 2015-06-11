From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 1/1] ibacm: Add support for pathrecord query through
 netlink
Date: Thu, 11 Jun 2015 13:54:22 -0600
Message-ID: <20150611195422.GC24457@obsidianresearch.com>
References: <1434042265-5066-1-git-send-email-kaike.wan@intel.com>
 <20150611175940.GD20142@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD2BD@CRSMSX101.amr.corp.intel.com>
 <20150611184641.GB20779@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD316@CRSMSX101.amr.corp.intel.com>
 <20150611192719.GA24457@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD362@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CABD362-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 07:35:37PM +0000, Wan, Kaike wrote:

> #define RDMA_NLA_F_MANDATORY   (1 << 13)
> #define RDMA_NLA_TYPE_MASK  ~(NLA_F_NESTED | NLA_F_NET_BYTEORDER | RDMA_NLA_F_MANDATORY)
> 
> In this case, kernel will use (RDMA_NLA_F_MANDATORY | type) to
> inform user space that this attribute is mandatory.

That general idea makes sense to me.

Then just test RDMA_NLA_F_MANDATORY in the case default: in acm. Fail
if set, ignore if unset.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
