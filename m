From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 08/12] Target/sbc: add debug print
Date: Wed, 19 Feb 2014 17:50:21 +0200
Message-ID: <1392825025-29943-9-git-send-email-sagig@mellanox.com>
References: <1392825025-29943-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392825025-29943-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/target/target_core_sbc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 33f3163..59fdc9f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -657,6 +657,9 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 
 	cmd->prot_type = dev->dev_attrib.pi_prot_type;
 	cmd->prot_length = dev->prot_length * sectors;
+	pr_debug("%s: prot_type=%d, prot_length=%d prot_op=%d prot_checks=%d\n",
+		 __func__, cmd->prot_type, cmd->prot_length,
+		 cmd->prot_op, cmd->prot_checks);
 
 	return true;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
