From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/2] Flow steering handling
Date: Wed,  8 Nov 2017 18:18:15 +0200
Message-ID: <1510157897-10384-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series aligns in the user space area the flow steering uverbs commands
with other objects (e.g. QP, CQ) such that the commands don't allocate and free
the ib_flow but are just responsible to issue the command.

The second patch in the series in mlx4 handles the cleanup on fatal scenario as
already done for other destroy commands on top of the above change.

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/244

Yishai Hadas (2):
  Align flow steering commands with other objects
  mlx4: Cleanup upon fatal in the destroy flow

 libibverbs/cmd.c       | 15 +++++----------
 libibverbs/driver.h    |  3 ++-
 providers/mlx4/mlx4.c  |  4 ++--
 providers/mlx4/mlx4.h  |  2 ++
 providers/mlx4/verbs.c | 30 ++++++++++++++++++++++++++++++
 providers/mlx5/mlx5.c  |  4 ++--
 providers/mlx5/mlx5.h  |  2 ++
 providers/mlx5/verbs.c | 29 +++++++++++++++++++++++++++++
 8 files changed, 74 insertions(+), 15 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
