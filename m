From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v6 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 25 Jun 2015 17:16:36 -0600
Message-ID: <20150625231636.GA7901@obsidianresearch.com>
References: <1434117966-17978-1-git-send-email-kaike.wan@intel.com>
 <1434117966-17978-5-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434117966-17978-5-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 12, 2015 at 10:06:06AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> This patch routes a SA pathrecord query to netlink first and processes the
> response appropriately. If a failure is returned, the request will be sent
> through IB. The decision whether to route the request to netlink first is
> determined by the presence of a listener for the local service netlink
> multicast group. If the user-space local service netlink multicast group
> listener is not present, the request will be sent through IB, just like
> what is currently being done.

I'd really like to test this out here, I was hoping to get to that
this week, but not yet.. And I was still hoping to read through
carefully.

Anyhow, brief check seemed like things make sense

> +struct ib_nl_attr_info {
> +	u16 len;	/* Total attr len: header + payload + padding */
> +	ib_sa_comp_mask comp_mask;
> +	void *input;
> +	void (*set_attrs)(struct sk_buff *skb, struct ib_nl_attr_info
> *info);

I don't really get what this is for, set_attrs is only ever equal to
ib_nl_set_path_rec_attrs - is this whole indirection left over from
something else? Drop it?

This code does wander quite a bit, lots of functions are called from
only one place, not necessarily bad, but at least topo sort them so the
one-place called function is before the only caller... Makes it easier
to read

> +	struct ib_sa_path_rec *sa_rec = info->input;
> +	__u8 val1;
> +	__u16 val2;
> +	__u64 val3;

At least use val8, val16, val64 for names and IIRC, the __ is not used
inside the kernel proper

> +
> +	if ((info->comp_mask & IB_SA_PATH_REC_REVERSIBLE) &&
> +	    sa_rec->reversible != 0) {
> +		if ((info->comp_mask & IB_SA_PATH_REC_NUMB_PATH) &&
> +		    sa_rec->numb_path > 1)

The kernel never sets numb path, I would just never set _ALL for now
and leave it as a placeholder.

> +			val1 = LS_NLA_PATH_USE_ALL;
> +		else
> +			val1 = LS_NLA_PATH_USE_GMP;
> +	} else {
> +		val1 = LS_NLA_PATH_USE_UNIDIRECTIONAL;
> +	}
> +	nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_PATH_USE, sizeof(val1),
> +		&val1);

This uses a u8 but other places are not using that:
+    case LS_NLA_TYPE_PATH_USE:
+    	  use = (struct rdma_nla_ls_path_use *) NLA_DATA(attr);

> +			if (curr->nla_type == LS_NLA_TYPE_PATH_RECORD) {
> +				rec = nla_data(curr);
> +				if (rec->flags && IB_PATH_PRIMARY) {

&& is the wrong operator isn't it?

IB_PATH_PRIMARY is the wrong test, I think I covered this already..

I still feel like the netlink specific stuff should live in its own
file, not be jammed into sa_query.c - unless it is really hard to
disentangle, but it doesn't look too bad at first glance..

> +static int ib_nl_get_path_rec_attrs_len(struct ib_nl_attr_info *info)
> +{
> +	if (len > 0)
> +	   len += nla_total_size(sizeof(struct rdma_nla_ls_path_use));

Seems a bit goofy, I don't think we should ever generate an empty
netlink query. That feels like a WARN_ON scenario.

> +	skb = nlmsg_new(attrs->len, GFP_KERNEL);
> +	if (!skb) {
> +	   pr_err("alloc failed ret=%d\n", ret);

Doesn't alloc failure already print enough?

> +	      if (ret != -ESRCH)
> +	      	      pr_err("ibnl_multicast failed l=%d, r=%d\n",
> +		      			     	           attrs->len,ret);

What is this print about? Seem strange?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
