From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: MLX4 Cq Question
Date: Mon, 20 May 2013 17:53:10 +0300
Message-ID: <201305201753.10806.jackm@dev.mellanox.co.il>
References: <51968438.7070907@opengridcomputing.com> <CAG4TOxNi0PxxskqXgxRhMPG0bmr+sS-x0_RG-zKyvLW1LNzoBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxNi0PxxskqXgxRhMPG0bmr+sS-x0_RG-zKyvLW1LNzoBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Saturday 18 May 2013 00:37, Roland Dreier wrote:
> On Fri, May 17, 2013 at 12:25 PM, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> > I'm looking at the Linux MLX4 net driver and found something that confuses me mightily. In particular in the file net/ethernet/mellanox/mlx4/cq.c, the mlx4_ib_completion function does not take any kind of lock when looking up the SW CQ in the radix tree, however, the mlx4_cq_event function does. In addition if I go look at the code paths where cq are removed from this tree, they are protected by spin_lock_irq. So I am baffled at this point as to what the locking strategy is and how this is supposed to work. I'm sure I'm missing something and would greatly appreciate it if someone would explain this.
> 
> This is a bit tricky.  If you look at
> 
> void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq)
> {
>         struct mlx4_priv *priv = mlx4_priv(dev);
>         struct mlx4_cq_table *cq_table = &priv->cq_table;
>         int err;
> 
>         err = mlx4_HW2SW_CQ(dev, NULL, cq->cqn);
>         if (err)
>                 mlx4_warn(dev, "HW2SW_CQ failed (%d) for CQN %06x\n",
> err, cq->cqn);
> 
>         synchronize_irq(priv->eq_table.eq[cq->vector].irq);
> 
>         spin_lock_irq(&cq_table->lock);
>         radix_tree_delete(&cq_table->tree, cq->cqn);
>         spin_unlock_irq(&cq_table->lock);
> 
>         if (atomic_dec_and_test(&cq->refcount))
>                 complete(&cq->free);
>         wait_for_completion(&cq->free);
> 
>         mlx4_cq_free_icm(dev, cq->cqn);
> }
> 
> you see that when freeing a CQ, we first do the HW2SW_CQ firmware
> command; once this command completes, no more events will be generated
> for that CQ.  Then we do synchronize_irq for the CQ's interrupt
> vector.  Once that completes, no more completion handlers will be
> running for the CQ, so we can safely delete the CQ from the radix tree
> (relying on the radix tree's safety of deleting one entry while
> possibly looking up other entries, so no lock is needed).  We also use
> the lock to synchronize against the CQ event function, which as you
> noted does take the lock too.
> 
> Basic idea is that we're tricky and careful so we can make the fast
> path (completion interrupt handling) lock-free, but then use locks and
> whatever else needed in the slow path (CQ async event handling, CQ
> destroy).
> 
>  - R.
=======================================================

Roland, unfortunately we have seen that we need some locking on the
cq completion handler (there is a stack trace which resulted from this
lack of proper locking).
In our current driver, we are using the patch below (which uses RCU locking
instead of spinlocks).  I can prepare a proper patch for the upstream kernel.

===================================================
net/mlx4_core: Fix racy flow in the driver CQ completion handler

The mlx4 CQ completion handler, mlx4_cq_completion, doesn't bother to lock
the radix tree which is used to manage the table of CQs, nor does it increase
the reference count of the CQ before invoking the user provided callback
(and decrease it afterwards).

This is racy and can cause use-after-free, null pointer dereference, etc, which
result in kernel crashes.

To fix this, we must do the following in mlx4_cq_completion:
- increase the ref count on the cq before invoking the user callback, and
  decrement it after the callback.
- Place a lock around the radix tree lookup/ref-count-increase

Using an irq spinlock will not fix this issue. The problem is that under VPI,
the ETH interface uses multiple msix irq's, which can result in one cq completion
event interrupting another in-progress cq completion event. A deadlock results
when the handler for the first cq completion grabs the spinlock, and is
interrupted by the second completion before it has a chance to release the spinlock.
The handler for the second completion will deadlock waiting for the spinlock
to be released.

The proper fix is to use the RCU mechanism for locking radix-tree accesses in
the cq completion event handler (The radix-tree implementation uses the RCU
mechanism, so rcu_read_lock/unlock in the reader, with rcu_synchronize in the
updater, will do the job).

Note that the same issue exists in mlx4_cq_event() (the cq async event
handler), which also takes the same lock on the radix tree. Here, we replace the
spinlock with an rcu_read_lock().

This patch was motivated by the following report from the field:

