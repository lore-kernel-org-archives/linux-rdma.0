From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][MINOR] opensm/osm_sa_mcmember_record.c: Return proper scope
 for query with valid SA key
Date: Fri, 11 Jan 2013 14:33:56 -0500
Message-ID: <50F06924.8070005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Rather than return Scope 2, Scope 0 is returned when SA MCMemberRecord queried with valid SA key.

saquery MCMR --mlid 0xc000
MCMember Record dump:
MGID....................ff12:401b:ffff::ffff:ffff
PortGid.................::
qkey....................0xb1b
mlid....................0xc000
mtu.....................0x84
TClass..................0x0
pkey....................0xffff
rate....................0x83
pkt_life................0x92
SL......................0x0
FlowLabel...............0x0
HopLimit................0x0
Scope...................0x2
JoinState...............0x0
ProxyJoin...............0x0

saquery MCMR --mlid 0xc000 --smkey 1
MCMember Record dump:
MGID....................ff12:401b:ffff::ffff:ffff
PortGid.................fe80::8:f104:39a:169
qkey....................0xb1b
mlid....................0xc000
mtu.....................0x84
TClass..................0x0
pkey....................0xffff
rate....................0x83
pkt_life................0x92
SL......................0x0
FlowLabel...............0x0
HopLimit................0x0
Scope...................0x0
JoinState...............0x1
ProxyJoin...............0x0

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 4a5113a..96c1139 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -97,6 +97,7 @@ static void copy_from_create_mc_rec(IN ib_member_rec_t * dest,
 	dest->tclass = src->tclass;
 	dest->pkey = src->pkey;
 	dest->sl_flow_hop = src->sl_flow_hop;
+	dest->scope_state = src->scope_state;
 	dest->mtu = src->mtu;
 	dest->rate = src->rate;
 	dest->pkt_life = src->pkt_life;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
