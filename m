From: Sowmini Varadhan <sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: WARNING: suspicious RCU usage in rds_loop_conn_alloc
Date: Mon, 12 Feb 2018 11:09:51 -0500
Message-ID: <20180212160951.GA21125@oracle.com>
References: <001a1143e744e1cb89056505f466@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <001a1143e744e1cb89056505f466-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: syzbot <syzbot+da36cb8a23beedb61503-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by syzkaller563791/4086:
>  #0:  (rcu_read_lock){....}, at: [<00000000bf5db0e6>]
> __rds_conn_create+0xe46/0x1b50 net/rds/connection.c:218
> 

the rcu_read_lock() was added by ebeeb1ad9b. After we add that,
everything in the rcu read critical section needs to use GFP_ATOMIC
to avoid sleeping. I'll look into this fix.

--Sowmini

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
