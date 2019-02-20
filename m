From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 02/19] rdma: Remove duplicated print code
Date: Wed, 20 Feb 2019 09:21:19 +0200
Message-ID: <20190220072136.3840-3-leon@kernel.org>
References: <20190220072136.3840-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There is no need to keep same print functions for
uint32_t and uint64_t, unify them into one function.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/rdma/res.c b/rdma/res.c
index 6b0f5fe3..87865ec8 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -808,28 +808,20 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static void print_key(struct rd *rd, const char *name, uint32_t val)
+static void print_key(struct rd *rd, const char *name, uint64_t val)
 {
 	if (rd->json_output)
 		jsonw_xint_field(rd->jw, name, val);
 	else
-		pr_out("%s 0x%x ", name, val);
+		pr_out("%s 0x%" PRIx64 " ", name, val);
 }
 
-static void print_iova(struct rd *rd, uint64_t val)
+static void res_print_uint(struct rd *rd, const char *name, uint64_t val)
 {
 	if (rd->json_output)
-		jsonw_xint_field(rd->jw, "iova", val);
+		jsonw_uint_field(rd->jw, name, val);
 	else
-		pr_out("iova 0x%" PRIx64 " ", val);
-}
-
-static void print_mrlen(struct rd *rd, uint64_t val)
-{
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "mrlen", val);
-	else
-		pr_out("mrlen %" PRIu64 " ", val);
+		pr_out("%s %" PRIu64 " ", name, val);
 }
 
 static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
@@ -907,8 +899,8 @@ static int res_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (nla_line[RDMA_NLDEV_ATTR_RES_LKEY])
 			print_key(rd, "lkey", lkey);
 		if (nla_line[RDMA_NLDEV_ATTR_RES_IOVA])
-			print_iova(rd, iova);
-		print_mrlen(rd, mrlen);
+			print_key(rd, "iova", iova);
+		res_print_uint(rd, "mrlen", mrlen);
 		print_pid(rd, pid);
 		print_comm(rd, comm, nla_line);
 
-- 
2.19.1
