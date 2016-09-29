From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 1/9] Remove HAVE_CONFIG_H
Date: Thu, 29 Sep 2016 14:47:48 -0600
Message-ID: <1475182076-5411-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "open list:HF1 USERSPACE PROVIDER for hf1.ko" <intel-opa-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The cmake build system guarantees this header exists, we do not need
the define or the test.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                      | 2 --
 ibacm/prov/acmp/src/acmp.c          | 4 +---
 ibacm/src/acm.c                     | 4 +---
 ibacm/src/acme.c                    | 4 +---
 ibacm/src/libacm.c                  | 4 +---
 libcxgb3/src/cq.c                   | 4 +---
 libcxgb3/src/iwch.c                 | 4 +---
 libcxgb3/src/qp.c                   | 4 +---
 libcxgb3/src/verbs.c                | 4 +---
 libcxgb4/src/cq.c                   | 4 +---
 libcxgb4/src/dev.c                  | 4 +---
 libcxgb4/src/qp.c                   | 4 +---
 libcxgb4/src/verbs.c                | 4 +---
 libhfi1verbs/src/hfiverbs.c         | 4 +---
 libhfi1verbs/src/verbs.c            | 4 +---
 libi40iw/src/i40iw_umain.c          | 2 --
 libi40iw/src/i40iw_uverbs.c         | 2 --
 libibcm/src/cm.c                    | 4 +---
 libibumad/src/sysfs.c               | 4 +---
 libibumad/src/umad.c                | 4 +---
 libibumad/tests/umad_reg2_compat.c  | 4 +---
 libibumad/tests/umad_register2.c    | 4 +---
 libibverbs/examples/asyncwatch.c    | 4 +---
 libibverbs/examples/device_list.c   | 4 +---
 libibverbs/examples/devinfo.c       | 4 +---
 libibverbs/examples/rc_pingpong.c   | 4 +---
 libibverbs/examples/srq_pingpong.c  | 4 +---
 libibverbs/examples/uc_pingpong.c   | 4 +---
 libibverbs/examples/ud_pingpong.c   | 4 +---
 libibverbs/examples/xsrq_pingpong.c | 4 +---
 libibverbs/src/cmd.c                | 4 +---
 libibverbs/src/compat-1_0.c         | 4 +---
 libibverbs/src/device.c             | 4 +---
 libibverbs/src/init.c               | 4 +---
 libibverbs/src/marshall.c           | 4 +---
 libibverbs/src/memory.c             | 4 +---
 libibverbs/src/sysfs.c              | 4 +---
 libibverbs/src/verbs.c              | 4 +---
 libipathverbs/src/ipathverbs.c      | 4 +---
 libipathverbs/src/verbs.c           | 4 +---
 libmlx4/src/buf.c                   | 4 +---
 libmlx4/src/cq.c                    | 4 +---
 libmlx4/src/dbrec.c                 | 4 +---
 libmlx4/src/mlx4.c                  | 4 +---
 libmlx4/src/qp.c                    | 4 +---
 libmlx4/src/srq.c                   | 4 +---
 libmlx4/src/verbs.c                 | 4 +---
 libmlx5/src/buf.c                   | 4 +---
 libmlx5/src/cq.c                    | 5 +----
 libmlx5/src/dbrec.c                 | 4 +---
 libmlx5/src/mlx5.c                  | 4 +---
 libmlx5/src/qp.c                    | 5 +----
 libmlx5/src/srq.c                   | 4 +---
 libmlx5/src/verbs.c                 | 4 +---
 libmthca/src/ah.c                   | 4 +---
 libmthca/src/buf.c                  | 4 +---
 libmthca/src/cq.c                   | 4 +---
 libmthca/src/memfree.c              | 4 +---
 libmthca/src/mthca.c                | 4 +---
 libmthca/src/qp.c                   | 4 +---
 libmthca/src/srq.c                  | 4 +---
 libmthca/src/verbs.c                | 4 +---
 libnes/src/nes_umain.c              | 2 --
 libnes/src/nes_uverbs.c             | 2 --
 libocrdma/src/ocrdma_main.c         | 2 --
 libocrdma/src/ocrdma_verbs.c        | 2 --
 librdmacm/src/acm.c                 | 4 +---
 librdmacm/src/addrinfo.c            | 4 +---
 librdmacm/src/cma.c                 | 4 +---
 librdmacm/src/cma.h                 | 4 +---
 librdmacm/src/indexer.c             | 4 +---
 librdmacm/src/indexer.h             | 4 +---
 librdmacm/src/preload.c             | 4 +---
 librdmacm/src/rsocket.c             | 4 +---
 librxe/src/rxe.c                    | 4 +---
 75 files changed, 68 insertions(+), 220 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 7e9e13262899..a6fc092d7994 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -93,8 +93,6 @@ endif()
 # Setup the basic C compiler
 RDMA_BuildType()
 include_directories(${BUILD_INCLUDE})
