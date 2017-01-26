From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core] Make the provider facing libibverbs interface
 private
Date: Thu, 26 Jan 2017 16:08:13 -0700
Message-ID: <20170126230813.GA7149@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The first part is to remove the header files that define the
prototypes for these symbols from the set of packaged headers.
This ensures that nothing can compile and use these symbols.

Next we move the symbols into a new symbol version stanza only
for the private ABI. This breaks every existing out of-tree provider,
but the earlier change to ibv_cmd_create_ah already did that.

There are a few symbols that are still private by virtue of not being
in public headers, but these are used internally by the other libraries.
For distribution sanity continue to treat them as public ABI.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 Documentation/versioning.md   |  22 ++++++++
 debian/control                |   2 +-
 debian/libibverbs-dev.install |   3 --
 debian/libibverbs1.symbols    |  44 +--------------
 libibverbs/CMakeLists.txt     |   9 ++--
 libibverbs/libibverbs.map     | 122 +++++++++++++++++++++---------------------
 6 files changed, 93 insertions(+), 109 deletions(-)

diff --git a/Documentation/versioning.md b/Documentation/versioning.md
index b887b26e7b5825..eaa392803edc5e 100644
--- a/Documentation/versioning.md
+++ b/Documentation/versioning.md
@@ -126,3 +126,25 @@ $ readelf -s build/lib/libibumad.so.3.1.11
 ```
 
 Finally update the `debian/libibumad3.symbols` file.
+
+## Private symbols in libibverbs
+
+Many symbols in libibverbs are private to rdma-core, they are being marked in
+the map file using the IBVERBS_PRIVATE_ prefix.
+
+For simplicity, there is only one version of the private symbol version
+stanza, and it is bumped whenever any change (add/remove/modify) to any of the
+private ABI is done. This makes it very clear if an incompatible provider is
+being used with libibverbs.
+
+Due to this there is no reason to provide compat symbol versions for the
+private ABI.
+
+### Use of private symbols between component packages
+
+A distribution packaging system still must have the correct dependencies
+between libraries within rdma-core that may use these private symbols.
+
+For this reason the private symbols can only be used by provider libraries and
+the distribution must ensure that a matched set of provider libraries and
+libibverbs are installed.
diff --git a/debian/control b/debian/control
index eb58a244074ede..69fe97ecf27544 100644
--- a/debian/control
+++ b/debian/control
@@ -47,7 +47,7 @@ Description: Examples for the libibverbs library
 Package: ibverbs-providers
 Section: net
 Architecture: linux-any
-Depends: ${misc:Depends}, ${perl:Depends}, ${shlibs:Depends}
+Depends: libibverbs1 (= ${binary:Version}), ${misc:Depends}, ${perl:Depends}, ${shlibs:Depends}
 Provides: libcxgb3-1, libipathverbs1, libmlx4-1, libmlx5-1, libmthca1, libnes1
 Replaces: libcxgb3-1, libipathverbs1, libmlx4-1, libmlx5-1, libmthca1, libnes1
 Breaks: libcxgb3-1, libipathverbs1, libmlx4-1, libmlx5-1, libmthca1, libnes1
diff --git a/debian/libibverbs-dev.install b/debian/libibverbs-dev.install
index 4eb9296a8596be..0ddb0a8ebfd1e2 100644
--- a/debian/libibverbs-dev.install
+++ b/debian/libibverbs-dev.install
@@ -1,7 +1,4 @@
-usr/include/infiniband/arch.h
-usr/include/infiniband/driver.h
 usr/include/infiniband/kern-abi.h
-usr/include/infiniband/marshall.h
 usr/include/infiniband/opcode.h
 usr/include/infiniband/sa-kern-abi.h
 usr/include/infiniband/sa.h
diff --git a/debian/libibverbs1.symbols b/debian/libibverbs1.symbols
index b9c12f6b87ee20..c86f8952c4aa2e 100644
--- a/debian/libibverbs1.symbols
+++ b/debian/libibverbs1.symbols
@@ -1,6 +1,8 @@
 libibverbs.so.1 libibverbs1 #MINVER#
  IBVERBS_1.0@IBVERBS_1.0 1.1.6
  IBVERBS_1.1@IBVERBS_1.1 1.1.6
+# This version should always reflect the current package version.
+ (regex|optional)"@IBVERBS_PRIVATE_" 12-1
  ibv_ack_async_event@IBVERBS_1.0 1.1.6
  ibv_ack_async_event@IBVERBS_1.1 1.1.6
  ibv_ack_cq_events@IBVERBS_1.0 1.1.6
@@ -11,46 +13,6 @@ libibverbs.so.1 libibverbs1 #MINVER#
  ibv_attach_mcast@IBVERBS_1.1 1.1.6
  ibv_close_device@IBVERBS_1.0 1.1.6
  ibv_close_device@IBVERBS_1.1 1.1.6
- ibv_cmd_alloc_mw@IBVERBS_1.1 1.2.1
- ibv_cmd_alloc_pd@IBVERBS_1.0 1.1.6
- ibv_cmd_attach_mcast@IBVERBS_1.0 1.1.6
- ibv_cmd_close_xrcd@IBVERBS_1.1 1.1.8
- ibv_cmd_create_ah@IBVERBS_1.0 1.1.6
- ibv_cmd_create_cq@IBVERBS_1.0 1.1.6
- ibv_cmd_create_cq_ex@IBVERBS_1.0 1.2.1
- ibv_cmd_create_flow@IBVERBS_1.0 1.1.8
- ibv_cmd_create_qp@IBVERBS_1.0 1.1.6
- ibv_cmd_create_qp_ex2@IBVERBS_1.1 1.2.1
- ibv_cmd_create_qp_ex@IBVERBS_1.1 1.1.8
- ibv_cmd_create_srq@IBVERBS_1.0 1.1.6
- ibv_cmd_create_srq_ex@IBVERBS_1.1 1.1.8
- ibv_cmd_dealloc_mw@IBVERBS_1.1 1.2.1
- ibv_cmd_dealloc_pd@IBVERBS_1.0 1.1.6
- ibv_cmd_dereg_mr@IBVERBS_1.0 1.1.6
- ibv_cmd_destroy_ah@IBVERBS_1.0 1.1.6
- ibv_cmd_destroy_cq@IBVERBS_1.0 1.1.6
- ibv_cmd_destroy_flow@IBVERBS_1.0 1.1.8
- ibv_cmd_destroy_qp@IBVERBS_1.0 1.1.6
- ibv_cmd_destroy_srq@IBVERBS_1.0 1.1.6
- ibv_cmd_detach_mcast@IBVERBS_1.0 1.1.6
- ibv_cmd_get_context@IBVERBS_1.0 1.1.6
- ibv_cmd_modify_qp@IBVERBS_1.0 1.1.6
- ibv_cmd_modify_srq@IBVERBS_1.0 1.1.6
- ibv_cmd_open_qp@IBVERBS_1.1 1.1.8
- ibv_cmd_open_xrcd@IBVERBS_1.1 1.1.8
- ibv_cmd_poll_cq@IBVERBS_1.0 1.1.6
- ibv_cmd_post_recv@IBVERBS_1.0 1.1.6
- ibv_cmd_post_send@IBVERBS_1.0 1.1.6
- ibv_cmd_post_srq_recv@IBVERBS_1.0 1.1.6
- ibv_cmd_query_device@IBVERBS_1.0 1.1.6
- ibv_cmd_query_device_ex@IBVERBS_1.0 1.2.0
- ibv_cmd_query_port@IBVERBS_1.0 1.1.6
- ibv_cmd_query_qp@IBVERBS_1.0 1.1.6
- ibv_cmd_query_srq@IBVERBS_1.0 1.1.6
- ibv_cmd_reg_mr@IBVERBS_1.0 1.1.6
- ibv_cmd_req_notify_cq@IBVERBS_1.0 1.1.6
- ibv_cmd_rereg_mr@IBVERBS_1.1 1.2.1
- ibv_cmd_resize_cq@IBVERBS_1.0 1.1.6
  ibv_copy_ah_attr_from_kern@IBVERBS_1.1 1.1.6
  ibv_copy_path_rec_from_kern@IBVERBS_1.0 1.1.6
  ibv_copy_path_rec_to_kern@IBVERBS_1.0 1.1.6
@@ -123,7 +85,6 @@ libibverbs.so.1 libibverbs1 #MINVER#
  ibv_read_sysfs_file@IBVERBS_1.0 1.1.6
  ibv_reg_mr@IBVERBS_1.0 1.1.6
  ibv_reg_mr@IBVERBS_1.1 1.1.6
- ibv_register_driver@IBVERBS_1.1 1.1.6
  ibv_rereg_mr@IBVERBS_1.1 1.2.1
  ibv_resize_cq@IBVERBS_1.0 1.1.6
  ibv_resize_cq@IBVERBS_1.1 1.1.6
@@ -131,4 +92,3 @@ libibverbs.so.1 libibverbs1 #MINVER#
  ibv_wc_status_str@IBVERBS_1.1 1.1.6
  mbps_to_ibv_rate@IBVERBS_1.1 1.1.8
  mult_to_ibv_rate@IBVERBS_1.0 1.1.6
- verbs_register_driver@IBVERBS_1.1 1.1.8
diff --git a/libibverbs/CMakeLists.txt b/libibverbs/CMakeLists.txt
index 3e37afbc655114..3ad6191e74f8da 100644
--- a/libibverbs/CMakeLists.txt
+++ b/libibverbs/CMakeLists.txt
@@ -1,14 +1,17 @@
 publish_headers(infiniband
-  arch.h
-  driver.h
   kern-abi.h
-  marshall.h
   opcode.h
   sa-kern-abi.h
   sa.h
   verbs.h
   )
 
+publish_internal_headers(infiniband
+  arch.h
+  driver.h
+  marshall.h
+  )
+
 if (NOT NL_KIND EQUAL 0)
   set(NEIGH "neigh.c")
 else()
diff --git a/libibverbs/libibverbs.map b/libibverbs/libibverbs.map
index 275e1a04f13b35..24777c0969105b 100644
--- a/libibverbs/libibverbs.map
+++ b/libibverbs/libibverbs.map
@@ -37,43 +37,14 @@ IBVERBS_1.0 {
 		ibv_destroy_ah;
 		ibv_attach_mcast;
 		ibv_detach_mcast;
-		ibv_cmd_get_context;
-		ibv_cmd_query_device;
-		ibv_cmd_query_device_ex;
-		ibv_cmd_query_port;
-		ibv_cmd_query_gid;
-		ibv_cmd_query_pkey;
-		ibv_cmd_alloc_pd;
-		ibv_cmd_dealloc_pd;
-		ibv_cmd_reg_mr;
-		ibv_cmd_dereg_mr;
-		ibv_cmd_create_cq;
-		ibv_cmd_create_cq_ex;
-		ibv_cmd_poll_cq;
-		ibv_cmd_req_notify_cq;
-		ibv_cmd_resize_cq;
-		ibv_cmd_destroy_cq;
-		ibv_cmd_create_srq;
-		ibv_cmd_modify_srq;
-		ibv_cmd_query_srq;
-		ibv_cmd_destroy_srq;
-		ibv_cmd_create_qp;
-		ibv_cmd_query_qp;
-		ibv_cmd_modify_qp;
-		ibv_cmd_destroy_qp;
-		ibv_cmd_post_send;
-		ibv_cmd_post_recv;
-		ibv_cmd_post_srq_recv;
-		ibv_cmd_destroy_ah;
-		ibv_cmd_attach_mcast;
-		ibv_cmd_detach_mcast;
-		ibv_cmd_create_flow;
-		ibv_cmd_destroy_flow;
-		ibv_copy_qp_attr_from_kern;
-		ibv_copy_path_rec_from_kern;
-		ibv_copy_path_rec_to_kern;
 		ibv_rate_to_mult;
 		mult_to_ibv_rate;
+
+		/* These historical symbols are now private to libibverbs, but used by
+		   other rdma-core libraries. Do not change them. */
+		ibv_copy_path_rec_from_kern;
+		ibv_copy_path_rec_to_kern;
+		ibv_copy_qp_attr_from_kern;
 		ibv_get_sysfs_path;
 		ibv_read_sysfs_file;
 
@@ -91,48 +62,79 @@ IBVERBS_1.1 {
 
 		ibv_init_ah_from_wc;
 		ibv_create_ah_from_wc;
-		ibv_copy_ah_attr_from_kern;
 		ibv_fork_init;
 		ibv_dontfork_range;
 		ibv_dofork_range;
-		ibv_register_driver;
-		verbs_register_driver;
 
 		ibv_node_type_str;
 		ibv_port_state_str;
 		ibv_event_type_str;
 		ibv_wc_status_str;
 
-		ibv_cmd_alloc_mw;
-		ibv_cmd_dealloc_mw;
-
 		ibv_rate_to_mbps;
 		mbps_to_ibv_rate;
 
 		ibv_resolve_eth_l2_from_gid;
 
-		ibv_cmd_open_xrcd;
-		ibv_cmd_close_xrcd;
-		ibv_cmd_create_srq_ex;
-		ibv_cmd_create_qp_ex;
-		ibv_cmd_create_qp_ex2;
-		ibv_cmd_open_qp;
-		ibv_cmd_rereg_mr;
-
+		/* These historical symbols are now private to libibverbs, but used by
+		   other rdma-core libraries. Do not change them. */
+		ibv_copy_ah_attr_from_kern;
 } IBVERBS_1.0;
 
-IBVERBS_1.3 {
+/* If any symbols in this stanza change ABI then the entire staza gets a new symbol
+   version. */
+IBVERBS_PRIVATE_13 {
 	global:
-		ibv_cmd_create_wq;
-		ibv_cmd_modify_wq;
-		ibv_cmd_destroy_wq;
+		/* These historical symbols are now private to libibverbs */
+		ibv_cmd_alloc_mw;
+		ibv_cmd_alloc_pd;
+		ibv_cmd_attach_mcast;
+		ibv_cmd_close_xrcd;
+		ibv_cmd_create_ah;
+		ibv_cmd_create_cq;
+		ibv_cmd_create_cq_ex;
+		ibv_cmd_create_flow;
+		ibv_cmd_create_qp;
+		ibv_cmd_create_qp_ex2;
+		ibv_cmd_create_qp_ex;
 		ibv_cmd_create_rwq_ind_table;
+		ibv_cmd_create_srq;
+		ibv_cmd_create_srq_ex;
+		ibv_cmd_create_wq;
+		ibv_cmd_dealloc_mw;
+		ibv_cmd_dealloc_pd;
+		ibv_cmd_dereg_mr;
+		ibv_cmd_destroy_ah;
+		ibv_cmd_destroy_cq;
+		ibv_cmd_destroy_flow;
+		ibv_cmd_destroy_qp;
 		ibv_cmd_destroy_rwq_ind_table;
-		ibv_query_gid_type;
-} IBVERBS_1.1;
-
-IBVERBS_1.4 {
-	global:
+		ibv_cmd_destroy_srq;
+		ibv_cmd_destroy_wq;
+		ibv_cmd_detach_mcast;
+		ibv_cmd_get_context;
+		ibv_cmd_modify_qp;
 		ibv_cmd_modify_qp_ex;
-		ibv_cmd_create_ah;
-} IBVERBS_1.3;
+		ibv_cmd_modify_srq;
+		ibv_cmd_modify_wq;
+		ibv_cmd_open_qp;
+		ibv_cmd_open_xrcd;
+		ibv_cmd_poll_cq;
+		ibv_cmd_post_recv;
+		ibv_cmd_post_send;
+		ibv_cmd_post_srq_recv;
+		ibv_cmd_query_device;
+		ibv_cmd_query_device_ex;
+		ibv_cmd_query_gid;
+		ibv_cmd_query_pkey;
+		ibv_cmd_query_port;
+		ibv_cmd_query_qp;
+		ibv_cmd_query_srq;
+		ibv_cmd_reg_mr;
+		ibv_cmd_req_notify_cq;
+		ibv_cmd_rereg_mr;
+		ibv_cmd_resize_cq;
+		ibv_query_gid_type;
+		ibv_register_driver;
+		verbs_register_driver;
+};
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
