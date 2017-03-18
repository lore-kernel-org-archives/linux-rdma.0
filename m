From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH rfc 10/10] target: Use non-selective polling
Date: Sat, 18 Mar 2017 16:58:01 -0700
Message-ID: <1489881481.27336.23.camel@haakon3.risingtidesystems.com>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
         <1489065402-14757-11-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489065402-14757-11-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Sagi,

On Thu, 2017-03-09 at 15:16 +0200, Sagi Grimberg wrote:
> It doesn't really make sense to do selective polling
> because we never care about specific IOs. Non selective
> polling can actually help by doing some useful work
> while we're submitting a command.
> 
> We ask for a batch of (magic) 4 completions which looks
> like a decent network<->backend proportion, if less are
> available we'll see less.
> 
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/target/target_core_iblock.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index d316ed537d59..00726b6e51c4 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -757,6 +757,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  	}
>  
>  	iblock_submit_bios(&list);
> +	blk_mq_poll_batch(bdev_get_queue(IBLOCK_DEV(dev)->ibd_bd), 4);
>  	iblock_complete_cmd(cmd);
>  	return 0;
>  

Let's make 'batch' into a backend specific attribute so it can be
changed on-the-fly per device, instead of a hard-coded value.

Here's a quick patch to that end.  Feel free to fold it into your
series.

Beyond that:

Acked-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

>From c2c2a6185fc92132f61beb1708adbef9ea3995e9 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Date: Sat, 18 Mar 2017 20:29:05 +0000
Subject: [PATCH] target/iblock: Add poll_batch attribute

Signed-off-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
---
 drivers/target/target_core_iblock.c |   65 ++++++++++++++++++++++++++++++++---
 drivers/target/target_core_iblock.h |    2 ++
 2 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 00726b6..9396a60 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -35,6 +35,7 @@
 #include <linux/genhd.h>
 #include <linux/file.h>
 #include <linux/module.h>
+#include <linux/configfs.h>
 #include <scsi/scsi_proto.h>
 #include <asm/unaligned.h>
 
@@ -114,6 +115,7 @@ static int iblock_configure_device(struct se_device *dev)
 		goto out_free_bioset;
 	}
 	ib_dev->ibd_bd = bd;
+	ib_dev->poll_batch = IBLOCK_POLL_BATCH;
 
 	q = bdev_get_queue(bd);
 
@@ -757,7 +759,8 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
 	}
 
 	iblock_submit_bios(&list);
-	blk_mq_poll_batch(bdev_get_queue(IBLOCK_DEV(dev)->ibd_bd), 4);
+	blk_mq_poll_batch(bdev_get_queue(IBLOCK_DEV(dev)->ibd_bd),
+					 IBLOCK_DEV(dev)->poll_batch);
 	iblock_complete_cmd(cmd);
 	return 0;
 
@@ -840,7 +843,38 @@ static bool iblock_get_write_cache(struct se_device *dev)
 	return test_bit(QUEUE_FLAG_WC, &q->queue_flags);
 }
 
-static const struct target_backend_ops iblock_ops = {
+static ssize_t iblock_poll_batch_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+				struct se_dev_attrib, da_group);
+	struct iblock_dev *ibd = container_of(da->da_dev,
+				struct iblock_dev, dev);
+
+	return snprintf(page, PAGE_SIZE, "%u\n", ibd->poll_batch);
+}
+
+static ssize_t iblock_poll_batch_store(struct config_item *item, const char *page,
+				       size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+				struct se_dev_attrib, da_group);
+	struct iblock_dev *ibd = container_of(da->da_dev,
+				struct iblock_dev, dev);
+	u32 val;
+	int ret;
+
+	ret = kstrtou32(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	ibd->poll_batch = val;
+	return count;
+}
+CONFIGFS_ATTR(iblock_, poll_batch);
+
+static struct configfs_attribute **iblock_attrs;
+
+static struct target_backend_ops iblock_ops = {
 	.name			= "iblock",
 	.inquiry_prod		= "IBLOCK",
 	.inquiry_rev		= IBLOCK_VERSION,
@@ -860,17 +894,40 @@ static bool iblock_get_write_cache(struct se_device *dev)
 	.get_io_min		= iblock_get_io_min,
 	.get_io_opt		= iblock_get_io_opt,
 	.get_write_cache	= iblock_get_write_cache,
-	.tb_dev_attrib_attrs	= sbc_attrib_attrs,
+	.tb_dev_attrib_attrs	= NULL,
 };
 
 static int __init iblock_module_init(void)
 {
-	return transport_backend_register(&iblock_ops);
+	int rc, i, len = 0;
+
+	for (i = 0; sbc_attrib_attrs[i] != NULL; i++) {
+		len += sizeof(struct configfs_attribute *);
+	}
+	len += sizeof(struct configfs_attribute *) * 2;
+
+	iblock_attrs = kzalloc(len, GFP_KERNEL);
+	if (!iblock_attrs)
+		return -ENOMEM;
+
+	for (i = 0; sbc_attrib_attrs[i] != NULL; i++) {
+		iblock_attrs[i] = sbc_attrib_attrs[i];
+	}
+	iblock_attrs[i] = &iblock_attr_poll_batch;
+	iblock_ops.tb_dev_attrib_attrs = iblock_attrs;
+
+	rc = transport_backend_register(&iblock_ops);
+	if (rc) {
+		kfree(iblock_attrs);
+		return rc;
+	}
+	return 0;
 }
 
 static void __exit iblock_module_exit(void)
 {
 	target_backend_unregister(&iblock_ops);
+	kfree(iblock_attrs);
 }
 
 MODULE_DESCRIPTION("TCM IBLOCK subsystem plugin");
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 718d3fc..308b5c2 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -8,6 +8,7 @@
 
 #define IBLOCK_MAX_CDBS		16
 #define IBLOCK_LBA_SHIFT	9
+#define IBLOCK_POLL_BATCH	4
 
 struct iblock_req {
 	atomic_t pending;
@@ -23,6 +24,7 @@ struct iblock_dev {
 	struct bio_set	*ibd_bio_set;
 	struct block_device *ibd_bd;
 	bool ibd_readonly;
+	unsigned int poll_batch;
 } ____cacheline_aligned;
 
 #endif /* TARGET_CORE_IBLOCK_H */
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
