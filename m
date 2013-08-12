From: "Foraker, Jim" <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] IPoIB: Fix race in deleting ipoib_neigh entries
Date: Mon, 12 Aug 2013 17:28:17 +0000
Message-ID: <CFAC33911979AD4C8D88DE3515E8FE3615F4587A@PRDEXMBX-03.the-lab.llnl.gov>
References: <32E1700B9017364D9B60AED9960492BC21170384@FMSMSX107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC21170384-AtyAts71sc9zLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <7DE83B62A34B6E4DA01077AC3CD20EE7-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/12/13 9:04 AM, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> +			/* remove from parent list */
>> +			list_del(&neigh->list);
>>  			call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
>
>Should the list_del be a list_del_rcu()?
     I don't believe so, as it's the neighbor hash table
(priv->ntbl->htbl) that is RCU protected and not neigh->list.

     Jim

>
>From Documentation/RCU/listRCU.txt:
>
>Following are the RCU equivalents for these two functions:
>
>        static inline int audit_del_rule(struct audit_rule *rule,
>                                         struct list_head *list)
>        {
>                struct audit_entry  *e;
>
>                /* Do not use the _rcu iterator here, since this is the
>only
>                 * deletion routine. */
>                list_for_each_entry(e, list, list) {
>                        if (!audit_compare_rule(rule, &e->rule)) {
>                                list_del_rcu(&e->list);
>                                call_rcu(&e->rcu, audit_free_rule);
>                                return 0;
>                        }
>                }
>                return -EFAULT;         /* No matching rule */
>        }
>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