-# FIXME: Eliminate HAVE_CONFIG_H, we always have it.
-add_definitions(-DHAVE_CONFIG_H)
 
 # Require GNU99 mode
 RDMA_EnableCStd()
diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 75231bfef04f..ed68bd706f76 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -28,9 +28,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdarg.h>
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 41429e1db4d7..146fbff61857 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -28,9 +28,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdarg.h>
diff --git a/ibacm/src/acme.c b/ibacm/src/acme.c
index 4b5fe684c8e2..e96d36ff9fc0 100644
--- a/ibacm/src/acme.c
+++ b/ibacm/src/acme.c
@@ -28,9 +28,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/ibacm/src/libacm.c b/ibacm/src/libacm.c
index 3ad1db1d307b..def5b2cf5892 100644
--- a/ibacm/src/libacm.c
+++ b/ibacm/src/libacm.c
@@ -28,9 +28,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <osd.h>
 #include "libacm.h"
diff --git a/libcxgb3/src/cq.c b/libcxgb3/src/cq.c
index a6393d7b4fe3..1510d1e78631 100644
--- a/libcxgb3/src/cq.c
+++ b/libcxgb3/src/cq.c
@@ -29,9 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <netinet/in.h>
diff --git a/libcxgb3/src/iwch.c b/libcxgb3/src/iwch.c
index dd0d3711f2e2..aa9b10879d7a 100644
--- a/libcxgb3/src/iwch.c
+++ b/libcxgb3/src/iwch.c
@@ -29,9 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libcxgb3/src/qp.c b/libcxgb3/src/qp.c
index 7dd3c7e342a7..30dd898f6e87 100644
--- a/libcxgb3/src/qp.c
+++ b/libcxgb3/src/qp.c
@@ -29,9 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <netinet/in.h>
diff --git a/libcxgb3/src/verbs.c b/libcxgb3/src/verbs.c
index a2b737f2a192..0cb78d753d41 100644
--- a/libcxgb3/src/verbs.c
+++ b/libcxgb3/src/verbs.c
@@ -29,9 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/libcxgb4/src/cq.c b/libcxgb4/src/cq.c
index a33d48488967..1ed7dfdb88d4 100644
--- a/libcxgb4/src/cq.c
+++ b/libcxgb4/src/cq.c
@@ -29,9 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <syslog.h>
diff --git a/libcxgb4/src/dev.c b/libcxgb4/src/dev.c
index 8c3ecddc6a14..316fc0569f48 100644
--- a/libcxgb4/src/dev.c
+++ b/libcxgb4/src/dev.c
@@ -29,9 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libcxgb4/src/qp.c b/libcxgb4/src/qp.c
index 5444137c44bd..3c6d021095fc 100644
--- a/libcxgb4/src/qp.c
+++ b/libcxgb4/src/qp.c
@@ -29,9 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <assert.h>
 #include <stdlib.h>
diff --git a/libcxgb4/src/verbs.c b/libcxgb4/src/verbs.c
index aed547dc8ab1..70d250f30701 100644
--- a/libcxgb4/src/verbs.c
+++ b/libcxgb4/src/verbs.c
@@ -29,9 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/libhfi1verbs/src/hfiverbs.c b/libhfi1verbs/src/hfiverbs.c
index ced438d1a70b..d2b7dd450992 100644
--- a/libhfi1verbs/src/hfiverbs.c
+++ b/libhfi1verbs/src/hfiverbs.c
@@ -55,9 +55,7 @@
 
 */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libhfi1verbs/src/verbs.c b/libhfi1verbs/src/verbs.c
index e245ad9e5b4f..20d4352094af 100644
--- a/libhfi1verbs/src/verbs.c
+++ b/libhfi1verbs/src/verbs.c
@@ -55,9 +55,7 @@
 
 */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libi40iw/src/i40iw_umain.c b/libi40iw/src/i40iw_umain.c
