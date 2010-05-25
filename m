From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: nes: bug in phy_lock usage?
Date: Mon, 24 May 2010 21:32:28 -0700
Message-ID: <adask5gzjmr.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It seems that ce6e74f2 ("RDMA/nes: Make nesadapter->phy_lock usage
consistent") maybe introduced a locking bug.  sparse warns:

drivers/infiniband/hw/nes/nes_hw.c:2642:9: warning: context imbalance in 'nes_process_mac_intr' - different lock contexts for basic block

And indeed in nes_process_mac_intr(), you do

	spin_lock_irqsave(&nesadapter->phy_lock, flags);

at the very beginning, but then the unlock only happens inside

	if (nesadapter->mac_sw_state[mac_number] != NES_MAC_SW_IDLE) {

or inside

	if (mac_status & (NES_MAC_INT_LINK_STAT_CHG | NES_MAC_INT_XGMII_EXT)) {

so it seems it is possible to return from this function with the lock
held.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
