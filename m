From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH for-rc] uapi: Fix SPDX tags for files referring to the
 'OpenIB.org' license
Date: Fri, 20 Apr 2018 09:49:10 -0600
Message-ID: <20180420154910.GA2519@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Steve Winslow <swinslow@linuxfoundation.org>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Watson <davejwatson@fb.com>
List-Id: linux-rdma@vger.kernel.org

Based on discussion with Kate Stewart this license is not a
BSD-2-Clause, but is now formally identified as Linux-OpenIB
by SPDX.

The key difference between the licenses is in the 'warranty'
paragraph.

if_infiniband.h refers to the 'OpenIB.org' license, but
does not include the text, instead it links to an obsolete
web site that contains a license that matches the BSD-2-Clause
SPX. There is no 'three clause' version of the OpenIB.org
license.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 include/uapi/linux/if_infiniband.h      | 2 +-
 include/uapi/linux/rds.h                | 2 +-
 include/uapi/linux/tls.h                | 2 +-
 include/uapi/rdma/cxgb3-abi.h           | 2 +-
 include/uapi/rdma/cxgb4-abi.h           | 2 +-
 include/uapi/rdma/hns-abi.h             | 2 +-
 include/uapi/rdma/ib_user_cm.h          | 2 +-
 include/uapi/rdma/ib_user_ioctl_verbs.h | 2 +-
 include/uapi/rdma/ib_user_mad.h         | 2 +-
 include/uapi/rdma/ib_user_sa.h          | 2 +-
 include/uapi/rdma/ib_user_verbs.h       | 2 +-
 include/uapi/rdma/mlx4-abi.h            | 2 +-
 include/uapi/rdma/mlx5-abi.h            | 2 +-
 include/uapi/rdma/mthca-abi.h           | 2 +-
 include/uapi/rdma/nes-abi.h             | 2 +-
 include/uapi/rdma/qedr-abi.h            | 2 +-
 include/uapi/rdma/rdma_user_cm.h        | 2 +-
 include/uapi/rdma/rdma_user_ioctl.h     | 2 +-
 include/uapi/rdma/rdma_user_rxe.h       | 2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)

I propose to send this patch through the RDMA tree.