index ef694a025075..1756e65ee6be 100644
--- a/libi40iw/src/i40iw_umain.c
+++ b/libi40iw/src/i40iw_umain.c
@@ -32,9 +32,7 @@
 *
 *******************************************************************************/
 
-#if HAVE_CONFIG_H
 #include <config.h>
-#endif
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libi40iw/src/i40iw_uverbs.c b/libi40iw/src/i40iw_uverbs.c
index 8369e10f61ee..3a6799a9b50f 100644
--- a/libi40iw/src/i40iw_uverbs.c
+++ b/libi40iw/src/i40iw_uverbs.c
@@ -32,9 +32,7 @@
 *
 *******************************************************************************/
 
-#if HAVE_CONFIG_H
 #include <config.h>
-#endif
 
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/libibcm/src/cm.c b/libibcm/src/cm.c
index f5318f01fb61..ebe36bef89e6 100644
--- a/libibcm/src/cm.c
+++ b/libibcm/src/cm.c
@@ -33,9 +33,7 @@
  * $Id$
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <string.h>
diff --git a/libibumad/src/sysfs.c b/libibumad/src/sysfs.c
index 5d9460851897..d10f312285ea 100644
--- a/libibumad/src/sysfs.c
+++ b/libibumad/src/sysfs.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  *
  */
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <inttypes.h>
 #include <string.h>
diff --git a/libibumad/src/umad.c b/libibumad/src/umad.c
index a7879d385466..176d112e125b 100644
--- a/libibumad/src/umad.c
+++ b/libibumad/src/umad.c
@@ -32,9 +32,7 @@
  *
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <sys/poll.h>
 #include <unistd.h>
diff --git a/libibumad/tests/umad_reg2_compat.c b/libibumad/tests/umad_reg2_compat.c
index 9c239ee4bfae..264882ccc0c1 100644
--- a/libibumad/tests/umad_reg2_compat.c
+++ b/libibumad/tests/umad_reg2_compat.c
@@ -31,9 +31,7 @@
  *
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <string.h>
 #include <stdio.h>
