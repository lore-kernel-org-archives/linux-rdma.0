From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 1/4] RAW_PACKET QP type definition
Date: Mon, 6 Dec 2010 09:34:53 +0200
Message-ID: <4CFC921D.3000907@voltaire.com>
References: <4CFC918D.1090708@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFC918D.1090708-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reserve a place for future XRC patch in order to be sure that
OFED kernel ABI will not broken when XRC and RAW patches will be
accepted to upstream kernel.

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |    5 +++--
 include/rdma/ib_verbs.h         |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index af7a8b0..611c13c 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -326,8 +326,8 @@ EXPORT_SYMBOL(ib_create_qp);
 
 static const struct {
 	int			valid;
-	enum ib_qp_attr_mask	req_param[IB_QPT_RAW_ETHERTYPE + 1];
-	enum ib_qp_attr_mask	opt_param[IB_QPT_RAW_ETHERTYPE + 1];
+	enum ib_qp_attr_mask	req_param[IB_QPT_RAW_PACKET + 1];
+	enum ib_qp_attr_mask	opt_param[IB_QPT_RAW_PACKET + 1];
 } qp_state_table[IB_QPS_ERR + 1][IB_QPS_ERR + 1] = {
 	[IB_QPS_RESET] = {
 		[IB_QPS_RESET] = { .valid = 1 },
@@ -337,6 +337,7 @@ static const struct {
 				[IB_QPT_UD]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_QKEY),
+				[IB_QPT_RAW_PACKET] = IB_QP_PORT,
 				[IB_QPT_UC]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_ACCESS_FLAGS),
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e04c488..e14e3f8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -561,7 +561,8 @@ enum ib_qp_type {
 	IB_QPT_UC,
 	IB_QPT_UD,
 	IB_QPT_RAW_IPV6,
-	IB_QPT_RAW_ETHERTYPE
+	IB_QPT_RAW_ETHERTYPE = 7,
+	IB_QPT_RAW_PACKET = 8
 };
 
 enum ib_qp_create_flags {
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
