From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 1/3] RAW_PACKET QP type definition
Date: Wed, 03 Nov 2010 16:33:44 +0200
Message-ID: <4CD172C8.4010700@voltaire.com>
References: <4CD171F0.8020506@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD171F0.8020506-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch add a new QP type named RAW_PACKET.

This type of QP is used in Ethernet environment and intended for
creation of a whole packet, including L2 headers, from userspace.

Reserve a place for future XRC patch in order to be sure that OFED
kernel ABI will not broken when XRC and RAW patches will be accepted
to upstream kernel.

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/core/verbs.c |    4 ++--
 include/rdma/ib_verbs.h         |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index af7a8b0..b04b419 100644
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
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ecf098a..555165b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -562,7 +562,8 @@ enum ib_qp_type {
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
