From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH TRIVIAL rdma-core] srp_daemon.c: Cosmetic change to some error
 messages
Date: Fri, 8 Dec 2017 14:27:10 -0500
Message-ID: <e2975299-b1e8-25a3-c263-6a4cac991bc6@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Change opensm to SM

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index 2465ccd..cec36db 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -2212,7 +2212,7 @@ catas_start:
 			if (res->ud_res->ah) {
 				if (register_to_traps(res, 1))
 					pr_err("Fail to register to traps, maybe there "
-					       "is no opensm running on fabric or IB port is down\n");
+					       "is no SM running on fabric or IB port is down\n");
 				else
 					subscribed = 1;
 			}
@@ -2346,7 +2346,7 @@ static int recalc(struct resources *res)
 
 	umad_res->sm_lid = strtol(val, NULL, 0);
 	if (umad_res->sm_lid == 0) {
-		pr_err("SM LID is 0, maybe no opensm is running\n");
+		pr_err("SM LID is 0, maybe no SM is running\n");
 		return -1;
 	}
 
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
