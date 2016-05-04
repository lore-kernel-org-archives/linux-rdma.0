From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 0/9] RDMA/iw_cxgb4: Fixes various cleanups during failures
Date: Thu,  5 May 2016 01:27:28 +0530
Message-ID: <1462391857-20939-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi

The patch series fixes all kinds of ep leaks, if there are any failures
during connection establishment process and during arp failures. Also get
rid of abort_connection() and make use of c4iw_ep_disconnect() so that we
can properly cleanup in case of abort failures. Move QP to error state in
case of fatal disconnect errors. Also takes care of resource cleanup if we
fail to send flowc.

This patch series has been created against Doug Ledford's linux tree and
includes patches on iw_cxgb4 driver.

We have included all the maintainers of respective drivers. Kindly review
the change and let us know in case of any review comments.

Thanks

Hariprasad Shenai (9):
  RDMA/iw_cxgb4: release ep resources on accept arp failure
  RDMA/iw_cxgb4: stop ep timer on close failure
  RDMA/iw_cxgb4: ensure eps don't get freed while the mutex is held
  RDMA/iw_cxgb4: remove connection abort from process_mpa_reply
  RDMA/iw_cxgb4: free resources when send_flowc() fails
  RDMA/iw_cxgb4: remove abort_connection() usage from accept/reject
  RDMA/iw_cxgb4: don't use abort_connection in process_mpa_request()
  RDMA/iw_cxgb4: move QP -> ERROR on fatal disconnect errors
  RDMA/iw_cxgb4: remove abort_connection() usage from ep_timeout()

 drivers/infiniband/hw/cxgb4/cm.c | 252 +++++++++++++++++++++++++++------------
 1 file changed, 175 insertions(+), 77 deletions(-)

-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
