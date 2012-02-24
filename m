From: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Subject: [PATCH resend] libmlx4: Add multicast IBoE support
Date: Fri, 24 Feb 2012 10:32:30 -0600
Message-ID: <1330101150-1253-1-git-send-email-sbohrer@rgmadvisors.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add multicast support for IBoE to the address handle creation flow.
Derived from work by Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Signed-off-by: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
---
 src/verbs.c |   38 +++++++++++++++++++++++++++++++-------
 1 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/src/verbs.c b/src/verbs.c
index 199d107..2772de5 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -624,6 +624,11 @@ static int link_local_gid(const union ibv_gid *gid)
 	return 0;
 }
 
+static int is_multicast_gid(const union ibv_gid *gid)
+{
+	return gid->raw[0] == 0xff;
+}
+
 static uint16_t get_vlan_id(union ibv_gid *gid)
 {
 	uint16_t vid;
@@ -631,9 +636,12 @@ static uint16_t get_vlan_id(union ibv_gid *gid)
 	return vid < 0x1000 ? vid : 0xffff;
 }
 
-static int mlx4_resolve_grh_to_l2(struct mlx4_ah *ah, struct ibv_ah_attr *attr)
+static int mlx4_resolve_grh_to_l2(struct ibv_pd *pd, struct mlx4_ah *ah,
+				  struct ibv_ah_attr *attr)
 {
+	int err, i;
 	uint16_t vid;
+	union ibv_gid sgid;
 
 	if (link_local_gid(&attr->grh.dgid)) {
 		memcpy(ah->mac, &attr->grh.dgid.raw[8], 3);
@@ -641,13 +649,29 @@ static int mlx4_resolve_grh_to_l2(struct mlx4_ah *ah, struct ibv_ah_attr *attr)
 		ah->mac[0] ^= 2;
 
 		vid = get_vlan_id(&attr->grh.dgid);
-		if (vid != 0xffff) {
-			ah->av.port_pd |= htonl(1 << 29);
-			ah->vlan = vid | ((attr->sl & 7) << 13);
-		}
-		return 0;
+	} else if (is_multicast_gid(&attr->grh.dgid)) {
+		ah->mac[0] = 0x33;
+		ah->mac[1] = 0x33;
+		for (i = 2; i < 6; ++i)
+			ah->mac[i] = attr->grh.dgid.raw[i + 10];
+
+		err = ibv_query_gid(pd->context, attr->port_num,
+				    attr->grh.sgid_index, &sgid);
+		if (err)
+			return err;
+
+		ah->av.dlid = htons(0xc0000);
+		ah->av.port_pd |= htonl(1 << 31);
+
+		vid = get_vlan_id(&sgid);
 	} else
 		return 1;
+
+	if (vid != 0xFFFF) {
+		ah->av.port_pd |= htonl(1 << 29);
+		ah->vlan = vid | ((attr->sl & 7) << 13);
+	}
+	return 0;
 }
 
 struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
@@ -687,7 +711,7 @@ struct ibv_ah *mlx4_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 	}
 
 	if (port_attr.link_layer == IBV_LINK_LAYER_ETHERNET)
-		if (mlx4_resolve_grh_to_l2(ah, attr)) {
+		if (mlx4_resolve_grh_to_l2(pd, ah, attr)) {
 			free(ah);
 			return NULL;
 		}
-- 
1.7.7.5


-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
