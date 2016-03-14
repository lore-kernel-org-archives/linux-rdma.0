From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 libibverbs 0/2] Add memory re-registration support
Date: Mon, 14 Mar 2016 12:59:05 +0200
Message-ID: <1457953147-4280-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Sending V3 to address your note to return an informative error code
when ibv_rereg_mr has failed.
This will let an application to clearly know what is the state of
both old and new MRs.

Man page was updated accordingly.

Yishai


Details:
Memory re-registration is a feature that enables one to change
the attributes of a memory region, including PD, translation
(address and length) and access flags.

The first patch changes the API between libibverbs and the provider's
library. This change is safe as there's no ibv_rereg_mr verb exposed to
the user and thus no reason for a vendor to implement or use this function.

The second patch adds the actual memory region re-registration support.

Changes from V2:
#patch #2:
- Return an informative error code as part of ibv_rereg_mr.
- Update man page to match above.

Changes from V1:
#patch #2:
- Fix man page issues.
- Fix mismatch in the API around the 'access' field.
- Improve input parameters validation.
- Drop some un-relevant comment.

Changes from V0:
Split to 2 patches:
  libibverbs <--> provider's library API change
  Add MR re-registration support
Matan Barak (1):
  Change rereg_mr API between libibverbs and the provider's library

Yishai Hadas (1):
  Add MR re-registeration

 Makefile.am                   |  3 +-
 include/infiniband/driver.h   |  5 +++
 include/infiniband/kern-abi.h | 20 ++++++++++++
 include/infiniband/verbs.h    | 25 ++++++++++++--
 man/ibv_rereg_mr.3            | 76 +++++++++++++++++++++++++++++++++++++++++++
 src/cmd.c                     | 29 +++++++++++++++++
 src/libibverbs.map            |  1 +
 src/verbs.c                   | 62 +++++++++++++++++++++++++++++++++++
 8 files changed, 218 insertions(+), 3 deletions(-)
 create mode 100644 man/ibv_rereg_mr.3

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
