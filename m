From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for v3.15 0/4] uverbs ABI fixes
Date: Sun,  4 May 2014 23:21:12 +0200
Message-ID: <cover.1399216475.git.ydroneaud@opteya.com>
References: <1394814128-8815-1-git-send-email-hariprasad@chelsio.com> <1394814128-8815-3-git-send-email-hariprasad@chelsio.com> <1395848977.3297.15.camel@localhost.localdomain> <007101cf490c$3ec7cb30$bc576190$@opengridcomputing.com> <1394814128-8815-1-git-send-email-hariprasad@chelsio.com> <1394814128-8815-3-git-send-email-hariprasad@chelsio.com> <1395848977.3297.15.camel@localhost.localdomain> <20140328082428.GH25192@mwanda> <1396002468.3297.63.camel@localhost.localdomain> <20140502235616.GJ4963@mwanda>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find 4 patches which fix some issues regarding missing explicit
padding at end of structure exchanged between kernel and userspace.

These makes i386 userspace libraries and x86_64 kernel disagree about
the size of the structures.

Additionally, as reported by Dan Carpenter, in one case, stack information
can be leaked by the kernel to userspace due to implicit padding being not
initialized.

Unfortunately, the data structure cannot be fixed alone as it would break
existing applications. So in order to remain compatible with i386 libraries,
providers (hw) functions are modified to use the input length to guess the
expected format of the command in order to check the content of the reserved
field for future usage. Other are modified to not write the padding field in
response to make the kernel able to handle gracefully i386 userspace on x86_64.

For full coherency, patches against the userspace libraries (libcxgb4 and
libmlx5) will be submitted as a followup to update the data structure on
userspace side.

Yann Droneaud (4):
  RDMA/mlx5: add missing padding at end of struct mlx5_ib_create_cq
  RDMA/mlx5: add missing padding at end of struct mlx5_ib_create_srq
  RDMA/cxgb4: add missing padding at end of struct c4iw_create_cq_resp
  RDMA/cxgb4: add missing padding at end of struct
    c4iw_alloc_ucontext_resp

 drivers/infiniband/hw/cxgb4/cq.c       |  8 ++++++--
 drivers/infiniband/hw/cxgb4/provider.c |  8 ++++++--
 drivers/infiniband/hw/cxgb4/user.h     |  2 ++
 drivers/infiniband/hw/mlx5/cq.c        | 13 +++++++++++--
 drivers/infiniband/hw/mlx5/srq.c       | 18 +++++++++++++++---
 drivers/infiniband/hw/mlx5/user.h      |  2 ++
 6 files changed, 42 insertions(+), 9 deletions(-)

-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
