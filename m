From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 0/4] libocrdma bug-fixes
Date: Mon,  2 Nov 2015 01:37:21 -0500
Message-ID: <1446446245-534-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bug fix series of user-space rdma driver for Emulex
devices.

Devesh Sharma (3):
  RDMA/libocrdma: set vlan present bit for UD
  RDMA/libocrdma: Prevent CQ-Doorbell floods
  RDMA/libocrdma: update libocrdma version string

Padmanabh Ratnakar (1):
  RDMA/libocrdma:sync qp-state with hw state

 configure.in       |  4 ++--
 src/ocrdma_abi.h   |  7 ++++---
 src/ocrdma_main.h  |  7 +++++++
 src/ocrdma_verbs.c | 50 ++++++++++++++++++++++++++++----------------------
 4 files changed, 41 insertions(+), 27 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