diff --git a/libibumad/tests/umad_register2.c b/libibumad/tests/umad_register2.c
index ed7e816bb63c..7a9b655ae794 100644
--- a/libibumad/tests/umad_register2.c
+++ b/libibumad/tests/umad_register2.c
@@ -31,9 +31,7 @@
  *
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif				/* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <string.h>
 #include <stdio.h>
diff --git a/libibverbs/examples/asyncwatch.c b/libibverbs/examples/asyncwatch.c
index c78994d24bed..7af13bf936ec 100644
--- a/libibverbs/examples/asyncwatch.c
+++ b/libibverbs/examples/asyncwatch.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <endian.h>
diff --git a/libibverbs/examples/device_list.c b/libibverbs/examples/device_list.c
index 70c3af51b6c3..13f40ad63007 100644
--- a/libibverbs/examples/device_list.c
+++ b/libibverbs/examples/device_list.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 
diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
index e814bacdf7aa..5fd1affa455d 100644
--- a/libibverbs/examples/devinfo.c
+++ b/libibverbs/examples/devinfo.c
@@ -31,9 +31,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index 5aa3417c6e23..c92e551c00e6 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libibverbs/examples/srq_pingpong.c b/libibverbs/examples/srq_pingpong.c
index f17972580b57..863ff10dd0f4 100644
--- a/libibverbs/examples/srq_pingpong.c
+++ b/libibverbs/examples/srq_pingpong.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libibverbs/examples/uc_pingpong.c b/libibverbs/examples/uc_pingpong.c
index 7d982d36a5ef..2b105b947cf3 100644
--- a/libibverbs/examples/uc_pingpong.c
+++ b/libibverbs/examples/uc_pingpong.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libibverbs/examples/ud_pingpong.c b/libibverbs/examples/ud_pingpong.c
index deefb9b81013..d0cd73cc0fae 100644
--- a/libibverbs/examples/ud_pingpong.c
+++ b/libibverbs/examples/ud_pingpong.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libibverbs/examples/xsrq_pingpong.c b/libibverbs/examples/xsrq_pingpong.c
index 903548ed6824..c22893e0e721 100644
--- a/libibverbs/examples/xsrq_pingpong.c
+++ b/libibverbs/examples/xsrq_pingpong.c
@@ -31,9 +31,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <fcntl.h>
diff --git a/libibverbs/src/cmd.c b/libibverbs/src/cmd.c
index 11f65095b784..06a017b0c9b8 100644
--- a/libibverbs/src/cmd.c
+++ b/libibverbs/src/cmd.c
@@ -32,9 +32,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <unistd.h>
diff --git a/libibverbs/src/compat-1_0.c b/libibverbs/src/compat-1_0.c
index 6b1961d19ede..b286fd73eb01 100644
--- a/libibverbs/src/compat-1_0.c
+++ b/libibverbs/src/compat-1_0.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <string.h>
 #include <stddef.h>
diff --git a/libibverbs/src/device.c b/libibverbs/src/device.c
index cfdf7cfd337c..b4864e3e384b 100644
--- a/libibverbs/src/device.c
+++ b/libibverbs/src/device.c
@@ -31,9 +31,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <netinet/in.h>
diff --git a/libibverbs/src/init.c b/libibverbs/src/init.c
index 7ae0fc87d332..779756938a32 100644
--- a/libibverbs/src/init.c
+++ b/libibverbs/src/init.c
@@ -31,9 +31,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <string.h>
diff --git a/libibverbs/src/marshall.c b/libibverbs/src/marshall.c
index 577b4b1ec2f9..a33048404d35 100644
--- a/libibverbs/src/marshall.c
+++ b/libibverbs/src/marshall.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <string.h>
 
diff --git a/libibverbs/src/memory.c b/libibverbs/src/memory.c
index 89509c6e356f..8e728c4f61fc 100644
--- a/libibverbs/src/memory.c
+++ b/libibverbs/src/memory.c
@@ -31,9 +31,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <errno.h>
 #include <sys/mman.h>
diff --git a/libibverbs/src/sysfs.c b/libibverbs/src/sysfs.c
index 2e68da4bc97f..d463241ade08 100644
--- a/libibverbs/src/sysfs.c
+++ b/libibverbs/src/sysfs.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libibverbs/src/verbs.c b/libibverbs/src/verbs.c
index debb6f687111..b470ba043658 100644
--- a/libibverbs/src/verbs.c
+++ b/libibverbs/src/verbs.c
@@ -32,9 +32,7 @@
  */
 
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <netinet/in.h>
diff --git a/libipathverbs/src/ipathverbs.c b/libipathverbs/src/ipathverbs.c
index 2ae1689a1131..9a19d0ab98ae 100644
--- a/libipathverbs/src/ipathverbs.c
+++ b/libipathverbs/src/ipathverbs.c
@@ -35,9 +35,7 @@
  * product whatsoever.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libipathverbs/src/verbs.c b/libipathverbs/src/verbs.c
index 578a38af3428..12ca35f32189 100644
--- a/libipathverbs/src/verbs.c
+++ b/libipathverbs/src/verbs.c
@@ -35,9 +35,7 @@
  * product whatsoever.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libmlx4/src/buf.c b/libmlx4/src/buf.c
index c06b3fded82c..9b41e7f62525 100644
--- a/libmlx4/src/buf.c
+++ b/libmlx4/src/buf.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <errno.h>
diff --git a/libmlx4/src/cq.c b/libmlx4/src/cq.c
index 2edbec8e327d..23cc3ed69dc8 100644
--- a/libmlx4/src/cq.c
+++ b/libmlx4/src/cq.c
@@ -32,9 +32,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libmlx4/src/dbrec.c b/libmlx4/src/dbrec.c
index 21ff93664df4..26d696fb94ae 100644
--- a/libmlx4/src/dbrec.c
+++ b/libmlx4/src/dbrec.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <netinet/in.h>
diff --git a/libmlx4/src/mlx4.c b/libmlx4/src/mlx4.c
index 1757ca325447..326ead4136f8 100644
--- a/libmlx4/src/mlx4.c
+++ b/libmlx4/src/mlx4.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libmlx4/src/qp.c b/libmlx4/src/qp.c
index 1b730bfea4b8..4b5acd71108e 100644
--- a/libmlx4/src/qp.c
+++ b/libmlx4/src/qp.c
@@ -32,9 +32,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <netinet/in.h>
diff --git a/libmlx4/src/srq.c b/libmlx4/src/srq.c
index 28bc2d41cdce..c0e028671828 100644
--- a/libmlx4/src/srq.c
+++ b/libmlx4/src/srq.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <netinet/in.h>
diff --git a/libmlx4/src/verbs.c b/libmlx4/src/verbs.c
index 5cc82cf38763..50a44340639b 100644
--- a/libmlx4/src/verbs.c
+++ b/libmlx4/src/verbs.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/libmlx5/src/buf.c b/libmlx5/src/buf.c
index 1a681c6a3eaf..7e06095d0352 100644
--- a/libmlx5/src/buf.c
+++ b/libmlx5/src/buf.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <signal.h>
 #include <sys/ipc.h>
