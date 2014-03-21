From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/8] Mem leak, locking and other misc. fixes for iw_cxgb4
Date: Fri, 21 Mar 2014 20:40:29 +0530
Message-ID: <1395414637-8298-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

This patch series provides fixes related to memory leak, one fix related to
locking and other miscelleneous fixes for Chelsio T4/T5 adapters on iw_cxgb4.

The patches series is created against 'infiniband' tree, 'for-next' branch.
And includes patches on iw_cxgb4 driver. 

These patches were part of a bigger patch-series posted initially on netdev:
https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg19052.html
Based on suggestion from David Miller, we have split above patch-series into
several smaller patch-series.
This is second of the smaller patch-series on iw-cxgb4.

Since this patch-series contains purely iw_cxgb4 patches, we would like to
request this patch series to get merged via Roland's 'infiniband' tree.

We have included all the maintainers of respective drivers. Kindly review the
change and let us know in case of any review comments.

Thanks

Steve Wise (8):
  iw_cxgb4: don't leak skb in c4iw_uld_rx_handler()
  iw_cxgb4: fix possible memory leak in RX_PKT processing
  iw_cxgb4: ignore read reponse type 1 CQEs
  iw_cxgb4: connect_request_upcall fixes
  iw_cxgb4: update snd_seq when sending MPA messages
  iw_cxgb4: lock around accept/reject downcalls
  iw_cxgb4: drop RX_DATA packets if the endpoint is gone
  iw_cxgb4: rx_data() needs to hold the ep mutex

 drivers/infiniband/hw/cxgb4/cm.c     | 101 +++++++++++++++++++++++------------
 drivers/infiniband/hw/cxgb4/cq.c     |  24 +++++++--
 drivers/infiniband/hw/cxgb4/device.c |   6 ++-
 3 files changed, 91 insertions(+), 40 deletions(-)

-- 
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
