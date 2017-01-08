From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/3] Add packet pacing support
Date: Sun,  8 Jan 2017 18:32:25 +0200
Message-ID: <1483893148-8211-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set from Bodong is the supplementary part of the kernel series that
was accepted upstream into 4.10.

Packet pacing is a feature to control packet injection rate in arbitrary rates.
One typical use case is for streaming vendors to control the bandwidth of
different customers based on service coverage.

Packet pacing is a rate limiting and shaping for a QP (SQ for RAW QP), set and
change the rate is done by modifying QP.

This series made the following high level changes:
1. Report rate limit capabilities, it includes:
   - The maximum and minimum rate limit in kbps supported
     by packet pacing.
   - Bitmap showing which QP types are supported by packet pacing operation.
2. Use the extended uverbs command for modify QP to add rate limit support.
3. Add support in mlx5 provider.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/51

Yishai

Bodong Wang (3):
  ibverbs: Report packet pacing capabilities when querying device
  ibverbs: Add support for packet pacing
  mlx5: Add packet pacing support

 libibverbs/cmd.c                     | 55 ++++++++++++++++++++++++++++++++----
 libibverbs/driver.h                  |  5 ++++
 libibverbs/examples/devinfo.c        | 21 ++++++++++++++
 libibverbs/kern-abi.h                | 27 +++++++++++++++---
 libibverbs/libibverbs.map            |  5 ++++
 libibverbs/man/ibv_modify_qp.3       |  2 ++
 libibverbs/man/ibv_query_device_ex.3 |  7 +++++
 libibverbs/verbs.h                   | 11 +++++++-
 providers/mlx5/mlx5-abi.h            |  2 ++
 providers/mlx5/verbs.c               | 20 +++++++++++--
 10 files changed, 143 insertions(+), 12 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
