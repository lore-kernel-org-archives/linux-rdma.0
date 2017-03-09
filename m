From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH rfc 10/10] target: Use non-selective polling
Date: Thu,  9 Mar 2017 15:16:42 +0200
Message-ID: <1489065402-14757-11-git-send-email-sagi@grimberg.me>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

It doesn't really make sense to do selective polling
because we never care about specific IOs. Non selective
polling can actually help by doing some useful work
while we're submitting a command.

We ask for a batch of (magic) 4 completions which looks
like a decent network<->backend proportion, if less are
available we'll see less.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/target/target_core_iblock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d316ed537d59..00726b6e51c4 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -757,6 +757,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	}
 
 	iblock_submit_bios(&list);
+	blk_mq_poll_batch(bdev_get_queue(IBLOCK_DEV(dev)->ibd_bd), 4);
 	iblock_complete_cmd(cmd);
 	return 0;
 
-- 
2.7.4
