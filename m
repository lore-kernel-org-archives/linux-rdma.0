From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 0/2] Memory Windows implementation
Date: Thu,  5 Feb 2015 14:28:31 +0200
Message-ID: <1423139313-17418-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set implements the Memory Windows support that was introduced in
libibverbs:
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg22856.html

This patch set includes two patches:
Patch #1: Implements the Memory Windows verbs; ibv_alloc_mw, ibv_bind_mw and
ibv_dealloc_mw.
Patch #2: Implements the Send with invalidate.


Majd Dibbiny (2):
  Add Memory Windows support
  Implement Send with invalidate

 src/cq.c    |   11 ++++++++++
 src/mlx4.c  |    3 ++
 src/mlx4.h  |    5 ++++
 src/qp.c    |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/verbs.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/wqe.h   |   19 +++++++++++++++++
 6 files changed, 161 insertions(+), 0 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
