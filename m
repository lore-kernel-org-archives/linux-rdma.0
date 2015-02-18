From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 0/3] Re-introduce extended query device verb with ODP support
Date: Wed, 18 Feb 2015 09:26:01 +0200
Message-ID: <1424244364-6242-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

The extended query device verb was pulled out of kernel v3.19 at the last moment
because of needed changes in the ABI it will expose.

This patch-set re-introduces the verb, with the changes proposed by Yann
Droneaud [1], and also returning the response length as part of the response,
as suggested by Ira Weiny [2].

I hope it can be accepted into v3.20.

Regards,
Haggai

Changes from v0:
- Add a comment explaining the repsonse buffer size check in
  ib_uverbs_ex_query_device.
- Refer to related patches in the commit messages.

[1] [PATCH v1 0/5] IB/core: extended query device caps cleanup for v3.19
    http://thread.gmane.org/gmane.linux.kernel.api/7889/
[2] RE: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not depend on request's comp_mask
    http://article.gmane.org/gmane.linux.drivers.rdma/23355

Eli Cohen (1):
  IB/core: Add support for extended query device caps

Haggai Eran (2):
  IB/core: Add on demand paging caps to ib_uverbs_ex_query_device
  IB/mlx5: Enable the ODP capability query verb

 drivers/infiniband/core/uverbs.h      |   1 +
 drivers/infiniband/core/uverbs_cmd.c  | 150 ++++++++++++++++++++++++----------
 drivers/infiniband/core/uverbs_main.c |   1 +
 drivers/infiniband/hw/mlx5/main.c     |   2 +
 include/uapi/rdma/ib_user_verbs.h     |  23 ++++++
 5 files changed, 136 insertions(+), 41 deletions(-)

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
