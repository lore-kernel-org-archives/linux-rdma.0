From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH librdmacm] udaddy/ucmatose: allow easy setting of tos in
 hex
Date: Sun, 11 Dec 2011 17:40:51 +0200
Message-ID: <alpine.LRH.2.00.1112111740050.5556@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Under IBoE, the 3 MSBits of the TOS map to the SL, hence letting
the user to specify them in hex makes the interface friendlier.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/cmatose.c |    2 +-
 examples/udaddy.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/examples/cmatose.c b/examples/cmatose.c
index 82e0d7c..ce99f22 100644
--- a/examples/cmatose.c
+++ b/examples/cmatose.c
@@ -702,7 +702,7 @@ int main(int argc, char **argv)
 			break;
 		case 't':
 			set_tos = 1;
-			tos = (uint8_t) atoi(optarg);
+			tos = strtoul(optarg, NULL, 0);
 			break;
 		case 'p':
 			port = atoi(optarg);
diff --git a/examples/udaddy.c b/examples/udaddy.c
index 1534df5..365ce4e 100644
--- a/examples/udaddy.c
+++ b/examples/udaddy.c
@@ -655,7 +655,7 @@ int main(int argc, char **argv)
 			break;
 		case 't':
 			set_tos = 1;
-			tos = (uint8_t) atoi(optarg);
+			tos = strtoul(optarg, NULL, 0);
 			break;
 		case 'p':
 			port_space = strtol(optarg, NULL, 0);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
