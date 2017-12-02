From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH tip/core/rcu 16/21] drivers/infiniband: Remove
 now-redundant smp_read_barrier_depends()
Date: Fri, 1 Dec 2017 17:08:51 -0800
Message-ID: <20171202010851.GL7829@linux.vnet.ibm.com>
References: <20171201195053.GA23494@linux.vnet.ibm.com>
 <1512157876-24665-16-git-send-email-paulmck@linux.vnet.ibm.com>
 <20171202001109.GQ7754@ziepe.ca>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-alpha-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171202001109.GQ7754@ziepe.ca>
Sender: linux-alpha-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com, akpm@linux-foundation.org, mathieu.desnoyers@efficios.com, josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com, fweisbec@gmail.com, oleg@redhat.com, Doug Ledford <dledford@redhat.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Michael Cree <mcree@orcon.net.nz>, Andrea Parri <parri.andrea@gmail.com>, linux-rdma@vger.kernel.org, linux-alpha@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 01, 2017 at 05:11:09PM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 01, 2017 at 11:51:11AM -0800, Paul E. McKenney wrote:
> > The smp_read_barrier_depends() does nothing at all except on DEC Alpha,
> > and no current DEC Alpha systems use Infiniband:
> > 
> > 	lkml.kernel.org/r/20171023085921.jwbntptn6ictbnvj@tower
> 
> I understand DEC Alpha has PCI, and we continue to support several
> RDMA devices that used the PCI bus.
> 
> However, the hif1, rdma vt and qib drivers modified in this patch are
> PCI-Express ONLY. So I think this idea is fine, but would revise the
> commit message to focus on PCI-E not Infiniband.

Hmmm...  It is not just the commit log, but also the Kconfig change.
I am not as worried as I might be about the few museum-piece DEC
Alpha systems suddenly sporting new RDMA PCI devices, but I am worried
about getting a more complex change right.

And if someone really does add a PCI RDMA device to their DEC Alpha,
and this patch causes them trouble, we can work out what to do about
it when and if that happens.

> >  drivers/dma/ioat/dma.c              | 2 --
> >  drivers/infiniband/Kconfig          | 1 +
> 
> Did you mean to have ioat/dma.c in this patch?

Indeed I did not, thank you for catching this!  Please see below for
updated ioat-free patch.

							Thanx, Paul

------------------------------------------------------------------------

