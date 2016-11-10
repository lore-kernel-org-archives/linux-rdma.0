From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 rdma-core 0/7] libhns: userspace library for hns
Date: Thu, 10 Nov 2016 20:46:10 +0800
Message-ID: <1478781977-116803-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series introduces userspace library for hns RoCE driver.

changes v2 -> v3:
1. Fix the code style, for example, if (addr == NULL)
2. Fix the bug for hns_roce_u_reg_mr

changes v1 -> v2:
1. Delete the min() definition and instead of ccan header
2. Delete the CHECK_C_SOURCE_COMPILES
3. sort the c file in rdma_provider()
4. Delete the unused code in hns_roce_u_db.h

Lijun Ou (7):
  libhns: Add initial main frame
  libhns: Add verbs of querying device and querying port
  libhns: Add verbs of pd and mr support
  libhns: Add verbs of cq support
  libhns: Add verbs of qp support
  libhns: Add verbs of post_send and post_recv support
  libhns: Add consolidated repo for userspace library of hns

 CMakeLists.txt                   |   1 +
 MAINTAINERS                      |   6 +
 README.md                        |   1 +
 providers/hns/CMakeLists.txt     |   6 +
 providers/hns/hns_roce_u.c       | 228 +++++++++++
 providers/hns/hns_roce_u.h       | 255 ++++++++++++
 providers/hns/hns_roce_u_abi.h   |  69 ++++
 providers/hns/hns_roce_u_buf.c   |  61 +++
 providers/hns/hns_roce_u_db.h    |  54 +++
 providers/hns/hns_roce_u_hw_v1.c | 839 +++++++++++++++++++++++++++++++++++++++
 providers/hns/hns_roce_u_hw_v1.h | 242 +++++++++++
 providers/hns/hns_roce_u_verbs.c | 525 ++++++++++++++++++++++++
 12 files changed, 2287 insertions(+)
 create mode 100644 providers/hns/CMakeLists.txt
 create mode 100644 providers/hns/hns_roce_u.c
 create mode 100644 providers/hns/hns_roce_u.h
 create mode 100644 providers/hns/hns_roce_u_abi.h
 create mode 100644 providers/hns/hns_roce_u_buf.c
 create mode 100644 providers/hns/hns_roce_u_db.h
 create mode 100644 providers/hns/hns_roce_u_hw_v1.c
 create mode 100644 providers/hns/hns_roce_u_hw_v1.h
 create mode 100644 providers/hns/hns_roce_u_verbs.c

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
