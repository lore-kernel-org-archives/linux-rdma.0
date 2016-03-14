From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 0/2] Misc fixes
Date: Mon, 14 Mar 2016 13:47:33 +0200
Message-ID: <1457956055-2593-1-git-send-email-noaos@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Yishai
This series of patches fixes two issues in libmlx4 as follows.

The first patch fixes a resize CQ issue.
The second patch handles correctly the case when zero
length SGE was provided.

Noa.

Haggai Abramonvsky (1):
  Update consumer index after resize CQ operation

Noa Osherovich (1):
  Handling 0-length sge correctly

 src/cq.c    |  9 ++-------
 src/mlx4.h  | 14 ++++++++++++++
 src/qp.c    |  5 ++++-
 src/verbs.c |  1 +
 4 files changed, 21 insertions(+), 8 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
