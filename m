From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [rdma-core v2 0/3] libbnxt_re bug fixes
Date: Wed, 31 Jan 2018 10:28:48 -0500
Message-ID: <1517412531-25195-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changelog:
v1->v2:
* fixed the DCO error in travis build checker.

--------

This patch series contains important bug fixes.
Patch 1 addresses a latency test failure. Patch 2
improves the f/w version display. Patch 3 updates
the PCI-ID table.

Devesh Sharma (2):
  libbnxt_re: Fix lat test failure in event mode
  libbnxt_re: Update and sort device pci-id table

Selvin Xavier (1):
  libbnxt_re: Display FW version using ibv_devinfo

 providers/bnxt_re/main.c  | 17 +++++++++++------
 providers/bnxt_re/main.h  |  3 +++
 providers/bnxt_re/verbs.c | 19 ++++++++++++++++---
 3 files changed, 30 insertions(+), 9 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
