From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v7 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Fri, 3 Jul 2015 15:38:14 -0600
Message-ID: <20150703213814.GB5595@obsidianresearch.com>
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

I still think this is long and rambly, but that is mostly a style
preference, I think you should look at it and remove some of the left
over stuff, like we really don't need a rough in for other responses
at this point.

> +#define IB_SA_ENABLE_LOCAL_SERVICE	0x00000001
> +#define IB_SA_CANCEL			0x00000002
> +
> +#define IB_SA_LOCAL_SVC_ENABLED(query) \
> +	((query)->flags & IB_SA_ENABLE_LOCAL_SERVICE)
> +#define IB_SA_ENABLE_LOCAL_SVC(query) \
> +	((query)->flags |= IB_SA_ENABLE_LOCAL_SERVICE)
> +#define IB_SA_DISABLE_LOCAL_SVC(query) \
> +	((query)->flags &= ~IB_SA_ENABLE_LOCAL_SERVICE)
> +
> +#define IB_SA_QUERY_CANCELLED(query) \
> +	((query)->flags & IB_SA_CANCEL)
> +#define IB_SA_CANCEL_QUERY(query) \
> +	((query)->flags |= IB_SA_CANCEL)

This whole bit is really strange style - if you really want to keep
this then at least use static inline functions not macros.


> +static struct ib_nl_request_info *
> +ib_nl_alloc_request(struct ib_sa_query *query)
> +{
> +	struct ib_nl_request_info *rinfo;
> +
> +	rinfo = kzalloc(sizeof(*rinfo), GFP_ATOMIC);
> +	if (rinfo == NULL)
> +		return ERR_PTR(-ENOMEM);

There really seem to be alot of kallocs going on for what is supposed
to be a performance path.

I would probably work to fold this into the ib_sa_query allocation, it
is just a few bytes we can waste that ram if we are not using netlink.

> +	if ((info->comp_mask & IB_SA_PATH_REC_REVERSIBLE) &&
> +	    sa_rec->reversible != 0) {
> +		if ((info->comp_mask & IB_SA_PATH_REC_NUMB_PATH) &&
> +		    sa_rec->numb_path > 1)
> +			val8 = LS_NLA_PATH_USE_ALL;
> +		else
> +			val8 = LS_NLA_PATH_USE_GMP;

Drop the num_paths stuff, just set USE_GMP, it is confusing. I thought
I mentioned this already.

> +	} else {
> +		val8 = LS_NLA_PATH_USE_UNIDIRECTIONAL;
> +	}

> +	nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_PATH_USE, sizeof(val8),
> +		&val8);

Non-optional attributes should probably go in a non-nested header,
possibly along with the portGUID/portnum/whatever.

So the structure would be:

nlmsghdr
struct rdma_ls_resolve_path
{
  u64 port_guid; // whatever
  u32 path_use;
}
nlattr[IB_SA_PATH_REC_PKEY,...]*

This is standard layout for netlink messages

> +static int ib_nl_get_path_rec_attrs_len(struct ib_nl_attr_info *info)
> +{
> +	/*
> +	 * We need path use attribute no matter reversible or numb_path is
> +	 * set or not, as long as some other fields get set
> +	 */
> +	if (WARN_ON(len == 0))
> +		return len;

The comment is obsolete, and it shouldn't exit without reserving space
for the mandatory fields.

> +static int ib_nl_send_request(struct ib_nl_request_info *rinfo)
> +{
> +	struct ib_nl_attr_info info;
> +	int opcode;
> +	struct ib_sa_mad *mad;
> +	unsigned long flags;
> +	unsigned long delay;
> +	int ret;
> +
> +	mad = rinfo->query->mad_buf->mad;
> +	switch (mad->mad_hdr.attr_id) {
> +	case cpu_to_be16(IB_SA_ATTR_PATH_REC):
> +		opcode = RDMA_NL_LS_OP_RESOLVE;
> +		mad = rinfo->query->mad_buf->mad;
> +		info.comp_mask = mad->sa_hdr.comp_mask;
> +		info.input = rinfo->query->mad_buf->context[1];
> +		rinfo->query->mad_buf->context[1] = NULL;
> +		info.len = ib_nl_get_path_rec_attrs_len(&info);
> +		info.set_attrs = ib_nl_set_path_rec_attrs;
> +		break;

So now we put a bunch of stuff in yet another structure and call
through a function pointer. Rambly, I'd streamline that..

> +	struct ib_mad_send_wc mad_send_wc;
> +	struct ib_sa_mad *mad = NULL;
> +	const struct nlattr *head, *curr;
> +	struct ib_path_rec_data  *rec;
> +	int len, rem;
> +
> +	if (query->callback) {
> +		head = (const struct nlattr *) nlmsg_data(nlh);
> +		len = nlmsg_len(nlh);
> +		nla_for_each_attr(curr, head, len, rem) {
> +			if (curr->nla_type == LS_NLA_TYPE_PATH_RECORD) {
> +				rec = nla_data(curr);
> +				if (rec->flags && IB_PATH_PRIMARY) {

This is still wrong.

I looked very closely, and it turns out the record you want to find
depends on the path use that was asked for.

LS_NLA_PATH_USE_ALL: IB_PATH_PRIMARY | IB_PATH_GMP | IB_PATH_BIDIRECTIONAL
LS_NLA_PATH_USE_GMP: IB_PATH_PRIMARY | IB_PATH_GMP | IB_PATH_BIDIRECTIONAL
LS_NLA_PATH_USE_UNIDIRECTIONAL IB_PATH_PRIMARY | IB_PATH_OUTBOUND

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
> +
> +	head = (const struct nlattr *) nlmsg_data(nlh);
> +	len = nlmsg_len(nlh);
> +	nla_for_each_attr(curr, head, len, rem) {
> +		if (curr->nla_type == LS_NLA_TYPE_PATH_RECORD)
> +			return 1;
> +	}

As discussed already, this needs to use nla_parse_nested, which should
eliminate all of this. Do not do nla_for_each_attr here, just look for
ERR.
> +static int ib_nl_handle_set_timeout(struct sk_buff *skb,
> +				    struct netlink_callback *cb)
> +{
> +	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
> +	int timeout, delta, abs_delta;
> +	const struct nlattr *attr;
> +	struct rdma_nla_ls_timeout *to_attr;
> +	unsigned long flags;
> +	struct ib_nl_request_info *rinfo;
> +	long delay = 0;
> +
> +	if (nlmsg_len(nlh) < nla_attr_size(sizeof(*to_attr)))
> +		goto settimeout_out;

All this should be driven by nla_parse

> +	attr = (const struct nlattr *) nlmsg_data(nlh);
> +	if (attr->nla_type != LS_NLA_TYPE_TIMEOUT ||
> +	    nla_len(attr) != sizeof(*to_attr))
> +		goto settimeout_out;

No nested attr, as discussed

There is something weird here, IIRC in netlink a SET should return
back exactly the same message with the up to date values. (Probably
should confirm, I'm not 100% on that)

And I don't think this should be a dump, again, not 100% sure.

I didn't check the locking or a few otherthings, but I did test it out
a bit with a custom cache userspace client, would like to try again
when the protocol is fixed up.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
