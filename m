From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v8 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 23 Jul 2015 14:14:11 -0600
Message-ID: <20150723201411.GA31524@obsidianresearch.com>
References: <1436463268-32365-1-git-send-email-kaike.wan@intel.com>
 <1436463268-32365-5-git-send-email-kaike.wan@intel.com>
 <20150722210918.GB20815@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CB55290@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CB55290-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 23, 2015 at 07:26:32PM +0000, Wan, Kaike wrote:
> The nl sequence increased sequentially. What's the difference?

Hmm, looks like in my version the DGID was getting mangled and this
causes ipoib to enter a tight query loop..

Not your problem.
> > Actually, looks like nothing removes nl queries from the timeout loop when
> > they successfully complete. (ie this series doesn't even have a hope of
> > working properly)
> 
> That is incorrect. The first thing in ib_nl_handle_resolve_resp is
> to find the request and remove it from the ib_nl_rquest_list. the
> timeout routine will remove the entries that have timed out from the
> nl request list.

Yep, okay, I see it now.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
