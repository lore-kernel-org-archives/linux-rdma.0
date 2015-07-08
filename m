From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mlx4: BUG: unable to handle kernel at ffffffffa02be210
Date: Wed, 8 Jul 2015 16:07:59 +0200
Message-ID: <CAD+HZHWBn-KZCsskSGPKLtntj-LjDRodda9jngr+qcKSxLhkGQ@mail.gmail.com>
References: <CAD+HZHXi2bB59eWLYaGiXj5-b5w3V1NhwUJbSjx5NfdmhEaRhA@mail.gmail.com>
	<559D1562.2070309@mellanox.com>
	<CAD+HZHVCMa97zEQ1SB=JXCKHOGgSO93BPyLha2PDrOOTsHTUCw@mail.gmail.com>
	<559D2A80.4040909@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559D2A80.4040909-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks for your time.

Looks the last one is missing in OFED 2.4 driver, I just checked the
history of mainline

commit bf1bac5b7882daa41249f85fbc97828f0597de5c
Author: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Thu Oct 23 15:57:27 2014 +0300

    net/mlx4_core: Call synchronize_irq() before freeing EQ buffer

    After moving the EQ ownership to software effectively destroying it, call
    synchronize_irq() to ensure that any handler routines running on other CPU
    cores finish execution. Only then free the EQ buffer.
    The same thing is done when we destroy a CQ which is one of the sources
    generating interrupts. In the case of CQ we want to avoid
completion handlers
    on a CQ that was destroyed. In the case we do the same to avoid receiving
    asynchronous events after the EQ has been destroyed and its buffers freed.

    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

This fix looks fit the bug we're hitting. Yes, we plan to update 3.0
OFED recently, and the fix is included there.
Will report if the bug is still there

Thanks again.
Jack

2015-07-08 15:49 GMT+02:00 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:
> On 7/8/2015 3:47 PM, Jack Wang wrote:
>>
>> static void mlx4_ib_cq_comp(struct mlx4_cq *cq)
>> 47 {
>> 48 struct ib_cq *ibcq = &to_mibcq(cq)->ibcq;
>> 49 ibcq->comp_handler(ibcq, ibcq->cq_context);
>> 50 }
>>
>> Looks like cq use-after-free? I have no idea where.
>
>
> see if you have in the code base you're using (why not the stock 3.18.14
> driver, BTW?) all the synchronize_irq
> calls we have in the latest upstream driver:
>
> drivers/net/ethernet/mellanox/mlx4/cq.c:371:
> synchronize_irq(priv->eq_table.eq[MLX4_CQ_TO_EQ_VECTOR(cq->vector)].irq);
> drivers/net/ethernet/mellanox/mlx4/cq.c:374:
> synchronize_irq(priv->eq_table.eq[MLX4_EQ_ASYNC].irq);
> drivers/net/ethernet/mellanox/mlx4/eq.c:1088: synchronize_irq(eq->irq);
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
