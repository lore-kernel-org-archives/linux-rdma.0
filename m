From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 17/19] rdma: Unify netlink attribute checks prior to prints
Date: Tue, 22 Jan 2019 20:31:23 +0200
Message-ID: <20190122183125.15920-18-leon@kernel.org>
References: <20190122183125.15920-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122183125.15920-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Place check if netlink attribute available in general place,
instead of doing the same check in many paces.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-cmid.c |  9 ++++-----
 rdma/res-cq.c   | 22 +++++++++++-----------
 rdma/res-mr.c   | 21 +++++++--------------
 rdma/res-pd.c   | 20 +++++++++-----------
 rdma/res-qp.c   | 10 +++++-----
 rdma/res.c      | 16 +++++++++++++---
 rdma/res.h      |  6 ++++--
 7 files changed, 53 insertions(+), 51 deletions(-)

diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index 12d1acee..22d99a8b 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -202,16 +202,15 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 		jsonw_start_array(rd->jw);
 
 	print_link(rd, idx, name, port, nla_line);
-	if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN])
-		res_print_uint(rd, "lqpn", lqpn);
+	res_print_uint(rd, "cm-idn", cm_idn,
+		       nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN]);
+	res_print_uint(rd, "lqpn", lqpn, nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
 	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
 		print_qp_type(rd, type);
 	print_cm_id_state(rd, state);
 	print_ps(rd, ps);
-	res_print_uint(rd, "pid", pid);
+	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
-	if (nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN])
-		res_print_uint(rd, "cm-idn", cm_idn);
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR])
 		print_ipaddr(rd, "src-addr", src_addr_str, src_port);
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index e50d76ce..cea4f6bd 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -17,8 +17,11 @@ static const char *poll_ctx_to_str(uint8_t idx)
 	return "UNKNOWN";
 }
 
