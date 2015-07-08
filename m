From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Mlx4: BUG: unable to handle kernel at ffffffffa02be210
Date: Wed, 8 Jul 2015 16:49:52 +0300
Message-ID: <559D2A80.4040909@mellanox.com>
References: <CAD+HZHXi2bB59eWLYaGiXj5-b5w3V1NhwUJbSjx5NfdmhEaRhA@mail.gmail.com>
	<559D1562.2070309@mellanox.com>
 <CAD+HZHVCMa97zEQ1SB=JXCKHOGgSO93BPyLha2PDrOOTsHTUCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAD+HZHVCMa97zEQ1SB=JXCKHOGgSO93BPyLha2PDrOOTsHTUCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/8/2015 3:47 PM, Jack Wang wrote:
> static void mlx4_ib_cq_comp(struct mlx4_cq *cq)
> 47 {
> 48 struct ib_cq *ibcq = &to_mibcq(cq)->ibcq;
> 49 ibcq->comp_handler(ibcq, ibcq->cq_context);
> 50 }
>
> Looks like cq use-after-free? I have no idea where.

see if you have in the code base you're using (why not the stock 3.18.14 
driver, BTW?) all the synchronize_irq
calls we have in the latest upstream driver:

drivers/net/ethernet/mellanox/mlx4/cq.c:371: 
synchronize_irq(priv->eq_table.eq[MLX4_CQ_TO_EQ_VECTOR(cq->vector)].irq);
drivers/net/ethernet/mellanox/mlx4/cq.c:374: 
synchronize_irq(priv->eq_table.eq[MLX4_EQ_ASYNC].irq);
drivers/net/ethernet/mellanox/mlx4/eq.c:1088: synchronize_irq(eq->irq);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