diff --git a/libmlx5/src/cq.c b/libmlx5/src/cq.c
index 5ad076c40d91..2a53c897706f 100644
--- a/libmlx5/src/cq.c
+++ b/libmlx5/src/cq.c
@@ -30,10 +30,7 @@
  * SOFTWARE.
  */
 
-
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libmlx5/src/dbrec.c b/libmlx5/src/dbrec.c
index dbc0e650b6f4..3af81124ed95 100644
--- a/libmlx5/src/dbrec.c
+++ b/libmlx5/src/dbrec.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <netinet/in.h>
diff --git a/libmlx5/src/mlx5.c b/libmlx5/src/mlx5.c
index 058b52fcd5f6..121a833062f1 100644
--- a/libmlx5/src/mlx5.c
+++ b/libmlx5/src/mlx5.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libmlx5/src/qp.c b/libmlx5/src/qp.c
index 9363fddc3f3c..04abe1588d6e 100644
--- a/libmlx5/src/qp.c
+++ b/libmlx5/src/qp.c
@@ -30,10 +30,7 @@
  * SOFTWARE.
  */
 
-
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <netinet/in.h>
diff --git a/libmlx5/src/srq.c b/libmlx5/src/srq.c
index 24979bfb69ab..a06afa3a5931 100644
--- a/libmlx5/src/srq.c
+++ b/libmlx5/src/srq.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <netinet/in.h>
diff --git a/libmlx5/src/verbs.c b/libmlx5/src/verbs.c
index 4be602be8025..58673f4433fd 100644
--- a/libmlx5/src/verbs.c
+++ b/libmlx5/src/verbs.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/libmthca/src/ah.c b/libmthca/src/ah.c
index d7494d57f960..e83d66527839 100644
--- a/libmthca/src/ah.c
+++ b/libmthca/src/ah.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <netinet/in.h>
diff --git a/libmthca/src/buf.c b/libmthca/src/buf.c
index 074a5f8dc710..78e7b89c4db5 100644
--- a/libmthca/src/buf.c
+++ b/libmthca/src/buf.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <sys/mman.h>
diff --git a/libmthca/src/cq.c b/libmthca/src/cq.c
index 8b4a6a862d1a..d71d430c6e28 100644
--- a/libmthca/src/cq.c
+++ b/libmthca/src/cq.c
@@ -32,9 +32,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libmthca/src/memfree.c b/libmthca/src/memfree.c
index 87de4c0f5899..77a80e24b95f 100644
--- a/libmthca/src/memfree.c
+++ b/libmthca/src/memfree.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <netinet/in.h>
diff --git a/libmthca/src/mthca.c b/libmthca/src/mthca.c
index e33bf7ff8559..d6bda2d29d66 100644
--- a/libmthca/src/mthca.c
+++ b/libmthca/src/mthca.c
@@ -31,9 +31,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libmthca/src/qp.c b/libmthca/src/qp.c
index 84dd206d9125..715ca65e9bd6 100644
--- a/libmthca/src/qp.c
+++ b/libmthca/src/qp.c
@@ -31,9 +31,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <netinet/in.h>
diff --git a/libmthca/src/srq.c b/libmthca/src/srq.c
index 97a0c743f5f7..ff6f532733f4 100644
--- a/libmthca/src/srq.c
+++ b/libmthca/src/srq.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <netinet/in.h>
diff --git a/libmthca/src/verbs.c b/libmthca/src/verbs.c
index b6782c9865eb..b3bce82affae 100644
--- a/libmthca/src/verbs.c
+++ b/libmthca/src/verbs.c
@@ -31,9 +31,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/libnes/src/nes_umain.c b/libnes/src/nes_umain.c
index 16ce3f13c702..b4e0bc136160 100644
--- a/libnes/src/nes_umain.c
+++ b/libnes/src/nes_umain.c
@@ -31,9 +31,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
 #include <config.h>
-#endif				/* HAVE_CONFIG_H */
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libnes/src/nes_uverbs.c b/libnes/src/nes_uverbs.c
index 983d87a80b8b..7c2454e7f55a 100644
--- a/libnes/src/nes_uverbs.c
+++ b/libnes/src/nes_uverbs.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
 #include <config.h>
