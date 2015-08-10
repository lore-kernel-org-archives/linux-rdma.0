From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/sa: Restrict SA Netlink to admin users
Date: Mon, 10 Aug 2015 17:58:30 -0400
Message-ID: <20150810215829.GA12260@phlsvsds.ph.intel.com>
References: <1438895310-6087-1-git-send-email-ira.weiny@intel.com> <55C8407C.6060103@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55C8407C.6060103-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 10, 2015 at 09:11:08AM +0300, Haggai Eran wrote:
> On 07/08/2015 00:08, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > @@ -754,6 +764,12 @@ static int ib_nl_handle_resolve_resp(struct sk_buff *skb,
> >  	int found = 0;
> >  	int ret;
> >  
> > +	if (!ns_capable(sock_net(skb->sk)->user_ns, CAP_NET_ADMIN)) {
> > +		pr_warn_ratelimited("SA netlink: invalid perm for response: `%s'.\n",
> > +				    current->comm);
> > +		return -EPERM;
> > +	}
> > +
> >  	spin_lock_irqsave(&ib_nl_request_lock, flags);
> >  	list_for_each_entry(query, &ib_nl_request_list, list) {
> >  		/*
> 
> Maybe I'm missing something, but I thought you would want to check the
> capability with init_user_ns as the target, since the SA queries will
> affect all namespaces, not just the one that sent the response.

I'm not an expert in namespaces but these checks are only concerned with the
network namespace of the process which is acting as an SA proxy (via netlink).

AFAIK a user can't elevate a network namespace that the SA proxy is running in.
While you are correct that this data does affect all namespaces who are using a
particular port, this does not matter.  The SA data for that port is applicable
no matter which network namespace an application running on that port is in.

Furthermore, the check in netlink_bind also uses the socket namespace to
restrict the use of multicast.  This plus my checks should allow an admin to
place the SA proxy (ibacm in our test cases) in an alternate network namespace
if they so desire.  But this is independent to the namespace which may be used
for data applications.


All that said, I did find the netlink_net_capable helper call which I should
have used instead.  I'll work up a v2 today.

Thanks,
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
