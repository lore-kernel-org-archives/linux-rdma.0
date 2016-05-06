From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 00/17] RDMA/iw_cxgb4: Misc. fixes and enhancements for iw_cxgb4
Date: Fri,  6 May 2016 22:17:53 +0530
Message-ID: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi

This patch series corrects the RFC number of MPA, fixes endpoint leaks in
lot of failure paths, adds code to handle return values for c4iw_ofld_send,
c4iw_l2t_send and process_mpa_reply. Adds code to lookup and reference the
endpoints atomically. Some fixes related to endpoint timer during MPA
negotiation. Pass correct FID value in DSGL command.

This patch series has been created against Doug Ledford's linux tree and
includes patches on iw_cxgb4 driver.

We have included all the maintainers of respective drivers. Kindly review
the change and let us know in case of any review comments.

Thanks

Hariprasad Shenai (17):
  RDMA/iw_cxgb4: Add few history bits for ep
  RDMA/iw_cxgb4: Correct RFC number of MPA
  RDMA/iw_cxgb4: set the correct FID value in DSGL commands
  RDMA/iw_cxgb4: parent_ep has to be dereferenced in case of passive
    accept failure
  RDMA/iw_cxgb4: Do not stop timer in case of incomplete messages
  RDMA/iw_cxgb4: stop_ep_timer() after MPA negotiation
  RDMA/iw_cxgb4: handle return value of c4iw_l2t_send() and
    send_mpa_req()
  RDMA/iw_cxgb4: in process_timeout() don't move ep state to ABORTING
  RDMA/iw_cxgb4: Handle return value of c4iw_ofld_send() in
    abort_arp_failure()
  RDMA/iw_cxgb4: atomically lookup ep and get a reference
  RDMA/iw_cxgb4: Free skb in case of arp failure in _c4iw_free_ep()
  RDMA/iw_cxgb4: Release ep for for FPDU_MODE and MPA_REQ_RCVD in
    process_timeout
  RDMA/iw_cxgb4: Handle ULP accept/reject during ABORTING
  RDMA/iw_cxgb4: atomic find and reference for listening endpoints
  RDMA/iw_cxgb4: Handle ret value of process_mpa_reply() in rx_data
  RDMA/iw_cxgb4: Always wake up waiter in c4iw_peer_abort_intr()
  RDMA/iw_cxgb4: Add arp failure handlers to send_mpa_reply/reject()

 drivers/infiniband/hw/cxgb4/cm.c            | 371 ++++++++++++++++++----------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |   9 +-
 drivers/infiniband/hw/cxgb4/mem.c           |   5 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |   4 +
 4 files changed, 257 insertions(+), 132 deletions(-)

-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
