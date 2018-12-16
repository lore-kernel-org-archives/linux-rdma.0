From: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
Subject: [PATCH rds linux-next v4 2/2] net/rds: remove user triggered WARN_ON in rds_sendmsg
Date: Sun, 16 Dec 2018 09:01:09 +0200
Message-ID: <20181216070109.6758-3-shamir.rabinovitch@oracle.com>
References: <20181216070109.6758-1-shamir.rabinovitch@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181216070109.6758-1-shamir.rabinovitch@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, netdev@vger.kernel.org
Cc: shamir.rabinovitch@oracle.com, gerd.rausch@oracle.com, santosh.shilimkar@oracle.com, haakon.bugge@oracle.com, davem@davemloft.net
List-Id: linux-rdma@vger.kernel.org

From: shamir rabinovitch <shamir.rabinovitch@oracle.com>

per comment from Leon in rdma mailing list
https://lkml.org/lkml/2018/10/31/312 :

Please don't forget to remove user triggered WARN_ON.
https://lwn.net/Articles/769365/
"Greg Kroah-Hartman raised the problem of core kernel API code that will
use WARN_ON_ONCE() to complain about bad usage; that will not generate
the desired result if WARN_ON_ONCE() is configured to crash the machine.
He was told that the code should just call pr_warn() instead, and that
the called function should return an error in such situations. It was
generally agreed that any WARN_ON() or WARN_ON_ONCE() calls that can be
triggered from user space need to be fixed."

in addition harden rds_sendmsg to detect and overcome issues with
invalid sg count and fail the sendmsg.

Suggested-by: Leon Romanovsky <leon@kernel.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com> 
Signed-off-by: shamir rabinovitch <shamir.rabinovitch@oracle.com>
---
 net/rds/message.c | 24 ++++++++++++++++++------
 net/rds/rdma.c    | 12 ++++--------
 net/rds/rds.h     |  3 ++-
 net/rds/send.c    |  9 +++++----
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 4b00b1152a5f..f139420ba1f6 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -308,16 +308,27 @@ struct rds_message *rds_message_alloc(unsigned int extra_len, gfp_t gfp)
 /*
  * RDS ops use this to grab SG entries from the rm's sg pool.
  */
-struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents)
+struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents,
+					  int *ret)
 {
 	struct scatterlist *sg_first = (struct scatterlist *) &rm[1];
 	struct scatterlist *sg_ret;
 
-	WARN_ON(rm->m_used_sgs + nents > rm->m_total_sgs);
-	WARN_ON(!nents);
+	if (WARN_ON(!ret))
+		return NULL;
 
-	if (rm->m_used_sgs + nents > rm->m_total_sgs)
+	if (nents <= 0) {
+		pr_warn("rds: alloc sgs failed! nents <= 0\n");
+		*ret = -EINVAL;
 		return NULL;
+	}
+
+	if (rm->m_used_sgs + nents > rm->m_total_sgs) {
+		pr_warn("rds: alloc sgs failed! total %d used %d nents %d\n",
+			rm->m_total_sgs, rm->m_used_sgs, nents);
+		*ret = -ENOMEM;
+		return NULL;
+	}
 
 	sg_ret = &sg_first[rm->m_used_sgs];
 	sg_init_table(sg_ret, nents);
@@ -332,6 +343,7 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	unsigned int i;
 	int num_sgs = ceil(total_len, PAGE_SIZE);
 	int extra_bytes = num_sgs * sizeof(struct scatterlist);
+	int ret;
 
 	rm = rds_message_alloc(extra_bytes, GFP_NOWAIT);
 	if (!rm)
@@ -340,10 +352,10 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	set_bit(RDS_MSG_PAGEVEC, &rm->m_flags);
 	rm->m_inc.i_hdr.h_len = cpu_to_be32(total_len);
 	rm->data.op_nents = ceil(total_len, PAGE_SIZE);
-	rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs);
+	rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs, &ret);
 	if (!rm->data.op_sg) {
 		rds_message_put(rm);
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(ret);
 	}
 
 	for (i = 0; i < rm->data.op_nents; ++i) {
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index e1965d9cbcf8..182ab8430594 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -623,11 +623,9 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 	op->op_active = 1;
 	op->op_recverr = rs->rs_recverr;
 	WARN_ON(!nr_pages);
-	op->op_sg = rds_message_alloc_sgs(rm, nr_pages);
-	if (!op->op_sg) {
-		ret = -ENOMEM;
+	op->op_sg = rds_message_alloc_sgs(rm, nr_pages, &ret);
+	if (!op->op_sg)
 		goto out_pages;
-	}
 
 	if (op->op_notify || op->op_recverr) {
 		/* We allocate an uninitialized notifier here, because
@@ -839,11 +837,9 @@ int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
 	rm->atomic.op_silent = !!(args->flags & RDS_RDMA_SILENT);
 	rm->atomic.op_active = 1;
 	rm->atomic.op_recverr = rs->rs_recverr;
-	rm->atomic.op_sg = rds_message_alloc_sgs(rm, 1);
-	if (!rm->atomic.op_sg) {
-		ret = -ENOMEM;
+	rm->atomic.op_sg = rds_message_alloc_sgs(rm, 1, &ret);
+	if (!rm->atomic.op_sg)
 		goto err;
-	}
 
 	/* verify 8 byte-aligned */
 	if (args->local_addr & 0x7) {
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 4d2523100093..02ec4a3b2799 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -839,7 +839,8 @@ rds_conn_connecting(struct rds_connection *conn)
 
 /* message.c */
 struct rds_message *rds_message_alloc(unsigned int nents, gfp_t gfp);
-struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents);
+struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents,
+					  int *ret);
 int rds_message_copy_from_user(struct rds_message *rm, struct iov_iter *from,
 			       bool zcopy);
 struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned int total_len);
diff --git a/net/rds/send.c b/net/rds/send.c
index ec2267cbf85f..b39b30706210 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -886,6 +886,9 @@ static int rds_rm_size(struct msghdr *msg, int num_sgs,
 	bool zcopy_cookie = false;
 	struct rds_iov_vector *iov, *tmp_iov;
 
+	if (num_sgs < 0)
+		return -EINVAL;
+
 	for_each_cmsghdr(cmsg, msg) {
 		if (!CMSG_OK(msg, cmsg))
 			return -EINVAL;
@@ -1259,11 +1262,9 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 
 	/* Attach data to the rm */
 	if (payload_len) {
-		rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs);
-		if (!rm->data.op_sg) {
-			ret = -ENOMEM;
+		rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs, &ret);
+		if (!rm->data.op_sg)
 			goto out;
-		}
 		ret = rds_message_copy_from_user(rm, &msg->msg_iter, zcopy);
 		if (ret)
 			goto out;
-- 
2.19.1
