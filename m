From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 00/11] Broadcom User Space RoCE Driver
Date: Sat, 28 Jan 2017 17:13:31 -0500
Message-ID: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series introduces the user space RoCE driver for the Broadcom
NetXtreme-E 10/25/40/50 RDMA Ethernet Controller. This driver
is dependent on the bnxt_re driver posted earlier to linux-rdma
community and is under reveiw.

This patch series is based on the latest master of rdma-core
repository hosted at https://github.com/linux-rdma/rdma-core.git

The GIT for this library is hosted at following URL on github
https://github.com/dsharma283/bnxtre-rdma-core.git
branch: bnxtre-v0

Please review and give your feedback.

Devesh Sharma (11):
  libbnxtre: introduce bnxtre user space RDMA provider
  libbnxtre: Add support for user memory regions
  libbnxtre: Add support for CQ and QP management
  libbnxtre: Add support for posting and polling
  libbnxtre: Allow apps to poll for flushed completions
  libbnxtre: convert cpu to le all over the place
  libbnxtre: Enable UD control path and wqe posting
  libbnxtre: Enable polling for UD completions
  libbnxtre: Add support for atomic operations
  libbnxtre: Add support for SRQ in user lib
  libbnxtre: Add versioning support

 CMakeLists.txt                  |    1 +
 MAINTAINERS                     |    5 +
 providers/bnxtre/CMakeLists.txt |    6 +
 providers/bnxtre/abi.h          |  418 ++++++++++
 providers/bnxtre/bnxtre.driver  |    1 +
 providers/bnxtre/db.c           |  110 +++
 providers/bnxtre/list.h         |  135 ++++
 providers/bnxtre/main.c         |  220 ++++++
 providers/bnxtre/main.h         |  358 +++++++++
 providers/bnxtre/memory.c       |   77 ++
 providers/bnxtre/memory.h       |  160 ++++
 providers/bnxtre/verbs.c        | 1597 +++++++++++++++++++++++++++++++++++++++
 providers/bnxtre/verbs.h        |  106 +++
 providers/bnxtre/version.h      |   53 ++
 14 files changed, 3247 insertions(+)
 create mode 100644 providers/bnxtre/CMakeLists.txt
 create mode 100644 providers/bnxtre/abi.h
 create mode 100644 providers/bnxtre/bnxtre.driver
 create mode 100644 providers/bnxtre/db.c
 create mode 100644 providers/bnxtre/list.h
 create mode 100644 providers/bnxtre/main.c
 create mode 100644 providers/bnxtre/main.h
 create mode 100644 providers/bnxtre/memory.c
 create mode 100644 providers/bnxtre/memory.h
 create mode 100644 providers/bnxtre/verbs.c
 create mode 100644 providers/bnxtre/verbs.h
 create mode 100644 providers/bnxtre/version.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
