From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v2 19/19] rdma: Provide and reuse filter functions
Date: Sat, 23 Feb 2019 11:15:28 +0200
Message-ID: <20190223091528.8509-20-leon@kernel.org>
References: <20190223091528.8509-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190223091528.8509-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Globally replace all filter function in safer variants of those
is_filtered functions, which take into account the availability/lack
of netlink attributes.

Such conversion allowed to fix a number of places in the code, where
the previous implementation didn't honor filter requests if netlink
attribute wasn't present.

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/rdma.h     |  7 +++---
 rdma/res-cmid.c | 57 +++++++++++++++++++++++++++----------------------
 rdma/res-cq.c   | 22 +++++++++++--------
 rdma/res-mr.c   | 12 +++++++----
 rdma/res-pd.c   | 12 +++++++----
 rdma/res-qp.c   | 53 ++++++++++++++++++++++-----------------------
 rdma/utils.c    | 26 ++++++++++++++++++----
 7 files changed, 112 insertions(+), 77 deletions(-)

diff --git a/rdma/rdma.h b/rdma/rdma.h
index e86c7f21..1022e9a2 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -110,9 +110,10 @@ struct dev_map *dev_map_lookup(struct rd *rd, bool allow_port_index);
  */
 bool rd_doit_index(struct rd *rd, uint32_t *idx);
 int rd_build_filter(struct rd *rd, const struct filters valid_filters[]);
-bool rd_check_is_filtered(struct rd *rd, const char *key, uint32_t val);
-bool rd_check_is_string_filtered(struct rd *rd, const char *key, const char *val);
-bool rd_check_is_key_exist(struct rd *rd, const char *key);
+bool rd_is_filtered_attr(struct rd *rd, const char *key, uint32_t val,
+			 struct nlattr *attr);
+bool rd_is_string_filtered_attr(struct rd *rd, const char *key, const char *val,
+				struct nlattr *attr);
 /*
  * Netlink
  */
diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index 0b61e433..0b830088 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -132,57 +132,64 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 	if (port && port != rd->port_idx)
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN]) {
+	if (nla_line[RDMA_NLDEV_ATTR_RES_LQPN])
 		lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
-		if (rd_check_is_filtered(rd, "lqpn", lqpn))
-			goto out;
-	}
-	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE]) {
+
+	if (rd_is_filtered_attr(rd, "lqpn", lqpn,
+				nla_line[RDMA_NLDEV_ATTR_RES_LQPN]))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
 		type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
-		if (rd_check_is_string_filtered(rd, "qp-type",
-						qp_types_to_str(type)))
-			goto out;
-	}
+	if (rd_is_string_filtered_attr(rd, "qp-type", qp_types_to_str(type),
+				       nla_line[RDMA_NLDEV_ATTR_RES_TYPE]))
+		goto out;
 
 	ps = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PS]);
-	if (rd_check_is_string_filtered(rd, "ps", cm_id_ps_to_str(ps)))
+	if (rd_is_string_filtered_attr(rd, "ps", cm_id_ps_to_str(ps),
+				       nla_line[RDMA_NLDEV_ATTR_RES_PS]))
 		goto out;
 
 	state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
-	if (rd_check_is_string_filtered(rd, "state", cm_id_state_to_str(state)))
+	if (rd_is_string_filtered_attr(rd, "state", cm_id_state_to_str(state),
+				       nla_line[RDMA_NLDEV_ATTR_RES_STATE]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR]) {
+	if (nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR])
 		if (ss_ntop(nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR],
 			    src_addr_str, &src_port))
 			goto out;
-		if (rd_check_is_string_filtered(rd, "src-addr", src_addr_str))
-			goto out;
-		if (rd_check_is_filtered(rd, "src-port", src_port))
-			goto out;
-	}
+	if (rd_is_string_filtered_attr(rd, "src-addr", src_addr_str,
+				       nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR]))
+		goto out;
+	if (rd_is_filtered_attr(rd, "src-port", src_port,
+				nla_line[RDMA_NLDEV_ATTR_RES_SRC_ADDR]))
+		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR]) {
+	if (nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR])
 		if (ss_ntop(nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR],
 			    dst_addr_str, &dst_port))
 			goto out;
-		if (rd_check_is_string_filtered(rd, "dst-addr", dst_addr_str))
-			goto out;
-		if (rd_check_is_filtered(rd, "dst-port", dst_port))
-			goto out;
-	}
+	if (rd_is_string_filtered_attr(rd, "dst-addr", dst_addr_str,
+				       nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR]))
+		goto out;
+	if (rd_is_filtered_attr(rd, "dst-port", dst_port,
+				nla_line[RDMA_NLDEV_ATTR_RES_DST_ADDR]))
+		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
 	}
 