diff --git a/include/uapi/linux/if_infiniband.h b/include/uapi/linux/if_infiniband.h
index 050b92dcf8cf40..0fc33bf30e45a1 100644
--- a/include/uapi/linux/if_infiniband.h
+++ b/include/uapi/linux/if_infiniband.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
 /*
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
index a66b213de3d7a4..20c6bd0b00079e 100644
--- a/include/uapi/linux/rds.h
+++ b/include/uapi/linux/rds.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2008 Oracle.  All rights reserved.
  *
diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index c6633e97eca40b..ff02287495ac56 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2016-2017, Mellanox Technologies. All rights reserved.
  *
diff --git a/include/uapi/rdma/cxgb3-abi.h b/include/uapi/rdma/cxgb3-abi.h
index 9acb4b7a624633..85aed672f43e65 100644
--- a/include/uapi/rdma/cxgb3-abi.h
+++ b/include/uapi/rdma/cxgb3-abi.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2006 Chelsio, Inc. All rights reserved.
  *
diff --git a/include/uapi/rdma/cxgb4-abi.h b/include/uapi/rdma/cxgb4-abi.h
index 1fefd0140c26f6..a159ba8dcf8f13 100644
--- a/include/uapi/rdma/cxgb4-abi.h
+++ b/include/uapi/rdma/cxgb4-abi.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2009-2010 Chelsio, Inc. All rights reserved.
  *
diff --git a/include/uapi/rdma/hns-abi.h b/include/uapi/rdma/hns-abi.h
index 7092c8de4bd883..78613b609fa846 100644
--- a/include/uapi/rdma/hns-abi.h
+++ b/include/uapi/rdma/hns-abi.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2016 Hisilicon Limited.
  *
diff --git a/include/uapi/rdma/ib_user_cm.h b/include/uapi/rdma/ib_user_cm.h
index 4a8f9562f7cd9b..e2709bb8cb1802 100644
--- a/include/uapi/rdma/ib_user_cm.h
+++ b/include/uapi/rdma/ib_user_cm.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2005 Topspin Communications.  All rights reserved.
  * Copyright (c) 2005 Intel Corporation.  All rights reserved.
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 04e46ea517d328..625545d862d7e4 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2017-2018, Mellanox Technologies inc.  All rights reserved.
  *
diff --git a/include/uapi/rdma/ib_user_mad.h b/include/uapi/rdma/ib_user_mad.h
index ef92118dad9770..90c0cf228020dc 100644
--- a/include/uapi/rdma/ib_user_mad.h
+++ b/include/uapi/rdma/ib_user_mad.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
  * Copyright (c) 2005 Voltaire, Inc. All rights reserved.
diff --git a/include/uapi/rdma/ib_user_sa.h b/include/uapi/rdma/ib_user_sa.h
index 0d2607f0cd20c3..435155d6e1c6a5 100644
--- a/include/uapi/rdma/ib_user_sa.h
+++ b/include/uapi/rdma/ib_user_sa.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2005 Intel Corporation.  All rights reserved.
  *
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 9be07394fdbe50..6aeb03315b0bd5 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2005 Topspin Communications.  All rights reserved.
  * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
diff --git a/include/uapi/rdma/mlx4-abi.h b/include/uapi/rdma/mlx4-abi.h
index 04f64bc4045f1b..f745575281756d 100644
--- a/include/uapi/rdma/mlx4-abi.h
+++ b/include/uapi/rdma/mlx4-abi.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2007 Cisco Systems, Inc. All rights reserved.
  * Copyright (c) 2007, 2008 Mellanox Technologies. All rights reserved.
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index cb4a02c4a1cef0..fdaf00e206498c 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2013-2015, Mellanox Technologies. All rights reserved.
  *
diff --git a/include/uapi/rdma/mthca-abi.h b/include/uapi/rdma/mthca-abi.h
index ac756cd9e80772..91b12e1a6f43ce 100644
--- a/include/uapi/rdma/mthca-abi.h
+++ b/include/uapi/rdma/mthca-abi.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2005 Topspin Communications.  All rights reserved.
  * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
diff --git a/include/uapi/rdma/nes-abi.h b/include/uapi/rdma/nes-abi.h
index 35bfd4015d0705..f80495baa9697e 100644
--- a/include/uapi/rdma/nes-abi.h
+++ b/include/uapi/rdma/nes-abi.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2006 - 2011 Intel Corporation.  All rights reserved.
  * Copyright (c) 2005 Topspin Communications.  All rights reserved.
diff --git a/include/uapi/rdma/qedr-abi.h b/include/uapi/rdma/qedr-abi.h
index 8ba098900e9aac..24c658b3c79042 100644
--- a/include/uapi/rdma/qedr-abi.h
+++ b/include/uapi/rdma/qedr-abi.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /* QLogic qedr NIC Driver
  * Copyright (c) 2015-2016  QLogic Corporation
  *
diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
index e1269024af47f0..0d1e78ebad0515 100644
--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2005-2006 Intel Corporation.  All rights reserved.
  *
diff --git a/include/uapi/rdma/rdma_user_ioctl.h b/include/uapi/rdma/rdma_user_ioctl.h
index d223f4164a0f8d..d92d2721b28c5b 100644
--- a/include/uapi/rdma/rdma_user_ioctl.h
+++ b/include/uapi/rdma/rdma_user_ioctl.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2016 Mellanox Technologies, LTD. All rights reserved.
  *
diff --git a/include/uapi/rdma/rdma_user_rxe.h b/include/uapi/rdma/rdma_user_rxe.h
index 1f8a9e7daea43e..44ef6a3b7afc8c 100644
--- a/include/uapi/rdma/rdma_user_rxe.h
+++ b/include/uapi/rdma/rdma_user_rxe.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-2-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
 /*
  * Copyright (c) 2016 Mellanox Technologies Ltd. All rights reserved.
  *
-- 
2.17.0
