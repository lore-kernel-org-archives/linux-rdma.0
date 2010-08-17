From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 0/1] IB/ipoib: fix dangling pointer references to
	ipoib_neigh and ipoib_path
Date: Tue, 17 Aug 2010 13:36:19 -0700
Message-ID: <20100817203619.22174.62871.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hopefully, this is the last update needed to this patch and
it can be applied. It has been in use within QLogic for several months
without problems.

Changes from v4 to v5:

Removed the "break;" in ipoib_cm_flush_path() so now the function
comment matches the code.

Updated the error case code in ipoib_cm_tx_start() so the address
handle and cached GID are reset so the next call to ipoib_start_xmit()
will create a new CM connection.

Added netif_tx_lock_bh() in ipoib_neigh_cleanup()
in order to call ipoib_cm_destroy_tx().
I don't think it is strictly needed, I'm just being paranoid and I
don't think it is a performance path when deleting struct neighbour.

=================
These are my notes on the IPoIB locking and what I figured out
in the process of creating the patch that follows.

IPoIB connected mode uses a separate QP for transmit and receive.
I will only talk about the transmit side although the some of the
data structures are used by both.

The executive summary for locking is that most things are protected
by the struct ipoib_dev_priv.lock. The network device lock,
netif_tx_lock(), netif_tx_lock_bh(), or stopping network output via
netif_stop_queue() is used to prevent ipoib_start_xmit() and
ipoib_cm_send() from being called which can access struct ipoib_neigh
and struct ipoib_cm_tx without holding locks.

struct sk_buff {
  // This pointer may hold a reference (see SKB_DST_NOREF).
  // IPoIB doesn't change this pointer so the locking rules aren't important.
  unsigned long _skb_refdst;
}

struct dst_entry {
  // The neighbour pointer holds a reference.
  // IPoIB doesn't change this pointer so the locking rules aren't important.
  struct neighbour *neighbour;

  atomic_t refcnt;
}

struct neighbour {
  // stores the IPoIB "hardware" address:
  // (control flags (one byte), QPN (3 bytes), destination GID (16 bytes),
  // padding (0 or 4 bytes), and a pointer to struct ipoib_neigh (4 or 8 bytes)
  // which is not reference counted.
  // It is protected by calling netif_tx_lock(dev) or netif_stop_queue(dev).
  // The Linux network stack can free the ipoib_neigh pointer by calling
  // ipoib_neigh_cleanup()
  uchar ha[];

  struct neigh_ops *ops;
  atomic_t refcnt;
}

struct ipoib_neigh {
  // This is protected by priv->lock and *does not* hold a reference
  struct neighbour *neighbour; // back pointer to containing struct

  // This is protected by priv->lock although it is accessed w/o
  // holding the priv->lock in ipoib_start_xmit() which means that
  // to clear the pointer, ipoib_start_xmit() has to be prevented from
  // being called if there is a chance that
  // "to_ipoib_neigh(skb_dst(skb)->neighbour)" could point to this struct.
  struct ipoib_cm_tx *cm;

  // This is protected by priv->lock and holds a reference
  struct ipoib_ah *ah;

  // Link for path->neigh_list or mcast->neigh_list.
  // This is protected by priv->lock.
  struct list_head list;
}

struct ipoib_cm_tx {
  // This is protected by priv->lock.
  struct ipoib_neigh *neigh;
}

struct ipoib_path {
  struct ib_sa_query *query; // non-NULL if SA path record query is pending

  // This is protected by priv->lock and holds a reference
  struct ipoib_ah *ah;

  struct completion   done;  // True if query is finished

  // list of all struct ipoib_neigh.list with the same ah pointer
  struct list_head neigh_list;
}

struct ipoib_dev_priv {
  // This lock protects a number of things associated with this
  // IPoIB network device.
  spinlock_t lock;

  // Contains the struct ipoib_mcast nodes indexed by MGID.
  // It is protected by priv->lock.
  struct rb_root multicast_tree;
}


Before any nodes can send IPoIB packets, the SA creates the
"all HCA multicast group GID" which encodes <flag>, <scope>,
<IPv4/IPv6>, <pkey>.  For example, transient, link local scope, IPv4,
pkey of 0x8001, limited broadcast address we have:
FF12:401B:8001::FFFF:FFFF, in compressed format.
The group also has a P_Key, Q_Key, and MTU associated with it in the SA
path record.
This multicast group is used for IPv4 address resolution (ARP).
The group is joined when the IPoIB device is brought up and the details
saved in priv->broadcast.

