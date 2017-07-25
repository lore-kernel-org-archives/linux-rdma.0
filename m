From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 0/7] IB/rxe: Bug fixes
Date: Tue, 25 Jul 2017 09:39:21 -0400
Message-ID: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, allen.hubbe-8PEkshWhKlo@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set addresses a few issues which we have found in RXE.
The first patch fixes a serious issue that causes kernel panics during
network congestion.

Andrew Boyer (7):
  IB/rxe: Move refcounting earlier in rxe_send()
  IB/rxe: Disable completion upcalls when a CQ is destroyed
  IB/rxe: Remove dangling prototype
  IB/rxe: Fix up the responder's find_resources() function
  IB/rxe: Fix destination cache for IPv6
  IB/rxe: Fix up one more receive queue drain path that might prevent
    cleanup
  IB/rxe: Avoid ICRC errors by copying into the skb first

 drivers/infiniband/sw/rxe/rxe_cq.c    | 19 +++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_loc.h   |  4 ++--
 drivers/infiniband/sw/rxe/rxe_mr.c    | 12 ++++++------
 drivers/infiniband/sw/rxe/rxe_net.c   | 17 +++++++++++------
 drivers/infiniband/sw/rxe/rxe_qp.c    |  9 ++-------
 drivers/infiniband/sw/rxe/rxe_req.c   |  4 +++-
 drivers/infiniband/sw/rxe/rxe_resp.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c |  2 ++
 drivers/infiniband/sw/rxe/rxe_verbs.h |  2 ++
 9 files changed, 48 insertions(+), 23 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
