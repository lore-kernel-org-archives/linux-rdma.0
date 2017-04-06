From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/6] More sparse cleanup
Date: Thu,  6 Apr 2017 16:42:19 -0600
Message-ID: <1491518545-14746-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Have rxe, ipath, hfi1 and ocrdma enable sparse in travis.

The bug sparse noticed in mlx4 sure looks legit and odd it has remained
undetected for so long.

Jason Gunthorpe (6):
  rxe: Use libc's IN6_IS_ADDR_V4MAPPED
  ipath/hfi: Enable sparse from travis
  ocrdma: Fix missing endian swap in debug print
  ocrdma: Add sparse annotations
  mlx4: Fix incorrect masking of g_mlpath_rqpn
  mlx4: Fix typo in byte swap direction

 CMakeLists.txt                  | 10 +++++-----
 providers/mlx4/cq.c             |  4 ++--
 providers/ocrdma/ocrdma_abi.h   | 39 ++++++++++++++++++++++++++-------------
 providers/ocrdma/ocrdma_verbs.c | 22 +++++++++++-----------
 providers/rxe/rxe.c             |  3 +--
 5 files changed, 45 insertions(+), 33 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
