From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 13/20] IB: Expose ib_ucontext from a given ib_uverbs_file
Date: Sun, 17 Jun 2018 12:59:59 +0300
Message-ID: <20180617100006.30663-14-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Drivers that use the IOCTL API may have the ib_uverbs_file and need a
way to get the related ib_ucontext from it, this is enabled by this
patch.

Downstream patches from this series will use it.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_main.c | 6 ++++++
 include/rdma/ib_verbs.h               | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 3ae2339dd27a..f5f4bfb59705 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -138,6 +138,12 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
 static void ib_uverbs_add_one(struct ib_device *device);
 static void ib_uverbs_remove_one(struct ib_device *device, void *client_data);
 
+struct ib_ucontext *ib_uverbs_get_ucontext(struct ib_uverbs_file *ufile)
+{
+	return ufile->ucontext;
+}
+EXPORT_SYMBOL(ib_uverbs_get_ucontext);
+
 int uverbs_dealloc_mw(struct ib_mw *mw)
 {
 	struct ib_pd *pd = mw->pd;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 152b5907c864..1b30520c8c28 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4107,4 +4107,6 @@ ib_get_vector_affinity(struct ib_device *device, int comp_vector)
  */
 void rdma_roce_rescan_device(struct ib_device *ibdev);
 
+struct ib_ucontext *ib_uverbs_get_ucontext(struct ib_uverbs_file *ufile);
+
 #endif /* IB_VERBS_H */
-- 
2.14.4