The transmit process starts with the Linux networking code calling
netif_tx_lock(dev) and then calling:

ipoib_hard_header()
  // This prepends the "hardware address" onto the sk_buff header if
  // the neighbor address hasn't been set in the sk_buff.

ipoib_start_xmit(skb, dev)
  // The first time through, skb_dst(skb)->neighbour won't be set and
  // ipoib_hard_header() will have prepended the IPv4 broadcast
  // "hardware address" which we strip off and call the following.
  ipoib_mcast_send(dev, mgid, skb)
    spin_lock_irqsave(&priv->lock, flags)
    // Search for the mgid and create an entry if not found.
    mcast = __ipoib_mcast_find(dev, mgid)
    // Since mgid is probably the "all HCA multicast group GID" which
    // was initialized when the network interface was started, we call:
    spin_unlock_irqrestore(&priv->lock, flags)
    // XXX bug? using mcast->ah after unlock w/o incref on ah?
    ipoib_send(dev, skb, mcast->ah, IB_MULTICAST_QPN)

// Eventually, we get an ARP reply, the struct neighbour.ha[] is filled
// in with the destination's "hardware address" and ipoib_start_xmit()
// is called again:
ipoib_start_xmit(skb, dev)
  // This time, if (likely(skb_dst(skb) && skb_dst(skb)->neighbour)) is true
  neigh = *to_ipoib_neigh(skb_dst(skb)->neighbour)
  // neigh is NULL so we allocate a struct ipoib_neigh:
  neigh = neigh_alloc(skb_dst(skb)->neighbour, skb->dev)
  path_lookup(skb, dev, neigh)
    // Assume it is a unicast address
    neigh_add_path(skb, dev, neigh)
      spin_lock_irqsave(&priv->lock, flags)
      // Find or allocate a path record entry
      path = __path_find(dev, n->ha + 4)
      if (!path)
        path = path_rec_create(dev, n->ha + 4)
      // path->ah will be NULL the first time through so:
      path_rec_start(dev, path)
        // Start the path record lookup process.
        // When it is finished, path_rec_completion() will be called.
      spin_unlock_irqrestore(&priv->lock, flags)

// Eventually, path_rec_completion() will be called when the SA replies.
path_rec_completion()
  // Create address handle from the reply
  ah = ipoib_create_ah()
  spin_lock_irqsave(&priv->lock, flags)
  // for each ipoib_neigh in path->neigh_list
    // set neigh->ah
    // create connected mode QP if enabled
    ipoib_cm_set(neigh, ipoib_cm_create_tx())
      // Allocate a struct ipoib_cm_tx.
      tx = kzalloc()
      // Add it to the list of structs waiting to be processed.
      list_add(&tx->list, &priv->cm.start_list)
      // At this point, tx->neigh != NULL so ipoib_cm_destroy_tx(tx)
      // will have an effect.
      // Schedule ipoib_cm_tx_start() to be called by work thread
      queue_work(ipoib_workqueue, &priv->cm.start_task)
  // Mark path as "done" doing the SA path record query process
  path->query = NULL
  complete(&path->done)
  spin_unlock_irqrestore(&priv->lock, flags)
  // Requeue waiting skbs if any
  while ((skb = __skb_dequeue(&skqueue)))
    dev_queue_xmit(skb)

// Some time later, ipoib_cm_tx_start() is called from the workqueue thread
ipoib_cm_tx_start()
  // netif_tx_lock_bh() is needed because we may set neigh->cm = NULL
  netif_tx_lock_bh(dev)
  spin_lock_irqsave(&priv->lock, flags)
  while (!list_empty(&priv->cm.start_list))
    // Remove tx from priv->cm.start_list
    list_del_init(&p->list)
    // Save the QPN and path record (destination address)
    spin_unlock_irqrestore(&priv->lock, flags)
    netif_tx_unlock_bh(dev)
    ipoib_cm_tx_init()
      // Create and initialize QP
      p->qp = ipoib_cm_create_tx_qp()
      // Create CM state
      ib_create_cm_id(ipoib_cm_tx_handler)
      // Call CM to start the process of establishing the RC QP connection
      ipoib_cm_send_req()
    netif_tx_lock_bh(dev)
    spin_lock_irqsave(&priv->lock, flags)
    // We need the lock to check p->neigh in case ipoib_cm_destroy_tx()
    // was called but can't call ipoib_cm_tx_destroy() w/ the lock held so
    // put it on the priv->reap_list if there was an error.
  spin_unlock_irqrestore(&priv->lock, flags)
  netif_tx_unlock_bh(dev)

