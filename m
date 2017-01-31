From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 00/10] Completion timestamping support in mlx4
Date: Tue, 31 Jan 2017 17:46:27 +0200
Message-ID: <1485877597-23845-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sending V1 to address few notes from Jason, details below.

This series from Ariel implements the libibverbs 'Completion timestamping' API
in the mlx4 provider.

It implements the new iterator style CQ polling API with support of querying
specific CQ fields, among them the completion timestamp.

Benchmarks we ran in our test lab found that this new approach generally equals
to the legacy API but *not* worse than. As the new API enables extending the
polled fields we can overall say that it's a better API than the legacy one.

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/61

Yishai

Changes from V0:
- Add an extra two pre patches so that likely/unlikely and ALWAYS_INLINE will
  be defined in one place and make the relevant cleanup.
- Drop redundant 'inline' from mlx4_cq_read_xxx functions as they are called
  directly outside of mlx4 by their function pointer.


Ariel Levkovich (10):
  Handle likely/unlikely in a single place
  Handle always_inline attribute in util/compiler.h
  mlx4: sl_vid field in struct mlx4_cqe should be 16 bit
  mlx4: Refactor mlx4_poll_one
  mlx4: Add lazy CQ polling
  mlx4: Add inline functions to read completion's attributes
  mlx4: Add ability to poll CQs through iterator's style API
  mlx4: Add support for creating an extended CQ
  mlx4: Add ibv_query_device_ex support
  mlx4: Add ibv_query_rt_values

 providers/cxgb4/t4.h          |   2 +-
 providers/hns/hns_roce_u.h    |   5 +-
 providers/i40iw/i40iw_umain.h |   8 +-
 providers/mlx4/cq.c           | 490 ++++++++++++++++++++++++++++++++++--------
 providers/mlx4/mlx4-abi.h     |  27 +++
 providers/mlx4/mlx4.c         |  41 +++-
 providers/mlx4/mlx4.h         |  49 +++--
 providers/mlx4/verbs.c        | 238 ++++++++++++++++++--
 providers/mlx5/mlx5.h         |  12 +-
 providers/nes/nes_umain.h     |   8 +-
 util/compiler.h               |  22 ++
 11 files changed, 746 insertions(+), 156 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
