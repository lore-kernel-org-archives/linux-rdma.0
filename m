From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] rds: ib: Fix NULL pointer dereference in debug code
Date: Fri, 10 Nov 2017 14:55:16 +0900 (KST)
Message-ID: <20171110.145516.1895467386398674445.davem@davemloft.net>
References: <20171107153334.24401-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107153334.24401-1-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Haakon.Bugge@oracle.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, knut.omang@oracle.com, wei.lin.guay@oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Håkon Bugge <Haakon.Bugge@oracle.com>
Date: Tue,  7 Nov 2017 16:33:34 +0100

> rds_ib_recv_refill() is a function that refills an IB receive
> queue. It can be called from both the CQE handler (tasklet) and a
> worker thread.
> 
> Just after the call to ib_post_recv(), a debug message is printed with
> rdsdebug():
> 
>             ret = ib_post_recv(ic->i_cm_id->qp, &recv->r_wr, &failed_wr);
>             rdsdebug("recv %p ibinc %p page %p addr %lu ret %d\n", recv,
>                      recv->r_ibinc, sg_page(&recv->r_frag->f_sg),
>                      (long) ib_sg_dma_address(
>                             ic->i_cm_id->device,
>                             &recv->r_frag->f_sg),
>                     ret);
> 
> Now consider an invocation of rds_ib_recv_refill() from the worker
> thread, which is preemptible. Further, assume that the worker thread
> is preempted between the ib_post_recv() and rdsdebug() statements.
> 
> Then, if the preemption is due to a receive CQE event, the
> rds_ib_recv_cqe_handler() will be invoked. This function processes
> receive completions, including freeing up data structures, such as the
> recv->r_frag.
> 
> In this scenario, rds_ib_recv_cqe_handler() will process the receive
> WR posted above. That implies, that the recv->r_frag has been freed
> before the above rdsdebug() statement has been executed. When it is
> later executed, we will have a NULL pointer dereference:
 ...
> This bug was provoked by compiling rds out-of-tree with
> EXTRA_CFLAGS="-DRDS_DEBUG -DDEBUG" and inserting an artificial delay
> between the rdsdebug() and ib_ib_port_recv() statements:
> 
>    	       /* XXX when can this fail? */
> 	       ret = ib_post_recv(ic->i_cm_id->qp, &recv->r_wr, &failed_wr);
> +		if (can_wait)
> +			usleep_range(1000, 5000);
> 	       rdsdebug("recv %p ibinc %p page %p addr %lu ret %d\n", recv,
> 			recv->r_ibinc, sg_page(&recv->r_frag->f_sg),
> 			(long) ib_sg_dma_address(
> 
> The fix is simply to move the rdsdebug() statement up before the
> ib_post_recv() and remove the printing of ret, which is taken care of
> anyway by the non-debug code.
> 
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> Reviewed-by: Knut Omang <knut.omang@oracle.com>
> Reviewed-by: Wei Lin Guay <wei.lin.guay@oracle.com>

Applied, thank you.
