From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/core: Fix uninitialized variable use in check_qp_port_pkey_settings
Date: Fri, 30 Jun 2017 17:35:35 +0300
Message-ID: <1498833335-937-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Check the return value from get_pkey_and_subnet_prefix to prevent using
uninitialized variables.

Fixes: d291f1a65232 ("IB/core: Enforce PKey security on QPs")
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/security.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 3e8c389..70ad19c 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -120,21 +120,25 @@ static int check_qp_port_pkey_settings(struct ib_ports_pkeys *pps,
 		return 0;
 
 	if (pps->main.state != IB_PORT_PKEY_NOT_VALID) {
-		get_pkey_and_subnet_prefix(&pps->main,
-					   &pkey,
-					   &subnet_prefix);
+		ret = get_pkey_and_subnet_prefix(&pps->main,
+						 &pkey,
+						 &subnet_prefix);
+		if (ret)
+			return ret;
 
 		ret = enforce_qp_pkey_security(pkey,
 					       subnet_prefix,
 					       sec);
+		if (ret)
+			return ret;
 	}
-	if (ret)
-		return ret;
 
 	if (pps->alt.state != IB_PORT_PKEY_NOT_VALID) {
-		get_pkey_and_subnet_prefix(&pps->alt,
-					   &pkey,
-					   &subnet_prefix);
+		ret = get_pkey_and_subnet_prefix(&pps->alt,
+						 &pkey,
+						 &subnet_prefix);
+		if (ret)
+			return ret;
 
 		ret = enforce_qp_pkey_security(pkey,
 					       subnet_prefix,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
