From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 0/3] IB/rxe: Three small fixes
Date: Thu, 22 Dec 2016 08:54:35 -0500
Message-ID: <1482414878-6892-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series addresses two issues found during heavy traffic
testing as well as a recently-reported Smatch issue.

Andrew Boyer (3):
  IB/rxe: Use BTH_PSN_MASK when ACKing duplicate sends
  IB/rxe: Drop future atomic/read packets rather than retrying
  IB/rxe: Don't check for null ptr in send()

 drivers/infiniband/sw/rxe/rxe_comp.c | 2 +-
 drivers/infiniband/sw/rxe/rxe_net.c  | 3 +--
 drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
