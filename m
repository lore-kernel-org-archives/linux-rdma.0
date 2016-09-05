From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/4] RXE fixes for 4.8
Date: Mon,  5 Sep 2016 15:09:15 +0300
Message-ID: <1473077359-11546-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find the following four patches from Yonatan which
fixes numerous issues in RXE code.

Thanks,

Yonatan Cohen (4):
  IB/rxe: Fix kernel panic in udp_setup_tunnel
  IB/rxe: Fix duplicate atomic request handling
  IB/rxe: Fix race condition between requester and completer
  IB/rxe: Fix kmem_cache leak

 drivers/infiniband/sw/rxe/rxe.c      | 14 +++++++--
 drivers/infiniband/sw/rxe/rxe_comp.c | 13 ++++++++
 drivers/infiniband/sw/rxe/rxe_net.c  | 45 ++++++++++++++++++----------
 drivers/infiniband/sw/rxe/rxe_net.h  |  3 +-
 drivers/infiniband/sw/rxe/rxe_req.c  | 57 ++++++++++++++++++++++++++++--------
 drivers/infiniband/sw/rxe/rxe_resp.c | 11 +++----
 6 files changed, 106 insertions(+), 37 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
