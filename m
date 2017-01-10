From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 rdma-core 0/3] Add packet pacing support
Date: Tue, 10 Jan 2017 19:49:01 +0200
Message-ID: <1484070544-26501-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

V2 is just a rebase series, details below.

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

Changes from V1:
- Rebase over V1 of below cleanup patch.

Changes from V0:
- The series is sent on top of an extra cleanup patch named:
  "rdma: Handle uninitialized data for ibv_cmd_modify_qp".
  The above patch was sent upstream separately based on Leon's request so that it can
  be taken by itself regardless this series.
- Patch #2: Add an extra check as part of ibv_cmd_query_qp to return an error
            in case a mask that is not supported by that command was asked.
Bodong Wang (3):
  ibverbs: Report packet pacing capabilities when querying device
  ibverbs: Add support for packet pacing
  mlx5: Add packet pacing support

 libibverbs/cmd.c                     | 62 +++++++++++++++++++++++++++++++++---
 libibverbs/driver.h                  |  5 +++
 libibverbs/examples/devinfo.c        | 21 ++++++++++++
 libibverbs/kern-abi.h                | 27 +++++++++++++---
 libibverbs/libibverbs.map            |  5 +++
 libibverbs/man/ibv_modify_qp.3       |  2 ++
 libibverbs/man/ibv_query_device_ex.3 |  7 ++++
 libibverbs/verbs.h                   | 11 ++++++-
 providers/mlx5/mlx5-abi.h            |  2 ++
 providers/mlx5/verbs.c               | 18 ++++++++++-
 10 files changed, 149 insertions(+), 11 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
