From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/8] Completion timestamping support in mlx4
Date: Wed, 25 Jan 2017 16:49:43 +0200
Message-ID: <1485355791-27646-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

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

Ariel Levkovich (8):
  mlx4: sl_vid field in struct mlx4_cqe should be 16 bit
  mlx4: Refactor mlx4_poll_one
  mlx4: Add lazy CQ polling
  mlx4: Add inline functions to read completion's attributes
  mlx4: Add ability to poll CQs through iterator's style API
  mlx4: Add support for creating an extended CQ
  mlx4: Add ibv_query_device_ex support
  mlx4: Add ibv_query_rt_values

 providers/mlx4/cq.c       | 492 +++++++++++++++++++++++++++++++++++++---------
 providers/mlx4/mlx4-abi.h |  27 +++
 providers/mlx4/mlx4.c     |  41 +++-
 providers/mlx4/mlx4.h     |  56 +++++-
 providers/mlx4/verbs.c    | 238 ++++++++++++++++++++--
 5 files changed, 735 insertions(+), 119 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
