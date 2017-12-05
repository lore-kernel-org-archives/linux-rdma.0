From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH tip/core/rcu 16/21] drivers/infiniband: Remove
 now-redundant smp_read_barrier_depends()
Date: Tue, 5 Dec 2017 12:06:14 -0800
Message-ID: <20171205200614.GQ7829@linux.vnet.ibm.com>
References: <20171201195053.GA23494@linux.vnet.ibm.com>
 <1512157876-24665-16-git-send-email-paulmck@linux.vnet.ibm.com>
 <20171202001109.GQ7754@ziepe.ca>
 <20171202010851.GL7829@linux.vnet.ibm.com>
 <20171205150832.GA27409@ziepe.ca>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171205150832.GA27409@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-kernel@vger.kernel.org, mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com, akpm@linux-foundation.org, mathieu.desnoyers@efficios.com, josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com, fweisbec@gmail.com, oleg@redhat.com, Doug Ledford <dledford@redhat.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Michael Cree <mcree@orcon.net.nz>, Andrea Parri <parri.andrea@gmail.com>, linux-rdma@vger.kernel.org, linux-alpha@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 05, 2017 at 08:08:32AM -0700, Jason Gunthorpe wrote:
> > commit c389c98ec5f4a7aa4c36853e89801eb5ea81870e
> > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Date:   Mon Nov 27 09:04:22 2017 -0800
> > 
> >     drivers/infiniband: Remove now-redundant smp_read_barrier_depends()
> >     
> >     The smp_read_barrier_depends() does nothing at all except on DEC Alpha,
> >     and no current DEC Alpha systems use Infiniband:
> >     
> >     	lkml.kernel.org/r/20171023085921.jwbntptn6ictbnvj@tower
> >     
> >     This commit therefore makes Infiniband depend on !ALPHA and removes
> >     the now-ineffective invocations of smp_read_barrier_depends() from
> >     the InfiniBand driver.
> >     
> >     Please note that this patch should not be construed as my saying that
> >     InfiniBand's memory ordering is correct, but rather that this patch does
> >     not in any way affect InfiniBand's correctness.  In other words, the
> >     result of applying this patch is bug-for-bug compatible with the original.
> >     
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >     Cc: Doug Ledford <dledford@redhat.com>
> >     Cc: Jason Gunthorpe <jgg@mellanox.com>
> >     Cc: Richard Henderson <rth@twiddle.net>
> >     Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> >     Cc: Matt Turner <mattst88@gmail.com>
> >     Cc: Michael Cree <mcree@orcon.net.nz>
> >     Cc: Andrea Parri <parri.andrea@gmail.com>
> >     Cc: <linux-rdma@vger.kernel.org>
> >     Cc: <linux-alpha@vger.kernel.org>
> >     [ paulmck: Removed drivers/dma/ioat/dma.c per Jason Gunthorpe's feedback. ]
> 
> Let me know if you want this patch to flow through the rdma tree..
> 
> Acked-by: Jason Gunthorpe <jgg@mellanox.com>

I applied your ack, thank you!

Your choice as to what tree it flows through.  By default, and if all
goes well, I will push this series through -rcu and -tip during the next
merge window.

							Thanx, Paul
