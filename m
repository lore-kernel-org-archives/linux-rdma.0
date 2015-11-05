From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH ib-next 0/3] IB core uverbs support for leagacy commands
Date: Thu,  5 Nov 2015 19:40:05 +0200
Message-ID: <1446745208-17733-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

this patcheset is addresses comments from both Jason and Yann.

Eli

Eli Cohen (3):
  IB/core: Avoid duplicate code
  IB/core: IB/core: Allow legacy verbs through extended interfaces
  IB/core: Modify conditional on ucontext existence

 drivers/infiniband/core/uverbs_main.c | 70 +++++++++++++++++------------------
 1 file changed, 34 insertions(+), 36 deletions(-)

-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
