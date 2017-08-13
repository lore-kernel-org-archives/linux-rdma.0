From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/8] IB/hfi1: Add flag for platform config scratch
 register read
Date: Sun, 13 Aug 2017 08:08:34 -0700
Message-ID: <20170813150833.23208.84771.stgit@scvm10.sc.intel.com>
References: <20170813150659.23208.66243.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813150659.23208.66243.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add flag in pport data structure to determine when platform config was
read from scratch registers. Change conditions in parse_platform_config
and get_platform_config_field to use the new flag.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/firmware.c |    6 ++++--
 drivers/infiniband/hw/hfi1/hfi.h      |    3 +++
 drivers/infiniband/hw/hfi1/platform.c |    2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 885714b..fb095e6 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1789,6 +1789,7 @@ static int check_meta_version(struct hfi1_devdata *dd, u32 *system_table)
 int parse_platform_config(struct hfi1_devdata *dd)
 {
 	struct platform_config_cache *pcfgcache = &dd->pcfg_cache;
+	struct hfi1_pportdata *ppd = dd->pport;
 	u32 *ptr = NULL;
 	u32 header1 = 0, header2 = 0, magic_num = 0, crc = 0, file_length = 0;
 	u32 record_idx = 0, table_type = 0, table_length_dwords = 0;
@@ -1800,7 +1801,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 	 * scratch register bitmap, thus there is no platform config to parse.
 	 * Skip parsing in these situations.
 	 */
-	if (is_integrated(dd) && !platform_config_load)
+	if (ppd->config_from_scratch)
 		return 0;
 
 	if (!dd->platform_config.data) {
@@ -2089,13 +2090,14 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 	int ret = 0, wlen = 0, seek = 0;
 	u32 field_len_bits = 0, field_start_bits = 0, *src_ptr = NULL;
 	struct platform_config_cache *pcfgcache = &dd->pcfg_cache;
+	struct hfi1_pportdata *ppd = dd->pport;
 
 	if (data)
 		memset(data, 0, len);
 	else
 		return -EINVAL;
 
-	if (is_integrated(dd) && !platform_config_load) {
+	if (ppd->config_from_scratch) {
 		/*
 		 * Use saved configuration from ppd for integrated platforms
 		 */
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index dff3d3f..181feca 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -677,6 +677,9 @@ struct hfi1_pportdata {
 	u8  default_atten;
 	u8  max_power_class;
 
+	/* did we read platform config from scratch registers? */
+	bool config_from_scratch;
+
 	/* GUIDs for this interface, in host order, guids[0] is a port guid */
 	u64 guids[HFI1_GUIDS_PER_PORT];
 
diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index 5c38a24..ab221b0 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -138,6 +138,8 @@ static void save_platform_config_fields(struct hfi1_devdata *dd)
 
 	ppd->max_power_class = (temp_scratch & QSFP_MAX_POWER_SMASK) >>
 				QSFP_MAX_POWER_SHIFT;
+
+	ppd->config_from_scratch = true;
 }
 
 void get_platform_config(struct hfi1_devdata *dd)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
