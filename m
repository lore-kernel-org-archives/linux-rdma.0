From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 0/5] RSS support
Date: Tue, 30 Aug 2016 18:38:38 +0300
Message-ID: <1472571523-12067-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set implements the RSS libibverbs series
that was sent upstream.

It can serve as some driver reference code to justify and demonstrate the usage
of the new verbs and objects.

Yishai

Yishai Hadas (5):
  Add support for RSS WQ verbs
  Add support for Receive WQ indirection table verbs
  Add RSS QP support
  Expose RSS capabilities
  Add RSS data path support

 src/cq.c       |  55 +++++++---
 src/mlx5-abi.h |  62 +++++++++++
 src/mlx5.c     |   5 +
 src/mlx5.h     |  35 ++++++
 src/qp.c       |  96 +++++++++++++++++
 src/verbs.c    | 333 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 566 insertions(+), 20 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
