From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2] opensm: fixed memory leak in osm_console()
Date: Mon, 7 Mar 2011 17:35:01 +0200
Message-ID: <20110307153501.GQ5577@calypso.voltaire.com>
References: <20110307100302.GJ5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110307100302.GJ5577-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Variable temp is unsigned.

Changes from v1:
Changed strtol() to strtoul()
Added 2 more cases 'p' and 'l'

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/main.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/opensm/main.c b/opensm/main.c
index 756fe6f..b3abdbb 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -811,7 +811,7 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'l':
-			temp = strtol(optarg, NULL, 0);
+			temp = strtoul(optarg, NULL, 0);
 			if (temp > 7) {
 				fprintf(stderr,
 					"ERROR: LMC must be 7 or less.\n");
@@ -876,8 +876,8 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'p':
-			temp = strtol(optarg, NULL, 0);
-			if (0 > temp || 15 < temp) {
+			temp = strtoul(optarg, NULL, 0);
+			if (temp > 15) {
 				fprintf(stderr,
 					"ERROR: priority must be between 0 and 15\n");
 				return -1;
@@ -986,8 +986,8 @@ int main(int argc, char *argv[])
 			opt.do_mesh_analysis = TRUE;
 			break;
 		case 6:
-			temp = strtol(optarg, NULL, 0);
-			if (temp < 0 || temp >= IB_MAX_NUM_VLS) {
+			temp = strtoul(optarg, NULL, 0);
+			if (temp >= IB_MAX_NUM_VLS) {
 				fprintf(stderr,
 					"ERROR: starting lash vl must be between 0 and 15\n");
 				return -1;
@@ -996,8 +996,8 @@ int main(int argc, char *argv[])
 			printf(" LASH starting VL = %d\n", opt.lash_start_vl);
 			break;
 		case 7:
-			temp = strtol(optarg, NULL, 0);
-			if (temp < 0 || temp > 15) {
+			temp = strtoul(optarg, NULL, 0);
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