-#endif				/* HAVE_CONFIG_H */
 
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/libocrdma/src/ocrdma_main.c b/libocrdma/src/ocrdma_main.c
index 064ecb318c4c..f3830d9fc5d3 100644
--- a/libocrdma/src/ocrdma_main.c
+++ b/libocrdma/src/ocrdma_main.c
@@ -32,9 +32,7 @@
  * THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#if HAVE_CONFIG_H
 #include <config.h>
-#endif				/* HAVE_CONFIG_H */
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/libocrdma/src/ocrdma_verbs.c b/libocrdma/src/ocrdma_verbs.c
index 628e4bf18b43..6d58cb219fe1 100644
--- a/libocrdma/src/ocrdma_verbs.c
+++ b/libocrdma/src/ocrdma_verbs.c
@@ -32,9 +32,7 @@
  * THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#if HAVE_CONFIG_H
 #include <config.h>
-#endif				/* HAVE_CONFIG_H */
 
 #include <assert.h>
 #include <stdlib.h>
diff --git a/librdmacm/src/acm.c b/librdmacm/src/acm.c
index 823381aac367..ad6706b2592e 100644
--- a/librdmacm/src/acm.c
+++ b/librdmacm/src/acm.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <inttypes.h>
diff --git a/librdmacm/src/addrinfo.c b/librdmacm/src/addrinfo.c
index 046b8be11be1..2f4e674e1ebb 100644
--- a/librdmacm/src/addrinfo.c
+++ b/librdmacm/src/addrinfo.c
@@ -32,9 +32,7 @@
  * $Id: cm.c 3453 2005-09-15 21:43:21Z sean.hefty $
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <sys/types.h>
 #include <sys/socket.h>
diff --git a/librdmacm/src/cma.c b/librdmacm/src/cma.c
index a89e663bcaab..77f6fea38c6b 100644
--- a/librdmacm/src/cma.c
+++ b/librdmacm/src/cma.c
@@ -30,9 +30,7 @@
  * SOFTWARE.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <string.h>
diff --git a/librdmacm/src/cma.h b/librdmacm/src/cma.h
index ce428deba849..d6005538227f 100644
--- a/librdmacm/src/cma.h
+++ b/librdmacm/src/cma.h
@@ -34,9 +34,7 @@
 #if !defined(CMA_H)
 #define CMA_H
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdlib.h>
 #include <errno.h>
diff --git a/librdmacm/src/indexer.c b/librdmacm/src/indexer.c
index be2e69c895c2..00be7d04cc93 100644
--- a/librdmacm/src/indexer.c
+++ b/librdmacm/src/indexer.c
@@ -31,9 +31,7 @@
  *
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <errno.h>
 #include <sys/types.h>
diff --git a/librdmacm/src/indexer.h b/librdmacm/src/indexer.h
index 0c5f3882673f..2d1e46ecabd4 100644
--- a/librdmacm/src/indexer.h
+++ b/librdmacm/src/indexer.h
@@ -34,9 +34,7 @@
 #if !defined(INDEXER_H)
 #define INDEXER_H
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <sys/types.h>
 
diff --git a/librdmacm/src/preload.c b/librdmacm/src/preload.c
index 2a90f79b226c..cf258bf8eb3a 100644
--- a/librdmacm/src/preload.c
+++ b/librdmacm/src/preload.c
@@ -31,9 +31,7 @@
  *
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <sys/types.h>
 #include <sys/socket.h>
diff --git a/librdmacm/src/rsocket.c b/librdmacm/src/rsocket.c
index 488d44fb3654..7e7a38ee82b6 100644
--- a/librdmacm/src/rsocket.c
+++ b/librdmacm/src/rsocket.c
@@ -31,9 +31,7 @@
  *
  */
 #define _GNU_SOURCE
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <sys/types.h>
 #include <sys/socket.h>
diff --git a/librxe/src/rxe.c b/librxe/src/rxe.c
index 7164f6627171..6bd04d696c41 100644
--- a/librxe/src/rxe.c
+++ b/librxe/src/rxe.c
@@ -37,9 +37,7 @@
  * product whatsoever.
  */
 
-#if HAVE_CONFIG_H
-#  include <config.h>
-#endif /* HAVE_CONFIG_H */
+#include <config.h>
 
 #include <stdio.h>
 #include <stdlib.h>
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
