From: Yanjun Zhu <yanjun.zhu@oracle.com>
Subject: Re: [PATCH] IB/core: Make ib_mad_client_id atomic
Date: Thu, 19 Apr 2018 10:59:28 +0800
Message-ID: <d2d8f0c7-7802-a899-22de-1fe31603b21b@oracle.com>
References: <20180418142450.15581-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180418142450.15581-1-Haakon.Bugge@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?H=c3=a5kon_Bugge?= <Haakon.Bugge@oracle.com>, Doug Ledford <dledford@redhat.com>, Don Hiatt <don.hiatt@intel.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 2018/4/18 22:24, Håkon Bugge wrote:
> Two kernel threads may get the same value for agent.hi_tid, if the
> agents are registered for different ports. As of now, this works, as
> the agent list is per port.
>
> It is however confusing and not future robust. Hence, making it
> atomic.
>
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> Reviewed-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
>   drivers/infiniband/core/mad.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index c50596f7f98a..b28452a55a08 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -59,7 +59,7 @@ module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
>   MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
>   
>   static struct list_head ib_mad_port_list;
> -static u32 ib_mad_client_id = 0;
> +static atomic_t ib_mad_client_id = ATOMIC_INIT(0);
>   
>   /* Port list lock */
>   static DEFINE_SPINLOCK(ib_mad_port_list_lock);
> @@ -377,7 +377,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
>   	}
>   
>   	spin_lock_irqsave(&port_priv->reg_lock, flags);
> -	mad_agent_priv->agent.hi_tid = ++ib_mad_client_id;
> +	mad_agent_priv->agent.hi_tid = atomic_inc_return(&ib_mad_client_id);
>   
>   	/*
>   	 * Make sure MAD registration (if supplied)
