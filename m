From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH for-next] IB/hfi: Fix up comments in engine mapping
Date: Fri, 31 Mar 2017 13:04:51 -0400
Message-ID: <1490979892-19031-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fix off by 1 error in comments documenting the sdma and send context
mappings.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/pio.h  | 26 +++++++++++-----------
 drivers/infiniband/hw/hfi1/sdma.h | 46 +++++++++++++++++++--------------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.h b/drivers/infiniband/hw/hfi1/pio.h
index 867e5ffc3595..6678e7a40355 100644
--- a/drivers/infiniband/hw/hfi1/pio.h
+++ b/drivers/infiniband/hw/hfi1/pio.h
@@ -195,7 +195,7 @@ struct sc_config_sizes {
  *      |    mask                  |              --/  |--------------------|
  *      |--------------------------|            -/     |        *           |
  *      |    actual_vls (max 8)    |          -/       |--------------------|
- *      |--------------------------|       --/         | ksc[n] -> sc n     |
+ *      |--------------------------|       --/         | ksc[n-1] -> sc n   |
  *      |    vls (max 8)           |     -/            +--------------------+
  *      |--------------------------|  --/
  *      |    map[0]                |-/
@@ -208,21 +208,21 @@ struct sc_config_sizes {
  *      |--------------------------|                   |--------------------|
  *      |   map[vls - 1]           |-                  |         *          |
  *      +--------------------------+ \-                |--------------------|
- *                                     \-              | ksc[m] -> sc m+n   |
+ *                                     \-              | ksc[m-1] -> sc m+n |
  *                                       \             +--------------------+
  *                                        \-
  *                                          \
- *                                           \-        +--------------------+
- *                                             \-      |       mask         |
- *                                               \     |--------------------|
- *                                                \-   | ksc[0] -> sc 1+m+n |
- *                                                  \- |--------------------|
- *                                                    >| ksc[1] -> sc 2+m+n |
- *                                                     |--------------------|
- *                                                     |         *          |
- *                                                     |--------------------|
- *                                                     | ksc[o] -> sc o+m+n |
- *                                                     +--------------------+
+ *                                           \-        +----------------------+
+ *                                             \-      |       mask           |
+ *                                               \     |----------------------|
+ *                                                \-   | ksc[0] -> sc 1+m+n   |
+ *                                                  \- |----------------------|
+ *                                                    >| ksc[1] -> sc 2+m+n   |
+ *                                                     |----------------------|
+ *                                                     |         *            |
+ *                                                     |----------------------|
+ *                                                     | ksc[o-1] -> sc o+m+n |
+ *                                                     +----------------------+
  *
  */
 
diff --git a/drivers/infiniband/hw/hfi1/sdma.h b/drivers/infiniband/hw/hfi1/sdma.h
index 21f1e2834f37..64f10b8b5db8 100644
--- a/drivers/infiniband/hw/hfi1/sdma.h
+++ b/drivers/infiniband/hw/hfi1/sdma.h
@@ -966,34 +966,34 @@ static inline void sdma_iowait_schedule(
  *      |    mask                  |              --/  |--------------------|
  *      |--------------------------|            -/     |        *           |
  *      |    actual_vls (max 8)    |          -/       |--------------------|
- *      |--------------------------|       --/         | sde[n] -> eng n    |
+ *      |--------------------------|       --/         | sde[n-1] -> eng n  |
  *      |    vls (max 8)           |     -/            +--------------------+
  *      |--------------------------|  --/
  *      |    map[0]                |-/
- *      |--------------------------|                   +--------------------+
- *      |    map[1]                |---                |       mask         |
- *      |--------------------------|   \----           |--------------------|
- *      |           *              |        \--        | sde[0] -> eng 1+n  |
- *      |           *              |           \----   |--------------------|
- *      |           *              |                \->| sde[1] -> eng 2+n  |
- *      |--------------------------|                   |--------------------|
- *      |   map[vls - 1]           |-                  |         *          |
- *      +--------------------------+ \-                |--------------------|
- *                                     \-              | sde[m] -> eng m+n  |
- *                                       \             +--------------------+
+ *      |--------------------------|                   +---------------------+
+ *      |    map[1]                |---                |       mask          |
+ *      |--------------------------|   \----           |---------------------|
+ *      |           *              |        \--        | sde[0] -> eng 1+n   |
+ *      |           *              |           \----   |---------------------|
+ *      |           *              |                \->| sde[1] -> eng 2+n   |
+ *      |--------------------------|                   |---------------------|
+ *      |   map[vls - 1]           |-                  |         *           |
+ *      +--------------------------+ \-                |---------------------|
+ *                                     \-              | sde[m-1] -> eng m+n |
+ *                                       \             +---------------------+
  *                                        \-
  *                                          \
- *                                           \-        +--------------------+
- *                                             \-      |       mask         |
- *                                               \     |--------------------|
- *                                                \-   | sde[0] -> eng 1+m+n|
- *                                                  \- |--------------------|
- *                                                    >| sde[1] -> eng 2+m+n|
- *                                                     |--------------------|
- *                                                     |         *          |
- *                                                     |--------------------|
- *                                                     | sde[o] -> eng o+m+n|
- *                                                     +--------------------+
+ *                                           \-        +----------------------+
+ *                                             \-      |       mask           |
+ *                                               \     |----------------------|
+ *                                                \-   | sde[0] -> eng 1+m+n  |
+ *                                                  \- |----------------------|
+ *                                                    >| sde[1] -> eng 2+m+n  |
+ *                                                     |----------------------|
+ *                                                     |         *            |
+ *                                                     |----------------------|
+ *                                                     | sde[o-1] -> eng o+m+n|
+ *                                                     +----------------------+
  *
  */
 
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
