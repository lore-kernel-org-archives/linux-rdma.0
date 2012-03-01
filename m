From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 1/4] IB/core: add RAW Packet QP type
Date: Thu, 1 Mar 2012 12:17:51 +0200
Message-ID: <alpine.LRH.2.00.1203011217020.19663@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com> <alpine.LRH.2.00.1201171337040.26871@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201171337040.26871-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Applications that use this qp type should build the whole packet,
including L2 headers when sending. On the receive side, the HW isn't
expected to strip any headers. The new qp type designated usage is
from user-space in Ethernet environments, e.g by applications that do
TCP/IP offloading. Only processes with the NET_RAW capability may open
such qp. The name raw packet was selected to resemble the similarity
to AF_PACKET / SOL_RAW sockets.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

changes from V0:
 removed spaces at ib_verbs.h that went in by mistake

 drivers/infiniband/core/uverbs_cmd.c |    3 +++
 drivers/infiniband/core/verbs.c      |    1 +
 include/rdma/ib_verbs.h              |    2 +-
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 4d27e4c..7d801e6 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1399,6 +1399,9 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;

+	if (cmd.qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
+		return -EPERM;
+
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 575b780..140f9a5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -479,6 +479,7 @@ static const struct {
 				[IB_QPT_UD]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_QKEY),
+				[IB_QPT_RAW_PACKET] = IB_QP_PORT,
 				[IB_QPT_UC]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_ACCESS_FLAGS),
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c3cca5a..a3fa323 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -605,7 +605,7 @@ enum ib_qp_type {
 	IB_QPT_UD,
 	IB_QPT_RAW_IPV6,
 	IB_QPT_RAW_ETHERTYPE,
-	/* Save 8 for RAW_PACKET */
+	IB_QPT_RAW_PACKET = 8,
 	IB_QPT_XRC_INI = 9,
 	IB_QPT_XRC_TGT,
 	IB_QPT_MAX
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
