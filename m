From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 00/15] IB/rxe patches for kernel v4.11
Date: Tue, 10 Jan 2017 11:15:39 -0800
Message-ID: <20170110191554.17359-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Doug,

The patches in this series are what I came up with by reviewing and testing
the rdma_rxe driver. Please consider these patches for kernel v4.11. The
changes compared with v1 of this patch series are:
- Modified patch 4 such that an unused argument is removed from get_mtu().
- Introduced the "notify" argument in patch 11 instead of patch 10.
- Modified patch 11 such that the comment that refers to the IBA spec is
  preserved instead of removed.

Thanks,

Bart.

Bart Van Assche (15):
  IB/rxe: Suppress sparse warnings
  IB/rxe: Constify the pool name
  IB/rxe: Remove an unused function
  IB/rxe: Remove an unused variable and an unused argument
  IB/rxe: Remove superfluous casts
  IB/rxe: Enable type checking on SKB_TO_PKT() and PKT_TO_SKB()
    arguments
  IB/rxe: Let the compiler check the type of the cleanup functions
  IB/rxe: Issue warnings once
  IB/rxe: Add a runtime check in alloc_index()
  IB/rxe: Introduce functions for queue draining
  IB/rxe: Generate a completion for all failed work requests
  IB/rxe: Fix a MR reference leak in check_rkey()
  IB/rxe: Fix reference leaks in memory key invalidation code
  IB/rxe: Remove a pointless indirection layer
  IB/rxe: Fix an skb leak

 drivers/infiniband/sw/rxe/rxe.c       |  2 +-
 drivers/infiniband/sw/rxe/rxe_comp.c  | 91 ++++++++++++++++++-----------------
 drivers/infiniband/sw/rxe/rxe_cq.c    |  4 +-
 drivers/infiniband/sw/rxe/rxe_hdr.h   | 12 ++++-
 drivers/infiniband/sw/rxe/rxe_loc.h   | 29 ++++++++---
 drivers/infiniband/sw/rxe/rxe_mcast.c |  8 +--
 drivers/infiniband/sw/rxe/rxe_mr.c    | 10 ++--
 drivers/infiniband/sw/rxe/rxe_net.c   | 51 +++++++-------------
 drivers/infiniband/sw/rxe/rxe_pool.c  | 14 ++----
 drivers/infiniband/sw/rxe/rxe_pool.h  |  8 +--
 drivers/infiniband/sw/rxe/rxe_qp.c    |  4 +-
 drivers/infiniband/sw/rxe/rxe_recv.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_req.c   | 34 +++++--------
 drivers/infiniband/sw/rxe/rxe_resp.c  | 64 ++++++++++++------------
 drivers/infiniband/sw/rxe/rxe_verbs.c | 10 ++--
 drivers/infiniband/sw/rxe/rxe_verbs.h | 24 +--------
 16 files changed, 174 insertions(+), 193 deletions(-)

-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
