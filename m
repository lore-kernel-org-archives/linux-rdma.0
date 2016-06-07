From: root <root-6HSsQxwzXLRrcEM49+0neVaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v3 0/2] libibverbs memory barrier fixes
Date: Tue, 7 Jun 2016 07:42:53 -0700
Message-ID: <cover.1465310573.git.root@r9.asicdesigners.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series implements ARM64 memory barrier support, and fails compiles
if there is no platform implementation of the memory barriers.

Changes since V3:

white noise fix

parens around asm macros (checkpatch recommendation)

remove RFC tag

Changes since V2:

Implement the mb* macros from scratch

Retested changes on ARM64

Steve Wise (2):
  libibverbs: add ARM64 memory barrier macros
  Fail compiles if no platform specific memory barriers exist

 include/infiniband/arch.h |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
