From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 2/2] IB/mad: Use IDR for agent IDs
Date: Tue, 12 Jun 2018 14:33:22 -0600
Message-ID: <20180612203322.GG6314@ziepe.ca>
References: <20180608174218.32455-1-willy@infradead.org>
 <20180608174218.32455-3-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180608174218.32455-3-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 08, 2018 at 10:42:18AM -0700, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Allocate agent IDs from a global IDR instead of an atomic variable.
> This eliminates the possibility of reusing an ID which is already in
> use after 4 billion registrations, and we can also limit the assigned
> ID to be less than 2^24, which fixes a bug in the mlx4 device.
> 
> We look up the agent under protection of the RCU lock, which means we
> have to free the agent using kfree_rcu, and only increment the reference
> counter if it is not 0.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
>  drivers/infiniband/core/mad.c      | 78 ++++++++++++++++++------------
>  drivers/infiniband/core/mad_priv.h |  7 +--
>  include/linux/idr.h                |  9 ++++
>  3 files changed, 59 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 68f4dda916c8..62384a3dd3ec 100644
> +++ b/drivers/infiniband/core/mad.c
> @@ -38,6 +38,7 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/dma-mapping.h>
> +#include <linux/idr.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/security.h>
> @@ -58,8 +59,8 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests
>  module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
>  MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
>  
> +static DEFINE_IDR(ib_mad_clients);
>  static struct list_head ib_mad_port_list;
> -static atomic_t ib_mad_client_id = ATOMIC_INIT(0);
>  
>  /* Port list lock */
>  static DEFINE_SPINLOCK(ib_mad_port_list_lock);
> @@ -377,13 +378,24 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
>  		goto error4;
>  	}
>  
> -	spin_lock_irq(&port_priv->reg_lock);
> -	mad_agent_priv->agent.hi_tid = atomic_inc_return(&ib_mad_client_id);
> +	idr_preload(GFP_KERNEL);
> +	idr_lock(&ib_mad_clients);
> +	ret2 = idr_alloc_cyclic(&ib_mad_clients, mad_agent_priv, 0,
> +			(1 << 24), GFP_ATOMIC);

I like this series, my only concern is this magic number here, at the
very least it deserves a big comment explaining why it
exists..

Let me see if I can get someone to give it some test time, I assume
you haven't been able to test it it?

> diff --git a/include/linux/idr.h b/include/linux/idr.h
> index e856f4e0ab35..bef0df8600e2 100644
> +++ b/include/linux/idr.h
> @@ -81,6 +81,15 @@ static inline void idr_set_cursor(struct idr *idr, unsigned int val)
>  	WRITE_ONCE(idr->idr_next, val);
>  }
>  
> +#define idr_lock(idr)		xa_lock(&(idr)->idr_rt)
> +#define idr_unlock(idr)		xa_unlock(&(idr)->idr_rt)
> +#define idr_lock_irq(idr)	xa_lock_irq(&(idr)->idr_rt)
> +#define idr_unlock_irq(idr)	xa_unlock_irq(&(idr)->idr_rt)
> +#define idr_lock_irqsave(idr, flags) \
> +				xa_lock_irqsave(&(idr)->idr_rt, flags)
> +#define idr_unlock_irqrestore(idr, flags) \
> +				xa_unlock_irqrestore(&(idr)->idr_rt, flags)
> +

And you are Ok to take these through the rdma tree?

Thanks,
Jason
