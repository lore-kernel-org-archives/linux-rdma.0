From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 02/12] Target/sbc: Set protection operation and relevant checks
Date: Wed, 19 Feb 2014 17:50:15 +0200
Message-ID: <1392825025-29943-3-git-send-email-sagig@mellanox.com>
References: <1392825025-29943-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392825025-29943-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com, martin.petersen@oracle.com
List-Id: linux-rdma@vger.kernel.org

SBC-3 mandates the protection checks that must be
performed in the rdprotect/wrprotect field. Use them.
According to backstore device pi_attributes and
cdb rdprotect/wrprotect field.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_sbc.c  |   86 +++++++++++++++++++++++++++++++------
 include/target/target_core_base.h |    7 +++
 2 files changed, 79 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index a448944..6939947 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -569,30 +569,84 @@ sbc_compare_and_write(struct se_cmd *cmd)
 	return TCM_NO_SENSE;
 }
 
+static int
+sbc_set_prot_op_checks(u8 protect, enum target_prot_type prot_type,
+		       bool is_write, struct se_cmd *cmd)
+{
+	if (is_write) {
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
+	} else {
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
+	}
+
+	return 0;
+}
+
 static bool
 sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
-	       u32 sectors)
+	       u32 sectors, bool is_write)
 {
+	u8 protect = cdb[1] >> 5;
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
@@ -600,6 +654,10 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 		return true;
 	}
 
+	if (sbc_set_prot_op_checks(protect, dev->dev_attrib.pi_prot_type,
+				   is_write, cmd))
+		return false;
+
 	cmd->prot_type = dev->dev_attrib.pi_prot_type;
 	cmd->prot_length = dev->prot_length * sectors;
 	cmd->prot_handover = PROT_SEPERATED;
@@ -628,7 +686,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_10(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 
-		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+		if (!sbc_check_prot(dev, cmd, cdb, sectors, false))
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
@@ -639,7 +697,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_12(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 
-		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+		if (!sbc_check_prot(dev, cmd, cdb, sectors, false))
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
@@ -650,7 +708,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
 
-		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+		if (!sbc_check_prot(dev, cmd, cdb, sectors, false))
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
@@ -669,7 +727,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_10(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 
-		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+		if (!sbc_check_prot(dev, cmd, cdb, sectors, true))
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		if (cdb[1] & 0x8)
@@ -682,7 +740,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_12(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 
-		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+		if (!sbc_check_prot(dev, cmd, cdb, sectors, true))
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		if (cdb[1] & 0x8)
@@ -695,7 +753,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
 
-		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+		if (!sbc_check_prot(dev, cmd, cdb, sectors, true))
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 
 		if (cdb[1] & 0x8)
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
