From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v6 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Fri, 26 Jun 2015 14:49:24 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAC1C69@CRSMSX101.amr.corp.intel.com>
References: <1434117966-17978-1-git-send-email-kaike.wan@intel.com>
 <1434117966-17978-5-git-send-email-kaike.wan@intel.com>
 <20150625231636.GA7901@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625231636.GA7901-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Thursday, June 25, 2015 7:17 PM
> To: Wan, Kaike
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Fleck, John; Weiny, Ira
> Subject: Re: [PATCH v6 4/4] IB/sa: Route SA pathrecord query through netlink
> 
> On Fri, Jun 12, 2015 at 10:06:06AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > This patch routes a SA pathrecord query to netlink first and processes
> > the response appropriately. If a failure is returned, the request will
> > be sent through IB. The decision whether to route the request to
> > netlink first is determined by the presence of a listener for the
> > local service netlink multicast group. If the user-space local service
> > netlink multicast group listener is not present, the request will be
> > sent through IB, just like what is currently being done.
> 
> I'd really like to test this out here, I was hoping to get to that this week, but
> not yet.. And I was still hoping to read through carefully.
> 
> Anyhow, brief check seemed like things make sense

Thank you.

> 
> > +struct ib_nl_attr_info {
> > +	u16 len;	/* Total attr len: header + payload + padding */
> > +	ib_sa_comp_mask comp_mask;
> > +	void *input;
> > +	void (*set_attrs)(struct sk_buff *skb, struct ib_nl_attr_info
> > *info);
> 
> I don't really get what this is for, set_attrs is only ever equal to
> ib_nl_set_path_rec_attrs - is this whole indirection left over from something
> else? Drop it?

For this patch,  set_attrs is equal to ib_nl_set_path_rec_attrs. However, in the future, the same netlink mechanism could be easily extended to other SA querires, such as McMemberRecord. In that case, set_attrs will be set to another function. Alternatively, instead of differentiating the request type (pathrecord or other SA queries) in ib_nl_send_request(), we could do it in ib_nl_send_msg() under the spinlock. In that case, we need  neither set_attr field nor struct ib_nl_attr_info. However, we have to pass all input info into ib_nl_send_msg() with rinfo (struct ib_nl_request_info *), essentially moving the switch statements from ib_nl_send_request() into ib_nl_send_msg(). In that case, ib_nl_send_msg() may have to be renamed because it functions more like the current ib_nl_send_request(
 )...

Do you really prefer that? It's all about parameter passing.

> 
> This code does wander quite a bit, lots of functions are called from only one
> place, not necessarily bad, but at least topo sort them so the one-place
> called function is before the only caller... Makes it easier to read
> 
> > +	struct ib_sa_path_rec *sa_rec = info->input;
> > +	__u8 val1;
> > +	__u16 val2;
> > +	__u64 val3;
> 
> At least use val8, val16, val64 for names and IIRC, the __ is not used inside
> the kernel proper

I will use u8/u16/u64 instead and change the names accordingly.

Thank you for pointing it out.

> 
> > +
> > +	if ((info->comp_mask & IB_SA_PATH_REC_REVERSIBLE) &&
> > +	    sa_rec->reversible != 0) {
> > +		if ((info->comp_mask & IB_SA_PATH_REC_NUMB_PATH) &&
> > +		    sa_rec->numb_path > 1)
> 
> The kernel never sets numb path, I would just never set _ALL for now and
> leave it as a placeholder.

rdma_cm sets numb_path to 1. Ipoib and srp do not set it at all.  therefore, _ALL is never set.

Can we just leave the code here in case someone might want to set numb_path > 1?

> 
> > +			val1 = LS_NLA_PATH_USE_ALL;
> > +		else
> > +			val1 = LS_NLA_PATH_USE_GMP;
> > +	} else {
> > +		val1 = LS_NLA_PATH_USE_UNIDIRECTIONAL;
> > +	}
> > +	nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_PATH_USE,
> sizeof(val1),
> > +		&val1);
> 
> This uses a u8 but other places are not using that:

Are you referring to u8 instead of __u8? I will replace __u8 with u8 in the netlink code in sa_query.c

> +    case LS_NLA_TYPE_PATH_USE:
> +    	  use = (struct rdma_nla_ls_path_use *) NLA_DATA(attr);
> 
> > +			if (curr->nla_type == LS_NLA_TYPE_PATH_RECORD) {
> > +				rec = nla_data(curr);
> > +				if (rec->flags && IB_PATH_PRIMARY) {
> 
> && is the wrong operator isn't it?

You are right, it should be "&".

> 
> IB_PATH_PRIMARY is the wrong test, I think I covered this already..

Could you be more specific? what do you think will be a good test here?

> 
> I still feel like the netlink specific stuff should live in its own file, not be
> jammed into sa_query.c - unless it is really hard to disentangle, but it doesn't
> look too bad at first glance..

It could be done. We need a header file for all netlink functions used by sa_query.c (to register /unregister the rdma netlink client, to cancel request, etc). In addition, we also need to have another header file from sa_query for those structures and functions used by the netlink code.  Of course, those functions can't be static anymore.  For these reasons, I prefer to keep them together.


> 
> > +static int ib_nl_get_path_rec_attrs_len(struct ib_nl_attr_info *info)
> > +{
> > +	if (len > 0)
> > +	   len += nla_total_size(sizeof(struct rdma_nla_ls_path_use));
> 
> Seems a bit goofy, I don't think we should ever generate an empty netlink
> query. That feels like a WARN_ON scenario.

I will use WARN_ON here.


> 
> > +	skb = nlmsg_new(attrs->len, GFP_KERNEL);
> > +	if (!skb) {
> > +	   pr_err("alloc failed ret=%d\n", ret);
> 
> Doesn't alloc failure already print enough?

I will remove the print.

> 
> > +	      if (ret != -ESRCH)
> > +	      	      pr_err("ibnl_multicast failed l=%d, r=%d\n",
> > +		      			     	           attrs->len,ret);
> 
> What is this print about? Seem strange?

I will remove the print.

Kaike

> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