// Eventually, CM calls ipoib_cm_tx_handler to say what parameters to
// use to modify the QP to RTS
ipoib_cm_tx_handler()
  ipoib_cm_rep_handler()
    // Use CM parameters to complete RC QP initialization
    ib_modify_qp()
    // This allows ipoib_start_xmit() to call ipoib_cm_send()
    set_bit(IPOIB_FLAG_OPER_UP, &p->flags)
    // XXX Hmm, race between ipoib_start_xmit() setting UP flag and
    // then getting the priv lock to queue the skb if UP wasn't set.
  

// Requeued skb will call:
ipoib_start_xmit(skb, dev)
  // This time all the checks pass so we call:
  ipoib_cm_send()
    post_send()
      ib_post_send()

// Some time later, we get a send completion
ipoib_cm_handle_tx_wc()
  // Note that the completion contains a pointer to the QP
  // which contains a pointer to the struct ipoib_cm_tx.
  // This means that when destroying a RC QP, we need to wait for completions
  // to drain before calling kfree(tx). See ipoib_cm_tx_destroy().
  struct ipoib_cm_tx *tx = wc->qp->qp_context;
  ib_dma_unmap_single()
  dev_kfree_skb_any()
  // We lock the network device transmit since ipoib_cm_destroy_tx()
  // might be called and change neigh->cm = NULL.
  // Also, it protects tx->tx_tail, tx->tx_head, and ipoib_cm_send().
  netif_tx_lock(dev)
  if wc error
    spin_lock_irqsave(&priv->lock, flags)
    // This prevents ipoib_cm_send(tx) from being called.
    // XXX not really needed since we hold the netif_tx_lock() and
    // will clear neigh->cm.
    clear_bit(IPOIB_FLAG_OPER_UP, &tx->flags)
    ipoib_cm_destroy_tx(tx)
      // Since there can be many error completions queued,
      // tx->neigh != NULL means this is the first time this tx is being
      // destroyed
      struct ipoib_neigh *neigh = tx->neigh
      if (!neigh) return;
      neigh->cm = NULL;
      tx->neigh = NULL;
      // if ipoib_cm_tx_start() is not actively using this tx,
      // put on tx reap list
    spin_unlock_irqrestore(&priv->lock, flags)
  netif_tx_unlock(dev)

// This is called by the workqueue to reap struct ipoib_cm_tx
ipoib_cm_tx_reap()
  // This protects struct ipoib_cm_tx
  netif_tx_lock_bh(dev);
  spin_lock_irqsave(&priv->lock, flags);
  while (!list_empty(&priv->cm.reap_list))
    // remove from list, unlock
    ipoib_cm_tx_destroy(p)
      if (p->id) ib_destroy_cm_id(p->id);
      // wait for all competions
      if (p->qp) ib_destroy_qp(p->qp);
      vfree(p->tx_ring);
      kfree(p);
    // lock
  spin_unlock_irqrestore(&priv->lock, flags);
  netif_tx_unlock_bh(dev);

// ipoib_flush_paths() is called when bringing the network interface down,
// or when changing between connected<->datagram modes.
ipoib_flush_paths()
  // This protects priv->path_tree from ipoib_start_xmit()
  netif_tx_lock_bh(dev);
  spin_lock_irqsave(&priv->lock, flags);
  // remove path from lookup table, add to remove_list
  list_for_each_entry_safe(path, tp, &remove_list, list)
    // Cancel any outstanding SA path query for this path
    // unlock and wait for SA query completion
    wait_for_completion(&path->done)
    path_free(path)
      foreach neigh in path->neigh_list
        ipoib_neigh_flush(neigh)
          // lock to protect against ipoib_start_xmit()
          // return struct ipoib_neigh back to initial state
          // unlock
      kfree(path)
    // lock
  spin_unlock_irqrestore(&priv->lock, flags);
  netif_tx_unlock_bh(dev);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
