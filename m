From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libcxgb4 0/2] uverbs ABI fixes
Date: Sun,  4 May 2014 23:31:50 +0200
Message-ID: <cover.1399235229.git.ydroneaud@opteya.com>
References: <cover.1399216475.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find two patches for libcxgb4 to keep the library in sync
regarding the kernel changes I've submitted: explicit padding
must be added at end of the structure so that i386 userspace library
has the same structure layout than x86_64 kernel.

See http://marc.info/?i=cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Yann Droneaud (2):
  kernel abi: adds explicit padding in struct c4iw_create_cq_resp
  kernel abi: adds explicit padding in struct c4iw_alloc_ucontext_resp

 src/cxgb4-abi.h | 2 ++
 src/dev.c       | 5 +++++
 src/verbs.c     | 5 +++++
 3 files changed, 12 insertions(+)

-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
