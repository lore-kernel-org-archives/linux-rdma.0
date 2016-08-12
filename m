From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest] ib_read_bw: fix testing with XRC connections
Date: Fri, 12 Aug 2016 14:40:12 -0400
Message-ID: <1471027212-41282-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Zhaojuan Guo <zguo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

At some point, support for testing XRC connections was broken. Our QA
folks report that it used to work, but does not in 3.0:

$ ib_read_bw ib0-qe-06 -a -c XRC -F
Unknown connection type
 Unable to create QP.
Failed to create QP.
 Couldn't create IB resources
---------------------------------------------------------------------------------------
                    RDMA_Read BW Test
 Dual-port       : OFF		Device         : mlx5_0
 Number of qps   : 1		Transport type : IB
 Connection type : XRC		Using SRQ      : ON
 TX depth        : 128
 CQ Moderation   : 100
 Mtu             : 4096[B]
 Link type       : IB
 Outstand reads  : 16
 rdma_cm QPs	 : OFF
 Data ex. method : Ethernet

A bit of digging showed that assorted qp creation functions are lacking
switch cases for XRC, as well as create_reg_qp_main() lacking a path for
XRC. I suspect more surgery for create_reg_qp_main() to bring it closer
in line with create_exp_qp_main() might be in order, but with this
patch, for the previously failing test case, I now get:

$ ./ib_read_bw ib0-qe-06 -a -c XRC -F
---------------------------------------------------------------------------------------
                    RDMA_Read BW Test
 Dual-port       : OFF          Device         : mlx5_0
 Number of qps   : 1            Transport type : IB
 Connection type : XRC          Using SRQ      : ON
 TX depth        : 128
 CQ Moderation   : 100
 Mtu             : 4096[B]
 Link type       : IB
 Outstand reads  : 16
 rdma_cm QPs     : OFF
 Data ex. method : Ethernet
---------------------------------------------------------------------------------------
 local address: LID 0x34 QPN 0x0123 PSN 0x35a519 OUT 0x10 RKey 0x00fd4d VAddr 0x002b23febf4000 SRQn 0x000122
 remote address: LID 0x36 QPN 0x00f2 PSN 0x9ae18b OUT 0x10 RKey 0x00daf3 VAddr 0x002b92913eb000 SRQn 0x0000f1
---------------------------------------------------------------------------------------
 #bytes     #iterations    BW peak[MB/sec]    BW average[MB/sec]   MsgRate[Mpps]
 2          1000             15.51              14.05              7.366099
 4          1000             31.25              31.24              8.190245
 8          1000             62.51              62.50              8.191350
 16         1000             123.23             120.64             7.906333
 32         1000             248.82             248.26             8.134886
 64         1000             482.60             481.79             7.893613
 128        1000             947.58             945.85             7.748387
 256        1000             1820.35            1817.00            7.442447
 512        1000             3320.31            3313.77            6.786603
 1024       1000             5570.99            5521.33            5.653842
 2048       1000             6120.39            6119.02            3.132939
 4096       1000             6214.90            6214.54            1.590922
 8192       1000             6230.94            6229.90            0.797427
 16384      1000             6236.06            6235.92            0.399099
 32768      1000             6239.36            6239.31            0.199658
 65536      1000             6240.82            6240.71            0.099851
 131072     1000             6241.56            6241.55            0.049932
 262144     1000             6241.97            6241.97            0.024968
 524288     1000             6242.17            6242.17            0.012484
 1048576    1000             6242.29            6242.28            0.006242
 2097152    1000             6242.32            6242.31            0.003121
 4194304    1000             6242.35            6242.35            0.001561
 8388608    1000             6242.37            6242.37            0.000780
---------------------------------------------------------------------------------------

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
CC: Zhaojuan Guo <zguo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Zhaojuan Guo <zguo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_resources.c | 41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index 6915a66..951a06b 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -1449,10 +1449,20 @@ int modify_qp_to_init(struct pingpong_context *ctx,
 int create_reg_qp_main(struct pingpong_context *ctx,
 		struct perftest_parameters *user_param, int i, int num_of_qps)
 {
-	ctx->qp[i] = ctx_qp_create(ctx,user_param);
-	if (ctx->qp[i] == NULL) {
-		fprintf(stderr," Unable to create QP.\n");
-		return FAILURE;
+	if (user_param->use_xrc) {
+		#ifdef HAVE_XRCD
+		ctx->qp[i] = ctx_xrc_qp_create(ctx, user_param, i);
+		#endif
+		if (ctx->qp[i] == NULL) {
+			fprintf(stderr," Unable to create XRC QP.\n");
+			return FAILURE;
+		}
+	} else {
+		ctx->qp[i] = ctx_qp_create(ctx,user_param);
+		if (ctx->qp[i] == NULL) {
+			fprintf(stderr," Unable to create QP.\n");
+			return FAILURE;
+		}
 	}
 
 	return SUCCESS;
@@ -1625,6 +1635,14 @@ struct ibv_qp* ctx_exp_qp_create(struct pingpong_context *ctx,
 		case RC : attr.qp_type = IBV_QPT_RC; break;
 		case UC : attr.qp_type = IBV_QPT_UC; break;
 		case UD : attr.qp_type = IBV_QPT_UD; break;
+		#ifdef HAVE_XRCD
+		case XRC :
+		if (user_param->machine == SERVER)
+			attr.qp_type = IBV_QPT_XRC_RECV;
+		else
+			attr.qp_type = IBV_QPT_XRC_SEND;
+		break;
+		#endif
 		#ifdef HAVE_RAW_ETH
 		case RawEth : attr.qp_type = IBV_QPT_RAW_PACKET; break;
 		#endif
@@ -1681,6 +1699,14 @@ struct ibv_qp* ctx_qp_create(struct pingpong_context *ctx,
 		case RC : attr.qp_type = IBV_QPT_RC; break;
 		case UC : attr.qp_type = IBV_QPT_UC; break;
 		case UD : attr.qp_type = IBV_QPT_UD; break;
+		#ifdef HAVE_XRCD
+		case XRC :
+		if (user_param->machine == SERVER)
+			attr.qp_type = IBV_QPT_XRC_RECV;
+		else
+			attr.qp_type = IBV_QPT_XRC_SEND;
+		break;
+		#endif
 		#ifdef HAVE_RAW_ETH
 		case RawEth : attr.qp_type = IBV_QPT_RAW_PACKET; break;
 		#endif
@@ -1750,7 +1776,12 @@ struct ibv_qp* ctx_atomic_qp_create(struct pingpong_context *ctx,
 		case UC : attr.qp_type = IBV_QPT_UC; break;
 		case UD : attr.qp_type = IBV_QPT_UD; break;
 		#ifdef HAVE_XRCD
-		case XRC : attr.qp_type = IBV_QPT_XRC; break;
+		case XRC :
+		if (user_param->machine == SERVER)
+			attr.qp_type = IBV_QPT_XRC_RECV;
+		else
+			attr.qp_type = IBV_QPT_XRC_SEND;
+		break;
 		#endif
 		#ifdef HAVE_RAW_ETH
 		case RawEth : attr.qp_type = IBV_QPT_RAW_PACKET; break;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