-	if (rd_check_is_filtered(rd, "pid", pid))
+	if (rd_is_filtered_attr(rd, "pid", pid,
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN])
 		cm_idn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN]);
-	if (rd_check_is_filtered(rd, "cm-idn", cm_idn))
+	if (rd_is_filtered_attr(rd, "cm-idn", cm_idn,
+				nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index c14637e6..5afb97c5 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -51,32 +51,36 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 	cqe = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
 
 	users = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
-	if (rd_check_is_filtered(rd, "users", users))
+	if (rd_is_filtered_attr(rd, "users", users,
+				nla_line[RDMA_NLDEV_ATTR_RES_USECNT]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]) {
+	if (nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX])
 		poll_ctx =
 			mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
-		if (rd_check_is_string_filtered(rd, "poll-ctx",
-						poll_ctx_to_str(poll_ctx)))
-			goto out;
-	}
+	if (rd_is_string_filtered_attr(rd, "poll-ctx",
+				       poll_ctx_to_str(poll_ctx),
+				       nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]))
+		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
 	}
 
-	if (rd_check_is_filtered(rd, "pid", pid))
+	if (rd_is_filtered_attr(rd, "pid", pid,
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
 		cqn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
-	if (rd_check_is_filtered(rd, "cqn", cqn))
+	if (rd_is_filtered_attr(rd, "cqn", cqn,
+				nla_line[RDMA_NLDEV_ATTR_RES_CQN]))
 		goto out;
 	if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
 		ctxn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
-	if (rd_check_is_filtered(rd, "ctxn", ctxn))
+	if (rd_is_filtered_attr(rd, "ctxn", ctxn,
+				nla_line[RDMA_NLDEV_ATTR_RES_CTXN]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index d42e8d81..f4a24dc1 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -31,7 +31,8 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 		iova = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_IOVA]);
 
 	mrlen = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]);
-	if (rd_check_is_filtered(rd, "mrlen", mrlen))
+	if (rd_is_filtered_attr(rd, "mrlen", mrlen,
+				nla_line[RDMA_NLDEV_ATTR_RES_MRLEN]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
@@ -39,17 +40,20 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 		comm = get_task_name(pid);
 	}
 
-	if (rd_check_is_filtered(rd, "pid", pid))
+	if (rd_is_filtered_attr(rd, "pid", pid,
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
 		mrn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
-	if (rd_check_is_filtered(rd, "mrn", mrn))
+	if (rd_is_filtered_attr(rd, "mrn", mrn,
+				nla_line[RDMA_NLDEV_ATTR_RES_MRN]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
 		pdn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
-	if (rd_check_is_filtered(rd, "pdn", pdn))
+	if (rd_is_filtered_attr(rd, "pdn", pdn,
+				nla_line[RDMA_NLDEV_ATTR_RES_PDN]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index 956d4d9f..07c836e8 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -28,7 +28,8 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 			nla_line[RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY]);
 
 	users = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
-	if (rd_check_is_filtered(rd, "users", users))
+	if (rd_is_filtered_attr(rd, "users", users,
+				nla_line[RDMA_NLDEV_ATTR_RES_USECNT]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY])
@@ -40,18 +41,21 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 		comm = get_task_name(pid);
 	}
 
-	if (rd_check_is_filtered(rd, "pid", pid))
+	if (rd_is_filtered_attr(rd, "pid", pid,
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
 		ctxn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
 
-	if (rd_check_is_filtered(rd, "ctxn", ctxn))
+	if (rd_is_filtered_attr(rd, "ctxn", ctxn,
+				nla_line[RDMA_NLDEV_ATTR_RES_CTXN]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
 		pdn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
-	if (rd_check_is_filtered(rd, "pdn", pdn))
+	if (rd_is_filtered_attr(rd, "pdn", pdn,
+				nla_line[RDMA_NLDEV_ATTR_RES_PDN]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index ac9976fc..954e465d 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -103,53 +103,49 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 		goto out;
 
 	lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
-	if (rd_check_is_filtered(rd, "lqpn", lqpn))
+	if (rd_is_filtered_attr(rd, "lqpn", lqpn,
+				nla_line[RDMA_NLDEV_ATTR_RES_LQPN]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
 		pdn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
-	if (rd_check_is_filtered(rd, "pdn", pdn))
+	if (rd_is_filtered_attr(rd, "pdn", pdn,
+				nla_line[RDMA_NLDEV_ATTR_RES_PDN]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN]) {
+	if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
 		rqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQPN]);
-		if (rd_check_is_filtered(rd, "rqpn", rqpn))
-			goto out;
-	} else {
-		if (rd_check_is_key_exist(rd, "rqpn"))
-			goto out;
-	}
+	if (rd_is_filtered_attr(rd, "rqpn", rqpn,
+				nla_line[RDMA_NLDEV_ATTR_RES_RQPN]))
+		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]) {
+	if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
 		rq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]);
-		if (rd_check_is_filtered(rd, "rq-psn", rq_psn))
-			goto out;
-	} else {
-		if (rd_check_is_key_exist(rd, "rq-psn"))
-			goto out;
-	}
+	if (rd_is_filtered_attr(rd, "rq-psn", rq_psn,
+				nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]))
+		goto out;
 
 	sq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]);
-	if (rd_check_is_filtered(rd, "sq-psn", sq_psn))
+	if (rd_is_filtered_attr(rd, "sq-psn", sq_psn,
+				nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]))
 		goto out;
 
-	if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]) {
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
 		path_mig_state = mnl_attr_get_u8(
 			nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]);
-		if (rd_check_is_string_filtered(rd, "path-mig-state",
-						path_mig_to_str(path_mig_state)))
-			goto out;
-	} else {
-		if (rd_check_is_key_exist(rd, "path-mig-state"))
-			goto out;
-	}
+	if (rd_is_string_filtered_attr(
+		    rd, "path-mig-state", path_mig_to_str(path_mig_state),
+		    nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]))
+		goto out;
 
 	type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
