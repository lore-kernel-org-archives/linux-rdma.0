From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/5] RXE fixes for 4.9
Date: Wed, 16 Nov 2016 10:39:13 +0200
Message-ID: <1479285558-19627-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below the RXE fixes for 4.9 from Yonatan and Moni.

This patchset was generated against v4.9-rc3.

Available in the "topic/rxe-fixes-4.9" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/rxe-fixes-4.9

Thanks

Yonatan Cohen (5):
  IB/rxe: Fix kernel panic in UDP tunnel with GRO and RX checksum
  IB/rxe: Fix handling of erroneous WR
  IB/rxe: Increase max number of completions to 32k
  IB/rxe: Clear queue buffer when modifying QP to reset
  IB/rxe: Update qp state for user query

 drivers/infiniband/sw/rxe/rxe_net.c   |  8 ++------
 drivers/infiniband/sw/rxe/rxe_param.h |  2 +-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  2 ++
 drivers/infiniband/sw/rxe/rxe_queue.c |  9 +++++++++
 drivers/infiniband/sw/rxe/rxe_queue.h |  2 ++
 drivers/infiniband/sw/rxe/rxe_req.c   | 21 +++++++++++++--------
 6 files changed, 29 insertions(+), 15 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
