From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH tip/core/rcu 16/21] drivers/infiniband: Remove
 now-redundant smp_read_barrier_depends()
Date: Fri, 1 Dec 2017 17:11:09 -0700
Message-ID: <20171202001109.GQ7754@ziepe.ca>
References: <20171201195053.GA23494@linux.vnet.ibm.com>
 <1512157876-24665-16-git-send-email-paulmck@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1512157876-24665-16-git-send-email-paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dipankar-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Henderson <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, Ivan Kokshaysky <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Cree <mcree-q3Ck4f9/EBK9koe0gwxAeg@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 01, 2017 at 11:51:11AM -0800, Paul E. McKenney wrote:
> The smp_read_barrier_depends() does nothing at all except on DEC Alpha,
> and no current DEC Alpha systems use Infiniband:
> 
> 	lkml.kernel.org/r/20171023085921.jwbntptn6ictbnvj@tower

I understand DEC Alpha has PCI, and we continue to support several
RDMA devices that used the PCI bus.

However, the hif1, rdma vt and qib drivers modified in this patch are
PCI-Express ONLY. So I think this idea is fine, but would revise the
commit message to focus on PCI-E not Infiniband.

>  drivers/dma/ioat/dma.c              | 2 --
>  drivers/infiniband/Kconfig          | 1 +

Did you mean to have ioat/dma.c in this patch?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
