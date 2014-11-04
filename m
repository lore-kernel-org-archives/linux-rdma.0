From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 libibverbs 0/2] Add memory re-registration support
Date: Tue,  4 Nov 2014 16:59:37 +0200
Message-ID: <1415113179-6699-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

These two patches add memory region re-registration support.
Memory re-registration is a feature that enables one to change
the attributes of a memory region, including PD, translation
(address and length) and access flags.

The first patch changes the API between libibverbs and the provider's
library. This change is safe as there's no ibv_rereg_mr verb exposed to
the user and thus no reason for a vendor to implement or use this function.

The second patch adds the actual memory region re-registration support.

Matan

Changes from V0:
  - Split to 2 patches:
      libibverbs <--> provider's library API change
      Add MR re-registration support

Matan Barak (2):
  Change rereg_mr API between libibverbs and the provider's library
  Add MR re-registeration

 include/infiniband/driver.h   |  5 ++++
 include/infiniband/kern-abi.h | 20 ++++++++++++++++
 include/infiniband/verbs.h    | 11 +++++++--
 src/cmd.c                     | 29 +++++++++++++++++++++++
 src/libibverbs.map            |  1 +
 src/verbs.c                   | 55 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 119 insertions(+), 2 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
