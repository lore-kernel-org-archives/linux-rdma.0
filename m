From: Knut Omang <knut.omang@oracle.com>
Subject: [PATCH v2 8/8] ib_uverbs: Support for kernel implementation of XRC
Date: Fri, 16 Sep 2016 20:31:19 +0200
Message-ID: <88ffb8c9407a71069b52e155dde308a36dfaf247.1474049924.git-series.knut.omang@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
In-Reply-To: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Knut Omang <knut.omang@oracle.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Matan Barak <matanb@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Leon Romanovsky <leonro@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Extends the kernel/user space interface for work requests to also provide
the XRC shared receive queue number. Necessary to support
kernel level implementation of user verbs for XRC.

Requires a corresponding libibverbs change to support XRC.

Also fix kernel support for XRC broken by commit

"IB: remove xrc_remote_srq_num from struct ib_send_wr"

which removed a field needed to support kernel side XRC as part of an effort
to trim a work request to sizes dependent of the actual request instead
of the union approach.

With this commit I try to follow the pattern outlined by that cleanup
to also support kernel side XRC. Since XRC attributes are associated with
QP type and are (almost) orthogonal to the type of request, the XRC
specific attribute(s) would have to be applicable to several different
work request type specific subtypes. Since the subtypes have different sizes,
putting the xrc specific attributes at the end would require accessor functions
and to keep explicit track of the size of the subtype used.

The chosen solution is to introduce the xrc specific attributes at the top of
the struct instead, this way type checking is taking care of most issues,
except that extra care is needed at deallocation time. Note that this requires
padding of the xrc specific attributes that matches the size of struct ib_sge,
to avoid that the ALIGN() calls used to ensure that the scatter list of the
work is aligned does not extend beyond the size of the allocates space:

struct ib_xrc_wr
{
  <xrc specific part>;
  struct ib_send_wr wr;
}
< subtype extensions will still extend ib_send_wr down here >

Signed-off-by: Knut Omang <knut.omang@oracle.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 40 +++++++++++++++++++++++------
 include/rdma/ib_verbs.h              | 12 +++++++++-
 include/uapi/rdma/ib_user_verbs.h    |  2 +-
 3 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7f4470e..152e617 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2471,12 +2471,30 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	return in_len;
 }
 
-static void *alloc_wr(size_t wr_size, __u32 num_sge)
+static void *alloc_wr(struct ib_qp *qp, size_t wr_size, __u32 num_sge)
 {
-	return kmalloc(ALIGN(wr_size, sizeof (struct ib_sge)) +
-			 num_sge * sizeof (struct ib_sge), GFP_KERNEL);
+	void *wr;
+	size_t xrc_ext = qp->qp_type == IB_QPT_XRC_INI ?
+		sizeof(struct ib_xrc_wr) - sizeof(struct ib_send_wr) :
+		0;
+
+	wr = kmalloc(ALIGN(wr_size + xrc_ext, sizeof (struct ib_sge)) +
+		num_sge * sizeof (struct ib_sge), GFP_KERNEL);
+	if (unlikely(!wr))
+		return wr;
+
+	return wr + xrc_ext;
 };
 
+static void free_wr(struct ib_qp *qp, struct ib_send_wr *wr)
+{
+	void *d;
+	if (unlikely(!wr))
+		return;
+	d = qp->qp_type == IB_QPT_XRC_INI ? xrc_wr(wr) : (void *)wr;
+	kfree(d);
+}
+
 ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			    struct ib_device *ib_dev,
 			    const char __user *buf, int in_len,
@@ -2511,6 +2529,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 		goto out;
 
 	is_ud = qp->qp_type == IB_QPT_UD;
+
 	sg_ind = 0;
 	last = NULL;
 	for (i = 0; i < cmd.wr_count; ++i) {
@@ -2536,7 +2555,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			}
 
 			next_size = sizeof(*ud);
-			ud = alloc_wr(next_size, user_wr->num_sge);
+			ud = alloc_wr(qp, next_size, user_wr->num_sge);
 			if (!ud) {
 				ret = -ENOMEM;
 				goto out_put;
@@ -2558,7 +2577,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			struct ib_rdma_wr *rdma;
 
 			next_size = sizeof(*rdma);
-			rdma = alloc_wr(next_size, user_wr->num_sge);
+			rdma = alloc_wr(qp, next_size, user_wr->num_sge);
 			if (!rdma) {
 				ret = -ENOMEM;
 				goto out_put;
@@ -2573,7 +2592,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			struct ib_atomic_wr *atomic;
 
 			next_size = sizeof(*atomic);
-			atomic = alloc_wr(next_size, user_wr->num_sge);
+			atomic = alloc_wr(qp, next_size, user_wr->num_sge);
 			if (!atomic) {
 				ret = -ENOMEM;
 				goto out_put;
@@ -2589,7 +2608,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			   user_wr->opcode == IB_WR_SEND_WITH_IMM ||
 			   user_wr->opcode == IB_WR_SEND_WITH_INV) {
 			next_size = sizeof(*next);
-			next = alloc_wr(next_size, user_wr->num_sge);
+			next = alloc_wr(qp, next_size, user_wr->num_sge);
 			if (!next) {
 				ret = -ENOMEM;
 				goto out_put;
@@ -2607,6 +2626,11 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 			next->ex.invalidate_rkey = user_wr->ex.invalidate_rkey;
 		}
 
+		if (qp->qp_type == IB_QPT_XRC_INI) {
+			struct ib_xrc_wr *xrc = xrc_wr(next);
+			xrc->remote_srqn = user_wr->xrc_remote_srq_num;
+		}
+
 		if (!last)
 			wr = next;
 		else
@@ -2655,7 +2679,7 @@ out_put:
 		if (is_ud && ud_wr(wr)->ah)
 			put_ah_read(ud_wr(wr)->ah);
 		next = wr->next;
-		kfree(wr);
+		free_wr(qp, wr);
 		wr = next;
 	}
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 192d591..093d68e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1276,6 +1276,18 @@ static inline struct ib_sig_handover_wr *sig_handover_wr(struct ib_send_wr *wr)
 	return container_of(wr, struct ib_sig_handover_wr, wr);
 }
 
+struct ib_xrc_wr {
+	u32 			remote_srqn;
+	u32			reserved1;
+	u64			reserved2;
+	struct ib_send_wr	wr;
+};
+
+static inline struct ib_xrc_wr *xrc_wr(struct ib_send_wr *wr)
+{
+	return container_of(wr, struct ib_xrc_wr, wr);
+}
+
 struct ib_recv_wr {
 	struct ib_recv_wr      *next;
 	union {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 6b8c9c0..db74a5e 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -725,6 +725,8 @@ struct ib_uverbs_send_wr {
 			__u32 reserved;
 		} ud;
 	} wr;
+	__u32 xrc_remote_srq_num;
+	__u32 reserved;
 };
 
 struct ib_uverbs_post_send {
-- 
git-series 0.8.10
