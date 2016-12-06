From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/hfi1: Define platform_config_table_limits once
Date: Mon, 5 Dec 2016 16:48:11 -0800
Message-ID: <870f083a-df8e-8a22-52c2-e4d2dde46b9d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Defining static data structures in a header file is wrong because
this causes the data structure to be instantiated once in every .c
file it is included in. Hence move the definition of a static
array from a header file into the only .c file in which it is used.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/firmware.c | 10 ++++++++++
 drivers/infiniband/hw/hfi1/platform.h | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 13db8eb4f4ec..acbc261b1858 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -239,6 +239,16 @@ static const u8 all_fabric_serdes_broadcast = 0xe1;
 const u8 pcie_serdes_broadcast[2] = { 0xe2, 0xe3 };
 static const u8 all_pcie_serdes_broadcast = 0xe0;
 
+static const u32 platform_config_table_limits[PLATFORM_CONFIG_TABLE_MAX] = {
+	0,
+	SYSTEM_TABLE_MAX,
+	PORT_TABLE_MAX,
+	RX_PRESET_TABLE_MAX,
+	TX_PRESET_TABLE_MAX,
+	QSFP_ATTEN_TABLE_MAX,
+	VARIABLE_SETTINGS_TABLE_MAX
+};
+
 /* forwards */
 static void dispose_one_firmware(struct firmware_details *fdet);
 static int load_fabric_serdes_firmware(struct hfi1_devdata *dd,
diff --git a/drivers/infiniband/hw/hfi1/platform.h b/drivers/infiniband/hw/hfi1/platform.h
index e2c21613c326..ad46dd6b4b3d 100644
--- a/drivers/infiniband/hw/hfi1/platform.h
+++ b/drivers/infiniband/hw/hfi1/platform.h
@@ -168,16 +168,6 @@ struct platform_config_cache {
 	struct platform_config_data config_tables[PLATFORM_CONFIG_TABLE_MAX];
 };
 
-static const u32 platform_config_table_limits[PLATFORM_CONFIG_TABLE_MAX] = {
-	0,
-	SYSTEM_TABLE_MAX,
-	PORT_TABLE_MAX,
-	RX_PRESET_TABLE_MAX,
-	TX_PRESET_TABLE_MAX,
-	QSFP_ATTEN_TABLE_MAX,
-	VARIABLE_SETTINGS_TABLE_MAX
-};
-
 /* This section defines default values and encodings for the
  * fields defined for each table above
  */
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
