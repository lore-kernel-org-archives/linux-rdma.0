From: Knut Omang <knut.omang@oracle.com>
Subject: [PATCH v2 5/8] ib_uverbs: Add padding to end align ib_uverbs_reg_mr_resp
Date: Fri, 16 Sep 2016 20:31:16 +0200
Message-ID: <aafa787a72e9df9a40b292fb33833e67ffb46c6a.1474049924.git-series.knut.omang@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
In-Reply-To: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Knut Omang <knut.omang@oracle.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Matan Barak <matanb@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

The ib_uverbs_reg_mr_resp structure was not 64 bit end aligned
as required by the protocol. This causes alignment issues
if a device specific driver needs to transfer extra response
arguments.

Avoid breaking backward compatibility by improving the handling
of the length checking in ib_uverbs_reg_mr to consider the case
where the kernel has been updated, but user space still has
the old length without padding.

Signed-off-by: Knut Omang <knut.omang@oracle.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 10 ++++++----
 include/uapi/rdma/ib_user_verbs.h    |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index dbc5885..fa8a717 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -967,16 +967,18 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	struct ib_pd                *pd;
 	struct ib_mr                *mr;
 	int                          ret;
+	size_t resp_size = sizeof resp;
 
-	if (out_len < sizeof resp)
-		return -ENOSPC;
+	if (out_len < resp_size) {
+		resp_size = out_len;
+	}
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
+		   in_len - sizeof cmd, out_len - resp_size);
 
 	if ((cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
 		return -EINVAL;
@@ -1030,7 +1032,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	resp.mr_handle = uobj->id;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+			 &resp, resp_size)) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 7f035f4..6b8c9c0 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -307,6 +307,7 @@ struct ib_uverbs_reg_mr_resp {
 	__u32 mr_handle;
 	__u32 lkey;
 	__u32 rkey;
+	__u32 reserved;
 };
 
 struct ib_uverbs_rereg_mr {
-- 
git-series 0.8.10
