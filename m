From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Tue, 24 Oct 2017 09:42:49 -0500
Message-ID: <20171024144249.GA14496@ssaleem-MOBL4.amr.corp.intel.com>
References: <20171024123957.32207.70888.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171024123957.32207.70888.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 24, 2017 at 08:41:01AM -0400, Michael J. Ruhl wrote:
> From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> ---
>  drivers/infiniband/core/netlink.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
> index b12e587..1fb72c3 100644
> --- a/drivers/infiniband/core/netlink.c
> +++ b/drivers/infiniband/core/netlink.c
> @@ -175,13 +175,24 @@ static int rdma_nl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	    !netlink_capable(skb, CAP_NET_ADMIN))
>  		return -EPERM;
>  
> +	/*
> +	 * LS responses overload the 0x100 (NLM_F_ROOT) flag.  Don't
> +	 * mistakenly call the .dump() function.
> +	 */
> +	if (index == RDMA_NL_LS) {
> +		if (cb_table[op].doit)
> +			return cb_table[op].doit(skb, nlh, extack);
> +		return -EINVAL;
> +	}
>  	/* FIXME: Convert IWCM to properly handle doit callbacks */
>  	if ((nlh->nlmsg_flags & NLM_F_DUMP) || index == RDMA_NL_RDMA_CM ||
>  	    index == RDMA_NL_IWCM) {
>  		struct netlink_dump_control c = {
>  			.dump = cb_table[op].dump,
>  		};
> -		return netlink_dump_start(nls, skb, nlh, &c);
> +		if (c.dump)
> +			return netlink_dump_start(nls, skb, nlh, &c);
> +		return -EINVAL;
>  	}
>  
>  	if (cb_table[op].doit)
>

Do you neccessarily need the non-null checks for cb_table[op].doit and c.dump?

Otherwise, looks good.

Reviewed-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
