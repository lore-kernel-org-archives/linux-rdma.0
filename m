From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 03/12] Target/file: place escape values for protection information format
Date: Sun, 16 Feb 2014 19:38:08 +0200
Message-ID: <1392572297-5333-4-git-send-email-sagig@mellanox.com>
References: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

No need to actually compute protection information when formatting

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_file.c |   40 +------------------------------------
 1 files changed, 1 insertions(+), 39 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index cf991a9..7d6cdda 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -854,25 +854,6 @@ static int fd_init_prot(struct se_device *dev)
 	return 0;
 }
 
-static void fd_init_format_buf(struct se_device *dev, unsigned char *buf,
-			       u32 unit_size, u32 *ref_tag, u16 app_tag,
-			       bool inc_reftag)
-{
-	unsigned char *p = buf;
-	int i;
-
-	for (i = 0; i < unit_size; i += dev->prot_length) {
-		*((u16 *)&p[0]) = 0xffff;
-		*((__be16 *)&p[2]) = cpu_to_be16(app_tag);
-		*((__be32 *)&p[4]) = cpu_to_be32(*ref_tag);
-
-		if (inc_reftag)
-			(*ref_tag)++;
-
-		p += dev->prot_length;
-	}
-}
-
 static int fd_format_prot(struct se_device *dev)
 {
 	struct fd_dev *fd_dev = FD_DEV(dev);
@@ -880,10 +861,8 @@ static int fd_format_prot(struct se_device *dev)
 	sector_t prot_length, prot;
 	unsigned char *buf;
 	loff_t pos = 0;
-	u32 ref_tag = 0;
 	int unit_size = FDBD_FORMAT_UNIT_SIZE * dev->dev_attrib.block_size;
 	int rc, ret = 0, size, len;
-	bool inc_reftag = false;
 
 	if (!dev->dev_attrib.pi_prot_type) {
 		pr_err("Unable to format_prot while pi_prot_type == 0\n");
@@ -894,37 +873,20 @@ static int fd_format_prot(struct se_device *dev)
 		return -ENODEV;
 	}
 
-	switch (dev->dev_attrib.pi_prot_type) {
-	case TARGET_DIF_TYPE3_PROT:
-		ref_tag = 0xffffffff;
-		break;
-	case TARGET_DIF_TYPE2_PROT:
-	case TARGET_DIF_TYPE1_PROT:
-		inc_reftag = true;
-		break;
-	default:
-		break;
-	}
-
 	buf = vzalloc(unit_size);
 	if (!buf) {
 		pr_err("Unable to allocate FILEIO prot buf\n");
 		return -ENOMEM;
 	}
-
 	prot_length = (dev->transport->get_blocks(dev) + 1) * dev->prot_length;
 	size = prot_length;
 
 	pr_debug("Using FILEIO prot_length: %llu\n",
 		 (unsigned long long)prot_length);
 
+	memset(buf, 0xff, unit_size);
 	for (prot = 0; prot < prot_length; prot += unit_size) {
-
-		fd_init_format_buf(dev, buf, unit_size, &ref_tag, 0xffff,
-				   inc_reftag);
-
 		len = min(unit_size, size);
-
 		rc = kernel_write(prot_fd, buf, len, pos);
 		if (rc != len) {
 			pr_err("vfs_write to prot file failed: %d\n", rc);
-- 
1.7.1
