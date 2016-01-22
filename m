From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 5/6] IB/rdmavt: Fix copyright date
Date: Fri, 22 Jan 2016 13:04:58 -0800
Message-ID: <20160122210456.9932.74662.stgit@scvm10.sc.intel.com>
References: <20160122210251.9932.46251.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122210251.9932.46251.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Update all files added by rdmavt which do not yet have 2016 as the
copyright year.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/ah.c    |    2 +-
 drivers/infiniband/sw/rdmavt/ah.h    |    2 +-
 drivers/infiniband/sw/rdmavt/cq.c    |    2 +-
 drivers/infiniband/sw/rdmavt/cq.h    |    2 +-
 drivers/infiniband/sw/rdmavt/dma.c   |    2 +-
 drivers/infiniband/sw/rdmavt/dma.h   |    2 +-
 drivers/infiniband/sw/rdmavt/mad.c   |    2 +-
 drivers/infiniband/sw/rdmavt/mad.h   |    2 +-
 drivers/infiniband/sw/rdmavt/mcast.c |    2 +-
 drivers/infiniband/sw/rdmavt/mcast.h |    2 +-
 drivers/infiniband/sw/rdmavt/mmap.c  |    2 +-
 drivers/infiniband/sw/rdmavt/mmap.h  |    2 +-
 drivers/infiniband/sw/rdmavt/mr.c    |    2 +-
 drivers/infiniband/sw/rdmavt/mr.h    |    2 +-
 drivers/infiniband/sw/rdmavt/pd.c    |    2 +-
 drivers/infiniband/sw/rdmavt/pd.h    |    2 +-
 drivers/infiniband/sw/rdmavt/qp.c    |    2 +-
 drivers/infiniband/sw/rdmavt/qp.h    |    2 +-
 drivers/infiniband/sw/rdmavt/srq.c   |    2 +-
 drivers/infiniband/sw/rdmavt/srq.h   |    2 +-
 drivers/infiniband/sw/rdmavt/trace.c |    2 +-
 drivers/infiniband/sw/rdmavt/trace.h |    2 +-
 drivers/infiniband/sw/rdmavt/vt.c    |    2 +-
 drivers/infiniband/sw/rdmavt/vt.h    |    2 +-
 include/rdma/rdma_vt.h               |    2 +-
 include/rdma/rdmavt_mr.h             |    2 +-
 include/rdma/rdmavt_qp.h             |    2 +-
 27 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
index c194d9d..9372c43 100644
--- a/drivers/infiniband/sw/rdmavt/ah.c
+++ b/drivers/infiniband/sw/rdmavt/ah.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/ah.h b/drivers/infiniband/sw/rdmavt/ah.h
index 8cd7ea7..e9c36be 100644
--- a/drivers/infiniband/sw/rdmavt/ah.h
+++ b/drivers/infiniband/sw/rdmavt/ah.h
@@ -2,7 +2,7 @@
 #define DEF_RVTAH_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 7308a27..055aa71 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/cq.h b/drivers/infiniband/sw/rdmavt/cq.h
index 3813d90..6182c29 100644
--- a/drivers/infiniband/sw/rdmavt/cq.h
+++ b/drivers/infiniband/sw/rdmavt/cq.h
@@ -2,7 +2,7 @@
 #define DEF_RVTCQ_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/dma.c b/drivers/infiniband/sw/rdmavt/dma.c
index c070141..33076a5 100644
--- a/drivers/infiniband/sw/rdmavt/dma.c
+++ b/drivers/infiniband/sw/rdmavt/dma.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/dma.h b/drivers/infiniband/sw/rdmavt/dma.h
index a80cc35..979f07e 100644
--- a/drivers/infiniband/sw/rdmavt/dma.h
+++ b/drivers/infiniband/sw/rdmavt/dma.h
@@ -2,7 +2,7 @@
 #define DEF_RDMAVTDMA_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/mad.c b/drivers/infiniband/sw/rdmavt/mad.c
index e01f3fb..5c720d3 100644
--- a/drivers/infiniband/sw/rdmavt/mad.c
+++ b/drivers/infiniband/sw/rdmavt/mad.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/mad.h b/drivers/infiniband/sw/rdmavt/mad.h
index 5d8a6a9..c89faf4 100644
--- a/drivers/infiniband/sw/rdmavt/mad.h
+++ b/drivers/infiniband/sw/rdmavt/mad.h
@@ -2,7 +2,7 @@
 #define DEF_RVTMAD_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/mcast.c b/drivers/infiniband/sw/rdmavt/mcast.c
