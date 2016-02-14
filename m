From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-next 0/3] IB/core uverbs support for legacy commands
Date: Sun, 14 Feb 2016 17:07:46 +0200
Message-ID: <1455462469-9124-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Doug,
I'm resending the Eli's patches [1] which adds uverbs support for
legacy commands.

[1] http://permalink.gmane.org/gmane.linux.drivers.rdma/30545

Eli Cohen (3):
  IB/core: Avoid duplicate code
  IB/core: IB/core: Allow legacy verbs through extended interfaces
  IB/core: Modify conditional on ucontext existence

 drivers/infiniband/core/uverbs_main.c | 70 +++++++++++++++++------------------
 1 file changed, 34 insertions(+), 36 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
