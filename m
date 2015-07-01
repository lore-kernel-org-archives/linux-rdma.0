From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v7 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Wed, 1 Jul 2015 11:38:22 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAC2482@CRSMSX101.amr.corp.intel.com>
References: <1435671955-9744-1-git-send-email-kaike.wan@intel.com>
 <1435671955-9744-5-git-send-email-kaike.wan@intel.com>
 <20150630222445.GA1918@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150630222445.GA1918-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Tuesday, June 30, 2015 6:25 PM
> To: Wan, Kaike
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Fleck, John; Weiny, Ira
> Subject: Re: [PATCH v7 4/4] IB/sa: Route SA pathrecord query through netlink
> 
> On Tue, Jun 30, 2015 at 09:45:55AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> 
> > +static inline int ib_nl_is_good_resolve_resp(const struct nlmsghdr
> > +*nlh) {
> > +	const struct nlattr *head, *curr;
> > +	int len, rem;
> > +
> > +	if (nlh->nlmsg_flags & RDMA_NL_LS_F_ERR)
> > +		return 0;
> > +
> > +	if (!(nlh->nlmsg_flags & RDMA_NL_LS_F_OK))
> > +		return 0;
> > +
> > +	if (nlmsg_len(nlh) < nla_attr_size(sizeof(*rec)))
> > +		return 0;
> 
> Um, why are you sending patches that are not even compile tested?

My bad. I had a debugging patch on top of these patches and I built them together to do the tests (rdma_cm, ipoib, srp), but forgot to compile the rest after popping off the debugging patch. 

> 
> drivers/infiniband/core/sa_query.c: In function 'ib_nl_is_good_resolve_resp':
> drivers/infiniband/core/sa_query.c:732:45: error: 'rec' undeclared (first use
> in this function)
>   if (nlmsg_len(nlh) < nla_attr_size(sizeof(*rec)))
> 
> This routine should also be using nla_parse and friends, not a roll your own.

Yes, I can use nla_find() for this purpose here.

> 
> And you didn't address all the comments either..

I addressed your comments with questions in an previous reply, but did not hear from you.

See

http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg25614.html



Thanks,

Kaike

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
