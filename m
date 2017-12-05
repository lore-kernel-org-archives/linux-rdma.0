From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH tip/core/rcu 16/21] drivers/infiniband: Remove
 now-redundant smp_read_barrier_depends()
Date: Tue, 5 Dec 2017 08:08:32 -0700
Message-ID: <20171205150832.GA27409@ziepe.ca>
References: <20171201195053.GA23494@linux.vnet.ibm.com>
 <1512157876-24665-16-git-send-email-paulmck@linux.vnet.ibm.com>
 <20171202001109.GQ7754@ziepe.ca>
 <20171202010851.GL7829@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171202010851.GL7829-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dipankar-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Cree <mcree-q3Ck4f9/EBK9koe0gwxAeg@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> commit c389c98ec5f4a7aa4c36853e89801eb5ea81870e
> Author: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Date:   Mon Nov 27 09:04:22 2017 -0800
> 
>     drivers/infiniband: Remove now-redundant smp_read_barrier_depends()
>     
>     The smp_read_barrier_depends() does nothing at all except on DEC Alpha,
>     and no current DEC Alpha systems use Infiniband:
>     
>     	lkml.kernel.org/r/20171023085921.jwbntptn6ictbnvj@tower
>     
>     This commit therefore makes Infiniband depend on !ALPHA and removes
>     the now-ineffective invocations of smp_read_barrier_depends() from
>     the InfiniBand driver.
>     
>     Please note that this patch should not be construed as my saying that
>     InfiniBand's memory ordering is correct, but rather that this patch does
>     not in any way affect InfiniBand's correctness.  In other words, the
>     result of applying this patch is bug-for-bug compatible with the original.
>     
>     Signed-off-by: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>     Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>     Cc: Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>
>     Cc: Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>
>     Cc: Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>     Cc: Michael Cree <mcree-q3Ck4f9/EBK9koe0gwxAeg@public.gmane.org>
>     Cc: Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>     Cc: <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>     Cc: <linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>     [ paulmck: Removed drivers/dma/ioat/dma.c per Jason Gunthorpe's feedback. ]

Let me know if you want this patch to flow through the rdma tree..

Acked-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
