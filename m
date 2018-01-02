From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/core: Add encode/decode FDR/EDR rates
Date: Tue,  2 Jan 2018 14:50:40 +0100
Message-ID: <20180102135040.5243-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aron.silverton-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

The cases for FDR/EDR signalling speed, were missing in
ib_rate_to_mult and mult_to_ib_rate giving wrong return values when
drivers convert static rate to/from inter-packet-delay.

Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Håkon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 56 ++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 3fb8fb6cc824..c4152b7ff337 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -124,16 +124,24 @@ EXPORT_SYMBOL(ib_wc_status_msg);
 __attribute_const__ int ib_rate_to_mult(enum ib_rate rate)
 {
 	switch (rate) {
-	case IB_RATE_2_5_GBPS: return  1;
-	case IB_RATE_5_GBPS:   return  2;
-	case IB_RATE_10_GBPS:  return  4;
-	case IB_RATE_20_GBPS:  return  8;
-	case IB_RATE_30_GBPS:  return 12;
-	case IB_RATE_40_GBPS:  return 16;
-	case IB_RATE_60_GBPS:  return 24;
-	case IB_RATE_80_GBPS:  return 32;
-	case IB_RATE_120_GBPS: return 48;
-	default:	       return -1;
+	case IB_RATE_2_5_GBPS: return   1;
+	case IB_RATE_5_GBPS:   return   2;
+	case IB_RATE_10_GBPS:  return   4;
+	case IB_RATE_20_GBPS:  return   8;
+	case IB_RATE_30_GBPS:  return  12;
+	case IB_RATE_40_GBPS:  return  16;
+	case IB_RATE_60_GBPS:  return  24;
+	case IB_RATE_80_GBPS:  return  32;
+	case IB_RATE_120_GBPS: return  48;
+	case IB_RATE_14_GBPS:  return   6;
+	case IB_RATE_56_GBPS:  return  22;
+	case IB_RATE_112_GBPS: return  45;
+	case IB_RATE_168_GBPS: return  67;
+	case IB_RATE_25_GBPS:  return  10;
+	case IB_RATE_100_GBPS: return  40;
+	case IB_RATE_200_GBPS: return  80;
+	case IB_RATE_300_GBPS: return 120;
+	default:	       return  -1;
 	}
 }
 EXPORT_SYMBOL(ib_rate_to_mult);
@@ -141,16 +149,24 @@ EXPORT_SYMBOL(ib_rate_to_mult);
 __attribute_const__ enum ib_rate mult_to_ib_rate(int mult)
 {
 	switch (mult) {
-	case 1:  return IB_RATE_2_5_GBPS;
-	case 2:  return IB_RATE_5_GBPS;
-	case 4:  return IB_RATE_10_GBPS;
-	case 8:  return IB_RATE_20_GBPS;
-	case 12: return IB_RATE_30_GBPS;
-	case 16: return IB_RATE_40_GBPS;
-	case 24: return IB_RATE_60_GBPS;
-	case 32: return IB_RATE_80_GBPS;
-	case 48: return IB_RATE_120_GBPS;
-	default: return IB_RATE_PORT_CURRENT;
+	case 1:   return IB_RATE_2_5_GBPS;
+	case 2:   return IB_RATE_5_GBPS;
+	case 4:   return IB_RATE_10_GBPS;
+	case 8:   return IB_RATE_20_GBPS;
+	case 12:  return IB_RATE_30_GBPS;
+	case 16:  return IB_RATE_40_GBPS;
+	case 24:  return IB_RATE_60_GBPS;
+	case 32:  return IB_RATE_80_GBPS;
+	case 48:  return IB_RATE_120_GBPS;
+	case 6:   return IB_RATE_14_GBPS;
+	case 22:  return IB_RATE_56_GBPS;
+	case 45:  return IB_RATE_112_GBPS;
+	case 67:  return IB_RATE_168_GBPS;
+	case 10:  return IB_RATE_25_GBPS;
+	case 40:  return IB_RATE_100_GBPS;
+	case 80:  return IB_RATE_200_GBPS;
+	case 120: return IB_RATE_300_GBPS;
+	default:  return IB_RATE_PORT_CURRENT;
 	}
 }
 EXPORT_SYMBOL(mult_to_ib_rate);
-- 
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
