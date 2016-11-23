From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 0/8] RXE improvements
Date: Wed, 23 Nov 2016 12:39:16 -0500
Message-ID: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These patches provide a series of small improvements to the
RXE driver related to loopback, retries, error handling, and
zero-byte operations.

Changes since v1:
  - Edit commit messages as suggested
  - Remove saddr buffer from stack as suggested
  - Split reference leak patch into two as suggested

Andrew Boyer (8):
  IB/rxe: Remove buffer used for printing IP address
  IB/rxe: Advance the consumer pointer before posting the CQE
  IB/rxe: Don't update the response PSN unless it's going forwards
  IB/rxe: Unblock loopback by moving skb_out increment
  IB/rxe: Add support for zero-byte operations
  IB/rxe: Add support for IB_CQ_REPORT_MISSED_EVENTS
  IB/rxe: Fix ref leak in rxe_create_qp()
  IB/rxe: Fix ref leak in duplicate_request()

 drivers/infiniband/sw/rxe/rxe_comp.c  |  5 +++--
 drivers/infiniband/sw/rxe/rxe_loc.h   |  2 --
 drivers/infiniband/sw/rxe/rxe_mr.c    |  3 +++
 drivers/infiniband/sw/rxe/rxe_net.c   |  2 ++
 drivers/infiniband/sw/rxe/rxe_recv.c  | 11 +++++------
 drivers/infiniband/sw/rxe/rxe_resp.c  | 22 ++++++++++++++++++----
 drivers/infiniband/sw/rxe/rxe_verbs.c | 17 +++++++++++++----
 7 files changed, 44 insertions(+), 18 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
