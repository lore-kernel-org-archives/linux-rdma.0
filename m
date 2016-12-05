From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 0/2] IB/rxe: Fix kernel panics when tearing down QPs
Date: Mon,  5 Dec 2016 08:42:12 -0500
Message-ID: <1480945335-2577-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a set of two patches that prevent kernel panics seen when tearing
down QPs. The second patch (holding refs in tasklets) might or might not be
needed once the first patch (waiting for tasklets to finish) is applied.
Feedback welcomed.

Update for v2:
 - Remove default initialization of idle in rxe_cleanup_task() per review

Andrew Boyer (2):
  IB/rxe: Wait for tasklets to finish before tearing down QP
  IB/rxe: Hold refs when running tasklets

 drivers/infiniband/sw/rxe/rxe_comp.c |  4 ++++
 drivers/infiniband/sw/rxe/rxe_req.c  |  4 ++++
 drivers/infiniband/sw/rxe/rxe_resp.c |  3 +++
 drivers/infiniband/sw/rxe/rxe_task.c | 19 +++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_task.h |  1 +
 5 files changed, 31 insertions(+)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
