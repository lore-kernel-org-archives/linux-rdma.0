From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/4] opensm/osm_sa_mcmember_record.c: Add mtu validation if
 supplied
Date: Tue, 04 Oct 2011 09:53:23 -0400
Message-ID: <4E8B0FD3.7020608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_mcmember_record.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 451f774..ad48d00 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -1452,6 +1452,20 @@ static uint8_t rate_is_valid(IN const ib_sa_mad_t *p_sa_mad,
 	return 1;
 }
 
+static int mtu_is_valid(IN const ib_sa_mad_t *p_sa_mad,
+			IN const ib_member_rec_t *p_recvd_mcmember_rec)
+{
+	uint8_t mtu;
+
+	/* Validate MTU if supplied */
+	if ((p_sa_mad->comp_mask & IB_MCR_COMPMASK_MTU_SEL) &&
+	    (p_sa_mad->comp_mask & IB_MCR_COMPMASK_MTU)) {
+		mtu = (uint8_t) (p_recvd_mcmember_rec->mtu & 0x3F);
+		return ib_mtu_is_valid(mtu);
+	}
+	return 1;
+}
+
 void osm_mcmr_rcv_process(IN void *context, IN void *data)
 {
 	osm_sa_t *sa = context;
@@ -1492,7 +1506,8 @@ void osm_mcmr_rcv_process(IN void *context, IN void *data)
 					  IB_SA_MAD_STATUS_INSUF_COMPS);
 			goto Exit;
 		}
-		if (!rate_is_valid(p_sa_mad, p_recvd_mcmember_rec)) {
+		if (!rate_is_valid(p_sa_mad, p_recvd_mcmember_rec) ||
+		    !mtu_is_valid(p_sa_mad, p_recvd_mcmember_rec)) {
 			osm_sa_send_error(sa, p_madw,
 					  IB_SA_MAD_STATUS_REQ_INVALID);
 			goto Exit;
@@ -1514,7 +1529,8 @@ void osm_mcmr_rcv_process(IN void *context, IN void *data)
 					  IB_SA_MAD_STATUS_INSUF_COMPS);
 			goto Exit;
 		}
-		if (!rate_is_valid(p_sa_mad, p_recvd_mcmember_rec)) {
+		if (!rate_is_valid(p_sa_mad, p_recvd_mcmember_rec) ||
+		    !mtu_is_valid(p_sa_mad, p_recvd_mcmember_rec)) {
 			osm_sa_send_error(sa, p_madw,
 					  IB_SA_MAD_STATUS_REQ_INVALID);
 			goto Exit;
@@ -1527,7 +1543,8 @@ void osm_mcmr_rcv_process(IN void *context, IN void *data)
 		break;
 	case IB_MAD_METHOD_GET:
 	case IB_MAD_METHOD_GETTABLE:
-		if (!rate_is_valid(p_sa_mad, p_recvd_mcmember_rec)) {
+		if (!rate_is_valid(p_sa_mad, p_recvd_mcmember_rec) ||
+		    !mtu_is_valid(p_sa_mad, p_recvd_mcmember_rec)) {
 			osm_sa_send_error(sa, p_madw,
 					  IB_SA_MAD_STATUS_REQ_INVALID);
 			goto Exit;
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
