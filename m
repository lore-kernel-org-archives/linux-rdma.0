From: Colin King <colin.king@canonical.com>
Subject: [PATCH][rdma-next] RDMA/hns: make various function static, fixes warnings
Date: Fri, 29 Sep 2017 14:16:01 +0100
Message-ID: <20170929131601.7111-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The functions hns_roce_table_mhop_get, hns_roce_table_mhop_put,
hns_roce_cleanup_mhop_hem_table,  hns_roce_v1_post_mbox,
hns_roce_cmq_setup_basic_desc, hns_roce_cmq_send,
hns_roce_cmq_query_hw_info are all local to the source and do
not need to be in global scope, so make them static.

Cleans up sparse warnings:
symbol 'hns_roce_table_mhop_get' was not declared. Should it be static?
symbol 'hns_roce_table_mhop_put' was not declared. Should it be static?
symbol 'hns_roce_cleanup_mhop_hem_table' was not declared. Should it be
static?
symbol 'hns_roce_v1_post_mbox' was not declared. Should it be static?
symbol 'hns_roce_cmq_setup_basic_desc' was not declared. Should it be
static?
symbol 'hns_roce_cmq_send' was not declared. Should it be static?
symbol 'hns_roce_cmq_query_hw_info' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c   | 18 +++++++++---------
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c |  6 +++---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 12 ++++++------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 125e26ebf250..8388ae25640c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -363,9 +363,9 @@ static int hns_roce_set_hem(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
-int hns_roce_table_mhop_get(struct hns_roce_dev *hr_dev,
-			    struct hns_roce_hem_table *table,
-			    unsigned long obj)
+static int hns_roce_table_mhop_get(struct hns_roce_dev *hr_dev,
+				   struct hns_roce_hem_table *table,
+				   unsigned long obj)
 {
 	struct device *dev = hr_dev->dev;
 	struct hns_roce_hem_mhop mhop;
@@ -576,10 +576,10 @@ int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
-void hns_roce_table_mhop_put(struct hns_roce_dev *hr_dev,
-			     struct hns_roce_hem_table *table,
-			     unsigned long obj,
-			     int check_refcount)
+static void hns_roce_table_mhop_put(struct hns_roce_dev *hr_dev,
+				    struct hns_roce_hem_table *table,
+				    unsigned long obj,
+				    int check_refcount)
 {
 	struct device *dev = hr_dev->dev;
 	struct hns_roce_hem_mhop mhop;
@@ -983,8 +983,8 @@ int hns_roce_init_hem_table(struct hns_roce_dev *hr_dev,
 	return -ENOMEM;
 }
 
-void hns_roce_cleanup_mhop_hem_table(struct hns_roce_dev *hr_dev,
-				     struct hns_roce_hem_table *table)
+static void hns_roce_cleanup_mhop_hem_table(struct hns_roce_dev *hr_dev,
+					    struct hns_roce_hem_table *table)
 {
 	struct hns_roce_hem_mhop mhop;
 	u32 buf_chunk_size;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 426f55a030e6..290fcc2d8b98 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1628,9 +1628,9 @@ static int hns_roce_v1_cmd_pending(struct hns_roce_dev *hr_dev)
 	return (!!(status & (1 << HCR_GO_BIT)));
 }
 
-int hns_roce_v1_post_mbox(struct hns_roce_dev *hr_dev, u64 in_param,
-			  u64 out_param, u32 in_modifier, u8 op_modifier,
-			  u16 op, u16 token, int event)
+static int hns_roce_v1_post_mbox(struct hns_roce_dev *hr_dev, u64 in_param,
+				 u64 out_param, u32 in_modifier, u8 op_modifier,
+				 u16 op, u16 token, int event)
 {
 	u32 *hcr = (u32 *)(hr_dev->reg_base + ROCEE_MB1_REG);
 	unsigned long end;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4171f73bdad5..4870b51caab9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -496,9 +496,9 @@ static void hns_roce_v2_cmq_exit(struct hns_roce_dev *hr_dev)
 	hns_roce_free_cmq_desc(hr_dev, &priv->cmq.crq);
 }
 
-void hns_roce_cmq_setup_basic_desc(struct hns_roce_cmq_desc *desc,
-				   enum hns_roce_opcode_type opcode,
-				   bool is_read)
+static void hns_roce_cmq_setup_basic_desc(struct hns_roce_cmq_desc *desc,
+					  enum hns_roce_opcode_type opcode,
+					  bool is_read)
 {
 	memset((void *)desc, 0, sizeof(struct hns_roce_cmq_desc));
 	desc->opcode = cpu_to_le16(opcode);
@@ -542,8 +542,8 @@ static int hns_roce_cmq_csq_clean(struct hns_roce_dev *hr_dev)
 	return clean;
 }
 
-int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
-		      struct hns_roce_cmq_desc *desc, int num)
+static int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
+			     struct hns_roce_cmq_desc *desc, int num)
 {
 	struct hns_roce_v2_priv *priv = (struct hns_roce_v2_priv *)hr_dev->priv;
 	struct hns_roce_v2_cmq_ring *csq = &priv->cmq.csq;
@@ -629,7 +629,7 @@ int hns_roce_cmq_send(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
-int hns_roce_cmq_query_hw_info(struct hns_roce_dev *hr_dev)
+static int hns_roce_cmq_query_hw_info(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_query_version *resp;
 	struct hns_roce_cmq_desc desc;
-- 
2.14.1
