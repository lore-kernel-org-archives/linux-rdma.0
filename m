From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/sa: Restrict SA Netlink to admin users
Date: Mon, 10 Aug 2015 09:11:08 +0300
Message-ID: <55C8407C.6060103@mellanox.com>
References: <1438895310-6087-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438895310-6087-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/08/2015 00:08, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> @@ -754,6 +764,12 @@ static int ib_nl_handle_resolve_resp(struct sk_buff *skb,
>  	int found = 0;
>  	int ret;
>  
> +	if (!ns_capable(sock_net(skb->sk)->user_ns, CAP_NET_ADMIN)) {
> +		pr_warn_ratelimited("SA netlink: invalid perm for response: `%s'.\n",
> +				    current->comm);
> +		return -EPERM;
> +	}
> +
>  	spin_lock_irqsave(&ib_nl_request_lock, flags);
>  	list_for_each_entry(query, &ib_nl_request_list, list) {
>  		/*

Maybe I'm missing something, but I thought you would want to check the
capability with init_user_ns as the target, since the SA queries will
affect all namespaces, not just the one that sent the response.

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
