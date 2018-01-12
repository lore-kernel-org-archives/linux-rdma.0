From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 0/2] Two additional RDMA/rxe fixes
Date: Fri, 12 Jan 2018 15:11:57 -0800
Message-ID: <20180112231159.26569-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Jason,

This patch series provides two additional fixes for issues I ran into while
testing the RDMA/CM support in the SRP initiator driver. Please consider these
for inclusion in the upstream kernel.

Thanks,

Bart.

Bart Van Assche (2):
  RDMA/rxe: Fix a race condition in rxe_requester()
  RDMA/rxe: Fix rxe_qp_cleanup()

 drivers/infiniband/sw/rxe/rxe_loc.h   |  1 -
 drivers/infiniband/sw/rxe/rxe_qp.c    | 12 ++++++++++--
 drivers/infiniband/sw/rxe/rxe_req.c   |  9 +--------
 drivers/infiniband/sw/rxe/rxe_resp.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h |  3 +++
 5 files changed, 15 insertions(+), 12 deletions(-)

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
