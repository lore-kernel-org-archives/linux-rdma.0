From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm 7/8] acm.c: Fix endian of qkey in MCMemberRecord in
 acm_init_join
Date: Tue, 06 Aug 2013 07:45:40 -0400
Message-ID: <5200E1E4.1000900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index b35c986..83c6b70 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1496,7 +1496,7 @@ static void acm_init_join(struct ib_sa_mad *mad, union ibv_gid *port_gid,
 	mc_rec = (struct ib_mc_member_rec *) mad->data;
 	acm_format_mgid(&mc_rec->mgid, pkey | 0x8000, tos, rate, mtu);
 	mc_rec->port_gid = *port_gid;
-	mc_rec->qkey = ACM_QKEY;
+	mc_rec->qkey = htonl(ACM_QKEY);
 	mc_rec->mtu = 0x80 | mtu;
 	mc_rec->tclass = tclass;
 	mc_rec->pkey = htons(pkey);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
