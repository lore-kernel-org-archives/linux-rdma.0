From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 4/6] ib[netdiscover portstate].c: Add HDR
 support
Date: Tue, 28 Nov 2017 17:12:01 -0500
Message-ID: <5e17e529-a54e-e425-eb89-dbce256bc8f1@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Per MgtWG comments #9364-9366

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/ibnetdiscover.c | 3 +++
 src/ibportstate.c   | 7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
index 68374a2..6f360bb 100644
--- a/src/ibnetdiscover.c
+++ b/src/ibnetdiscover.c
@@ -115,6 +115,9 @@ char *dump_linkspeedext_compat(uint32_t espeed, uint32_t speed, uint32_t fdr10)
 	case 2:
 		return ("EDR");
 		break;
+	case 4:
+		return ("HDR");
+		break;
 	}
 	return ("???");
 }
diff --git a/src/ibportstate.c b/src/ibportstate.c
index 06bd5d2..6b78fa7 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -356,7 +356,12 @@ static void validate_speed(int speed, int peerspeed, int lsa)
 
 static void validate_extended_speed(int espeed, int peerespeed, int lsea)
 {
-	if ((espeed & peerespeed & 0x2)) {
+	if ((espeed & peerespeed & 0x4)) {
+		if (lsea != 4)
+			IBWARN
+			    ("Peer ports operating at active extended speed %d rather than 4 (53.125 Gbps)",
+			     lsea);
+	} else if ((espeed & peerespeed & 0x2)) {
 		if (lsea != 2)
 			IBWARN
 			    ("Peer ports operating at active extended speed %d rather than 2 (25.78125 Gbps)",
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
