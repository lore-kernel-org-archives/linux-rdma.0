From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags/vendstat: Fix GeneralInfo SW version
Date: Tue, 17 Dec 2013 17:27:24 +0200
Message-ID: <20131217152724.GA8696@r-ufm5-17.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix the offset for GeneralInfo SWInfo for IS4

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/vendstat.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/src/vendstat.c b/src/vendstat.c
index a53e80d..f28ff02 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -87,6 +87,7 @@ typedef struct {
 	uint32_t ext_major;
 	uint32_t ext_minor;
 	uint32_t ext_sub_minor;
+	uint32_t reserved[4];
 } is4_fw_ext_info_t;
 
 typedef struct {
@@ -324,6 +325,7 @@ int main(int argc, char **argv)
 	uint32_t fw_ver_major = 0;
 	uint32_t fw_ver_minor = 0;
 	uint32_t fw_ver_sub_minor = 0;
+	uint8_t sw_ver_major = 0, sw_ver_minor = 0, sw_ver_sub_minor = 0;
 	is3_general_info_t *gi_is3;
 	is4_general_info_t *gi_is4;
 	const struct ibdiag_opt opts[] = {
@@ -415,10 +417,16 @@ int main(int argc, char **argv)
 		fw_ver_major = ntohl(gi_is4->ext_fw_info.ext_major);
 		fw_ver_minor = ntohl(gi_is4->ext_fw_info.ext_minor);
 		fw_ver_sub_minor = ntohl(gi_is4->ext_fw_info.ext_sub_minor);
+		sw_ver_major = gi_is4->sw_info.major;
+		sw_ver_minor = gi_is4->sw_info.minor;
+		sw_ver_sub_minor = gi_is4->sw_info.sub_minor;
 	} else {
 		fw_ver_major = gi_is3->fw_info.major;
 		fw_ver_minor = gi_is3->fw_info.minor;
 		fw_ver_sub_minor = gi_is3->fw_info.sub_minor;
+		sw_ver_major = gi_is3->sw_info.major;
+		sw_ver_minor = gi_is3->sw_info.minor;
+		sw_ver_sub_minor = gi_is3->sw_info.sub_minor;
 	}
 
 	if (general_info) {
@@ -435,8 +443,8 @@ int main(int argc, char **argv)
 		printf("fw_psid:     '%s'\n", gi_is3->fw_info.psid);
 		printf("fw_ini_ver:  %d\n",
 		       ntohl(gi_is3->fw_info.ini_file_version));
-		printf("sw_version:  %02d.%02d.%02d\n", gi_is3->sw_info.major,
-		       gi_is3->sw_info.minor, gi_is3->sw_info.sub_minor);
+		printf("sw_version:  %02d.%02d.%02d\n", sw_ver_major,
+		       sw_ver_minor, sw_ver_sub_minor);
 	}
 
 	if (xmit_wait) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
