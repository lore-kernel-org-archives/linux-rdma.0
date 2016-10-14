From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/8] Enable -Wredundant-decls
Date: Fri, 14 Oct 2016 16:14:13 -0600
Message-ID: <1476483257-16308-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1476483257-16308-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476483257-16308-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is useful to detect possible confusion/mistakes around function
prototypes.

Old libnl includes such a mistake so this warning is only turned on with
new distros.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt        | 20 ++++++++++++++++++++
 ibacm/src/acm_util.h  |  4 ++--
 libibverbs/neigh.c    |  3 ---
 librdmacm/preload.c   |  2 --
 providers/mlx4/mlx4.h |  6 ------
 5 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 58de78d6cde0..bd58a7039618 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -269,6 +269,23 @@ endif()
 RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WSTRICT_PROTOTYPES "-Wstrict-prototypes")
 RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WOLD_STYLE_DEFINITION "-Wold-style-definition")
 
+# Old versions of libnl have a duplicated rtnl_route_put, disbale the warning on those
+# systems
+if (NOT NL_KIND EQUAL 0)
+  set(SAFE_CMAKE_REQUIRED_INCLUDES "${CMAKE_REQUIRED_INCLUDES}")
+  set(SAFE_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
+  set(CMAKE_REQUIRED_INCLUDES "${NL_INCLUDE_DIRS}")
+  set(CMAKE_REQUIRED_FLAGS "-Wredundant-decls")
+  CHECK_C_SOURCE_COMPILES("
+ #include <netlink/route/route.h>
+ int main(int argc,const char *argv[]) { return 0; }"
+  HAVE_C_WREDUNDANT_DECLS
+  FAIL_REGEX "warning")
+  set(CMAKE_REQUIRED_INCLUDES "${SAFE_CMAKE_REQUIRED_INCLUDES}")
+  set(CMAKE_REQUIRED_FLAGS "${SAFE_CMAKE_REQUIRED_FLAGS}")
+endif()
+RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WREDUNDANT_DECLS "-Wredundant-decls")
+
 #-------------------------
 # Build Prep
 # Write out a git ignore file to the build directory if it isn't the source
@@ -354,3 +371,6 @@ endif()
 if (NOT HAVE_C_WORKING_MISSING_FIELD_INITIALIZERS)
   message(STATUS " -Wmissing-field-initializers does NOT work")
 endif()
+if (NOT HAVE_C_WREDUNDANT_DECLS)
+  message(STATUS " -Wredundant-decls does NOT work")
+endif()
diff --git a/ibacm/src/acm_util.h b/ibacm/src/acm_util.h
index 055122cbeb86..a83d915f13e8 100644
--- a/ibacm/src/acm_util.h
+++ b/ibacm/src/acm_util.h
@@ -31,17 +31,17 @@
 #define ACM_IF_H
 
 #include <infiniband/verbs.h>
+#include <infiniband/acm_prov.h>
 
 #ifdef ACME_PRINTS
 
+#undef acm_log
 #define acm_log(level, format, ...) \
 	printf(format, ## __VA_ARGS__)
 
 #else /* !ACME_PRINTS */
 #define acm_log(level, format, ...) \
 	acm_write(level, "%s: "format, __func__, ## __VA_ARGS__)
-
-void acm_write(int level, const char *format, ...);
 #endif /* ACME_PRINTS */
 
 int acm_if_is_ib(char *ifname);
diff --git a/libibverbs/neigh.c b/libibverbs/neigh.c
index 67a83eb0fd27..1856aab74842 100644
--- a/libibverbs/neigh.c
+++ b/libibverbs/neigh.c
@@ -36,9 +36,6 @@ extern unsigned int if_nametoindex(__const char *__ifname) __THROW;
 #define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define MIN(a, b) ((a) < (b) ? (a) : (b))
 
-/* Workaround - declaration missing */
-extern int		rtnl_link_vlan_get_id(struct rtnl_link *);
-
 #ifndef HAVE_LIBNL1
 #include <netlink/route/link/vlan.h>
 #endif
diff --git a/librdmacm/preload.c b/librdmacm/preload.c
index cf258bf8eb3a..c924f499b7c7 100644
--- a/librdmacm/preload.c
+++ b/librdmacm/preload.c
@@ -132,8 +132,6 @@ struct config_entry {
 
 static struct config_entry *config;
 static int config_cnt;
-extern char *program_invocation_short_name;
-
 
 static void free_config(void)
 {
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index a2d39e169c15..b851e953c36b 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -85,12 +85,6 @@ struct mlx4_xsrq_table {
 	int			  mask;
 };
 
-void mlx4_init_xsrq_table(struct mlx4_xsrq_table *xsrq_table, int size);
-struct mlx4_srq *mlx4_find_xsrq(struct mlx4_xsrq_table *xsrq_table, uint32_t srqn);
-int mlx4_store_xsrq(struct mlx4_xsrq_table *xsrq_table, uint32_t srqn,
-		    struct mlx4_srq *srq);
-void mlx4_clear_xsrq(struct mlx4_xsrq_table *xsrq_table, uint32_t srqn);
-
 enum {
 	MLX4_XRC_QPN_BIT     = (1 << 23)
 };
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
