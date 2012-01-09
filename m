From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IPoIB/cm: Add connected mode support for devices without SRQs
Date: Mon, 9 Jan 2012 14:58:40 +0300
Message-ID: <20120109115840.GA12634@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Pradeep Satyanarayana,

This is a semi-automatic email about new static checker warnings.

The patch 68e995a29572: "IPoIB/cm: Add connected mode support for 
devices without SRQs" from Jan 25, 2008, leads to the following 
Smatch complaint:

drivers/infiniband/ulp/ipoib/ipoib_cm.c +684 ipoib_cm_handle_rx_wc()
	 error: we previously assumed 'p' could be null (see line 611)

drivers/infiniband/ulp/ipoib/ipoib_cm.c
   610		if (unlikely(!(wr_id & IPOIB_CM_RX_UPDATE_MASK))) {
   611			if (p && time_after_eq(jiffies, p->jiffies + IPOIB_CM_RX_UPDATE_TIME)) {
                            ^
Old check.  This was added in d6ef7d68 to fix a NULL deref that people
were hitting in production but the code has been rewritten since then
and I don't know if the check is still needed.

   612				spin_lock_irqsave(&priv->lock, flags);
   613				p->jiffies = jiffies;
   614				/* Move this entry to list head, but do not re-add it
   615				 * if it has been moved out of list. */
   616				if (p->state == IPOIB_CM_RX_LIVE)
   617					list_move(&p->list, &priv->cm.passive_ids);
   618				spin_unlock_irqrestore(&priv->lock, flags);
   619			}
   620		}
   621	
   622		if (wc->byte_len < IPOIB_CM_COPYBREAK) {

[snipped]

   674	repost:
   675		if (has_srq) {
   676			if (unlikely(ipoib_cm_post_receive_srq(dev, wr_id)))
   677				ipoib_warn(priv, "ipoib_cm_post_receive_srq failed "
   678					   "for buf %d\n", wr_id);
   679		} else {
   680			if (unlikely(ipoib_cm_post_receive_nonsrq(dev, p,
   681								  &priv->cm.rx_wr,
   682								  priv->cm.rx_sge,
   683								  wr_id))) {
   684				--p->recv_count;
                                  ^^^
New dereference.

   685				ipoib_warn(priv, "ipoib_cm_post_receive_nonsrq failed "
   686					   "for buf %d\n", wr_id);

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
