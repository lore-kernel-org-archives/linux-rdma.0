From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: MLX4 Cq Question
Date: Fri, 17 May 2013 14:37:57 -0700
Message-ID: <CAG4TOxNi0PxxskqXgxRhMPG0bmr+sS-x0_RG-zKyvLW1LNzoBg@mail.gmail.com>
References: <51968438.7070907@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51968438.7070907-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 17, 2013 at 12:25 PM, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> I'm looking at the Linux MLX4 net driver and found something that confuses me mightily. In particular in the file net/ethernet/mellanox/mlx4/cq.c, the mlx4_ib_completion function does not take any kind of lock when looking up the SW CQ in the radix tree, however, the mlx4_cq_event function does. In addition if I go look at the code paths where cq are removed from this tree, they are protected by spin_lock_irq. So I am baffled at this point as to what the locking strategy is and how this is supposed to work. I'm sure I'm missing something and would greatly appreciate it if someone would explain this.

This is a bit tricky.  If you look at

void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq)
{
        struct mlx4_priv *priv = mlx4_priv(dev);
        struct mlx4_cq_table *cq_table = &priv->cq_table;
        int err;

        err = mlx4_HW2SW_CQ(dev, NULL, cq->cqn);
        if (err)
                mlx4_warn(dev, "HW2SW_CQ failed (%d) for CQN %06x\n",
err, cq->cqn);

        synchronize_irq(priv->eq_table.eq[cq->vector].irq);

        spin_lock_irq(&cq_table->lock);
        radix_tree_delete(&cq_table->tree, cq->cqn);
        spin_unlock_irq(&cq_table->lock);

        if (atomic_dec_and_test(&cq->refcount))
                complete(&cq->free);
        wait_for_completion(&cq->free);

        mlx4_cq_free_icm(dev, cq->cqn);
}

you see that when freeing a CQ, we first do the HW2SW_CQ firmware
command; once this command completes, no more events will be generated
for that CQ.  Then we do synchronize_irq for the CQ's interrupt
vector.  Once that completes, no more completion handlers will be
running for the CQ, so we can safely delete the CQ from the radix tree
(relying on the radix tree's safety of deleting one entry while
possibly looking up other entries, so no lock is needed).  We also use
the lock to synchronize against the CQ event function, which as you
noted does take the lock too.

Basic idea is that we're tricky and careful so we can make the fast
path (completion interrupt handling) lock-free, but then use locks and
whatever else needed in the slow path (CQ async event handling, CQ
destroy).

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
