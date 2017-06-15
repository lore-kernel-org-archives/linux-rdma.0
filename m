From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/5] RXE checkpatch cleanup
Date: Thu, 15 Jun 2017 11:29:02 +0300
Message-ID: <20170615082907.5658-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset from Kamal cleanups some of the warnings
and errors that he got from applying checkpatch.pl script
on RXE files.

Kamal Heib (5):
  IB/rxe: Use "foo *bar" instead of "foo * bar"
  IB/rxe: Prefer 'unsigned int' to bare use of 'unsigned'
  IB/rxe: Use DEVICE_ATTR_RO macro to show parent field
  IB/rxe: Use __func__ to print function's name
  IB/rxe: Constify static rxe_vm_ops

 drivers/infiniband/sw/rxe/rxe.h       |  2 +-
 drivers/infiniband/sw/rxe/rxe_loc.h   |  2 +-
 drivers/infiniband/sw/rxe/rxe_mmap.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_pool.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_req.c   |  2 +-
 drivers/infiniband/sw/rxe/rxe_task.c  |  4 ++--
 drivers/infiniband/sw/rxe/rxe_verbs.c | 12 ++++++------
 7 files changed, 13 insertions(+), 13 deletions(-)

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
