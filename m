From: Aleksey Senin <alex-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Subject: [PATCH V1 1/4] Rename RAW_ETY to RAW_ETHERTYPE
Date: Sun, 04 Jul 2010 16:55:57 +0300
Message-ID: <4C3092ED.6000701@senin.name>
References: <4C308E07.7050903@senin.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C308E07.7050903-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yiftah Shahar <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rename RAW_ETY to RAW_ETHERTYPE in order to be more precise to
IBA qp types.

See discussion at
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04530.html

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c         |    4 ++--
 drivers/infiniband/hw/ehca/ehca_qp.c    |    2 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c |    2 +-
 include/rdma/ib_verbs.h                 |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 29edeba..af7a8b0 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -326,8 +326,8 @@ EXPORT_SYMBOL(ib_create_qp);
 
 static const struct {
 	int			valid;
-	enum ib_qp_attr_mask	req_param[IB_QPT_RAW_ETY + 1];
-	enum ib_qp_attr_mask	opt_param[IB_QPT_RAW_ETY + 1];
+	enum ib_qp_attr_mask	req_param[IB_QPT_RAW_ETHERTYPE + 1];
+	enum ib_qp_attr_mask	opt_param[IB_QPT_RAW_ETHERTYPE + 1];
 } qp_state_table[IB_QPS_ERR + 1][IB_QPS_ERR + 1] = {
 	[IB_QPS_RESET] = {
 		[IB_QPS_RESET] = { .valid = 1 },
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 47d388e..32fb342 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -251,7 +251,7 @@ static inline int ibqptype2servicetype(enum ib_qp_type ibqptype)
 		return ST_UD;
 	case IB_QPT_RAW_IPV6:
 		return -EINVAL;
-	case IB_QPT_RAW_ETY:
+	case IB_QPT_RAW_ETHERTYPE:
 		return -EINVAL;
 	default:
 		ehca_gen_err("Invalid ibqptype=%x", ibqptype);
diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index 3603ae8..f4ceecd 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -1817,7 +1817,7 @@ int mthca_CONF_SPECIAL_QP(struct mthca_dev *dev, int type, u32 qpn,
 	case IB_QPT_RAW_IPV6:
 		op_mod = 2;
 		break;
-	case IB_QPT_RAW_ETY:
+	case IB_QPT_RAW_ETHERTYPE:
 		op_mod = 3;
 		break;
 	default:
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4f4e81b..ecf098a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -562,7 +562,7 @@ enum ib_qp_type {
 	IB_QPT_UC,
 	IB_QPT_UD,
 	IB_QPT_RAW_IPV6,
-	IB_QPT_RAW_ETY
+	IB_QPT_RAW_ETHERTYPE
 };
 
 enum ib_qp_create_flags {
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
