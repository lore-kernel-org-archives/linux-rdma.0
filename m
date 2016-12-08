From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/23] IB/hfi1: Add special setting for low power AOC
Date: Wed, 07 Dec 2016 19:33:13 -0800
Message-ID: <20161208033311.21135.15785.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Low power QSFP AOC cables require a different SerDes
Tx PLL bandwidth setting than the default.  The
8051 firmware does not know the details, so the driver
needs to tell the firmware through a special setting.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/platform.c |   44 ++++++++++++++++++++++++++++++++-
 1 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index 0e70438..838fe84 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -637,6 +637,38 @@ static void apply_tx_lanes(struct hfi1_pportdata *ppd, u8 field_id,
 	}
 }
 
+/*
+ * Return a special SerDes setting for low power AOC cables.  The power class
+ * threshold and setting being used were all found by empirical testing.
+ *
+ * Summary of the logic:
+ *
+ * if (QSFP and QSFP_TYPE == AOC and QSFP_POWER_CLASS < 4)
+ *     return 0xe
+ * return 0; // leave at default
+ */
+static u8 aoc_low_power_setting(struct hfi1_pportdata *ppd)
+{
+	u8 *cache = ppd->qsfp_info.cache;
+	int power_class;
+
+	/* QSFP only */
+	if (ppd->port_type != PORT_TYPE_QSFP)
+		return 0; /* leave at default */
+
+	/* active optical cables only */
+	switch ((cache[QSFP_MOD_TECH_OFFS] & 0xF0) >> 4) {
+	case 0x0 ... 0x9: /* fallthrough */
+	case 0xC: /* fallthrough */
+	case 0xE:
+		/* active AOC */
+		power_class = get_qsfp_power_class(cache[QSFP_MOD_PWR_OFFS]);
+		if (power_class < QSFP_POWER_CLASS_4)
+			return 0xe;
+	}
+	return 0; /* leave at default */
+}
+
 static void apply_tunings(
 		struct hfi1_pportdata *ppd, u32 tx_preset_index,
 		u8 tuning_method, u32 total_atten, u8 limiting_active)
@@ -705,7 +737,17 @@ static void apply_tunings(
 		tx_preset_index, TX_PRESET_TABLE_POSTCUR, &tx_preset, 4);
 	postcur = tx_preset;
 
-	config_data = precur | (attn << 8) | (postcur << 16);
+	/*
+	 * NOTES:
+	 * o The aoc_low_power_setting is applied to all lanes even
+	 *   though only lane 0's value is examined by the firmware.
+	 * o A lingering low power setting after a cable swap does
+	 *   not occur.  On cable unplug the 8051 is reset and
+	 *   restarted on cable insert.  This resets all settings to
+	 *   their default, erasing any previous low power setting.
+	 */
+	config_data = precur | (attn << 8) | (postcur << 16) |
+			(aoc_low_power_setting(ppd) << 24);
 
 	apply_tx_lanes(ppd, TX_EQ_SETTINGS, config_data,
 		       "Applying TX settings");

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
