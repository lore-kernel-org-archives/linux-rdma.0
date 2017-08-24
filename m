From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core] verbs: Encode the private ABI version number in
 verbs_register_driver
Date: Thu, 24 Aug 2017 15:56:01 -0600
Message-ID: <20170824215601.GA19717@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This causes the symbol table to look like:

   208: 000000000000c000   142 FUNC    GLOBAL DEFAULT   13 verbs_register_driver_15@@IBVERBS_PRIVATE_15

Which encodes the expected private ABI version inside the symbol name
as well as with the symbol version.

This ensures that the ABI version is checked even if the linking
environment does not include symbol versions, for instance if an
end user is linking a provider static library to the system dynamic
libibverbs.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/config.h.in         |  1 +
 libibverbs/driver.h          | 11 +++++++++++
 libibverbs/libibverbs.map.in |  2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

Since Leon says people are using static provider libraries we should
do more to make sure they work right.

diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index b879bc9034d328..f477559aeac6d2 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -25,6 +25,7 @@
 
 #define VERBS_PROVIDER_DIR "@VERBS_PROVIDER_DIR@"
 #define VERBS_PROVIDER_SUFFIX "@IBVERBS_PROVIDER_SUFFIX@"
+#define IBVERBS_PABI_VERSION @IBVERBS_PABI_VERSION@
 
 // FIXME This has been supported in compilers forever, we should just fail to build on such old systems.
 #cmakedefine HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE 1
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 8ece40e28629b9..887412de6327c3 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -39,6 +39,7 @@
 #include <infiniband/verbs.h>
 #include <infiniband/kern-abi.h>
 #include <ccan/list.h>
+#include <config.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -128,6 +129,16 @@ verbs_get_device(const struct ibv_device *dev)
 
 typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_sys_path,
 						       int abi_version);
+
+/* Wire the IBVERBS_PRIVATE version number into the verbs_register_driver
+ * symbol name.  This guarentees we link to the correct set of symbols even if
+ * statically linking or using a dynmic linker with symbol versioning turned
+ * off.
+ */
+#define ___make_verbs_register_driver(x) verbs_register_driver_ ## x
+#define __make_verbs_register_driver(x)  ___make_verbs_register_driver(x)
+#define verbs_register_driver __make_verbs_register_driver(IBVERBS_PABI_VERSION)
+
 void verbs_register_driver(const char *name, verbs_driver_init_func init_func);
 void verbs_init_cq(struct ibv_cq *cq, struct ibv_context *context,
 		       struct ibv_comp_channel *channel,
diff --git a/libibverbs/libibverbs.map.in b/libibverbs/libibverbs.map.in
index a1124421bf364d..39d9d05100a5f9 100644
--- a/libibverbs/libibverbs.map.in
+++ b/libibverbs/libibverbs.map.in
@@ -137,6 +137,6 @@ IBVERBS_PRIVATE_@IBVERBS_PABI_VERSION@ {
 		ibv_cmd_resize_cq;
 		ibv_query_gid_type;
 		ibv_register_driver;
-		verbs_register_driver;
+		verbs_register_driver_@IBVERBS_PABI_VERSION@;
 		verbs_init_cq;
 };
-- 
2.7.4


-- 
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
