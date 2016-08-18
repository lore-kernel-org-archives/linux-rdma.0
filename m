From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest 19/23] perftest_resources: make sure num_of_qps is never 0
Date: Thu, 18 Aug 2016 13:32:14 -0400
Message-ID: <1471541538-20270-20-git-send-email-jarod@redhat.com>
References: <1471541538-20270-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471541538-20270-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Somehow or another, if someone were to feed a 1 into num_of_qps, then we'd
have num_of_qps = 1 / 2 = 0, and later on, portindex % 0 -- a divide by
zero condition. Make sure that can't happen.

This resolves a coverity/clang warning.

CC: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_resources.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index 7e982e9..959a5df 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -1830,6 +1830,8 @@ int ctx_modify_dc_qp_to_init(struct ibv_qp *qp,struct perftest_parameters *user_
 
 	if (user_param->duplex || user_param->tst == LAT) {
 		num_of_qps /= 2;
+		if (num_of_qps < 2)
+			num_of_qps = 2;
 		num_of_qps_per_port = num_of_qps / 2;
 	}
 
@@ -1896,6 +1898,8 @@ int ctx_modify_qp_to_init(struct ibv_qp *qp,struct perftest_parameters *user_par
 
 	if ( user_param->use_xrc && (user_param->duplex || user_param->tst == LAT)) {
 		num_of_qps /= 2;
+		if (num_of_qps < 2)
+			num_of_qps = 2;
 		num_of_qps_per_port = num_of_qps / 2;
 	}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
