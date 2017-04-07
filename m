From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 7/9] IB/iser: Add spaces for better code readability
Date: Fri, 7 Apr 2017 23:07:23 +0200
Message-ID: <7e406ba5-f7c8-16a7-9c3e-464e48120088@users.sourceforge.net>
References: <ce4249f2-c7e7-0282-2cff-3f9c3991efa3@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <ce4249f2-c7e7-0282-2cff-3f9c3991efa3@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>, Doug Ledford <dledford@redhat.com>, Erez Shitrit <erezsh@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Paolo Abeni <pabeni@redhat.com>, Roi Dayan <roid@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Sean Hefty <sean.hefty@intel.com>, Yuval Shaia <yuval.shaia@oracle.com>, Zhu Yanjun <yanjun.zhu@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 7 Apr 2017 21:37:48 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: space required after that ',' (ctx:VxV)

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/ulp/iser/iser_initiator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 6c48bdc8a64d..fbab1303a740 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -422,7 +422,7 @@ int iser_send_command(struct iscsi_conn *conn,
 		return 0;
 
 send_command_error:
-	iser_err("conn %p failed task->itt %d err %d\n",conn, task->itt, err);
+	iser_err("conn %p failed task->itt %d err %d\n", conn, task->itt, err);
 	return err;
 }
 
@@ -448,7 +448,7 @@ int iser_send_data_out(struct iscsi_conn *conn,
 	buf_offset   = ntohl(hdr->offset);
 
 	iser_dbg("%s itt %d dseg_len %d offset %d\n",
-		 __func__,(int)itt,(int)data_seg_len,(int)buf_offset);
+		 __func__, (int)itt, (int)data_seg_len, (int)buf_offset);
 
 	tx_desc = kmem_cache_zalloc(ig.desc_cache, GFP_ATOMIC);
 	if (tx_desc == NULL) {
@@ -553,7 +553,7 @@ int iser_send_control(struct iscsi_conn *conn,
 		return 0;
 
 send_control_error:
-	iser_err("conn %p failed err %d\n",conn, err);
+	iser_err("conn %p failed err %d\n", conn, err);
 	return err;
 }
 
-- 
2.12.2
