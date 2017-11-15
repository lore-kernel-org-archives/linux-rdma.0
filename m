From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/3] mlx5 - Enhanced CQ features
Date: Wed, 15 Nov 2017 16:23:39 +0200
Message-ID: <1510755822-15945-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series from Guy is the supplementary part of the kernel series that was
merged into 4.15 'for-next' branch by Doug.

The series exposes to mlx5 DV users some enhanced CQ features as of:
- Expose 128B CQE compression capability.
- Create padded 128B CQE.

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/253

Yishai

Guy Levi (3):
  mlx5: Expose 128B CQE compression capability
  mlx5: Expose 128B padded CQE capability in direct verb
  mlx5: Support padded CQE by mlx5dv_create_cq

 providers/mlx5/man/mlx5dv_query_device.3 |  2 ++
 providers/mlx5/mlx5-abi.h                | 13 +++++++++++--
 providers/mlx5/mlx5.c                    |  6 ++++++
 providers/mlx5/mlx5.h                    |  2 ++
 providers/mlx5/mlx5dv.h                  | 11 ++++++++++-
 providers/mlx5/verbs.c                   | 29 +++++++++++++++++++++++++++++
 6 files changed, 60 insertions(+), 3 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
