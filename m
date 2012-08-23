From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC] RDMA/cma: Make IPoIB port space multicast joins consistent with IPoIB
Date: Thu, 23 Aug 2012 17:28:47 +0300
Message-ID: <1345732127-7765-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

IPoIB port state multicast joins done by the CMA must be done with the same
component mask used by IPoIB, else its possible for the CMA to create a
group to which a join made by IPoIB will fail, or vise-versa.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Trying to actually reproduce the problem without this patch, I used an IPoIB
partition for which the MTU is 4k, that is set by the following in partitions.conf

# 5 = 4k 0x3 --> 0x8003 --> ib.8003
pkey2=0x3, ipoib, mtu=5, defmember=full : ALL, SELF=full;

and invoked mckey few times on a group, later tried ipoib on the group, I managed 
to make it fail only once, and I think this was actually "sendonly" flow join from 
IPoIB stand-point, e.g using "ping -b group-address" -- on ff12:401b:8003:0000:0000:0000:0101:0203 
which accounts to 225.1.2.3 (there's another failure on a system group 
ff12:401b:8003:0000:0000:0000:0000:0016 -- 224.0.0.16)

ib0.8003: no multicast record for ff12:401b:8003:0000:0000:0000:0001:0203, starting join
ib0.8003: MGID ff12:401b:8003:0000:0000:0000:0001:0203 AV ffff880223995c60, LID 0xc01c, SL 0
ib0.8003: setting up send only multicast group for ff12:401b:8003:0000:0000:0000:0101:0203
ib0.8003: no multicast record for ff12:401b:8003:0000:0000:0000:0101:0203, starting join
ib0.8003: multicast join failed for ff12:401b:8003:0000:0000:0000:0101:0203, status -22
ib0.8003: setting up send only multicast group for ff12:401b:8003:0000:0000:0000:0201:0203
ib0.8003: no multicast record for ff12:401b:8003:0000:0000:0000:0201:0203, starting join
ib0.8003: MGID ff12:401b:8003:0000:0000:0000:0201:0203 AV ffff880223995000, LID 0xc01e, SL 0
ib0.8003: setting up send only multicast group for ff12:401b:8003:0000:0000:0000:0004:0404
ib0.8003: no multicast record for ff12:401b:8003:0000:0000:0000:0004:0404, starting join
ib0.8003: MGID ff12:401b:8003:0000:0000:0000:0004:0404 AV ffff8802268fa0c0, LID 0xc01f, SL 0
ib0.8003: restarting multicast task
ib0.8003: no multicast record for ff12:401b:8003:0000:0000:0000:0000:0016, starting join
ib0.8003: stopping multicast thread
ib0.8003: adding multicast entry for mgid ff12:401b:8003:0000:0000:0000:0104:0404
ib0.8003: starting multicast thread
ib0.8003: joining MGID ff12:401b:8003:0000:0000:0000:0104:0404
ib0.8003: multicast join failed for ff12:401b:8003:0000:0000:0000:0000:0016, status -22
ib0.8003: join completion for ff12:401b:8003:0000:0000:0000:0104:0404 (status 0)
ib0.8003: MGID ff12:401b:8003:0000:0000:0000:0104:0404 AV ffff880226862f00, LID 0xc020, SL 0
ib0.8003: successfully joined all multicast groups
ib0.8003: no multicast record for ff12:401b:8003:0000:0000:0000:0000:0016, starting join
ib0.8003: multicast join failed for ff12:401b:8003:0000:0000:0000:0000:0016, status -22


what's weird is that from the SA stand point, the failing group has
the same attributes as other groups on which IPoIB managed to join:

MCMemberRecord group dump:
                MGID....................ff12:401b:8003::ffff:ffff
                Mlid....................0xC003
                Mtu.....................0x85
                pkey....................0x8003
                Rate....................0x83
                SL......................0x0


MCMemberRecord group dump:
                MGID....................ff12:401b:8003::1:203
                Mlid....................0xC01C
                Mtu.....................0x85
                pkey....................0x8003
                Rate....................0x83
                SL......................0x0
MCMemberRecord group dump:
                MGID....................ff12:401b:8003::4:404
                Mlid....................0xC01F
                Mtu.....................0x85
                pkey....................0x8003
                Rate....................0x83
                SL......................0x0
MCMemberRecord group dump:
                MGID....................ff12:401b:8003::101:203
                Mlid....................0xC01D
                Mtu.....................0x85
                pkey....................0x8003
                Rate....................0x83
                SL......................0x0
MCMemberRecord group dump:
                MGID....................ff12:401b:8003::104:404
                Mlid....................0xC020
                Mtu.....................0x85
                pkey....................0x8003
                Rate....................0x83
                SL......................0x0
MCMemberRecord group dump:
                MGID....................ff12:401b:8003::201:203
                Mlid....................0xC01E
                Mtu.....................0x85
                pkey....................0x8003
                Rate....................0x83
                SL......................0x0

 drivers/infiniband/core/cma.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7172559..f7e4cb9 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3056,9 +3056,16 @@ static int cma_join_ib_multicast(struct rdma_id_private *id_priv,
 		    IB_SA_MCMEMBER_REC_FLOW_LABEL |
 		    IB_SA_MCMEMBER_REC_TRAFFIC_CLASS;
 
-	if (id_priv->id.ps == RDMA_PS_IPOIB)
+	if (id_priv->id.ps == RDMA_PS_IPOIB) {
 		comp_mask |= IB_SA_MCMEMBER_REC_RATE |
-			     IB_SA_MCMEMBER_REC_RATE_SELECTOR;
+			     IB_SA_MCMEMBER_REC_RATE_SELECTOR |
+			     IB_SA_MCMEMBER_REC_MTU_SELECTOR |
+			     IB_SA_MCMEMBER_REC_MTU |
+			     IB_SA_MCMEMBER_REC_HOP_LIMIT;
+
+		rec.rate_selector = IB_SA_EQ;
+		rec.mtu_selector  = IB_SA_EQ;
+	}
 
 	mc->multicast.ib = ib_sa_join_multicast(&sa_client, id_priv->id.device,
 						id_priv->id.port_num, &rec,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
