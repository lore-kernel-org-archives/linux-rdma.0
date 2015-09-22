From: wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [v1 0/2] libmlx4: Add support for checksum offload
Date: Tue, 22 Sep 2015 23:22:04 +0300
Message-ID: <1442953326-105006-1-git-send-email-bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Changes from v1:
 * Update patches to use the device_cap_flags to get the checksum offload caps
   
Bodong Wang (2):
  libmlx4: Update ibv_create_flow/ibv_destroy_flow according to change
    of libibverbs
  libmlx4: Add support for TX/RX checksum offload

 src/cq.c    |  6 ++++++
 src/mlx4.c  |  4 ++--
 src/mlx4.h  | 19 ++++++++++++++++++-
 src/qp.c    | 19 +++++++++++++++++++
 src/verbs.c | 24 ++++++++++++++++++++++++
 src/wqe.h   |  8 +++++---
 6 files changed, 74 insertions(+), 6 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