commit c389c98ec5f4a7aa4c36853e89801eb5ea81870e
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon Nov 27 09:04:22 2017 -0800

    drivers/infiniband: Remove now-redundant smp_read_barrier_depends()
    
    The smp_read_barrier_depends() does nothing at all except on DEC Alpha,
    and no current DEC Alpha systems use Infiniband:
    
    	lkml.kernel.org/r/20171023085921.jwbntptn6ictbnvj@tower
    
    This commit therefore makes Infiniband depend on !ALPHA and removes
    the now-ineffective invocations of smp_read_barrier_depends() from
    the InfiniBand driver.
    
    Please note that this patch should not be construed as my saying that
    InfiniBand's memory ordering is correct, but rather that this patch does
    not in any way affect InfiniBand's correctness.  In other words, the
    result of applying this patch is bug-for-bug compatible with the original.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Doug Ledford <dledford@redhat.com>
    Cc: Jason Gunthorpe <jgg@mellanox.com>
    Cc: Richard Henderson <rth@twiddle.net>
    Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
    Cc: Matt Turner <mattst88@gmail.com>
    Cc: Michael Cree <mcree@orcon.net.nz>
    Cc: Andrea Parri <parri.andrea@gmail.com>
    Cc: <linux-rdma@vger.kernel.org>
    Cc: <linux-alpha@vger.kernel.org>
    [ paulmck: Removed drivers/dma/ioat/dma.c per Jason Gunthorpe's feedback. ]

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 98ac46ed7214..3bb6e35b0bbf 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -4,6 +4,7 @@ menuconfig INFINIBAND
 	depends on NET
 	depends on INET
 	depends on m || IPV6 != m
+	depends on !ALPHA
 	select IRQ_POLL
 	---help---
 	  Core support for InfiniBand (IB).  Make sure to also select
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index fd01a760259f..f527bcda4650 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -302,7 +302,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		smp_read_barrier_depends(); /* see post_one_send() */
 		if (qp->s_last == READ_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
@@ -346,7 +345,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		newreq = 0;
 		if (qp->s_cur == qp->s_tail) {
 			/* Check if send work queue is empty. */
-			smp_read_barrier_depends(); /* see post_one_send() */
 			if (qp->s_tail == READ_ONCE(qp->s_head)) {
 				clear_ahg(qp);
 				goto bail;
@@ -900,7 +898,6 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd,
 	}
 
 	/* Ensure s_rdma_ack_cnt changes are committed */
-	smp_read_barrier_depends();
 	if (qp->s_rdma_ack_cnt) {
 		hfi1_queue_rc_ack(qp, is_fecn);
 		return;
@@ -1562,7 +1559,6 @@ static void rc_rcv_resp(struct hfi1_packet *packet)
 	trace_hfi1_ack(qp, psn);
 
 	/* Ignore invalid responses. */
-	smp_read_barrier_depends(); /* see post_one_send */
 	if (cmp_psn(psn, READ_ONCE(qp->s_next_psn)) >= 0)
 		goto ack_done;
 
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 2c7fc6e331ea..13b994738f41 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -362,7 +362,6 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	sqp->s_flags |= RVT_S_BUSY;
 
 again:
-	smp_read_barrier_depends(); /* see post_one_send() */
 	if (sqp->s_last == READ_ONCE(sqp->s_head))
 		goto clr_busy;
 	wqe = rvt_get_swqe_ptr(sqp, sqp->s_last);
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 31c8f89b5fc8..61c130dbed10 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -553,7 +553,6 @@ static void sdma_hw_clean_up_task(unsigned long opaque)
 
 static inline struct sdma_txreq *get_txhead(struct sdma_engine *sde)
 {
-	smp_read_barrier_depends(); /* see sdma_update_tail() */
 	return sde->tx_ring[sde->tx_head & sde->sdma_mask];
 }
 
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index 991bbee04821..132b63e787d1 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -79,7 +79,6 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		smp_read_barrier_depends(); /* see post_one_send() */
 		if (qp->s_last == READ_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
@@ -119,7 +118,6 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		    RVT_PROCESS_NEXT_SEND_OK))
 			goto bail;
 		/* Check if send work queue is empty. */
-		smp_read_barrier_depends(); /* see post_one_send() */
 		if (qp->s_cur == READ_ONCE(qp->s_head)) {
 			clear_ahg(qp);
 			goto bail;
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index beb5091eccca..deb184574395 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -486,7 +486,6 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		smp_read_barrier_depends(); /* see post_one_send */
 		if (qp->s_last == READ_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
@@ -500,7 +499,6 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	}
 
 	/* see post_one_send() */
-	smp_read_barrier_depends();
 	if (qp->s_cur == READ_ONCE(qp->s_head))
 		goto bail;
 
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 8f5754fb8579..1a785c37ad0a 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -246,7 +246,6 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		smp_read_barrier_depends(); /* see post_one_send() */
 		if (qp->s_last == READ_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
@@ -293,7 +292,6 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 		newreq = 0;
 		if (qp->s_cur == qp->s_tail) {
 			/* Check if send work queue is empty. */
-			smp_read_barrier_depends(); /* see post_one_send() */
 			if (qp->s_tail == READ_ONCE(qp->s_head))
 				goto bail;
 			/*
@@ -1340,7 +1338,6 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 		goto ack_done;
 
 	/* Ignore invalid responses. */
-	smp_read_barrier_depends(); /* see post_one_send */
 	if (qib_cmp24(psn, READ_ONCE(qp->s_next_psn)) >= 0)
 		goto ack_done;
 
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 9a37e844d4c8..4662cc7bde92 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -367,7 +367,6 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 	sqp->s_flags |= RVT_S_BUSY;
 
 again:
-	smp_read_barrier_depends(); /* see post_one_send() */
 	if (sqp->s_last == READ_ONCE(sqp->s_head))
 		goto clr_busy;
 	wqe = rvt_get_swqe_ptr(sqp, sqp->s_last);
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index bddcc37ace44..70c58b88192c 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -60,7 +60,6 @@ int qib_make_uc_req(struct rvt_qp *qp, unsigned long *flags)
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		smp_read_barrier_depends(); /* see post_one_send() */
 		if (qp->s_last == READ_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
@@ -90,7 +89,6 @@ int qib_make_uc_req(struct rvt_qp *qp, unsigned long *flags)
 		    RVT_PROCESS_NEXT_SEND_OK))
 			goto bail;
 		/* Check if send work queue is empty. */
-		smp_read_barrier_depends(); /* see post_one_send() */
 		if (qp->s_cur == READ_ONCE(qp->s_head))
 			goto bail;
 		/*
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 15962ed193ce..386c3c4da0c7 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -252,7 +252,6 @@ int qib_make_ud_req(struct rvt_qp *qp, unsigned long *flags)
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		smp_read_barrier_depends(); /* see post_one_send */
 		if (qp->s_last == READ_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
@@ -266,7 +265,6 @@ int qib_make_ud_req(struct rvt_qp *qp, unsigned long *flags)
 	}
 
 	/* see post_one_send() */
-	smp_read_barrier_depends();
 	if (qp->s_cur == READ_ONCE(qp->s_head))
 		goto bail;
 
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 9177df60742a..eae84c216e2f 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1684,7 +1684,6 @@ static inline int rvt_qp_is_avail(
 	/* non-reserved operations */
 	if (likely(qp->s_avail))
 		return 0;
-	smp_read_barrier_depends(); /* see rc.c */
 	slast = READ_ONCE(qp->s_last);
 	if (qp->s_head >= slast)
 		avail = qp->s_size - (qp->s_head - slast);