-	if (rd_check_is_string_filtered(rd, "type", qp_types_to_str(type)))
+	if (rd_is_string_filtered_attr(rd, "type", qp_types_to_str(type),
+				       nla_line[RDMA_NLDEV_ATTR_RES_TYPE]))
 		goto out;
 
 	state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
-	if (rd_check_is_string_filtered(rd, "state", qp_states_to_str(state)))
+	if (rd_is_string_filtered_attr(rd, "state", qp_states_to_str(state),
+				       nla_line[RDMA_NLDEV_ATTR_RES_STATE]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
@@ -157,7 +153,8 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 		comm = get_task_name(pid);
 	}
 
-	if (rd_check_is_filtered(rd, "pid", pid))
+	if (rd_is_filtered_attr(rd, "pid", pid,
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
 		goto out;
 
 	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
diff --git a/rdma/utils.c b/rdma/utils.c
index cff5297d..6bc14cd5 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -233,7 +233,7 @@ out:
 	return ret;
 }
 
-bool rd_check_is_key_exist(struct rd *rd, const char *key)
+static bool rd_check_is_key_exist(struct rd *rd, const char *key)
 {
 	struct filter_entry *fe;
 
@@ -249,8 +249,8 @@ bool rd_check_is_key_exist(struct rd *rd, const char *key)
  * Check if string entry is filtered:
  *  * key doesn't exist -> user didn't request -> not filtered
  */
-bool rd_check_is_string_filtered(struct rd *rd,
-				 const char *key, const char *val)
+static bool rd_check_is_string_filtered(struct rd *rd, const char *key,
+					const char *val)
 {
 	bool key_is_filtered = false;
 	struct filter_entry *fe;
@@ -300,7 +300,7 @@ out:
  * Check if key is filtered:
  * key doesn't exist -> user didn't request -> not filtered
  */
-bool rd_check_is_filtered(struct rd *rd, const char *key, uint32_t val)
+static bool rd_check_is_filtered(struct rd *rd, const char *key, uint32_t val)
 {
 	bool key_is_filtered = false;
 	struct filter_entry *fe;
@@ -349,6 +349,24 @@ out:
 	return key_is_filtered;
 }
 
+bool rd_is_filtered_attr(struct rd *rd, const char *key, uint32_t val,
+			 struct nlattr *attr)
+{
+	if (!attr)
+		return rd_check_is_key_exist(rd, key);
+
+	return rd_check_is_filtered(rd, key, val);
+}
+
+bool rd_is_string_filtered_attr(struct rd *rd, const char *key, const char *val,
+				struct nlattr *attr)
+{
+	if (!attr)
+		rd_check_is_key_exist(rd, key);
+
+	return rd_check_is_string_filtered(rd, key, val);
+}
+
 static void filters_cleanup(struct rd *rd)
 {
 	struct filter_entry *fe, *tmp;
-- 
2.19.1
