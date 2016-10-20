From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 0/6] libqedr: userspace library for qedr
Date: Thu, 20 Oct 2016 12:49:06 +0300
Message-ID: <1476956952-17388-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>

This series introduces RoCE RDMA userspace library for the 579xx RDMA products
by Qlogic.
The libqedr library will support both RoCE and iWarp, although this series only
adds RoCE support.

This libqedr version matches the qedr patches submitted for upstream recently- 
commit: 993d1b52615e1a549e55875c3b74308391672d9f.

Built on top of rdma-core 29e6d0ebc56cd089d9a200ba33a958899fc84bbe.

Ram Amrani (6):
  libqedr (qelr) chains
  libqedr (qelr) verbs
  libqedr (qelr) HSI
  libqedr (qelr) main
  libqedr (qelr) abi
  libqedr (qelr) addition to consolidated repo

 CMakeLists.txt                 |    1 +
 MAINTAINERS                    |    7 +
 README.md                      |    1 +
 providers/qedr/CMakeLists.txt  |    5 +
 providers/qedr/common_hsi.h    | 1502 +++++++++++++++++++++++++++++++
 providers/qedr/qelr.h          |  320 +++++++
 providers/qedr/qelr_abi.h      |  120 +++
 providers/qedr/qelr_chain.c    |  107 +++
 providers/qedr/qelr_chain.h    |  163 ++++
 providers/qedr/qelr_hsi.h      |   67 ++
 providers/qedr/qelr_hsi_rdma.h |  914 +++++++++++++++++++
 providers/qedr/qelr_main.c     |  286 ++++++
 providers/qedr/qelr_main.h     |   83 ++
 providers/qedr/qelr_verbs.c    | 1948 ++++++++++++++++++++++++++++++++++++++++
 providers/qedr/qelr_verbs.h    |   83 ++
 providers/qedr/rdma_common.h   |   74 ++
 providers/qedr/roce_common.h   |   50 ++
 17 files changed, 5731 insertions(+)
 create mode 100644 providers/qedr/CMakeLists.txt
 create mode 100644 providers/qedr/common_hsi.h
 create mode 100644 providers/qedr/qelr.h
 create mode 100644 providers/qedr/qelr_abi.h
 create mode 100644 providers/qedr/qelr_chain.c
 create mode 100644 providers/qedr/qelr_chain.h
 create mode 100644 providers/qedr/qelr_hsi.h
 create mode 100644 providers/qedr/qelr_hsi_rdma.h
 create mode 100644 providers/qedr/qelr_main.c
 create mode 100644 providers/qedr/qelr_main.h
 create mode 100644 providers/qedr/qelr_verbs.c
 create mode 100644 providers/qedr/qelr_verbs.h
 create mode 100644 providers/qedr/rdma_common.h
 create mode 100644 providers/qedr/roce_common.h

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