"[...] box panic'ed when trying to find a completion queue. There is
no corruption but there is a possible race which could result in
mlx4_cq_completion getting wrong height of the radix tree and
following a bit too deep into the chains. In the other code which uses
this radix tree the access is protected by the lock but
mlx4_cq_completion is running in the interrupt context and cannot
take locks, so instead it runs without any protection whatsoever."

The stack trace below is from the mlnx ofed 1.5.3 driver running under RHEL5.7.
(this driver uses the upstream kernel mlx4_cq_completion() code)

PID: 8178   TASK: ffff810b91a52400  CPU: 11  COMMAND: "universal_consu"

[exception RIP: radix_tree_lookup+38]
RIP: ffffffff8016405f  RSP: ffff81182fe3be90  RFLAGS: 00210002
RAX: 6b6b6b6b6b6b6b8b  RBX: ffff810c2fb90000  RCX: 0000000000000006
RDX: 0000000000000001  RSI: 00000000000000c0  RDI: 6b6b6b6b6b6b6b6b
RBP: 00000000000000c0   R8: 0000000000010000   R9: 000000000920ea94
R10: 00000000000000b3  R11: ffffffff800c7ea5  R12: 00000000000000b3
R13: ffff810c2b15a280  R14: ffff810b7a98ff58  R15: 0000000000000000
ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0000

*** <IRQ stack> ***

RIP: 00000000f5cd8859  RSP: 00000000f3eafa28  RFLAGS: 00200202
RAX: 0000000000000000  RBX: 00000000f3eafaf8  RCX: 000000000b6d4f00
RDX: 000000000000001c  RSI: 000000000000001c  RDI: 0000000000000000
RBP: ffff810bf1a0a120   R8: 0000000000000000   R9: 0000000000000000
R10: 0000000000000000  R11: 0000000000000000  R12: 0000000000000001
R13: 0000000000000000  R14: ffff810b9e7d5bf0  R15: 0000000000000000
ORIG_RAX: ffffffffffffff4c  CS: 0023  SS: 002b

The original patch  was generated by Yishai Hadas,
and reviewed by Or Gerlitz and Jack Morgenstein.  A subsequent fix
by Jack Morgenstein was reviewed by Eli Cohen.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/cq.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index ff91904..0e28258 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -57,8 +57,13 @@ void mlx4_cq_completion(struct mlx4_dev *dev, u32 cqn)
 {
 	struct mlx4_cq *cq;
 
+	rcu_read_lock();
 	cq = radix_tree_lookup(&mlx4_priv(dev)->cq_table.tree,
 			       cqn & (dev->caps.num_cqs - 1));
+	if (cq)
+		atomic_inc(&cq->refcount);
+	rcu_read_unlock();
+
 	if (!cq) {
 		mlx4_dbg(dev, "Completion event for bogus CQ %08x\n", cqn);
 		return;
@@ -67,6 +72,9 @@ void mlx4_cq_completion(struct mlx4_dev *dev, u32 cqn)
 	++cq->arm_sn;
 
 	cq->comp(cq);
+
+	if (atomic_dec_and_test(&cq->refcount))
+		complete(&cq->free);
 }
 
 void mlx4_cq_event(struct mlx4_dev *dev, u32 cqn, int event_type)
@@ -74,13 +82,13 @@ void mlx4_cq_event(struct mlx4_dev *dev, u32 cqn, int event_type)
 	struct mlx4_cq_table *cq_table = &mlx4_priv(dev)->cq_table;
 	struct mlx4_cq *cq;
 
-	spin_lock(&cq_table->lock);
+	rcu_read_lock();
 
 	cq = radix_tree_lookup(&cq_table->tree, cqn & (dev->caps.num_cqs - 1));
 	if (cq)
 		atomic_inc(&cq->refcount);
 
-	spin_unlock(&cq_table->lock);
+	rcu_read_unlock();
 
 	if (!cq) {
 		mlx4_warn(dev, "Async event for bogus CQ %08x\n", cqn);
@@ -328,6 +336,7 @@ err_radix:
 	spin_lock_irq(&cq_table->lock);
 	radix_tree_delete(&cq_table->tree, cq->cqn);
 	spin_unlock_irq(&cq_table->lock);
+	synchronize_rcu();
 
 err_icm:
 	mlx4_cq_free_icm(dev, cq->cqn);
@@ -351,6 +360,7 @@ void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq)
 	spin_lock_irq(&cq_table->lock);
 	radix_tree_delete(&cq_table->tree, cq->cqn);
 	spin_unlock_irq(&cq_table->lock);
+	synchronize_rcu();
 
 	if (atomic_dec_and_test(&cq->refcount))
 		complete(&cq->free);
-- 
1.7.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
