From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Tue, 23 Jan 2018 08:21:42 -0700
Message-ID: <20180123152142.GB30619@mellanox.com>
References: <20180123115013.12213-1-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180123115013.12213-1-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 01:50:13PM +0200, Leon Romanovsky wrote:
> Combination of CONFIG_DEBUG_OBJECTS_RCU_HEAD=y and
> CONFIG_INFINIBAND_SRPT=m produces the following build error.
> 
> ERROR: "init_rcu_head" [drivers/infiniband/ulp/srpt/ib_srpt.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
> make: *** [Makefile:1216: modules] Error 2
> 
> The reason to it that init_rcu_head() is not exported and not supposed
> to be used in modules. The correct function to use is init_rcu_head_on_stack().
> 
> Fixes: 795bc112cd5a ("IB/srpt: Make it safe to use RCU for srpt_device.rch_list")
> Fixes: a11253142e6d ("IB/srpt: Rework multi-channel support")
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index bf37816a1b12..65bbc3dbf0fd 100644
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1950,7 +1950,7 @@ static struct srpt_nexus *srpt_get_nexus(struct srpt_port *sport,
>  			nexus = ERR_PTR(-ENOMEM);
>  			break;
>  		}
> -		init_rcu_head(&tmp_nexus->rcu);
> +		init_rcu_head_on_stack(&tmp_nexus->rcu);

The comments for init_rcu_head_on_stack say it should only be used for
stack allocations and tmp_nexus is not a stack allocation.

Removing the init_rcu_head entirely seems like the right thing to do,
and maybe that function is poorly named?

/*
 * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
 * initialization and destruction of rcu_head on the stack. rcu_head structures
 * allocated dynamically in the heap or defined statically don't need any
 * initialization.
 */

The commit that introduced init_rcu_head is
546a9d8519ed137b2804a3f5a3659003039dd49c which suggests it exists only
to help the slab allocators, although curiously the allocators never
call it these days..

Maybe Paul can confirm?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
