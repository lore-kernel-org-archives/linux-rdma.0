From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH] libmthca: Add support for the reg_io_mr verb.
Date: Thu, 29 Jul 2010 11:36:50 -0500
Message-ID: <20100729163650.15024.66012.stgit@build.ogc.int>
References: <20100729163624.15024.57249.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100729163624.15024.57249.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org, swise-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Added support for the ibv_reg_io_mr and ibv_unreg_io_mr
verbs to the mthca ilbrary.

Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
---

 src/mthca-abi.h |    4 ++++
 src/mthca.c     |    2 ++
 src/mthca.h     |    4 ++++
 src/verbs.c     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/src/mthca-abi.h b/src/mthca-abi.h
index 4fbd98b..c0145d6 100644
--- a/src/mthca-abi.h
+++ b/src/mthca-abi.h
@@ -61,6 +61,10 @@ struct mthca_reg_mr {
 	__u32				reserved;
 };
 
+struct mthca_reg_io_mr {
+	struct ibv_reg_io_mr		ibv_cmd;
+};
+
 struct mthca_create_cq {
 	struct ibv_create_cq		ibv_cmd;
 	__u32				lkey;
diff --git a/src/mthca.c b/src/mthca.c
index e33bf7f..8892504 100644
--- a/src/mthca.c
+++ b/src/mthca.c
@@ -113,6 +113,8 @@ static struct ibv_context_ops mthca_ctx_ops = {
 	.dealloc_pd    = mthca_free_pd,
 	.reg_mr        = mthca_reg_mr,
 	.dereg_mr      = mthca_dereg_mr,
+	.reg_io_mr     = mthca_reg_io_mr,
+	.dereg_io_mr   = mthca_dereg_io_mr,
 	.create_cq     = mthca_create_cq,
 	.poll_cq       = mthca_poll_cq,
 	.resize_cq     = mthca_resize_cq,
diff --git a/src/mthca.h b/src/mthca.h
index bd1e7a2..92a8649 100644
--- a/src/mthca.h
+++ b/src/mthca.h
@@ -312,6 +312,10 @@ struct ibv_mr *mthca_reg_mr(struct ibv_pd *pd, void *addr,
 			    size_t length, int access);
 int mthca_dereg_mr(struct ibv_mr *mr);
 
+struct ibv_mr *mthca_reg_io_mr(struct ibv_pd *pd, void *addr,
+			       size_t length, enum ibv_access_flags access);
+int mthca_dereg_io_mr(struct ibv_mr *mr);
+
 struct ibv_cq *mthca_create_cq(struct ibv_context *context, int cqe,
 			       struct ibv_comp_channel *channel,
 			       int comp_vector);
diff --git a/src/verbs.c b/src/verbs.c
index b6782c9..3580ad2 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -174,6 +174,56 @@ int mthca_dereg_mr(struct ibv_mr *mr)
 	return 0;
 }
 
+
+static struct ibv_mr *__mthca_reg_io_mr(struct ibv_pd *pd, void *addr,
+					size_t length, uint64_t hca_va,
+					enum ibv_access_flags access)
+{
+	struct ibv_mr *mr;
+	struct mthca_reg_io_mr cmd;
+	int ret;
+
+	mr = malloc(sizeof *mr);
+	if (!mr)
+		return NULL;
+
+#ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
+	{
+		struct ibv_reg_io_mr_resp resp;
+
+		ret = ibv_cmd_reg_io_mr(pd, addr, length, hca_va, access, mr,
+					&cmd.ibv_cmd, sizeof cmd, &resp, sizeof resp);
+	}
+#else
+	ret = ibv_cmd_reg_io_mr(pd, addr, length, hca_va, access, mr,
+				&cmd.ibv_cmd, sizeof cmd);
+#endif
+	if (ret) {
+		free(mr);
+		return NULL;
+	}
+
+	return mr;
+}
+
+struct ibv_mr *mthca_reg_io_mr(struct ibv_pd *pd, void *addr,
+			       size_t length, enum ibv_access_flags access)
+{
+	return __mthca_reg_io_mr(pd, addr, length, (uintptr_t) addr, access);
+}
+
+int mthca_dereg_io_mr(struct ibv_mr *mr)
+{
+	int ret;
+
+	ret = ibv_cmd_dereg_mr(mr);
+	if (ret)
+		return ret;
+
+	free(mr);
+	return 0;
+}
+
 static int align_cq_size(int cqe)
 {
 	int nent;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
