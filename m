From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v8 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Wed, 22 Jul 2015 15:09:18 -0600
Message-ID: <20150722210918.GB20815@obsidianresearch.com>
References: <1436463268-32365-1-git-send-email-kaike.wan@intel.com>
 <1436463268-32365-5-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1436463268-32365-5-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 09, 2015 at 01:34:28PM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This patch routes a SA pathrecord query to netlink first and processes the
> response appropriately. If a failure is returned, the request will be sent
> through IB. The decision whether to route the request to netlink first is
> determined by the presence of a listener for the local service netlink
> multicast group. If the user-space local service netlink multicast group
> listener is not present, the request will be sent through IB, just like
> what is currently being done.

So, I tested it again, and the UAPI looks pretty reasonable now.

The netlink validation still needs to be fixed.

> There is where we might have a problem: nla_parse() allows only one
> entry for each attribute type in the returned array tb[]. If we have
> multiple (say 6) pathrecords returned, each having different flags
> (for different path use), a later one will replace an earlier one in
> tb[].

The parse is OK, continue to use the for loop, nla_parse does more
than just extract into tb, it validates all the sizes are correct,
ignore tb.

My testing shows it seems to get into some kind of fast repeating
query loop:

[ 4904.969188] Return answer 0
[ 4904.969483] Return answer 0
[ 4904.969703] Return answer 0
[ 4904.969824] Return answer 0
[ 4904.969943] Return answer 0
[ 4904.970058] Return answer 0
[ 4904.970175] Return answer 0
[ 4904.970289] Return answer 0

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 63ea36d05072..e6b0181e7076 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -640,6 +640,8 @@ static void ib_nl_process_good_resolve_rsp(struct ib_sa_query *query,
                                }
                        }
                }
+
+               printk("Return answer %u\n",status);
                query->callback(query, status, mad);
        }

You'll have to figure that out. I'm just doing ping X while running
a responder on the netlink socket, v7 didn't do this, IIRC.

I think it has something to do with the timer as the first request
works fine, then a pause, then a storm.

Actually, looks like nothing removes nl queries from the timeout loop
when they successfully complete. (ie this series doesn't even have a
hope of working properly)

Please actually test this patch completely and thoroughly before
sending another version. I'm broadly happy with this, so get your
whole team to look it over agin.

> +	if (query->callback) {
> +		head = (const struct nlattr *) nlmsg_data(nlh);
> +		len = nlmsg_len(nlh);
> +		switch (query->path_use) {
> +		case LS_RESOLVE_PATH_USE_UNIDIRECTIONAL:
> +			mask = IB_PATH_PRIMARY | IB_PATH_OUTBOUND;
> +			break;
> +
> +		case LS_RESOLVE_PATH_USE_ALL:
> +		case LS_RESOLVE_PATH_USE_GMP:
> +		default:
> +			mask = IB_PATH_PRIMARY | IB_PATH_GMP |
> +				IB_PATH_BIDIRECTIONAL;
> +			break;
> +		}
> +		nla_for_each_attr(curr, head, len, rem) {
> +			if (curr->nla_type == LS_NLA_TYPE_PATH_RECORD) {
> +				rec = nla_data(curr);
> +				/*
> +				 * Get the first one. In the future, we may
> +				 * need to get up to 6 pathrecords.
> +				 */
> +				if (rec->flags & mask) {

(rec_>flags & mask) == mask

All requested bits must be set, not just any requested bit.

A IB_PATH_PRIMARY | IB_PATH_OUTBOUND result does not satisfy the
requirement for LS_RESOLVE_PATH_USE_GMP.

The goal is to local the one path of many that satisfies the
requirement. Future kernels will direct 6 path answers 

> +static int ib_nl_handle_set_timeout(struct sk_buff *skb,
> +				    struct netlink_callback *cb)
> +{
> +	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
> +	int timeout, delta, abs_delta;
> +	const struct nlattr *attr;
> +	unsigned long flags;
> +	struct ib_sa_query *query;
> +	long delay = 0;
> +	struct nlattr *tb[LS_NLA_TYPE_MAX + 1];
> +	int ret;
> +
> +	ret = nla_parse(tb, LS_NLA_TYPE_MAX, nlmsg_data(nlh), nlmsg_len(nlh),
> +			NULL);
> +	attr = (const struct nlattr *)tb[LS_NLA_TYPE_TIMEOUT];
> +	if (ret || !attr || nla_len(attr) != sizeof(u32))
> +		goto settimeout_out;

This probably doesn't need the nested attribute, but I'm indifferent.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
