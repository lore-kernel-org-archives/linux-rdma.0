From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 0/7] Memory Window support
Date: Mon,  8 Feb 2016 14:43:15 +0200
Message-ID: <1454935402-15192-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series of patches exposes to user application
the memory window support. The kernel part was already
accepted more than a year ago.

We made some extra review on V0 and addressed some issues,
details below.

The series was retested successfully with mlx4 driver (lib, kernel)
and can be accessed also from my openfabrics GIT at:
git://openfabrics.org/~yishaih/libibverbs.git
branch: for-upstream

This MW series is sent on top of rereg_mr that is pending your merge.
If may be helpful, it exists also on top of the master branch 
from my public GIT above, branch: mw.

Yishai
------


Memory Windows(MW) is a method to raise the remote privileges
of memory range within a Memory Region(MR).

A MW is allocated using ibv_alloc_mw and for it to be useful it
should be bound to a MR.

A MW can be bound to a MR according to its type:
1. Type one MW: Using ibv_bind_mw verb.
2. Type two MW: Posting a send work request with opcode IBV_WR_BIND_MW to a QP.

The bind operation generates a new R_key with the new permissions for the MW.
The advantages of MWs is the light weight generation of R_key with changing
permissions.

MW type one R_key can be invalidated by binding the MW to a MR where the length
of the MW is zero.

MW type two R_key can be invalidated by posting a send work request where the
immediate data contains the MW's R_key and the opcode is one of the following:

1. IBV_WR_LOCAL_INV: to invalidate a local MW's R_key.
2. IBV_WR_SEND_WITH_INV: to invalidate a remote MW's R_key.

To deallocate the MW, ibv_dealloc_mw verb should be used.
For more detailed information, please refer to the manual pages.

This patch set includes 7 patches as follows:
#1: Aligns the ibv_post_send manual page to be up-to-date, this update is
    necessary to add the MW related information afterwards.
#2: Adds the alloc/dealloc Memory Window verbs.
#3: Adds bind/unbind support for Memory Window type one.
#4: Exposes device capability for Memory Window type one.
#5: Adds bind/unbind support for Memory Window type two.
#6: Exposes device capabilities for Memory Window type two.
#7: Extends man pages to describe Memory Window usage.

Changes from V0:
- Split the series to small logical patches.
- Fix and update the man pages.
- Improve some issues in the API (Type usage, error checking).


Yishai Hadas (7):
  Update ibv_post_send manual page
  Add alloc/dealloc Memory Window verbs
  Add bind/unbind support for Memory Window type one
  Expose device capability for Memory Window type one
  Add bind/unbind support for Memory Window type two
  Expose device capabilities for Memory Window type two
  Extend man pages to describe Memory Window usage

 Makefile.am                   |  8 ++--
 include/infiniband/driver.h   |  6 +++
 include/infiniband/kern-abi.h | 23 +++++++++++
 include/infiniband/verbs.h    | 87 ++++++++++++++++++++++++++++++++++++----
 man/ibv_alloc_mw.3            | 54 +++++++++++++++++++++++++
 man/ibv_bind_mw.3             | 92 +++++++++++++++++++++++++++++++++++++++++++
 man/ibv_inc_rkey.3            | 32 +++++++++++++++
 man/ibv_post_send.3           | 51 ++++++++++++++++++++----
 src/cmd.c                     | 37 +++++++++++++++++
 src/libibverbs.map            |  3 ++
 10 files changed, 375 insertions(+), 18 deletions(-)
 create mode 100644 man/ibv_alloc_mw.3
 create mode 100644 man/ibv_bind_mw.3
 create mode 100644 man/ibv_inc_rkey.3

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
