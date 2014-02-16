From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 05/12] Target/core: Remove prot_handover use for now
Date: Sun, 16 Feb 2014 19:38:10 +0200
Message-ID: <1392572297-5333-6-git-send-email-sagig@mellanox.com>
References: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

This is not going to be supported soon - so drop it.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_sbc.c  |    1 -
 include/target/target_core_base.h |    6 ------
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 3f12726..3326acb 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -673,7 +673,6 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 
 	cmd->prot_type = dev->dev_attrib.pi_prot_type;
 	cmd->prot_length = dev->prot_length * sectors;
-	cmd->prot_handover = PROT_SEPERATED;
 
 	return true;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5ae9249..344fd05 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -451,11 +451,6 @@ enum target_prot_op {
 	TARGET_PROT_DOUT_PASS,
 };
 
-enum target_prot_ho {
-	PROT_SEPERATED,
-	PROT_INTERLEAVED,
-};
-
 enum target_prot_type {
 	TARGET_DIF_TYPE0_PROT,
 	TARGET_DIF_TYPE1_PROT,
@@ -567,7 +562,6 @@ struct se_cmd {
 	u32			reftag_seed;
 	struct scatterlist	*t_prot_sg;
 	unsigned int		t_prot_nents;
-	enum target_prot_ho	prot_handover;
 	sense_reason_t		pi_err;
 	sector_t		bad_sector;
 };
-- 
1.7.1
