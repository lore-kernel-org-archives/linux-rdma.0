From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/9] ib_srpt: Update comments to reference $driver/$port layout
Date: Mon, 24 Oct 2011 05:33:37 +0000
Message-ID: <1319434422-15354-5-git-send-email-nab@linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Reported-by: Bart Van Assche <bvanassche@acm.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index fee78b0..6e19816 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3805,7 +3805,7 @@ static void srpt_drop_tpg(struct se_portal_group *tpg)
 
 /**
  * configfs callback invoked for
- * mkdir /sys/kernel/config/target/$driver/$target
+ * mkdir /sys/kernel/config/target/$driver/$port
  */
 static struct se_wwn *srpt_make_tport(struct target_fabric_configfs *tf,
 				      struct config_group *group,
@@ -3828,7 +3828,7 @@ err:
 
 /**
  * configfs callback invoked for
- * rmdir /sys/kernel/config/target/$driver/$target
+ * rmdir /sys/kernel/config/target/$driver/$port
  */
 static void srpt_drop_tport(struct se_wwn *wwn)
 {
-- 
1.7.2.5