index 528c1ca..e06a875 100644
--- a/drivers/infiniband/sw/rdmavt/mcast.c
+++ b/drivers/infiniband/sw/rdmavt/mcast.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/mcast.h b/drivers/infiniband/sw/rdmavt/mcast.h
index cd15a98..29f5792 100644
--- a/drivers/infiniband/sw/rdmavt/mcast.h
+++ b/drivers/infiniband/sw/rdmavt/mcast.h
@@ -2,7 +2,7 @@
 #define DEF_RVTMCAST_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
index fc30ff7..d6330d7 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.c
+++ b/drivers/infiniband/sw/rdmavt/mmap.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/mmap.h b/drivers/infiniband/sw/rdmavt/mmap.h
index 3513e25..e806747 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.h
+++ b/drivers/infiniband/sw/rdmavt/mmap.h
@@ -2,7 +2,7 @@
 #define DEF_RDMAVTMMAP_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index f1dcaf4..ee36be3 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/mr.h b/drivers/infiniband/sw/rdmavt/mr.h
index c5339aa..6938051 100644
--- a/drivers/infiniband/sw/rdmavt/mr.h
+++ b/drivers/infiniband/sw/rdmavt/mr.h
@@ -2,7 +2,7 @@
 #define DEF_RVTMR_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/pd.c b/drivers/infiniband/sw/rdmavt/pd.c
index f8dba88..62fee44 100644
--- a/drivers/infiniband/sw/rdmavt/pd.c
+++ b/drivers/infiniband/sw/rdmavt/pd.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/pd.h b/drivers/infiniband/sw/rdmavt/pd.h
index 56d75e6..1892ca4 100644
--- a/drivers/infiniband/sw/rdmavt/pd.h
+++ b/drivers/infiniband/sw/rdmavt/pd.h
@@ -2,7 +2,7 @@
 #define DEF_RDMAVTPD_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 615358e..8d3563a 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/qp.h b/drivers/infiniband/sw/rdmavt/qp.h
index f438809..8409f80 100644
--- a/drivers/infiniband/sw/rdmavt/qp.h
+++ b/drivers/infiniband/sw/rdmavt/qp.h
@@ -2,7 +2,7 @@
 #define DEF_RVTQP_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/srq.c b/drivers/infiniband/sw/rdmavt/srq.c
index bbb623a..c9eb8b3 100644
--- a/drivers/infiniband/sw/rdmavt/srq.c
+++ b/drivers/infiniband/sw/rdmavt/srq.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/srq.h b/drivers/infiniband/sw/rdmavt/srq.h
index 0c3c5a7..9f07880 100644
--- a/drivers/infiniband/sw/rdmavt/srq.h
+++ b/drivers/infiniband/sw/rdmavt/srq.h
@@ -2,7 +2,7 @@
 #define DEF_RVTSRQ_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/trace.c b/drivers/infiniband/sw/rdmavt/trace.c
index 19afe39..d593285 100644
--- a/drivers/infiniband/sw/rdmavt/trace.c
+++ b/drivers/infiniband/sw/rdmavt/trace.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/trace.h b/drivers/infiniband/sw/rdmavt/trace.h
index b269291..d5b1281 100644
--- a/drivers/infiniband/sw/rdmavt/trace.h
+++ b/drivers/infiniband/sw/rdmavt/trace.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 7496d43..571463e 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index d9f78cc..a5c36d3 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -2,7 +2,7 @@
 #define DEF_RDMAVT_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 31f9e5a..f6569b2 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -2,7 +2,7 @@
 #define DEF_RDMA_VT_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/include/rdma/rdmavt_mr.h b/include/rdma/rdmavt_mr.h
index 4aa8171..5edffdc 100644
--- a/include/rdma/rdmavt_mr.h
+++ b/include/rdma/rdmavt_mr.h
@@ -2,7 +2,7 @@
 #define DEF_RDMAVT_INCMR_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index f0e2426..91f20fd 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -2,7 +2,7 @@
 #define DEF_RDMAVT_INCQP_H
 
 /*
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2016 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
