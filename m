From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 6/7] libmlx4: add IBoE UD/VLANs support
Date: Tue, 19 Jul 2011 12:34:15 +0300
Message-ID: <alpine.LRH.2.00.1107191233190.5580@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1107191223460.5580-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add VLANs support for the UD address handle creation flow,
where the vlan id is taken from the destination GID and the
and vlan priority from the IB SL specified by the application.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.h  |    1 +
 src/qp.c    |    1 +
 src/verbs.c |    9 +++++++--
 src/wqe.h   |    2 +-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/src/mlx4.h b/src/mlx4.h
index b277b06..0ad838d 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -241,6 +241,7 @@ struct mlx4_av {
 struct mlx4_ah {
 	struct ibv_ah			ibv_ah;
 	struct mlx4_av			av;
+	uint16_t			vlan;
 	uint8_t				mac[6];
 };

diff --git a/src/qp.c b/src/qp.c
index 4d79e38..40a6689 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -144,6 +144,7 @@ static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 	memcpy(dseg->av, &to_mah(wr->wr.ud.ah)->av, sizeof (struct mlx4_av));
 	dseg->dqpn = htonl(wr->wr.ud.remote_qpn);
 	dseg->qkey = htonl(wr->wr.ud.remote_qkey);
+	dseg->vlan = htons(to_mah(wr->wr.ud.ah)->vlan);
 	memcpy(dseg->mac, to_mah(wr->wr.ud.ah)->mac, 6);
 }

diff --git a/src/verbs.c b/src/verbs.c
index 6620ac2..8aa9860 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -634,13 +634,18 @@ static uint16_t get_vlan_id(union ibv_gid *gid)

 static int mlx4_resolve_grh_to_l2(struct mlx4_ah *ah, struct ibv_ah_attr *attr)
 {
-	if (get_vlan_id(&attr->grh.dgid) != 0xffff)
-		return 1;
+	uint16_t vid;

 	if (link_local_gid(&attr->grh.dgid)) {
 		memcpy(ah->mac, &attr->grh.dgid.raw[8], 3);
 		memcpy(ah->mac + 3, &attr->grh.dgid.raw[13], 3);
 		ah->mac[0] ^= 2;
+
+		vid = get_vlan_id(&attr->grh.dgid);
+		if (vid != 0xffff) {
+			ah->av.port_pd |= htonl(1 << 29);
+			ah->vlan = vid | ((attr->sl & 7) << 13);
+		}
 		return 0;
 	} else
 		return 1;
diff --git a/src/wqe.h b/src/wqe.h
index 043f0da..bbd22ba 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -78,7 +78,7 @@ struct mlx4_wqe_datagram_seg {
 	uint32_t		av[8];
 	uint32_t		dqpn;
 	uint32_t		qkey;
-	uint16_t		reserved;
+	uint16_t		vlan;
 	uint8_t			mac[6];
 };

-- 
1.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
