From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 08/12] Target/sbc: add debug print
Date: Sun, 16 Feb 2014 19:38:13 +0200
Message-ID: <1392572297-5333-9-git-send-email-sagig@mellanox.com>
References: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_sbc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 3326acb..fac8c77 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -673,6 +673,9 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 
 	cmd->prot_type = dev->dev_attrib.pi_prot_type;
 	cmd->prot_length = dev->prot_length * sectors;
+	pr_debug("%s: prot_type=%d, prot_length=%d prot_op=%d prot_checks=%d\n",
+		 __func__, cmd->prot_type, cmd->prot_length,
+		 cmd->prot_op, cmd->prot_checks);
 
 	return true;
 }
-- 
1.7.1
