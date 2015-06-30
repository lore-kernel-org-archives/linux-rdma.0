From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v7 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Tue, 30 Jun 2015 16:24:45 -0600
Message-ID: <20150630222445.GA1918@obsidianresearch.com>
References: <1435671955-9744-1-git-send-email-kaike.wan@intel.com>
 <1435671955-9744-5-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435671955-9744-5-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 30, 2015 at 09:45:55AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

> +static inline int ib_nl_is_good_resolve_resp(const struct nlmsghdr *nlh)
> +{
> +	const struct nlattr *head, *curr;
> +	int len, rem;
> +
> +	if (nlh->nlmsg_flags & RDMA_NL_LS_F_ERR)
> +		return 0;
> +
> +	if (!(nlh->nlmsg_flags & RDMA_NL_LS_F_OK))
> +		return 0;
> +
> +	if (nlmsg_len(nlh) < nla_attr_size(sizeof(*rec)))
> +		return 0;

Um, why are you sending patches that are not even compile tested?

drivers/infiniband/core/sa_query.c: In function 'ib_nl_is_good_resolve_resp':
drivers/infiniband/core/sa_query.c:732:45: error: 'rec' undeclared (first use in this function)
  if (nlmsg_len(nlh) < nla_attr_size(sizeof(*rec)))

This routine should also be using nla_parse and friends, not a roll
your own.

And you didn't address all the comments either..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