-static void print_poll_ctx(struct rd *rd, uint8_t poll_ctx)
+static void print_poll_ctx(struct rd *rd, uint8_t poll_ctx, struct nlattr *attr)
 {
+	if (!attr)
+		return;
+
 	if (rd->json_output) {
 		jsonw_string_field(rd->jw, "poll-ctx",
 				   poll_ctx_to_str(poll_ctx));
@@ -92,18 +95,15 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 		jsonw_start_array(rd->jw);
 
 	print_dev(rd, idx, name);
-	res_print_uint(rd, "cqe", cqe);
-	res_print_uint(rd, "users", users);
-	if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX])
-		print_poll_ctx(rd, poll_ctx);
-	res_print_uint(rd, "pid", pid);
+	res_print_uint(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
+	res_print_uint(rd, "cqe", cqe, nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
+	res_print_uint(rd, "users", users,
+		       nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
+	print_poll_ctx(rd, poll_ctx, nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
+	res_print_uint(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
-		res_print_uint(rd, "cqn", cqn);
-	if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
-		res_print_uint(rd, "ctxn", ctxn);
-
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
 	newline(rd);
 
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index 36993b5e..82e6d150 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -67,22 +67,15 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 		jsonw_start_array(rd->jw);
 
 	print_dev(rd, idx, name);
-	if (nla_line[RDMA_NLDEV_ATTR_RES_RKEY])
-		print_key(rd, "rkey", rkey);
-	if (nla_line[RDMA_NLDEV_ATTR_RES_LKEY])
-		print_key(rd, "lkey", lkey);
-	if (nla_line[RDMA_NLDEV_ATTR_RES_IOVA])
-		print_key(rd, "iova", iova);
-	res_print_uint(rd, "mrlen", mrlen);
-	res_print_uint(rd, "pid", pid);
+	res_print_uint(rd, "mrn", mrn, nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
+	print_key(rd, "rkey", rkey, nla_line[RDMA_NLDEV_ATTR_RES_RKEY]);
+	print_key(rd, "lkey", lkey, nla_line[RDMA_NLDEV_ATTR_RES_LKEY]);
+	print_key(rd, "iova", iova, nla_line[RDMA_NLDEV_ATTR_RES_IOVA]);
+	res_print_uint(rd, "mrlen", mrlen, nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
+	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
-		res_print_uint(rd, "mrn", mrn);
-
-	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
-		res_print_uint(rd, "pdn", pdn);
-
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
 	newline(rd);
 
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index 3c9ffa4e..e8c042dc 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -69,18 +69,16 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 		jsonw_start_array(rd->jw);
 
 	print_dev(rd, idx, name);
-	if (nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY])
-		print_key(rd, "local_dma_lkey", local_dma_lkey);
-	res_print_uint(rd, "users", users);
-	if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
-		print_key(rd, "unsafe_global_rkey", unsafe_global_rkey);
-	res_print_uint(rd, "pid", pid);
+	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+	print_key(rd, "local_dma_lkey", local_dma_lkey,
+		  nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]);
+	res_print_uint(rd, "users", users,
+		       nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
+	print_key(rd, "unsafe_global_rkey", unsafe_global_rkey,
+		  nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY]);
+	res_print_uint(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
-	if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
-		res_print_uint(rd, "ctxn", ctxn);
-
-	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
-		res_print_uint(rd, "pdn", pdn);
 
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
 	newline(rd);
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index e74c8b01..5d5ef27b 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -176,19 +176,19 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 
 	print_link(rd, idx, name, port, nla_line);
 
-	res_print_uint(rd, "lqpn", lqpn);
-	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
-		res_print_uint(rd, "pdn", pdn);
+	res_print_uint(rd, "lqpn", lqpn, nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
 	print_rqpn(rd, rqpn, nla_line);
 
 	print_type(rd, type);
 	print_state(rd, state);
 
 	print_rqpsn(rd, rq_psn, nla_line);
-	res_print_uint(rd, "sq-psn", sq_psn);
+	res_print_uint(rd, "sq-psn", sq_psn,
+		       nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]);
 
 	print_pathmig(rd, path_mig_state, nla_line);
-	res_print_uint(rd, "pid", pid);
+	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 
 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
diff --git a/rdma/res.c b/rdma/res.c
index 140c0908..564af9b4 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -47,7 +47,9 @@ static int res_print_summary(struct rd *rd, struct nlattr **tb)
 
 		name = mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME]);
 		curr = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
-		res_print_uint(rd, name, curr);
+		res_print_uint(
+			rd, name, curr,
+			nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
 	}
 	return 0;
 }
@@ -188,16 +190,24 @@ char *get_task_name(uint32_t pid)
 	return comm;
 }
 
-void print_key(struct rd *rd, const char *name, uint64_t val)
+void print_key(struct rd *rd, const char *name, uint64_t val,
+	       struct nlattr *nlattr)
 {
+	if (!nlattr)
+		return;
+
 	if (rd->json_output)
 		jsonw_xint_field(rd->jw, name, val);
 	else
 		pr_out("%s 0x%" PRIx64 " ", name, val);
 }
 
-void res_print_uint(struct rd *rd, const char *name, uint64_t val)
+void res_print_uint(struct rd *rd, const char *name, uint64_t val,
+		    struct nlattr *nlattr)
 {
+	if (!nlattr)
+		return;
+
 	if (rd->json_output)
 		jsonw_u64_field(rd->jw, name, val);
 	else
diff --git a/rdma/res.h b/rdma/res.h
index 89dd818a..575e1192 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -112,8 +112,10 @@ char *get_task_name(uint32_t pid);
 void print_dev(struct rd *rd, uint32_t idx, const char *name);
 void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 		struct nlattr **nla_line);
-void print_key(struct rd *rd, const char *name, uint64_t val);
-void res_print_uint(struct rd *rd, const char *name, uint64_t val);
+void print_key(struct rd *rd, const char *name, uint64_t val,
+	       struct nlattr *nlattr);
+void res_print_uint(struct rd *rd, const char *name, uint64_t val,
+		    struct nlattr *nlattr);
 void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line);
 const char *qp_types_to_str(uint8_t idx);
 
-- 
2.19.1
