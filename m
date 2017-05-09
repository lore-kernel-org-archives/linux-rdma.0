From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/2] Handle misc issues in mlx5 driver
Date: Tue,  9 May 2017 19:45:20 +0300
Message-ID: <1494348322-4526-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset handles misc issues in the mlx5 driver, details below.

Patch #1: Few cleanup fixes.
Patch #2  Update the supported PCI devices list.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/127

Artemy Kovalyov (1):
  mlx5: Few small fixes

Noa Osherovich (1):
  mlx5: Update supported PCI devices list

 providers/mlx5/cq.c   | 4 +---
 providers/mlx5/mlx5.c | 2 ++
 providers/mlx5/qp.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
