From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 02/12] Target/sbc: Set protection operation and relevant checks
Date: Sun, 16 Feb 2014 19:38:07 +0200
Message-ID: <1392572297-5333-3-git-send-email-sagig@mellanox.com>
References: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392572297-5333-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

SBC-3 mandates the protection checks that must be
performed in the rdprotect/wrprotect field. Use them.
According to backstore device pi_attributes and
cdb rdprotect/wrprotect.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/target/target_core_sbc.c  |   88 ++++++++++++++++++++++++++++++++++---
 include/target/target_core_base.h |    7 +++
 2 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index a448944..dfeb1c2 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -240,6 +240,11 @@ static inline u32 transport_lba_32(unsigned char *cdb)
 	return (cdb[2] << 24) | (cdb[3] << 16) | (cdb[4] << 8) | cdb[5];
 }
 
+static inline u8 rwprotect(unsigned char *cdb)
+{
+	return cdb[1] >> 5;
+}
+
 static inline unsigned long long transport_lba_64(unsigned char *cdb)
 {
 	unsigned int __v1, __v2;
@@ -569,30 +574,95 @@ sbc_compare_and_write(struct se_cmd *cmd)
 	return TCM_NO_SENSE;
 }
 
+static int
+sbc_set_prot_op_checks(u8 protect, enum target_prot_type prot_type,
+		       u8 op, struct se_cmd *cmd)
+{
+	switch (op) {
+	case READ_10:
+	case READ_12:
+	case READ_16:
+		cmd->prot_op = protect ? TARGET_PROT_DIN_PASS :
+					 TARGET_PROT_DIN_STRIP;
+		switch (protect) {
+		case 0x0:
+		case 0x1:
+		case 0x5:
+			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
+			if (prot_type == TARGET_DIF_TYPE1_PROT)
+				cmd->prot_checks |= TARGET_DIF_CHECK_REFTAG;
+			break;
+		case 0x2:
+			if (prot_type == TARGET_DIF_TYPE1_PROT)
+				cmd->prot_checks = TARGET_DIF_CHECK_REFTAG;
+			break;
+		case 0x3:
+			cmd->prot_checks = 0;
+			break;
+		case 0x4:
+			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
+			break;
+		default:
+			pr_err("Unsupported protect field %d\n", protect);
+			return -EINVAL;
+		}
+		break;
+	case WRITE_10:
+	case WRITE_12:
+	case WRITE_16:
+	case WRITE_VERIFY:
+		cmd->prot_op = protect ? TARGET_PROT_DOUT_PASS :
+					 TARGET_PROT_DOUT_INSERT;
+		switch (protect) {
+		case 0x0:
+		case 0x3:
+			cmd->prot_checks = 0;
+		case 0x1:
+		case 0x5:
+			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
+			if (prot_type == TARGET_DIF_TYPE1_PROT)
+				cmd->prot_checks |= TARGET_DIF_CHECK_REFTAG;
+			break;
+		case 0x2:
+			if (prot_type == TARGET_DIF_TYPE1_PROT)
+				cmd->prot_checks = TARGET_DIF_CHECK_REFTAG;
+			break;
+		case 0x4:
+			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
+			break;
+		default:
+			pr_err("Unsupported protect field %d\n", protect);
+			return -EINVAL;
+		}
+		break;
+	default:
+		pr_err("ERROR: bad opcode %d\n", op);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
+	return 0;
+}
+
 static bool
 sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 	       u32 sectors)
 {
+	u8 protect = rwprotect(cdb);
+
 	if (!cmd->t_prot_sg || !cmd->t_prot_nents)
 		return true;
 
 	switch (dev->dev_attrib.pi_prot_type) {
 	case TARGET_DIF_TYPE3_PROT:
-		if (!(cdb[1] & 0xe0))
-			return true;
-
 		cmd->reftag_seed = 0xffffffff;
 		break;
 	case TARGET_DIF_TYPE2_PROT:
-		if (cdb[1] & 0xe0)
+		if (protect)
 			return false;
 
 		cmd->reftag_seed = cmd->t_task_lba;
 		break;
 	case TARGET_DIF_TYPE1_PROT:
-		if (!(cdb[1] & 0xe0))
-			return true;
-
 		cmd->reftag_seed = cmd->t_task_lba;
 		break;
 	case TARGET_DIF_TYPE0_PROT:
@@ -600,6 +670,10 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 		return true;
 	}
 
+	if (sbc_set_prot_op_checks(protect, dev->dev_attrib.pi_prot_type,
+				   cdb[0], cmd))
+		return false;
+
 	cmd->prot_type = dev->dev_attrib.pi_prot_type;
 	cmd->prot_length = dev->prot_length * sectors;
 	cmd->prot_handover = PROT_SEPERATED;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 1772fad..5ae9249 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -463,6 +463,12 @@ enum target_prot_type {
 	TARGET_DIF_TYPE3_PROT,
 };
 
+enum target_core_dif_check {
+	TARGET_DIF_CHECK_GUARD  = 0x1 << 0,
+	TARGET_DIF_CHECK_APPTAG = 0x1 << 1,
+	TARGET_DIF_CHECK_REFTAG = 0x1 << 2,
+};
+
 struct se_dif_v1_tuple {
 	__be16			guard_tag;
 	__be16			app_tag;
@@ -556,6 +562,7 @@ struct se_cmd {
 	/* DIF related members */
 	enum target_prot_op	prot_op;
 	enum target_prot_type	prot_type;
+	u8			prot_checks;
 	u32			prot_length;
 	u32			reftag_seed;
 	struct scatterlist	*t_prot_sg;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
