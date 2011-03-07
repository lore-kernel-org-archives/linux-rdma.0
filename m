From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: removed unnecessary checks in main()
Date: Mon, 7 Mar 2011 12:01:46 +0200
Message-ID: <20110307100146.GI5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Variable temp is unsigned.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/main.c b/opensm/main.c
index 756fe6f..ef4b805 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -987,7 +987,7 @@ int main(int argc, char *argv[])
 			break;
 		case 6:
 			temp = strtol(optarg, NULL, 0);
-			if (temp < 0 || temp >= IB_MAX_NUM_VLS) {
+			if (temp >= IB_MAX_NUM_VLS) {
 				fprintf(stderr,
 					"ERROR: starting lash vl must be between 0 and 15\n");
 				return -1;
@@ -997,7 +997,7 @@ int main(int argc, char *argv[])
 			break;
 		case 7:
 			temp = strtol(optarg, NULL, 0);
-			if (temp < 0 || temp > 15) {
+			if (temp > 15) {
 				fprintf(stderr,
 					"ERROR: SM's SL must be between 0 and 15\n");
 				return -1;
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
