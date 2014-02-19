From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 01/12] Target/transport: Allocate protection sg if needed
Date: Wed, 19 Feb 2014 17:50:14 +0200
Message-ID: <1392825025-29943-2-git-send-email-sagig@mellanox.com>
References: <1392825025-29943-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392825025-29943-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com, martin.petersen@oracle.com
List-Id: linux-rdma@vger.kernel.org

In case protection information is involved, allocate
protection SG-list for transport.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_transport.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 24b4f65..0f9e1ea 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2036,6 +2036,10 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 	transport_free_sgl(cmd->t_bidi_data_sg, cmd->t_bidi_data_nents);
 	cmd->t_bidi_data_sg = NULL;
 	cmd->t_bidi_data_nents = 0;
+
+	transport_free_sgl(cmd->t_prot_sg, cmd->t_prot_nents);
+	cmd->t_prot_sg = NULL;
+	cmd->t_prot_nents = 0;
 }
 
 /**
@@ -2199,6 +2203,14 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 
+		if (cmd->prot_type != TARGET_PROT_NORMAL) {
+			ret = target_alloc_sgl(&cmd->t_prot_sg,
+					       &cmd->t_prot_nents,
+					       cmd->prot_length, true);
+			if (ret < 0)
+				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		}
+
 		ret = target_alloc_sgl(&cmd->t_data_sg, &cmd->t_data_nents,
 				       cmd->data_length, zero_flag);
 		if (ret < 0)
-- 
1.7.1
