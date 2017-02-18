From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [rdma-core v2 0/9] Broadcom User Space RoCE Driver
Date: Sat, 18 Feb 2017 10:43:49 -0500
Message-ID: <1487432638-19607-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series introduces the user space RoCE driver for the Broadcom
NetXtreme-E 10/25/40/50 RDMA Ethernet Controller. This driver
is dependent on the bnxt_re driver posted earlier to linux-rdma
community and is under reveiw.

This patch series is based on the latest master of rdma-core
repository hosted at https://github.com/linux-rdma/rdma-core.git

The GIT for this library is hosted at following URL on github
https://github.com/dsharma283/bnxtre-rdma-core.git
branch: bnxtre-v2

Please review and give your valuable feedback for the betterment.

v1->v2
 -- Rename directory from  bnxtre to bnxt_re
 -- Squashed byte-order conversion patch
 -- Removed version.h file

Devesh Sharma (9):
  libbnxt_re: introduce bnxtre user space RDMA provider
  libbnxt_re: Add support for user memory regions
  libbnxt_re: Add support for CQ and QP management
  libbnxt_re: Add support for posting and polling
  libbnxt_re: Allow apps to poll for flushed completions
  libbnxt_re: Enable UD control path and wqe posting
  libbnxt_re: Enable polling for UD completions
  libbnxt_re: Add support for atomic operations
  libbnxt_re: Add support for SRQ in user lib

 CMakeLists.txt                   |    1 +
 MAINTAINERS                      |    5 +
 providers/bnxt_re/CMakeLists.txt |    6 +
 providers/bnxt_re/bnxt_re-abi.h  |  375 +++++++++
 providers/bnxt_re/db.c           |  108 +++
 providers/bnxt_re/flush.h        |   85 ++
 providers/bnxt_re/main.c         |  215 ++++++
 providers/bnxt_re/main.h         |  398 ++++++++++
 providers/bnxt_re/memory.c       |   76 ++
 providers/bnxt_re/memory.h       |  154 ++++
 providers/bnxt_re/verbs.c        | 1591 ++++++++++++++++++++++++++++++++++++++
 providers/bnxt_re/verbs.h        |  101 +++
 12 files changed, 3115 insertions(+)
 create mode 100644 providers/bnxt_re/CMakeLists.txt
 create mode 100644 providers/bnxt_re/bnxt_re-abi.h
 create mode 100644 providers/bnxt_re/db.c
 create mode 100644 providers/bnxt_re/flush.h
 create mode 100644 providers/bnxt_re/main.c
 create mode 100644 providers/bnxt_re/main.h
 create mode 100644 providers/bnxt_re/memory.c
 create mode 100644 providers/bnxt_re/memory.h
 create mode 100644 providers/bnxt_re/verbs.c
 create mode 100644 providers/bnxt_re/verbs.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
