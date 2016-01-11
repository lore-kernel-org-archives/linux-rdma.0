From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 libibverbs 0/2] Add memory re-registration support
Date: Mon, 11 Jan 2016 17:05:16 +0200
Message-ID: <1452524718-21575-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series of patches from Matan Barak exposes to user application
the memory region re-registration verb.

The kernel part was already accepted more than
a year ago as part of 3.17.

We made some extra review on V1 and addressed some issues,
details below.

The series was retested successfully with mlx4 driver (lib, kernel)
and can be accessed also from my openfabrics GIT at:
git://openfabrics.org/~yishaih/libibverbs.git
branch: for-upstream.

Yishai


Details:
Memory re-registration is a feature that enables one to change
the attributes of a memory region, including PD, translation
(address and length) and access flags.

The first patch changes the API between libibverbs and the provider's
library. This change is safe as there's no ibv_rereg_mr verb exposed to
the user and thus no reason for a vendor to implement or use this function.

The second patch adds the actual memory region re-registration support.

changes from V1:
#patch #2:
- Fix man page issues.
- Fix mismatch in the API around the 'access' field.
- Improve input parameters validation.
- Drop some un-relevant comment.

Changes from V0:
Split to 2 patches:
  libibverbs <--> provider's library API change
  Add MR re-registration support

Matan Barak (2):
  Change rereg_mr API between libibverbs and the provider's library
  Add MR re-registeration

 include/infiniband/driver.h   |  5 ++++
 include/infiniband/kern-abi.h | 20 ++++++++++++++
 include/infiniband/verbs.h    | 11 ++++++--
 man/ibv_rereg_mr.3            | 62 +++++++++++++++++++++++++++++++++++++++++++
 src/cmd.c                     | 29 ++++++++++++++++++++
 src/libibverbs.map            |  1 +
 src/verbs.c                   | 56 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 182 insertions(+), 2 deletions(-)
 create mode 100644 man/ibv_rereg_mr.3

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
