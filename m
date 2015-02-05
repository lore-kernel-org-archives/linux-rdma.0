From: majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Subject: [PATCH libibverbs 0/3] Memory Windows support
Date: Thu,  5 Feb 2015 13:10:34 +0200
Message-ID: <1423134637-14438-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Overview:
Memory Windows(MW) is a method to raise the remote privileges of memory range
within a Memory Region(MR).

A MW is allocated using ibv_alloc_mw, and for it to be useful it should be
bound to a MR.

A MW can be bound to a MR according to it's type:
1. Type 1 MW: Using ibv_bind_mw verb.
2. Type 2 MW: Posting a send work request with opcode IBV_WR_BIND_MW to a QP.

The bind operation generates a new R_key with the new permissions for the MW.
The advantages of MWs is the light weight generation of R_key with changing
permissions.

MW type 1's R_key can be invalidated by binding the MW to a MR where the length
of the MW is zero.

MW type 2 R_key can be invalidated by posting a send work request(WR), where the
immediate data contains the MW's R_key and the opcode is on of the following:

1. IBV_WR_LOCAL_INV: to invalidate a local MW's R_key.
2. IBV_WR_SEND_WITH_INV: to invalidate a remote MW's R_key.

When done, the user can unbind and deallocate the MW using ibv_dealloc_mw.

For more detailed information, please refer to the manual pages.

In this patch set we have three patches:

Patch #1: Alignes the ibv_post_send manual page according the the header files.
This update is necessary to add the MW related information afterwards.

Patch #2: Adds the MW support.

Patch #3: Adds Send with invalidate. This patch is necessary to the MW support
to allow the users to remotely invalidate MW type 2 R_keys.

Majd Dibbiny (3):
  Update ibv_post_send manual page
  Add Memory Windows support
  Add Send with invalidate support

 Makefile.am                   |    7 ++-
 include/infiniband/driver.h   |    6 +++
 include/infiniband/kern-abi.h |   23 ++++++++++
 include/infiniband/verbs.h    |   84 +++++++++++++++++++++++++++++++++----
 man/ibv_alloc_mw.3            |   49 ++++++++++++++++++++++
 man/ibv_bind_mw.3             |   91 +++++++++++++++++++++++++++++++++++++++++
 man/ibv_inc_rkey.3            |   29 +++++++++++++
 man/ibv_post_send.3           |   33 +++++++++++++++
 src/cmd.c                     |   37 +++++++++++++++++
 src/libibverbs.map            |    3 +
 10 files changed, 351 insertions(+), 11 deletions(-)
 create mode 100644 man/ibv_alloc_mw.3
 create mode 100644 man/ibv_bind_mw.3
 create mode 100644 man/ibv_inc_rkey.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
