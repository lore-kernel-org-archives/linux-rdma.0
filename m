From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mlx4: BUG: unable to handle kernel at ffffffffa02be210
Date: Thu, 9 Jul 2015 15:35:21 +0200
Message-ID: <CAD+HZHVukRdGnfTWHin8O=hUkuOq0SS_aPqxbqjKCmk--OHn=w@mail.gmail.com>
References: <CAD+HZHXi2bB59eWLYaGiXj5-b5w3V1NhwUJbSjx5NfdmhEaRhA@mail.gmail.com>
	<559D1562.2070309@mellanox.com>
	<CAD+HZHVCMa97zEQ1SB=JXCKHOGgSO93BPyLha2PDrOOTsHTUCw@mail.gmail.com>
	<559D2A80.4040909@mellanox.com>
	<CAD+HZHWBn-KZCsskSGPKLtntj-LjDRodda9jngr+qcKSxLhkGQ@mail.gmail.com>
	<CAD+HZHXcrejwu=dAhmL7vZ=tkAPswm2LiCgwK42kEe5XDvBvhQ@mail.gmail.com>
	<559E592D.5000201@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559E592D.5000201-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2015-07-09 13:21 GMT+02:00 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:
> On 7/9/2015 2:14 PM, Jack Wang wrote:
>>
>> I managed to update the kernel to OFED 3.0 to verify the bug, but I
>> can still produce the bug, maybe there're still some synchronice_irq
>> is missing?
>
>
> Again, even if you don't use the upstream kernel for production, I suggest
> you
> try to reproduce the bug there and if it exists we'll try to solve it on
> upstream
> and later port to MLNX OFED, makes sense?You can start with just the
> installed 3.18.14
>
> Or.
Hello Or,

We have other kernel modules together also the autotest
infrastructure. It's not that easy to install a 3.18.14 kernel.

I look into the code a little bit. I think the bug may relate
radix_tree usage in mlx4_cq_free , OFED code in radix_tree_delete
before synchronize_irq, but mainline code call radix_tree_delete after
synchronize_irq,  does this matter? I'm building a new kernel with
this small change:

--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -393,16 +393,16 @@ void mlx4_cq_free(struct mlx4_dev *dev, struct
mlx4_cq *cq)
  if (err)
  mlx4_warn(dev, "HW2SW_CQ failed (%d) for CQN %06x\n", err, cq->cqn);

- spin_lock(&cq_table->lock);
- radix_tree_delete(&cq_table->tree, cq->cqn);
- spin_unlock(&cq_table->lock);
-
  synchronize_irq(priv->eq_table.eq[MLX4_CQ_TO_EQ_VECTOR(cq->vector)].irq);
  /* synchronize ASYNC irq */
  if (priv->eq_table.eq[MLX4_CQ_TO_EQ_VECTOR(cq->vector)].irq !=
     priv->eq_table.eq[MLX4_EQ_ASYNC].irq)
  synchronize_irq(priv->eq_table.eq[MLX4_EQ_ASYNC].irq);

+ spin_lock(&cq_table->lock);
+ radix_tree_delete(&cq_table->tree, cq->cqn);
+ spin_unlock(&cq_table->lock);
+
  if (atomic_dec_and_test(&cq->refcount))
  complete(&cq->free);
  wait_for_completion(&cq->free);
Thanks,
Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
