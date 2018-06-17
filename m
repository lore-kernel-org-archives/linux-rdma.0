From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 04/20] IB/uverbs: Export uverbs idr and fd types
Date: Sun, 17 Jun 2018 12:59:50 +0300
Message-ID: <20180617100006.30663-5-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb@mellanox.com>

As provider drivers could use UVERBS_ATTR_FD and UVERBS_ATTR_IDR macros
need to export them.

Signed-off-by: Matan Barak <matanb@mellanox.com>
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/rdma_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index a6e904973ba8..8035a0a7564c 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -611,6 +611,7 @@ const struct uverbs_obj_type_class uverbs_idr_class = {
 	 */
 	.needs_kfree_rcu = true,
 };
+EXPORT_SYMBOL(uverbs_idr_class);
 
 static void _uverbs_close_fd(struct ib_uobject_file *uobj_file)
 {
@@ -719,6 +720,7 @@ const struct uverbs_obj_type_class uverbs_fd_class = {
 	.remove_commit = remove_commit_fd_uobject,
 	.needs_kfree_rcu = false,
 };
+EXPORT_SYMBOL(uverbs_fd_class);
 
 struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_obj_type *type_attrs,
 						   struct ib_ucontext *ucontext,
-- 
2.14.4
