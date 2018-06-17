From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 08/20] IB/uverbs: Allow an empty namespace in ioctl() framework
Date: Sun, 17 Jun 2018 12:59:54 +0300
Message-ID: <20180617100006.30663-9-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb@mellanox.com>

The ioctl parser framework wrongly assumed that each namespace is
populated. This could lead to NULL dereferences. Fix the parser to
always check that a given namespace indeed exists.

Fixes: fac9658cabb9 ("IB/core: Add new ioctl interface")
Signed-off-by: Matan Barak <matanb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_ioctl.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index ee15c9ca788b..fb12e8ef7147 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -201,6 +201,9 @@ static int uverbs_finalize_attrs(struct uverbs_attr_bundle *attrs_bundle,
 			spec_hash[i];
 		unsigned int j;
 
+		if (!curr_spec_bucket)
+			continue;
+
 		for (j = 0; j < curr_bundle->num_attrs; j++) {
 			struct uverbs_attr *attr;
 			const struct uverbs_attr_spec *spec;
@@ -248,7 +251,7 @@ static int uverbs_uattrs_process(struct ib_device *ibdev,
 		struct uverbs_attr_spec_hash *attr_spec_bucket;
 
 		ret = uverbs_ns_idx(&attr_id, method->num_buckets);
-		if (ret < 0) {
+		if (ret < 0 || !method->attr_buckets[ret]) {
 			if (uattr->flags & UVERBS_ATTR_F_MANDATORY) {
 				uverbs_finalize_attrs(attr_bundle,
 						      method->attr_buckets,
@@ -291,6 +294,9 @@ static int uverbs_validate_kernel_mandatory(const struct uverbs_method_spec *met
 		struct uverbs_attr_spec_hash *attr_spec_bucket =
 			method_spec->attr_buckets[i];
 
+		if (!attr_spec_bucket)
+			continue;
+
 		if (!bitmap_subset(attr_spec_bucket->mandatory_attrs_bitmask,
 				   attr_bundle->hash[i].valid_bitmap,
 				   attr_spec_bucket->num_attrs))
@@ -404,7 +410,12 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
 	 * filled at a later stage (uverbs_process_attr)
 	 */
 	for (i = 0; i < method_spec->num_buckets; i++) {
-		unsigned int curr_num_attrs = method_spec->attr_buckets[i]->num_attrs;
+		unsigned int curr_num_attrs;
+
+		if (!method_spec->attr_buckets[i])
+			continue;
+
+		curr_num_attrs = method_spec->attr_buckets[i]->num_attrs;
 
 		ctx->uverbs_attr_bundle->hash[i].attrs = curr_attr;
 		curr_attr += curr_num_attrs;
-- 
2.14.4
