From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IPoIB: Fix race in deleting ipoib_neigh entries
Date: Mon, 12 Aug 2013 16:04:51 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC21170384@FMSMSX107.amr.corp.intel.com>
References: <1376009062-3049-1-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376009062-3049-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +			/* remove from parent list */
> +			list_del(&neigh->list);
>  			call_rcu(&neigh->rcu, ipoib_neigh_reclaim);

Should the list_del be a list_del_rcu()?

>From Documentation/RCU/listRCU.txt:

Following are the RCU equivalents for these two functions:

        static inline int audit_del_rule(struct audit_rule *rule,
                                         struct list_head *list)
        {
                struct audit_entry  *e;

                /* Do not use the _rcu iterator here, since this is the only
                 * deletion routine. */
                list_for_each_entry(e, list, list) {
                        if (!audit_compare_rule(rule, &e->rule)) {
                                list_del_rcu(&e->list);
                                call_rcu(&e->rcu, audit_free_rule);
                                return 0;
                        }
                }
                return -EFAULT;         /* No matching rule */
        }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
