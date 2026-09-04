Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD2347CC8E
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 10:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519167; cv=none; b=e/VZNM1kfdc8QDn/ZewOAfnIYLf7W2+obVYOQpuXuW9sR2aRALhOjIR3HfX6HzV+27QEJW8+Sx9j8n98SZQHiYoQE5x/jseC37ZFIE0yDOJHufi/OGv2o8CprmtdTyUd1i9FlWFkqKA9C9jjT6NgDs9JFVaekqrsjXjG6hdlfKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519167; c=relaxed/simple;
	bh=TnbhuuwueFxbVAiV2c3BcL/nidlaqVV85eaBF/1xO/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mtD/57WUelOaLZq0m5eroQmI3XB5Wrwy3b26VXfHjaQXPs90yiOQlIUzZdCC2CBXYn9Zwz0UXKQDwsDvF7mRuFGxGdgyGB60Uj+DU70BMgR9jaP7a1xRxoIzsrWhrTOIBbIYnk3zoPW14pairNfU68CAC8ypNA2ZrB0tmGK6IA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bJN7gM7u; arc=none smtp.client-ip=209.85.215.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bJN7gM7u"
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cc1c7364550so1091811a12.1
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519149; x=1789123949;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZoUkjrL3qtvPfJqPpBX5dtcKEGCq5j9ZlHCgvh4jx2A=;
        b=SNxPLUhKjFEjwXeXnaL+kQ0k1H+kHYQ49OtGGWcMJFiu+AwFvygockTY2i92/16Urh
         MwrPTGlfSOZNYBe60x01m5jJ7x3DepbUnf0iN1vZLqL9yRs4Li61g+r6qTQhC3ovD2p2
         8Utx+g+xICFO3czsCoQJfcedcTUkusjOy0NLqmrmbvS1OhmyS9HaudF4BF0N06lA6j2R
         hjLS5OgCSUTli8iynI0+ZjJOrPVQ+uGkKjx3clHbL2jFqpLz9ZowfhOnzL7uW6OKKOYZ
         mRHOqxdtvIJqieutUYorTj82IxIhnusIneXcr9Ujd6m/JVcPg4TU1KueloWH/K4rSf/q
         dQig==
X-Forwarded-Encrypted: i=1; AKwUvBwfjzZQ5w/1wsQFkT9gyaAwDCIod9c/B/U7WW1ipA0bHsMP7LAwczN3HK4qXrgIj2SAM1rfmQotj9NY@vger.kernel.org
X-Gm-Message-State: AFuF++nMxJaiZjIzPW7p/G1KUbukZzrdank0rrQTxzql4waxj5Rsm4yy
	lXWe04+5+HCgqEcmU9yRIrbvoACdqMwUh0PCXzWaoxAeU6BAhS57Xy4hGP2MzZAgw/6ABMHpoGZ
	w9w0wxf2kffHZGFK3OSjkTF43vEXJLA+JmeDDtl9568/iPiI8/+qzGUh/IfHm0w82+reRcs4Gji
	oTpuq04t8pxrLgA1HPjhJByQvHSSKNXQvHJ+wK+YYa5231r97j5OTt9hoRlud2bODhm5nQEm0ux
	C3Ta30Lm4l4wj+xJg==
X-Gm-Gg: AYBFou1D7lCvylcu+MFP/PrIQYdFEKRb87jF4ue+NQWbcfpMUijuyp+ed04OT1l80SM
	Yp6yNvA6BKRRKtVs6gqfYSRDNfHYMvaq1C3e4o0qf5TgVEAKM4dKezP7u6GDMOW08CsTOlOXYFy
	COQKGLoz9Rl5RUaxLcSOxaCKmwbvPrMH3yy6UeQjrdFqFmikbdzfppjogcub7XTqhdQJoDCQr8k
	VyUsr7KWV5j7Rm/hIfWaQzBO7LcPEr55FAzfaerRofgYU2gbGq3yUHkukDwOrs19EuXhtyLDb0r
	ttYP5qEX9MSa5s+HmLPnsAeHMG4aZazUsXjfz8gVVI5q31Co+2TKzdsb2zE1m7PxD7BHoRlWHQR
	JRmFZ81haKpeeZMBgJe1j4rE0B/zYLIPWw7rWrsG9wvOH9TSXfGInoP9cDiSMdCSDNGwVl00nhY
	Annk+OfW8GjjutTcQWAByYscWOlSj24qoF1w==
X-Received: by 2002:a05:6a00:9293:b0:857:726d:2e97 with SMTP id d2e1a72fcca58-8616a96c592mr6865152b3a.20.1788519148742;
        Fri, 04 Sep 2026 03:52:28 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc459d23d86sm223859a12.3.2026.09.04.03.52.28
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 03:52:28 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so1717134a91.1
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788519147; x=1789123947; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZoUkjrL3qtvPfJqPpBX5dtcKEGCq5j9ZlHCgvh4jx2A=;
        b=bJN7gM7u9nJtGJ52PAMMRF2Hysk+T6IOAW2OOzG0qxWRz5q03k7HdSC7eWfxPfmxjd
         TPiUmMJX5pAChXRLMtmyHVPg1mpWucQA2C1dQkOy5cnE3x5Q+hs+geIuL3UgAmfvcYn7
         DHXlGQbrFMAsmFrWsRDol9iURyqX5MXHTkXpo=
X-Forwarded-Encrypted: i=1; AKwUvBzB4Ko6cLtQTfFBptkwiuV7wZVLXXcYCoIe0lUp1uFXq5ADdNlJ9278Aq5diTQ6s0PtiPn5UQE1gEIk@vger.kernel.org
X-Received: by 2002:a17:90b:5845:b0:383:5a16:bd70 with SMTP id 98e67ed59e1d1-39b2620547amr7768785a91.16.1788519145358;
        Fri, 04 Sep 2026 03:52:25 -0700 (PDT)
X-Received: by 2002:a17:90b:5845:b0:383:5a16:bd70 with SMTP id 98e67ed59e1d1-39b2620547amr7768595a91.16.1788519143824;
        Fri, 04 Sep 2026 03:52:23 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534d0asm6171170eec.8.2026.09.04.03.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:52:22 -0700 (PDT)
From: Siva Reddy Kallam <siva.kallam@broadcom.com>
To: leonro@nvidia.com,
	jgg@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Raqib Jones <raqib.jones@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>
Subject: [PATCH 04/15] RDMA/bng_re: Add MPC, XID management, doorbell infrastructure
Date: Fri,  4 Sep 2026 03:43:12 -0700
Message-ID: <20260904104328.763768-5-siva.kallam@broadcom.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260904104328.763768-1-siva.kallam@broadcom.com>
References: <20260904104328.763768-1-siva.kallam@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=all
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Raqib Jones <raqib.jones@broadcom.com>

This patch has below changes

New MPC channel introduced for AH/QP operations
xid management support for AH/QP
Doorbell infrastructure changes

Signed-off-by: Raqib Jones <raqib.jones@broadcom.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
---
 drivers/infiniband/hw/bng_re/Makefile         |   13 +-
 drivers/infiniband/hw/bng_re/bng_debugfs.c    |  308 +++
 drivers/infiniband/hw/bng_re/bng_dev.c        |   98 +-
 drivers/infiniband/hw/bng_re/bng_fw.c         |    1 +
 drivers/infiniband/hw/bng_re/bng_fw.h         |    8 +-
 drivers/infiniband/hw/bng_re/bng_mpc.c        |  574 +++++
 drivers/infiniband/hw/bng_re/bng_re.h         |  174 ++
 .../infiniband/hw/bng_re/bng_re_mpc_roce.c    | 1863 +++++++++++++++++
 .../infiniband/hw/bng_re/bng_re_mpc_roce.h    |  218 ++
 drivers/infiniband/hw/bng_re/bng_res.c        |  114 +-
 drivers/infiniband/hw/bng_re/bng_res.h        |   78 +-
 drivers/infiniband/hw/bng_re/bng_roce_hsi.h   |   94 +
 drivers/infiniband/hw/bng_re/bng_sp.h         |    4 +
 drivers/infiniband/hw/bng_re/bng_xid.c        |  110 +
 drivers/infiniband/hw/bng_re/bng_xid.h        |   26 +
 .../infiniband/hw/bng_re/bng_xid_allocator.c  |  870 ++++++++
 drivers/infiniband/hw/bng_re/xid_allocator.h  |  114 +
 17 files changed, 4631 insertions(+), 36 deletions(-)
 create mode 100644 drivers/infiniband/hw/bng_re/bng_mpc.c
 create mode 100644 drivers/infiniband/hw/bng_re/bng_re_mpc_roce.c
 create mode 100644 drivers/infiniband/hw/bng_re/bng_re_mpc_roce.h
 create mode 100644 drivers/infiniband/hw/bng_re/bng_xid.c
 create mode 100644 drivers/infiniband/hw/bng_re/bng_xid.h
 create mode 100644 drivers/infiniband/hw/bng_re/bng_xid_allocator.c
 create mode 100644 drivers/infiniband/hw/bng_re/xid_allocator.h

diff --git a/drivers/infiniband/hw/bng_re/Makefile b/drivers/infiniband/hw/bng_re/Makefile
index 17e9d5871d40..ea0c6951728f 100644
--- a/drivers/infiniband/hw/bng_re/Makefile
+++ b/drivers/infiniband/hw/bng_re/Makefile
@@ -3,6 +3,13 @@ ccflags-y := -I $(srctree)/drivers/net/ethernet/broadcom/bnge
 
 obj-$(CONFIG_INFINIBAND_BNG_RE) += bng_re.o
 
-bng_re-y := bng_dev.o bng_fw.o \
-	    bng_res.o bng_sp.o \
-	    bng_debugfs.o
+bng_re-y := \
+	bng_xid_allocator.o \
+	bng_xid.o \
+	bng_mpc.o \
+	bng_re_mpc_roce.o \
+	bng_res.o \
+	bng_debugfs.o \
+	bng_fw.o \
+	bng_dev.o \
+	bng_sp.o
diff --git a/drivers/infiniband/hw/bng_re/bng_debugfs.c b/drivers/infiniband/hw/bng_re/bng_debugfs.c
index 9ec5a8785250..7f1e9bedc4e7 100644
--- a/drivers/infiniband/hw/bng_re/bng_debugfs.c
+++ b/drivers/infiniband/hw/bng_re/bng_debugfs.c
@@ -2,24 +2,332 @@
 // Copyright (c) 2025 Broadcom.
 #include <linux/debugfs.h>
 #include <linux/pci.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
 
 #include <rdma/ib_verbs.h>
 
 #include "bng_res.h"
+#include "bng_sp.h"
 #include "bng_fw.h"
 #include "bnge.h"
 #include "bnge_auxr.h"
 #include "bng_re.h"
 #include "bng_debugfs.h"
+#include "bng_re_mpc_roce.h"
 
 static struct dentry *bng_re_debugfs_root;
 
+/* MPC tuning parameter read/write functions */
+static ssize_t mpc_short_timeout_read(struct file *file, char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	struct bng_re_dev *rdev = file->private_data;
+	char tmp[16];
+
+	if (!rdev || !rdev->mpc_roce_creq.mpc_tune_params)
+		return -ENODEV;
+
+	snprintf(tmp, sizeof(tmp), "%u\n", rdev->mpc_roce_creq.mpc_tune_params->short_timeout);
+	return simple_read_from_buffer(buf, count, ppos, tmp, strlen(tmp));
+}
+
+static ssize_t mpc_short_timeout_write(struct file *file, const char __user *buf,
+				       size_t count, loff_t *ppos)
+{
+	struct bng_re_dev *rdev = file->private_data;
+	u32 val;
+	int ret;
+
+	if (!rdev || !rdev->mpc_roce_creq.mpc_tune_params)
+		return -ENODEV;
+
+	ret = kstrtou32_from_user(buf, count, 0, &val);
+	if (ret)
+		return ret;
+
+	rdev->mpc_roce_creq.mpc_tune_params->short_timeout = val;
+	return count;
+}
+
+static const struct file_operations mpc_short_timeout_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = mpc_short_timeout_read,
+	.write = mpc_short_timeout_write,
+};
+
+static ssize_t mpc_long_timeout_read(struct file *file, char __user *buf,
+				     size_t count, loff_t *ppos)
+{
+	struct bng_re_dev *rdev = file->private_data;
+	char tmp[16];
+
+	if (!rdev || !rdev->mpc_roce_creq.mpc_tune_params)
+		return -ENODEV;
+
+	snprintf(tmp, sizeof(tmp), "%u\n", rdev->mpc_roce_creq.mpc_tune_params->long_timeout);
+	return simple_read_from_buffer(buf, count, ppos, tmp, strlen(tmp));
+}
+
+static ssize_t mpc_long_timeout_write(struct file *file, const char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	struct bng_re_dev *rdev = file->private_data;
+	u32 val;
+	int ret;
+
+	if (!rdev || !rdev->mpc_roce_creq.mpc_tune_params)
+		return -ENODEV;
+
+	ret = kstrtou32_from_user(buf, count, 0, &val);
+	if (ret)
+		return ret;
+
+	if (!val)
+		return -EINVAL;
+
+	rdev->mpc_roce_creq.mpc_tune_params->long_timeout = val;
+	return count;
+}
+
+static const struct file_operations mpc_long_timeout_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = mpc_long_timeout_read,
+	.write = mpc_long_timeout_write,
+};
+
+static ssize_t mpc_max_retries_read(struct file *file, char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct bng_re_dev *rdev = file->private_data;
+	char tmp[16];
+
+	if (!rdev || !rdev->mpc_roce_creq.mpc_tune_params)
+		return -ENODEV;
+
+	snprintf(tmp, sizeof(tmp), "%u\n", rdev->mpc_roce_creq.mpc_tune_params->max_retries);
+	return simple_read_from_buffer(buf, count, ppos, tmp, strlen(tmp));
+}
+
+static ssize_t mpc_max_retries_write(struct file *file, const char __user *buf,
+				     size_t count, loff_t *ppos)
+{
+	struct bng_re_dev *rdev = file->private_data;
+	u16 val;
+	int ret;
+
+	if (!rdev || !rdev->mpc_roce_creq.mpc_tune_params)
+		return -ENODEV;
+
+	ret = kstrtou16_from_user(buf, count, 0, &val);
+	if (ret)
+		return ret;
+
+	rdev->mpc_roce_creq.mpc_tune_params->max_retries = val;
+	return count;
+}
+
+static const struct file_operations mpc_max_retries_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = mpc_max_retries_read,
+	.write = mpc_max_retries_write,
+};
+
+static ssize_t mpc_retry_sleep_read(struct file *file, char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct bng_re_dev *rdev = file->private_data;
+	char tmp[16];
+
+	if (!rdev || !rdev->mpc_roce_creq.mpc_tune_params)
+		return -ENODEV;
+
+	snprintf(tmp, sizeof(tmp), "%u\n", rdev->mpc_roce_creq.mpc_tune_params->retry_sleep);
+	return simple_read_from_buffer(buf, count, ppos, tmp, strlen(tmp));
+}
+
+static ssize_t mpc_retry_sleep_write(struct file *file, const char __user *buf,
+				     size_t count, loff_t *ppos)
+{
+	struct bng_re_dev *rdev = file->private_data;
+	u16 val;
+	int ret;
+
+	if (!rdev || !rdev->mpc_roce_creq.mpc_tune_params)
+		return -ENODEV;
+
+	ret = kstrtou16_from_user(buf, count, 0, &val);
+	if (ret)
+		return ret;
+
+	rdev->mpc_roce_creq.mpc_tune_params->retry_sleep = val;
+	return count;
+}
+
+static const struct file_operations mpc_retry_sleep_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = mpc_retry_sleep_read,
+	.write = mpc_retry_sleep_write,
+};
+
+static void bng_re_add_mpctune_knobs(struct bng_re_dev *rdev)
+{
+	struct dentry *mpctune_dir;
+
+	if (!rdev || !rdev->dbg_root)
+		return;
+
+	/* Create mpctune directory under debug root directory */
+	mpctune_dir = debugfs_create_dir("mpctune", rdev->dbg_root);
+	if (IS_ERR_OR_NULL(mpctune_dir)) {
+		dev_dbg(rdev_to_dev(rdev), "Unable to create mpctune debugfs dir\n");
+		return;
+	}
+
+	/* Create read-write files for each parameter - pass rdev as private_data */
+	debugfs_create_file("short_timeout", 0600, mpctune_dir,
+			    rdev, &mpc_short_timeout_fops);
+	debugfs_create_file("long_timeout", 0600, mpctune_dir,
+			    rdev, &mpc_long_timeout_fops);
+	debugfs_create_file("max_retries", 0600, mpctune_dir,
+			    rdev, &mpc_max_retries_fops);
+	debugfs_create_file("retry_sleep", 0600, mpctune_dir,
+			    rdev, &mpc_retry_sleep_fops);
+}
+
+static int bng_re_mpc_irq_info_show(struct seq_file *s, void *unused)
+{
+	struct bng_re_dev *rdev = s->private;
+	struct bng_mpc_ctx *mpc = rdev->mpc;
+
+	if (!mpc)
+		return -ENODEV;
+
+	seq_puts(s, "MPC IRQ info:\n");
+	seq_printf(s, "\t MPC IRQ Requested : %s\n\t irq_name : %s\n\t msix_vec: 0x%x\n\t NQ Ring ID: 0x%x\n",
+		   mpc->requested ? "YES" : "NO",
+		   mpc->irq_name,
+		   mpc->msix_vec,
+		   mpc->ring_id);
+
+	seq_puts(s, "MPC IRQ Stats:\n");
+	seq_printf(s, "\t Num IRQ Started: 0x%x\n\t Num IRQ Stopped : 0x%x\n\t Num IRQ Received : 0x%llx\n",
+		   mpc->stats.num_irq_started,
+		   mpc->stats.num_irq_stopped,
+		   mpc->stats.num_irq_received);
+	seq_printf(s, "\t Num NQ Rearmed : 0x%llx\n\t Num tasklet rescheduled : 0x%llx\n",
+		   mpc->stats.num_nq_rearm,
+		   mpc->stats.num_tasklet_resched);
+	seq_printf(s, "\t Num CQ pending/has_more_work: 0x%llx\n",
+		   mpc->stats.num_cq_pending);
+
+	seq_puts(s, "MPC NQ Info:\n");
+	seq_printf(s, "\t Last Consumer ID: 0x%x\n\t Max elements: 0x%x\n",
+		   mpc->hwq.cons,
+		   mpc->hwq.max_elements);
+	seq_puts(s, "\n");
+	return 0;
+}
+
+static int bng_re_mpc_irq_info_open(struct inode *inode, struct file *file)
+{
+	struct bng_re_dev *rdev = inode->i_private;
+
+	return single_open(file, bng_re_mpc_irq_info_show, rdev);
+}
+
+static const struct file_operations bng_re_mpc_irq_info_ops = {
+	.owner		= THIS_MODULE,
+	.open		= bng_re_mpc_irq_info_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+/* MPC performance and statistics display (must precede bng_re_debugfs_add_pdev) */
+static int bng_re_mpc_stats_show(struct seq_file *s, void *unused)
+{
+	struct bng_re_dev *rdev = s->private;
+
+	if (!rdev)
+		return -ENODEV;
+
+	seq_puts(s, "=== MPC RoCE Performance Statistics ===\n");
+	bng_re_mpc_roce_perf_debugfs_show(rdev, s, 1);
+
+	seq_puts(s, "\n=== MPC RoCE Diagnostic Counters ===\n");
+	bng_re_mpc_roce_diag_counters_debugfs_show(rdev, s);
+
+	return 0;
+}
+
+static int bng_re_mpc_stats_open(struct inode *inode, struct file *file)
+{
+	struct bng_re_dev *rdev = inode->i_private;
+
+	return single_open(file, bng_re_mpc_stats_show, rdev);
+}
+
+static const struct file_operations bng_re_mpc_stats_ops = {
+	.owner		= THIS_MODULE,
+	.open		= bng_re_mpc_stats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static ssize_t mpc_stats_clear_write(struct file *file, const char __user *buf,
+				     size_t count, loff_t *ppos)
+{
+	struct bng_re_dev *rdev = file->private_data;
+
+	if (!rdev)
+		return -ENODEV;
+
+	bng_re_mpc_roce_perf_debugfs_clear(rdev);
+	bng_re_mpc_roce_diag_counters_clear(rdev);
+
+	return count;
+}
+
+static const struct file_operations mpc_stats_clear_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.write = mpc_stats_clear_write,
+};
+
 void bng_re_debugfs_add_pdev(struct bng_re_dev *rdev)
 {
 	struct pci_dev *pdev = rdev->aux_dev->pdev;
 
 	rdev->dbg_root =
 		debugfs_create_dir(dev_name(&pdev->dev), bng_re_debugfs_root);
+
+	if (IS_ERR_OR_NULL(rdev->dbg_root)) {
+		dev_dbg(rdev_to_dev(rdev), "Unable to create debugfs %s",
+			dev_name(&pdev->dev));
+		return;
+	}
+
+	/* Add MPC IRQ info debugfs entry */
+	debugfs_create_file("mpc_irq", 0400, rdev->dbg_root,
+			    rdev, &bng_re_mpc_irq_info_ops);
+
+	/* Add MPC statistics display */
+	debugfs_create_file("mpc_stats", 0400, rdev->dbg_root,
+			    rdev, &bng_re_mpc_stats_ops);
+
+	/* Add MPC statistics clear functionality */
+	debugfs_create_file("mpc_stats_clear", 0200, rdev->dbg_root,
+			    rdev, &mpc_stats_clear_fops);
+
+	/* Add MPC tuning knobs for supported chips */
+	if (rdev->mpc_roce_creq.mpc_tune_params)
+		bng_re_add_mpctune_knobs(rdev);
 }
 
 void bng_re_debugfs_rem_pdev(struct bng_re_dev *rdev)
diff --git a/drivers/infiniband/hw/bng_re/bng_dev.c b/drivers/infiniband/hw/bng_re/bng_dev.c
index 311c8bc93160..ea6528e80ce3 100644
--- a/drivers/infiniband/hw/bng_re/bng_dev.c
+++ b/drivers/infiniband/hw/bng_re/bng_dev.c
@@ -15,6 +15,8 @@
 #include "bng_re.h"
 #include "bnge_hwrm.h"
 #include "bng_debugfs.h"
+#include "bng_re_mpc_roce.h"
+#include "bng_xid.h"
 
 MODULE_AUTHOR("Siva Reddy Kallam <siva.kallam@broadcom.com>");
 MODULE_DESCRIPTION(BNG_RE_DESC);
@@ -41,7 +43,6 @@ static struct bng_re_dev *bng_re_dev_add(struct auxiliary_device *adev,
 	return rdev;
 }
 
-
 static int bng_re_register_netdev(struct bng_re_dev *rdev)
 {
 	struct bnge_auxr_dev *aux_dev;
@@ -54,6 +55,8 @@ static void bng_re_destroy_chip_ctx(struct bng_re_dev *rdev)
 {
 	struct bng_re_chip_ctx *chip_ctx;
 
+	bng_res_unmap_db_bar(&rdev->bng_res);
+
 	kfree(rdev->dev_attr);
 	rdev->dev_attr = NULL;
 
@@ -65,6 +68,18 @@ static void bng_re_destroy_chip_ctx(struct bng_re_dev *rdev)
 	kfree(chip_ctx);
 }
 
+static void bng_re_set_db_offset(struct bng_re_dev *rdev)
+{
+	struct bnge_auxr_dev *aux_dev;
+	struct bng_re_res *res;
+
+	res = &rdev->bng_res;
+	aux_dev = rdev->aux_dev;
+
+	res->dpi_tbl.ucreg.offset = aux_dev->l2_db_offset;
+	res->dpi_tbl.wcreg.offset = aux_dev->l2_db_size;
+}
+
 static int bng_re_setup_chip_ctx(struct bng_re_dev *rdev)
 {
 	struct bng_re_chip_ctx *chip_ctx;
@@ -87,23 +102,31 @@ static int bng_re_setup_chip_ctx(struct bng_re_dev *rdev)
 		goto free_chip_ctx;
 	rdev->bng_res.dattr = rdev->dev_attr;
 
+	bng_re_set_db_offset(rdev);
+	rc = bng_res_map_db_bar(&rdev->bng_res);
+	if (rc)
+		goto free_attr;
+
 	return 0;
+free_attr:
+	kfree(rdev->dev_attr);
+	rdev->dev_attr = NULL;
 free_chip_ctx:
 	kfree(rdev->chip_ctx);
 	rdev->chip_ctx = NULL;
 	return rc;
 }
 
-static void bng_re_init_hwrm_hdr(struct input *hdr, u16 opcd)
+void bng_re_init_hwrm_hdr(struct input *hdr, u16 opcd)
 {
 	hdr->req_type = cpu_to_le16(opcd);
 	hdr->cmpl_ring = cpu_to_le16(-1);
 	hdr->target_id = cpu_to_le16(-1);
 }
 
-static void bng_re_fill_fw_msg(struct bnge_fw_msg *fw_msg, void *msg,
-			       int msg_len, void *resp, int resp_max_len,
-			       int timeout)
+void bng_re_fill_fw_msg(struct bnge_fw_msg *fw_msg, void *msg,
+			int msg_len, void *resp, int resp_max_len,
+			int timeout)
 {
 	fw_msg->msg = msg;
 	fw_msg->msg_len = msg_len;
@@ -112,8 +135,8 @@ static void bng_re_fill_fw_msg(struct bnge_fw_msg *fw_msg, void *msg,
 	fw_msg->timeout = timeout;
 }
 
-static int bng_re_net_ring_free(struct bng_re_dev *rdev,
-				u32 fw_ring_id, int type)
+int bng_re_net_ring_free(struct bng_re_dev *rdev,
+			 u32 fw_ring_id, int type)
 {
 	struct bnge_auxr_dev *aux_dev = rdev->aux_dev;
 	struct hwrm_ring_free_input req = {};
@@ -125,17 +148,17 @@ static int bng_re_net_ring_free(struct bng_re_dev *rdev,
 	req.ring_type = type;
 	req.ring_id = cpu_to_le32(fw_ring_id);
 	bng_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
-			    sizeof(resp), BNGE_DFLT_HWRM_CMD_TIMEOUT);
+			   sizeof(resp), BNGE_DFLT_HWRM_CMD_TIMEOUT);
 	rc = bnge_send_msg(aux_dev, &fw_msg);
 	if (rc)
-		ibdev_err(&rdev->ibdev, "Failed to free HW ring:%d :%#x",
-			  req.ring_id, rc);
+		ibdev_err(&rdev->ibdev, "Failed to free HW ring:%u :%#x",
+			  fw_ring_id, rc);
 	return rc;
 }
 
-static int bng_re_net_ring_alloc(struct bng_re_dev *rdev,
-				 struct bng_re_ring_attr *ring_attr,
-				 u16 *fw_ring_id)
+int bng_re_net_ring_alloc(struct bng_re_dev *rdev,
+			  struct bng_re_ring_attr *ring_attr,
+			  u16 *fw_ring_id)
 {
 	struct bnge_auxr_dev *aux_dev = rdev->aux_dev;
 	struct hwrm_ring_alloc_input req = {};
@@ -224,8 +247,8 @@ static int bng_re_query_hwrm_version(struct bng_re_dev *rdev)
 	ver_get_req.hwrm_intf_min = HWRM_VERSION_MINOR;
 	ver_get_req.hwrm_intf_upd = HWRM_VERSION_UPDATE;
 	bng_re_fill_fw_msg(&fw_msg, (void *)&ver_get_req, sizeof(ver_get_req),
-			    (void *)&ver_get_resp, sizeof(ver_get_resp),
-			    BNGE_DFLT_HWRM_CMD_TIMEOUT);
+			   (void *)&ver_get_resp, sizeof(ver_get_resp),
+			   BNGE_DFLT_HWRM_CMD_TIMEOUT);
 	rc = bnge_send_msg(aux_dev, &fw_msg);
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to query HW version, rc = 0x%x",
@@ -251,8 +274,15 @@ static int bng_re_query_hwrm_version(struct bng_re_dev *rdev)
 static void bng_re_dev_uninit(struct bng_re_dev *rdev)
 {
 	int rc;
+
+	bng_deinit_mpc(rdev);
+	bng_re_free_xid_tables(&rdev->bng_res);
+
 	bng_re_debugfs_rem_pdev(rdev);
 
+	if (test_and_clear_bit(BNG_RE_FLAG_TBLS_ALLOC_INITED, &rdev->flags))
+		bng_res_free_tbls(&rdev->bng_res);
+
 	if (test_and_clear_bit(BNG_RE_FLAG_RCFW_CHANNEL_EN, &rdev->flags)) {
 		rc = bng_re_deinit_rcfw(&rdev->rcfw);
 		if (rc)
@@ -262,7 +292,7 @@ static void bng_re_dev_uninit(struct bng_re_dev *rdev)
 		bng_re_free_stats_ctx_mem(rdev->bng_res.pdev, &rdev->stats_ctx);
 		bng_re_disable_rcfw_channel(&rdev->rcfw);
 		bng_re_net_ring_free(rdev, rdev->rcfw.creq.ring_id,
-			     RING_ALLOC_REQ_RING_TYPE_NQ);
+				     RING_ALLOC_REQ_RING_TYPE_NQ);
 		bng_re_free_rcfw_channel(&rdev->rcfw);
 	}
 
@@ -286,7 +316,7 @@ static int bng_re_dev_init(struct bng_re_dev *rdev)
 	rc = bng_re_register_netdev(rdev);
 	if (rc) {
 		ibdev_err(&rdev->ibdev,
-				"Failed to register with netedev: %#x\n", rc);
+			  "Failed to register with netedev: %#x\n", rc);
 		goto reg_netdev_fail;
 	}
 
@@ -347,7 +377,7 @@ static int bng_re_dev_init(struct bng_re_dev *rdev)
 	vid = rdev->nqr->msix_entries[BNG_RE_CREQ_NQ_IDX].vector;
 
 	rc = bng_re_enable_fw_channel(&rdev->rcfw,
-					vid, db_offt);
+				      vid, db_offt);
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to enable RCFW channel: %#x\n",
 			  rc);
@@ -358,6 +388,13 @@ static int bng_re_dev_init(struct bng_re_dev *rdev)
 	if (rc)
 		goto disable_rcfw;
 
+	rc = bng_re_init_xid_tables(rdev);
+	if (rc) {
+		ibdev_err(&rdev->ibdev,
+			  "Failed to init XID / IQM tables: %#x\n", rc);
+		goto disable_rcfw;
+	}
+
 	bng_re_debugfs_add_pdev(rdev);
 	rc = bng_re_alloc_stats_ctx_mem(rdev->bng_res.pdev, rdev->chip_ctx,
 					&rdev->stats_ctx);
@@ -370,7 +407,7 @@ static int bng_re_dev_init(struct bng_re_dev *rdev)
 	rc = bng_re_stats_ctx_alloc(rdev);
 	if (rc) {
 		ibdev_err(&rdev->ibdev,
-			  "Failed to allocate QPLIB context: %#x\n", rc);
+			  "Failed to allocate QP context: %#x\n", rc);
 		goto free_stats_ctx;
 	}
 
@@ -382,12 +419,32 @@ static int bng_re_dev_init(struct bng_re_dev *rdev)
 	}
 	set_bit(BNG_RE_FLAG_RCFW_CHANNEL_EN, &rdev->flags);
 
+	rc = bng_res_alloc_init_tbls(&rdev->bng_res);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Failed to allocate tbls: %#x\n", rc);
+		goto free_sctx;
+	}
+	set_bit(BNG_RE_FLAG_TBLS_ALLOC_INITED, &rdev->flags);
+
+	rtnl_lock();
+	rc = bng_alloc_init_mpc(rdev);
+	rtnl_unlock();
+	if (rc) {
+		ibdev_err(&rdev->ibdev,
+			  "MPC alloc-init failed rc = %#x\n", rc);
+		goto deinit_mpc;
+	}
 	return 0;
+deinit_mpc:
+	bng_deinit_mpc(rdev);
+	if (test_and_clear_bit(BNG_RE_FLAG_TBLS_ALLOC_INITED, &rdev->flags))
+		bng_res_free_tbls(&rdev->bng_res);
 free_sctx:
 	bng_re_stats_ctx_free(rdev);
 free_stats_ctx:
 	bng_re_free_stats_ctx_mem(rdev->bng_res.pdev, &rdev->stats_ctx);
 disable_rcfw:
+	bng_re_free_xid_tables(&rdev->bng_res);
 	bng_re_disable_rcfw_channel(&rdev->rcfw);
 free_ring:
 	bng_re_net_ring_free(rdev, rdev->rcfw.creq.ring_id, type);
@@ -434,7 +491,6 @@ static int bng_re_add_device(struct auxiliary_device *adev)
 	return rc;
 }
 
-
 static void bng_re_remove_device(struct bng_re_dev *rdev,
 				 struct auxiliary_device *aux_dev)
 {
@@ -442,7 +498,6 @@ static void bng_re_remove_device(struct bng_re_dev *rdev,
 	ib_dealloc_device(&rdev->ibdev);
 }
 
-
 static int bng_re_probe(struct auxiliary_device *adev,
 			const struct auxiliary_device_id *id)
 {
@@ -495,7 +550,6 @@ static int __init bng_re_mod_init(void)
 {
 	int rc;
 
-
 	bng_re_register_debugfs();
 
 	rc = auxiliary_driver_register(&bng_re_driver);
diff --git a/drivers/infiniband/hw/bng_re/bng_fw.c b/drivers/infiniband/hw/bng_re/bng_fw.c
index ab6a2d2e95b5..a69221368ba8 100644
--- a/drivers/infiniband/hw/bng_re/bng_fw.c
+++ b/drivers/infiniband/hw/bng_re/bng_fw.c
@@ -723,6 +723,7 @@ int bng_re_deinit_rcfw(struct bng_re_rcfw *rcfw)
 	clear_bit(FIRMWARE_INITIALIZED_FLAG, &rcfw->cmdq.flags);
 	return 0;
 }
+
 static inline bool _is_hw_retx_supported(u16 dev_cap_flags)
 {
 	return dev_cap_flags &
diff --git a/drivers/infiniband/hw/bng_re/bng_fw.h b/drivers/infiniband/hw/bng_re/bng_fw.h
index c89c926ec2fc..f89e4aeb2469 100644
--- a/drivers/infiniband/hw/bng_re/bng_fw.h
+++ b/drivers/infiniband/hw/bng_re/bng_fw.h
@@ -5,6 +5,8 @@
 #define __BNG_FW_H__
 
 #include "bng_tlv.h"
+#include "bnge.h"
+#include "bnge_auxr.h"
 
 /* FW DB related */
 #define BNG_FW_CMDQ_TRIG_VAL		1
@@ -43,7 +45,6 @@ struct bng_re_crsbe {
 	u8			data[1024];
 };
 
-
 static inline u32 bng_fw_cmdqe_npages(u32 depth)
 {
 	u32 npages;
@@ -58,6 +59,7 @@ static inline u32 bng_fw_cmdqe_page_size(u32 depth)
 {
 	return (bng_fw_cmdqe_npages(depth) * PAGE_SIZE);
 }
+
 struct bng_re_cmdq_mbox {
 	struct bng_re_reg_desc		reg;
 	void __iomem			*prod;
@@ -208,4 +210,8 @@ int bng_re_rcfw_send_message(struct bng_re_rcfw *rcfw,
 int bng_re_init_rcfw(struct bng_re_rcfw *rcfw,
 		     struct bng_re_stats *stats_ctx);
 int bng_re_deinit_rcfw(struct bng_re_rcfw *rcfw);
+
+void bng_re_init_hwrm_hdr(struct input *hdr, u16 opcd);
+void bng_re_fill_fw_msg(struct bnge_fw_msg *fw_msg, void *msg, int msg_len,
+			void *resp, int resp_max_len, int timeout);
 #endif
diff --git a/drivers/infiniband/hw/bng_re/bng_mpc.c b/drivers/infiniband/hw/bng_re/bng_mpc.c
new file mode 100644
index 000000000000..7bcad0dea632
--- /dev/null
+++ b/drivers/infiniband/hw/bng_re/bng_mpc.c
@@ -0,0 +1,574 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2025 Broadcom.
+
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/dma-mapping.h>
+#include <linux/sched.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+
+#include "bng_roce_hsi.h"
+#include "bng_tlv.h"
+#include "bng_res.h"
+#include "bng_sp.h"
+#include "bng_re.h"
+#include "bng_re_mpc_roce.h"
+#include "bng_fw.h"
+
+struct rdma_user_mmap_entry;
+
+#ifndef DBC_GROUP_SQ
+#define DBC_GROUP_SQ	0
+#define DBC_GROUP_CQ	3
+#endif
+
+static irqreturn_t bng_mpc_irq(int irq, void *dev_instance)
+{
+	struct bng_mpc_ctx *mpc = dev_instance;
+
+	tasklet_schedule(&mpc->mpc_tasklet);
+	dev_dbg(rdev_to_dev(mpc->rdev), "%s: MPC IRQ Received (0x%llx)\n",
+		__func__, mpc->stats.num_irq_received);
+	mpc->stats.num_irq_received++;
+
+	return IRQ_HANDLED;
+}
+
+static void bng_service_mpc(struct tasklet_struct *t)
+{
+	struct bng_mpc_ctx *mpc = from_tasklet(mpc, t, mpc_tasklet);
+
+	struct bng_re_res *res = &mpc->rdev->bng_res;
+	struct bng_re_hwq *nq_hwq = &mpc->hwq;
+	struct bng_re_dev *rdev = mpc->rdev;
+	int budget = 16; /*mpc->budget;*/
+	u32 has_more_nq = 1;
+	struct nq_base *nqe;
+	u32 type;
+
+	/*Process pending MPC completions before servicing NQ*/
+	if (mpc->cq_pending) {
+		mpc->cq_pending = bng_re_mpc_roce_service_cne(rdev, NULL,
+							      BNG_MPC_MAX_MESSAGES_PER_POLL);
+		if (mpc->cq_pending) {
+			mpc->stats.num_cq_pending++;
+			mpc->stats.num_tasklet_resched++;
+			tasklet_schedule(&mpc->mpc_tasklet);
+			dev_dbg(rdev_to_dev(mpc->rdev),
+				"%s:%d MPC IRQ Rescheduled due to CQ pending\n",
+				__func__, __LINE__);
+			return;
+		}
+	}
+
+	spin_lock_bh(&nq_hwq->lock);
+	do {
+		nqe = bng_re_get_qe(nq_hwq, nq_hwq->cons, NULL);
+		if (!NQE_CMP_VALID(nqe, mpc->nq_db.dbinfo.flags)) {
+			has_more_nq = 0;
+			break;
+		}
+		/* The valid test of the entry must be done first before
+		 * reading any further.
+		 */
+		dma_rmb();
+		type = le16_to_cpu(nqe->info10_type) & NQ_BASE_TYPE_MASK;
+		switch (type) {
+		case NQ_CN_TYPE_CQ_NOTIFICATION:
+		mpc->cq_pending =
+			bng_re_mpc_roce_service_cne(rdev, nqe,
+						    BNG_MPC_MAX_MESSAGES_PER_POLL);
+			if (mpc->cq_pending)
+				mpc->stats.num_cq_pending++;
+
+			break;
+		default:
+			dev_err(rdev_to_dev(mpc->rdev), "%s: Unsupported NQ type(0x%x)\n",
+				__func__, type);
+		}
+		bng_re_hwq_incr_cons(nq_hwq->max_elements, &nq_hwq->cons,
+				     1, &mpc->nq_db.dbinfo.flags);
+		dev_dbg(rdev_to_dev(mpc->rdev),
+			"%s: MPC IRQ NQ Processed Cons(0x%x) flag(0x%x) type(0x%x) max(0x%x)\n",
+			__func__, nq_hwq->cons, mpc->nq_db.dbinfo.flags,
+			type, nq_hwq->max_elements);
+	} while ((budget--) && (!mpc->cq_pending));
+
+	if (mpc->cq_pending) {
+		/* Update the consumer index only and dont enable arm */
+		bng_re_ring_nq_db(&mpc->nq_db.dbinfo, res->cctx, false);
+		mpc->stats.num_tasklet_resched++;
+		tasklet_schedule(&mpc->mpc_tasklet);
+		dev_dbg(rdev_to_dev(mpc->rdev),
+			"%s:%d MPC IRQ NQ Rescheduled due to CQ pending\n",
+			__func__, __LINE__);
+	} else {
+		if (!has_more_nq) {
+			mpc->stats.num_nq_rearm++;
+			bng_re_ring_nq_db(&mpc->nq_db.dbinfo, res->cctx, true);
+			dev_dbg(rdev_to_dev(mpc->rdev),
+				"%s: MPC IRQ NQ Armed flag(0x%x)\n",
+					__func__, mpc->nq_db.dbinfo.flags);
+		} else if (mpc->requested) {
+			/* Update the consumer index only and dont enable arm */
+			bng_re_ring_nq_db(&mpc->nq_db.dbinfo, res->cctx, false);
+			mpc->stats.num_tasklet_resched++;
+			tasklet_schedule(&mpc->mpc_tasklet);
+			dev_dbg(rdev_to_dev(mpc->rdev),
+				"%s: MPC IRQ NQ Rescheduled due to NQ pending\n",
+				__func__);
+		}
+	}
+	spin_unlock_bh(&nq_hwq->lock);
+}
+
+static int bng_mpc_start_irq(struct bng_mpc_ctx *mpc, int msix_vector,
+			     bool need_init)
+{
+	struct bng_re_res *res;
+	int rc;
+
+	res = &mpc->rdev->bng_res;
+
+	if (mpc->requested) {
+		dev_info(rdev_to_dev(mpc->rdev), "%s: MPC IRQ - Already Started\n", __func__);
+		return 0;
+	}
+	mpc->msix_vec = msix_vector;
+	if (need_init)
+		tasklet_setup(&mpc->mpc_tasklet,
+			      bng_service_mpc);
+	else
+		tasklet_enable(&mpc->mpc_tasklet);
+
+	mpc->irq_name = kasprintf(GFP_KERNEL, "bng_re-mpc@pci:%s",
+				  pci_name(res->pdev));
+	if (!mpc->irq_name) {
+		dev_err(rdev_to_dev(mpc->rdev), "%s: Failed to alloc irq_name\n", __func__);
+		return -ENOMEM;
+	}
+	rc = request_irq(mpc->msix_vec, bng_mpc_irq, 0,
+			 mpc->irq_name, mpc);
+	if (rc) {
+		kfree(mpc->irq_name);
+		mpc->irq_name = NULL;
+		tasklet_disable(&mpc->mpc_tasklet);
+		dev_err(rdev_to_dev(mpc->rdev), "%s: request_irq failed rc(0x%x)\n", __func__, rc);
+		return rc;
+	}
+	mpc->requested = true;
+	bng_re_ring_nq_db(&mpc->nq_db.dbinfo, res->cctx, true);
+
+	mpc->stats.num_irq_started++;
+
+	return 0;
+}
+
+void bng_mpc_stop_irq(struct bng_mpc_ctx *mpc, bool kill)
+{
+	struct bng_re_res *res;
+
+	dev_dbg(rdev_to_dev(mpc->rdev), "%s: Start(%d)\n",
+		__func__, mpc->requested);
+
+	if (!mpc->requested)
+		return;
+
+	mpc->requested = false;
+	res = &mpc->rdev->bng_res;
+	/* Mask h/w interrupt */
+	bng_re_ring_nq_db(&mpc->nq_db.dbinfo, res->cctx, false);
+	/* Sync with last running IRQ handler */
+	synchronize_irq(mpc->msix_vec);
+	irq_set_affinity_hint(mpc->msix_vec, NULL);
+	free_irq(mpc->msix_vec, mpc);
+	kfree(mpc->irq_name);
+	mpc->irq_name = NULL;
+
+	/* Cleanup Tasklet */
+	if (kill)
+		tasklet_kill(&mpc->mpc_tasklet);
+	else
+		tasklet_disable(&mpc->mpc_tasklet);
+}
+
+static void bng_map_mpc_nq_db(struct bng_mpc_ctx *mpc,  u32 reg_offt)
+{
+	struct bng_re_reg_desc *dbreg;
+	struct bng_re_nq_db *nq_db;
+	struct bng_re_res *res;
+
+	nq_db = &mpc->nq_db;
+	res = &mpc->rdev->bng_res;
+	dbreg = &res->dpi_tbl.ucreg;
+
+	nq_db->reg.bar_id = dbreg->bar_id;
+	nq_db->reg.bar_base = dbreg->bar_base;
+	nq_db->reg.bar_reg = dbreg->bar_reg + reg_offt;
+	nq_db->reg.len = sizeof(u64);
+
+	nq_db->dbinfo.db = nq_db->reg.bar_reg;
+	nq_db->dbinfo.hwq = &mpc->hwq;
+	nq_db->dbinfo.xid = mpc->ring_id;
+	nq_db->dbinfo.seed = mpc->ring_id;
+	nq_db->dbinfo.flags = 0;
+	spin_lock_init(&nq_db->dbinfo.lock);
+	nq_db->dbinfo.res =  &mpc->rdev->bng_res;
+}
+
+static int bng_alloc_mpc_nq_mem(struct bng_mpc_ctx *mpc)
+{
+	struct bng_re_hwq_attr hwq_attr = {};
+	struct bng_re_sg_info sginfo = {};
+
+	if (!mpc->hwq.max_elements ||
+	    mpc->hwq.max_elements > BNG_NQE_MAX_CNT)
+		mpc->hwq.max_elements = BNG_NQE_MAX_CNT;
+
+	sginfo.pgsize = PAGE_SIZE;
+	sginfo.pgshft = PAGE_SHIFT;
+	hwq_attr.res = &mpc->rdev->bng_res;
+	hwq_attr.sginfo = &sginfo;
+	hwq_attr.depth = mpc->hwq.max_elements;
+	hwq_attr.stride = sizeof(struct nq_base);
+	hwq_attr.type = BNG_HWQ_TYPE_QUEUE;
+	if (bng_re_alloc_init_hwq(&mpc->hwq, &hwq_attr)) {
+		dev_err(&mpc->rdev->bng_res.pdev->dev, "QP: MPC NQ allocation failed");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void bng_free_mpc_nq_mem(struct bng_mpc_ctx *mpc)
+{
+	if (mpc->hwq.max_elements) {
+		bng_re_free_hwq(&mpc->rdev->bng_res, &mpc->hwq);
+		mpc->hwq.max_elements = 0;
+	}
+}
+
+static int bng_setup_mpc_nq(struct bng_mpc_ctx *mpc)
+{
+	struct bng_re_dev *rdev = mpc->rdev;
+	struct bng_re_ring_attr rattr = {};
+	int depth;
+	u32 offt;
+	u16 vec;
+	int rc;
+
+	mutex_init(&rdev->nqr->load_lock);
+
+	depth = BNG_NQE_MAX_CNT;
+	vec = rdev->nqr->msix_entries[BNG_RE_MPC_IRQ_IDX].vector;
+	offt = rdev->nqr->msix_entries[BNG_RE_MPC_IRQ_IDX].db_offset;
+	mpc->hwq.max_elements = depth;
+	rc = bng_alloc_mpc_nq_mem(mpc);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev),
+			"Failed to get mem for MPC NQ %d, rc = 0x%x",
+			BNG_RE_MPC_IRQ_IDX, rc);
+		return rc;
+	}
+
+	rattr.dma_arr = mpc->hwq.pbl[BNG_PBL_LVL_0].pg_map_arr;
+	rattr.pages = mpc->hwq.pbl[mpc->hwq.level].pg_count;
+	rattr.type = RING_ALLOC_REQ_RING_TYPE_NQ;
+	rattr.mode = RING_ALLOC_REQ_INT_MODE_MSIX;
+	rattr.depth = mpc->hwq.max_elements - 1;
+	rattr.lrid = rdev->nqr->msix_entries[BNG_RE_MPC_IRQ_IDX].ring_idx;
+
+	rc = bng_re_net_ring_alloc(rdev, &rattr, &mpc->ring_id);
+	if (rc) {
+		mpc->ring_id = 0xffff; /* Invalid ring-id */
+		dev_err(rdev_to_dev(rdev),
+			"%s:pages(0x%x) type(0x%x) mode(0x%x)depth(0x%x) lrid(0x%x) ring_id(0x%x)",
+			__func__, rattr.pages, rattr.type, rattr.mode,
+			rattr.depth, rattr.lrid, mpc->ring_id);
+		dev_err(rdev_to_dev(rdev),
+			"Failed to get fw id for MPC NQ %d, rc = 0x%x",
+			BNG_RE_MPC_IRQ_IDX, rc);
+		goto fail_ring;
+	}
+	dev_dbg(rdev_to_dev(rdev),
+		"%s: pages(0x%x) type(0x%x) mode(0x%x) depth(0x%x) lrid(0x%x) ring_id(0x%x)",
+		__func__, rattr.pages, rattr.type, rattr.mode,
+		rattr.depth, rattr.lrid, mpc->ring_id);
+
+	return 0;
+
+fail_ring:
+	bng_free_mpc_nq_mem(mpc);
+	return rc;
+}
+
+static int bng_enable_mpc_nq(struct bng_mpc_ctx *mpc, int msix_vec, int bar_reg_offset)
+{
+	int rc;
+
+	rc = bng_setup_mpc_nq(mpc);
+	if (rc)
+		return rc;
+
+	bng_map_mpc_nq_db(mpc, bar_reg_offset);
+
+	rc = bng_mpc_start_irq(mpc, msix_vec, true);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+static int bng_disable_mpc_nq(struct bng_mpc_ctx *mpc)
+{
+	/* Make sure the HW is stopped! */
+	bng_mpc_stop_irq(mpc, true);
+
+	mpc->nq_db.reg.bar_reg = NULL;
+	mpc->nq_db.dbinfo.db = NULL;
+
+	mpc->msix_vec = 0;
+
+	return 0;
+}
+
+static int bng_alloc_mpc_ctx(struct bng_re_dev *rdev)
+{
+	rdev->mpc = kzalloc_obj(*rdev->mpc, GFP_KERNEL);
+	if (!rdev->mpc)
+		return -ENOMEM;
+
+	rdev->mpc->rdev = rdev;
+	return 0;
+}
+
+static void bng_free_mpc_ctx(struct bng_re_dev *rdev)
+{
+	kfree(rdev->mpc);
+	rdev->mpc = NULL;
+}
+
+static int bng_alloc_init_mpc_irq(struct bng_re_dev *rdev)
+{
+	int reg_offset = 0;
+	int msix_vec = 0;
+	int rc = 0;
+
+	rc = bng_alloc_mpc_ctx(rdev);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "%s: MPC Ctx Alloc Failed rc (0x%x)\n", __func__, rc);
+		return rc;
+	}
+
+	msix_vec = rdev->nqr->msix_entries[BNG_RE_MPC_IRQ_IDX].vector;
+	reg_offset = rdev->nqr->msix_entries[BNG_RE_MPC_IRQ_IDX].db_offset;
+
+	rc = bng_enable_mpc_nq(rdev->mpc, msix_vec, reg_offset);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "%s: Enable MPC NQ Failed rc (0x%x)\n", __func__, rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+static void bng_mask_mpc_irq(struct bng_re_dev *rdev)
+{
+	if (!rdev->mpc)
+		return;
+
+	bng_disable_mpc_nq(rdev->mpc);
+}
+
+static void bng_deinit_mpc_irq(struct bng_re_dev *rdev)
+{
+	if (!rdev->mpc)
+		return;
+
+	bng_free_mpc_nq_mem(rdev->mpc);
+	bng_re_net_ring_free(rdev, rdev->mpc->ring_id, RING_ALLOC_REQ_RING_TYPE_NQ);
+	bng_free_mpc_ctx(rdev);
+}
+
+/**
+ * bng_mpc_background_thread_fn - Continuously poll the MPC CQ.
+ * @data: struct bng_re_dev * (RoCE device)
+ * Returns: 0
+ */
+static int bng_mpc_background_thread_fn(void *data)
+{
+	struct bng_re_dev *rdev = (struct bng_re_dev *)data;
+
+	while (!kthread_should_stop()) {
+		usleep_range(BNG_MPC_MIN_USLEEP_POLL, BNG_MPC_MAX_USLEEP_POLL);
+		bng_re_mpc_roce_service_creq(rdev, BNG_MPC_MAX_MESSAGES_PER_POLL);
+	}
+
+	dev_dbg(rdev_to_dev(rdev), "%s: terminating\n", __func__);
+	return 0;
+}
+
+/**
+ * bng_mpc_start_background_poll - Start polling MPC CQ in the background.
+ * @rdev: RoCE device
+ * @new_thread: out param to cache the created thread
+ * Returns: 0 for success
+ */
+int bng_mpc_start_background_poll(struct bng_re_dev *rdev,
+				  struct task_struct **new_thread)
+{
+	*new_thread = kthread_create(bng_mpc_background_thread_fn,
+				     rdev, "mpc poll background thread");
+	if (IS_ERR(*new_thread)) {
+		dev_err(rdev_to_dev(rdev), "%s: kthread_create failed\n", __func__);
+		return -EPERM;
+	}
+	sched_set_fifo(*new_thread);
+	wake_up_process(*new_thread);
+	return 0;
+}
+
+/**
+ * bng_mpc_stop_background_poll - Stop the MPC background poll thread.
+ * @rdev: RoCE device
+ * @thread: thread to stop (set to NULL on return)
+ */
+void bng_mpc_stop_background_poll(struct bng_re_dev *rdev,
+				  struct task_struct **thread)
+{
+	int rc = 0;
+
+	if (*thread) {
+		rc = kthread_stop(*thread);
+		*thread = NULL;
+	}
+
+	if (rc)
+		dev_err(rdev_to_dev(rdev), "%s: kthread_stop returned %d\n",
+			__func__, rc);
+}
+
+static int bng_alloc_init_mpc_creq(struct bng_re_dev *rdev)
+{
+	int rc = 0;
+
+	/* init mpc creq channel */
+	rdev->mpc_roce_creq.bm_lr_index = rdev->nqr->msix_entries[BNG_RE_MPC_IRQ_IDX].ring_idx;
+	rdev->mpc_roce_creq.bm_nq_ring_id = rdev->mpc->ring_id;
+	rdev->mpc_roce_creq.bm_stat_index = rdev->stats_ctx.fw_id;
+
+	dev_info(rdev_to_dev(rdev),
+		 "[%s:%p:%d] bm_lr_index:%d, nq_ring_id:%d, stat_index:%d\n",
+		 __func__, current, __LINE__,
+		 rdev->mpc_roce_creq.bm_lr_index,
+		 rdev->mpc_roce_creq.bm_nq_ring_id,
+		 rdev->mpc_roce_creq.bm_stat_index);
+
+	rc = bng_re_mpc_roce_alloc_init(rdev);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev),
+			"[%s:%p:%d] Error alloc init mpc roce creq (err : %d)\n",
+			__func__, current, __LINE__, rc);
+		return rc;
+	}
+	set_bit(BNG_RE_FLAG_MPC_FW_CHANNEL_EN, &rdev->flags);
+
+	return rc;
+}
+
+static int bng_deinit_mpc_creq(struct bng_re_dev *rdev)
+{
+	rdev->mpc_roce_creq.bm_mpc_uninstall_pending = 1;
+	bng_re_check_mpc_pending_empty(rdev);
+	if (test_and_clear_bit(BNG_RE_FLAG_MPC_FW_CHANNEL_EN, &rdev->flags))
+		/*bnge_deinit_and_free_mpc_roce_creq(rdev->en_dev, true);*/
+		bng_re_mpc_roce_deinit_free(rdev);
+	else
+		dev_dbg(rdev_to_dev(rdev),
+			"Did not free mpc roce creq rings");
+
+	return 0;
+}
+
+int bng_alloc_init_mpc(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	int rc = 0;
+
+	if (creq->mpc_cache && creq->mpc_tune_params && creq->bm_diag_counters)
+		return 0;
+
+	rc = bng_alloc_init_mpc_irq(rdev);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "%s: Init MPC IRQ Failed (0x%x)\n", __func__, rc);
+		return rc;
+	}
+	rc = bng_alloc_init_mpc_creq(rdev);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "%s: Alloc Init MPC CREQ Failed(0x%x)\n", __func__, rc);
+		return rc;
+	}
+	/* to make sure it isn't a ghost setting */
+	rdev->mpc_roce_creq.bm_mpc_uninstall_pending = 0;
+	return rc;
+}
+
+int bng_deinit_mpc(struct bng_re_dev *rdev)
+{
+	int rc = 0;
+
+	/* Mask the MPC IRQ and kill the tasklet before draining/freeing
+	 * the CREQ hwqs and cache, so an in-flight completion can't run
+	 * against memory that is about to be freed.
+	 */
+	bng_mask_mpc_irq(rdev);
+
+	rc = bng_deinit_mpc_creq(rdev);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "%s: DeInit MPC CREQ Failed (0x%x)\n", __func__, rc);
+		return rc;
+	}
+
+	bng_deinit_mpc_irq(rdev);
+	return rc;
+}
+
+int bng_re_alloc_mpc_doorbells(struct bng_re_dev *rdev)
+{
+	/* the hw db recovery functionality is pending */
+	return 0;
+}
+
+void bng_re_unalloc_mpc_doorbells(struct bng_re_dev *rdev)
+{
+	struct bng_re_db_info *tx_db = &rdev->mpc_roce_creq.tx_db_info;
+	struct bng_re_db_info *cq_db = &rdev->mpc_roce_creq.cq_db_info;
+
+	tx_db->dbc = NULL;
+	cq_db->dbc = NULL;
+}
+
+void bng_re_check_mpc_pending_empty(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	int iters = 0;
+	const int max_iters = (CHECK_MPC_PENDING_MAX_SECS * 1000) / 20;
+
+	while (atomic_read(&creq->pending)) {
+		if (iters >= max_iters) {
+			dev_err(rdev_to_dev(rdev),
+				"%s - MPC pending did not drain within %d seconds\n",
+				__func__,
+				CHECK_MPC_PENDING_MAX_SECS);
+			return;
+		}
+		msleep(20);
+		iters++;
+	}
+	dev_dbg(rdev_to_dev(rdev),
+		"%s - MPC pending completed in %d iterations\n",
+		__func__,
+		iters);
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_re.h b/drivers/infiniband/hw/bng_re/bng_re.h
index dae4862621a7..d6fb205d9f12 100644
--- a/drivers/infiniband/hw/bng_re/bng_re.h
+++ b/drivers/infiniband/hw/bng_re/bng_re.h
@@ -4,7 +4,13 @@
 #ifndef __BNG_RE_H__
 #define __BNG_RE_H__
 
+#include "bnge.h"
+#include "bnge_auxr.h"
 #include "bng_res.h"
+#include "bng_fw.h"
+#include <rdma/ib_verbs.h>
+
+#define BNG_RE_XID_AVOID_REUSE		false
 
 #define BNG_RE_ADEV_NAME		"bng_en"
 
@@ -18,12 +24,165 @@
 #define BNG_RE_CREQ_NQ_IDX	0
 
 #define BNGE_INVALID_STATS_CTX_ID	-1
+
+/* poll interval while polling for mpc roce creq response */
+#define BNG_MPC_MIN_USLEEP_POLL (5)
+#define BNG_MPC_MAX_USLEEP_POLL (15)
+#define BNG_MPC_MAX_MESSAGES_PER_POLL  (32)
+
+/* limit how long we wait for mpc to drain during uninit */
+#define CHECK_MPC_PENDING_MAX_SECS (40)
+
+enum {
+	BNG_RE_AEQ_IDX = 0,
+	BNG_RE_MPC_IRQ_IDX,
+	BNG_RE_MAX_RSVD_IRQ,
+};
+
+/* MPC VF buffer specific information */
+#define BNG_MPC_MAX_REQ_SIZE		512
+#define BNG_MPC_MAX_NUM_REQ		1024
+#define BNG_MPC_MAX_VF_CMD_FWD_PAGES	1
+#define BNG_MPC_VF_BUF_PAGE_SLOTS	4
+
+/* RoCE MPC diagnostics and knobs (mirrors bnge for compatibility) */
+#define BNG_RE_MPC_MAX_LATENCY_SEC_SLAB_INDEX	201
+#define BNG_RE_MPC_MAX_LATENCY_MSEC_SLAB_INDEX	3000
+#define BNG_RE_MPC_MAX_STAT_INDEX		0x3FFFF
+
+#define ROCE_MPC_MAX_STAT_INDEX			BNG_RE_MPC_MAX_STAT_INDEX
+#define ROCE_MPC_MAX_LATENCY_SEC_SLAB_INDEX	BNG_RE_MPC_MAX_LATENCY_SEC_SLAB_INDEX
+#define ROCE_MPC_MAX_LATENCY_MSEC_SLAB_INDEX	BNG_RE_MPC_MAX_LATENCY_MSEC_SLAB_INDEX
+
+struct bng_re_mpc_poll_info {
+	u64 bm_last_poll_work_poll_jiffies_start;
+	u64 bm_last_poll_work_poll_jiffies_end;
+	u64 bm_max_poll_work_poll_jiffies;
+	u32 bm_current_cons_indx;
+	u64 bm_start_time_on_current_cons_indx;
+	u64 bm_curr_time_on_current_cons_indx;
+};
+
+struct bng_re_mpc_diag_counters {
+	atomic_t bm_mpc_verb_try;
+	atomic_t bm_mpc_sent_try;
+	atomic_t bm_mpc_sent_started_ok;
+	atomic_t bm_mpc_sent_started_ebusy;
+	atomic_t bm_mpc_sent_started_misc_err;
+	atomic_t bm_mpc_sent_response_ok;
+	atomic_t bm_mpc_sent_response_err;
+	atomic_t bm_mpc_fatal_ebusy;
+	atomic_t bm_mpc_sent_timeout;
+	atomic_t bm_mpc_misc_err;
+	atomic_t bm_mpc_consecutive_sent_err;
+	atomic_t bm_mpc_stalled_err;
+};
+
+struct bng_re_mpc_tune_params {
+	u32 short_timeout;
+	u32 long_timeout;
+	u16 max_retries;
+	u16 retry_sleep;
+};
+
+struct bng_re_mpc_roce_stats_info {
+	bool bms_stats_enabled;
+	u32 bms_qp_modify_stats_id;
+	u32 bms_ah_modify_stats_id;
+	u32 bms_other_stats_id;
+	u64 *bms_qp_modify_stats;
+	u64 *bms_ah_modify_stats;
+	u64 *bms_other_stats;
+	u32 *bms_lat_slab_sec;
+	u32 *bms_lat_slab_msec;
+};
+
+struct bng_re_mpc_roce_creq_info {
+	struct task_struct	 *bm_poll_thread;
+	u32			 bm_lr_index;
+	u16			 bm_nq_ring_id;
+	u32			 bm_stat_index;
+	struct bng_re_db_info tx_db_info;
+	struct bng_re_db_info cq_db_info;
+	struct rdma_user_mmap_entry      *tx_hdbr_mmap;
+	struct rdma_user_mmap_entry      *cq_hdbr_mmap;
+
+	/* Transmit and completion rings (roce-style HWQ) */
+	struct bng_re_hwq		tx_hwq;
+	struct bng_re_hwq		cq_hwq;
+	u32				tx_ring_id;
+	u16				cq_ring_id;
+
+	/* SW ring for tx: maps prod index to (handle, inline_bds, last_cons) */
+	struct {
+		unsigned long handle;
+		u8 inline_bds;
+		unsigned long last_cons;   /* BNG_RE_MPC_INV_HDL when completion received */
+	} *tx_sw_ring;
+	u32				tx_prod;
+	u32				tx_cons;
+	u16				tx_napi_idx;	/* for opaque */
+	u32				tx_ring_mask;	/* tx_hwq.max_elements - 1 */
+	u32				cq_ring_mask;	/* cq_hwq.max_elements - 1 */
+	u32				cq_cp_bit;	/* for CMP valid toggle */
+
+	/* lock access to the transmit ring */
+	spinlock_t			tx_lock;
+	/* lock access to the mpc context */
+	spinlock_t			mpc_ctx_lock;
+	/* lock access to receive buffer processing */
+	spinlock_t			bm_lock;
+
+	/* Diagnostics and poll info (from bnge) */
+	struct bng_re_mpc_poll_info	*bm_poll_info;
+	struct bng_re_mpc_diag_counters	*bm_diag_counters;
+	struct bng_re_mpc_tune_params	*mpc_tune_params;
+	struct bng_re_mpc_roce_stats_info *bm_stats_info;
+
+	/* Pending/context tracking (from bnge mpc_roce_info) */
+	atomic_t			pending;
+	atomic_t			max_pending;
+	u32				avail_buffer;
+	u32				min_avail_buffer;
+	struct kmem_cache		*mpc_cache;
+	bool				bm_mpc_stall;
+	u8				bm_mpc_uninstall_pending;
+};
+
+struct bng_mpc_stats {
+	u32	num_irq_started;
+	u32	num_irq_stopped;
+	u64	num_tasklet_resched;
+	u64	num_nq_rearm;
+	u64	num_irq_received;
+	u64	num_cq_pending;
+};
+
+struct bng_mpc_db {
+	struct bng_re_reg_desc	reg;
+	void __iomem			*db;
+	struct bng_re_db_info	dbinfo;
+};
+
 /* NQ specific structures  */
 struct bng_re_nq_db {
 	struct bng_re_reg_desc	reg;
 	struct bng_re_db_info	dbinfo;
 };
 
+struct bng_mpc_ctx {
+	struct bng_re_dev		*rdev;
+	struct bng_re_hwq		hwq;
+	struct bng_re_nq_db		nq_db;
+	struct bng_mpc_stats	stats;
+	struct tasklet_struct		mpc_tasklet;
+	char				*irq_name;
+	int				msix_vec;
+	u16				ring_id;
+	bool				requested; /*irq handler installed */
+	bool				cq_pending;
+};
+
 struct bng_re_nq {
 	struct pci_dev			*pdev;
 	struct bng_re_res		*res;
@@ -68,6 +227,13 @@ struct bng_re_dev {
 	unsigned long			flags;
 #define BNG_RE_FLAG_NETDEV_REGISTERED		0
 #define BNG_RE_FLAG_RCFW_CHANNEL_EN		1
+#define BNG_RE_FLAG_TBLS_ALLOC_INITED		2
+#define BNG_RE_FLAG_MPC_FW_CHANNEL_EN		31
+#define BNG_RE_FLAG_MPC_FW_THREAD_EN		32
+#define BNG_RE_FLAG_MPC_DB_PAGE_EN		34
+#define BNG_RE_FLAG_ERR_DEVICE_DETACHED		36
+
+#define BNG_RE_STEERING_TO_HOST			0
 	struct net_device		*netdev;
 	struct auxiliary_device         *adev;
 	struct bnge_auxr_dev		*aux_dev;
@@ -80,6 +246,14 @@ struct bng_re_dev {
 	struct bng_re_dev_attr		*dev_attr;
 	struct dentry			*dbg_root;
 	struct bng_re_stats		stats_ctx;
+	struct bng_re_mpc_roce_creq_info mpc_roce_creq;
+	struct bng_mpc_ctx	*mpc;
 };
 
+int bng_re_net_ring_alloc(struct bng_re_dev *rdev,
+			  struct bng_re_ring_attr *ring_attr,
+			  u16 *fw_ring_id);
+int bng_re_net_ring_free(struct bng_re_dev *rdev,
+			 u32 fw_ring_id, int type);
+
 #endif
diff --git a/drivers/infiniband/hw/bng_re/bng_re_mpc_roce.c b/drivers/infiniband/hw/bng_re/bng_re_mpc_roce.c
new file mode 100644
index 000000000000..3ecf5f34180a
--- /dev/null
+++ b/drivers/infiniband/hw/bng_re/bng_re_mpc_roce.c
@@ -0,0 +1,1863 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2025 Broadcom.
+
+#include <linux/stddef.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+
+#include "bng_roce_hsi.h"
+#include "bng_re.h"
+#include "bng_res.h"
+#include "bng_fw.h"
+#include "bnge.h"
+#include "bnge_hwrm.h"
+#include "bng_re_mpc_roce.h"
+#include "bnge_auxr.h"
+
+/* Handle unsolicited MPC completion (e.g. RCA QP XID cleanup complete). */
+
+/**
+ * bng_re_mpc_handle_event_cmpl - core handler for unsolicited MPC event completions
+ * @rdev:     RoCE device
+ * @cmpl:     pointer to the 32-byte completion payload (mpc_event_resp_cmpl)
+ * @cmpl_len: byte length of the payload
+ *
+ * Called directly from bng_re_mpc_roce_service_creq when handle == 0 and the
+ * completion is an EVENT type, bypassing the old ULP callback mechanism.
+ */
+void bng_re_mpc_handle_event_cmpl(struct bng_re_dev *rdev,
+				  void *cmpl, u32 cmpl_len)
+{
+	struct mpc_event_resp_cmpl *hdr = (struct mpc_event_resp_cmpl *)cmpl;
+	int event_data;
+	int event;
+	int xid;
+
+	if (!rdev || !cmpl) {
+		dev_warn(rdev_to_dev(rdev),
+			 "%s: Invalid driver state or completion pointer: %lu,%lu\n",
+			 __func__, (unsigned long)rdev, (unsigned long)cmpl);
+		return;
+	}
+	if (cmpl_len != sizeof(struct mpc_event_resp_cmpl)) {
+		dev_warn(rdev_to_dev(rdev),
+			 "unsolicited mpc cmpl too short: %u < %zu\n",
+			 cmpl_len, sizeof(struct mpc_event_resp_cmpl));
+		return;
+	}
+	xid        = (int)le32_to_cpu(hdr->xid);
+	event      = (int)le32_to_cpu(hdr->event_type);
+	event_data = (int)le32_to_cpu(hdr->event_data);
+	/*  sanity check the fields look sane */
+	if (!(event == MPC_EVENT_RESP_CMPL_EVENT_TYPE_EVENT_TYPE_QP_EVENT &&
+	      event_data == MPC_EVENT_RESP_CMPL_EVENT_DATA_EVENT_TYPE_FASTQP_MD_COMPLETE))
+		dev_warn(rdev_to_dev(rdev),
+			 "unexpected event mpc cmpl: xid=%d event=%d data=%d\n",
+			 xid, event, event_data);
+	/* process even if event / event_data isn't as expected, as we don't use them rn */
+	/* bng_re_qp_xid_pending_process_unsolicited_cmpl(rdev, xid); */
+}
+
+/**
+ * bng_re_mpc_process_vf_completion - Handle PF/VF MPC completion on the PF path
+ * @rdev: RoCE device
+ * @cmpl: Completion buffer (starts with &struct mpc_cmpl_hdr)
+ * @cmpl_len: Length of @cmpl in bytes
+ *
+ * Dispatches VF-related QP/AH create, modify, and destroy completions without
+ * registering with the bnge ULP. No-op if the device is detached or not registered.
+ */
+
+/**
+ * bng_re_roce_mpc_cmp - Deliver one solicited MPC completion to a command context
+ * @rdev: RoCE device
+ * @handle: Pointer to struct bng_re_roce_cmd_ctx cast to unsigned long
+ * @cmpl: Completion entry (payload and length)
+ *
+ * Copies the completion into the context, issues a write memory barrier, then
+ * either sets cmpl_available for polling mode or completes the wait queue.
+ */
+void bng_re_roce_mpc_cmp(struct bng_re_dev *rdev, unsigned long handle,
+			 struct bng_re_cmpl_entry *cmpl)
+{
+	struct bng_re_roce_cmd_ctx *ctx;
+	struct mpc_cmpl_hdr *cmp;
+	u32 len;
+
+	dev_dbg(rdev_to_dev(rdev), "%s: handele:%lx\n", __func__, handle);
+
+	if (cmpl->len != MPC_ROCE_COMPL_MAX_SIZE) {
+		dev_warn(rdev_to_dev(rdev), "%s: Unexpected cmpl_len:%d\n",
+			 __func__, cmpl->len);
+		return;
+	}
+	len = cmpl->len;
+	cmp = cmpl->cmpl;
+	ctx = (void *)handle;
+	if (!ctx) {
+		dev_warn(rdev_to_dev(rdev), "%s: ctx null\n",
+			 __func__);
+		return;
+	}
+	memcpy(&ctx->roce_cmp, cmp, len);
+	/* make sure memory is updated */
+	smp_wmb();
+	if (ctx->poll_cmp)
+		WRITE_ONCE(ctx->cmpl_available, 1);
+	else
+		complete(&ctx->cmp);
+}
+
+/**
+ * bng_re_mpc_tx_avail - Free TX ring slots for new MPC posts
+ * @creq: RoCE MPC channel state
+ *
+ * Return: Number of unused BD slots in the MPC TX ring (masked ring arithmetic).
+ */
+static u32 bng_re_mpc_tx_avail(struct bng_re_mpc_roce_creq_info *creq)
+{
+	u32 used = READ_ONCE(creq->tx_prod) - READ_ONCE(creq->tx_cons);
+
+	return (creq->tx_ring_mask + 1) - (used & creq->tx_ring_mask);
+}
+
+/**
+ * bng_re_mpc_adv_tx_cons - Advance MPC TX consumer past completed multi-BD posts
+ * @creq: RoCE MPC channel state
+ *
+ * Walks the software TX ring from tx_cons while each slot's last_cons marks
+ * the post as fully completed, so out-of-order completions can be absorbed
+ * safely. Bounded by MAX_ADV_ITERATIONS to avoid infinite loops on corruption.
+ */
+static void bng_re_mpc_adv_tx_cons(struct bng_re_mpc_roce_creq_info *creq)
+{
+	u32 tx_cons, slot, tx_prod, diff;
+	unsigned int iter = 0;
+
+	if (unlikely(!creq || !creq->tx_sw_ring)) {
+		WARN_ONCE(1, "%s: null creq or tx_sw_ring\n", __func__);
+		return;
+	}
+
+	tx_cons = creq->tx_cons;
+	tx_prod = READ_ONCE(creq->tx_prod);
+	/* Use unsigned subtraction (modular u32) so the check remains correct
+	 * after tx_prod wraps past 0xFFFFFFFF.  A raw tx_cons > tx_prod
+	 * comparison is unsafe at rollover: e.g. tx_prod=2, tx_cons=0xFFFFFFFE
+	 * is a valid 4-entry-in-flight state but would incorrectly satisfy
+	 * tx_cons > tx_prod.
+	 */
+	if (unlikely((tx_prod - tx_cons) > (creq->tx_ring_mask + 1))) {
+		WARN_ONCE(1,
+			  "%s: tx_cons (%u) > tx_prod (%u): consumer ahead of producer (double-consume, bad chain, or prod reset?)\n",
+			  __func__, tx_cons, tx_prod);
+		return;
+	}
+
+	diff = tx_prod - tx_cons;
+	if (diff <= creq->tx_ring_mask && (diff & creq->tx_ring_mask) == 0)
+		return;
+
+	slot = tx_cons & creq->tx_ring_mask;
+	do {
+		tx_prod = READ_ONCE(creq->tx_prod);
+		diff = tx_prod - tx_cons;
+		if (diff <= creq->tx_ring_mask && (diff & creq->tx_ring_mask) == 0)
+			break;
+		{
+			u32 bds = creq->tx_sw_ring[slot].inline_bds;
+			u32 next = tx_cons + bds;
+
+			/* Use unsigned distance (modular u32) so the bound check
+			 * stays correct after either counter wraps past 0xFFFFFFFF.
+			 * A raw next > tx_prod comparison gives wrong results when
+			 * next has wrapped and tx_prod has not, or vice versa.
+			 */
+			if (unlikely((tx_prod - next) > (creq->tx_ring_mask + 1))) {
+				WARN_ONCE(1,
+					  "%s: would advance tx_cons %u -> %u past tx_prod %u (bds=%u cons_slot=%u)\n",
+					  __func__, tx_cons, next, tx_prod, bds, slot);
+				return;
+			}
+			tx_cons = next;
+		}
+		creq->tx_cons = tx_cons;
+		iter++;
+		/*
+		 * Re-read producer after advancing: we may have just caught up
+		 * (tx_cons == tx_prod) while the physical slot still shows INV for
+		 * the next logical post — must exit before the while re-enters.
+		 */
+		tx_prod = READ_ONCE(creq->tx_prod);
+		diff = tx_prod - tx_cons;
+		if (diff <= creq->tx_ring_mask && (diff & creq->tx_ring_mask) == 0)
+			break;
+		if (iter >= MAX_ADV_ITERATIONS)
+			break;
+		slot = tx_cons & creq->tx_ring_mask;
+	} while (creq->tx_sw_ring[slot].last_cons == BNG_RE_MPC_INV_HDL);
+
+	if (iter >= MAX_ADV_ITERATIONS) {
+		tx_prod = READ_ONCE(creq->tx_prod);
+		diff = tx_prod - tx_cons;
+		if (diff > creq->tx_ring_mask || (diff & creq->tx_ring_mask) != 0) {
+			u32 prod_slot = tx_prod & creq->tx_ring_mask;
+
+			slot = tx_cons & creq->tx_ring_mask;
+			pr_err("bng_re: %s: exceeded max iterations (%u) tx_cons=%u tx_prod=%u d=%u cons_slot=%u prod_slot=%u last_cons=0x%lx\n",
+			       __func__, iter, tx_cons, tx_prod, diff, slot, prod_slot,
+			       creq->tx_sw_ring[slot].last_cons);
+		}
+	}
+}
+
+/**
+ * bng_re_mpc_roce_alloc_hwq - Allocate MPC TX and CQ hardware queues
+ * @rdev: RoCE device
+ *
+ * Ensures CQ page layout fits whole LONG completions, then allocates TX and CQ
+ * HWQs via the qpxxx. Sets ring masks and CQ copy-bit metadata.
+ *
+ * Return: 0 on success, %-ENOMEM on allocation failure (partial cleanup on CQ fail).
+ */
+static int bng_re_mpc_roce_alloc_hwq(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	struct bng_re_res *res = &rdev->bng_res;
+	struct bng_re_hwq_attr hwq_attr = {};
+	struct bng_re_sg_info sginfo = {};
+
+	dev_dbg(rdev_to_dev(rdev), "%s: %p\n", __func__, rdev);
+
+	/*
+	 * Each CQ page must hold a whole number of 32-byte LONG completions
+	 * (sizeof(mpc_qp_modify_cmpl) == 32 == 2 x BNG_RE_MPC_CQ_STRIDE).
+	 * This guarantees that a LONG completion never straddles a page
+	 * boundary, making non-contiguous scatter-gather handling unnecessary.
+	 */
+	BUILD_BUG_ON(PAGE_SIZE % sizeof(struct mpc_qp_modify_cmpl));
+
+	sginfo.pgsize = PAGE_SIZE;
+	sginfo.pgshft = PAGE_SHIFT;
+	hwq_attr.res = res;
+	hwq_attr.sginfo = &sginfo;
+	hwq_attr.type = BNG_HWQ_TYPE_QUEUE;
+
+	/* TX ring */
+	hwq_attr.depth = BNG_RE_MPC_TX_RING_SIZE;
+	hwq_attr.stride = BNG_RE_MPC_TX_STRIDE;
+	if (bng_re_alloc_init_hwq(&creq->tx_hwq, &hwq_attr)) {
+		dev_err(rdev_to_dev(rdev), "%s: TX HWQ alloc failed\n", __func__);
+		return -ENOMEM;
+	}
+	creq->tx_ring_mask = creq->tx_hwq.max_elements - 1;
+
+	memset(&sginfo, 0, sizeof(sginfo));
+	sginfo.pgsize = PAGE_SIZE;
+	sginfo.pgshft = PAGE_SHIFT;
+	/* CQ ring */
+	hwq_attr.depth = BNG_RE_MPC_CQ_RING_SIZE;
+	hwq_attr.stride = BNG_RE_MPC_CQ_STRIDE;
+	hwq_attr.type = BNG_HWQ_TYPE_QUEUE;
+	if (bng_re_alloc_init_hwq(&creq->cq_hwq, &hwq_attr)) {
+		dev_err(rdev_to_dev(rdev), "%s: CQ HWQ alloc failed\n", __func__);
+		bng_re_free_hwq(res, &creq->tx_hwq);
+		return -ENOMEM;
+	}
+
+	creq->cq_ring_mask = creq->cq_hwq.max_elements - 1;
+	creq->cq_cp_bit = creq->cq_hwq.max_elements;
+
+	return 0;
+}
+
+/**
+ * bng_re_mpc_roce_alloc_init - Initialize RoCE MPC channel software state and HWQs
+ * @rdev: RoCE device
+ *
+ * Allocates poll/diag/tune structures, stats, TX/CQ HWQs, software TX ring,
+ * command context kmem cache, firmware rings, and MPC doorbells. Initializes
+ * spinlocks and DB info for L2 doorbell posting.
+ *
+ * Return: 0 on success, negative errno on failure (all partial allocations rolled back).
+ */
+int bng_re_mpc_roce_alloc_init(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	struct bnge_auxr_dev *auxr_dev = rdev->aux_dev;
+	struct bng_re_res *res = &rdev->bng_res;
+	int rc;
+
+	res = &rdev->bng_res;
+
+	dev_dbg(rdev_to_dev(rdev), "%s: %p\n", __func__, rdev);
+
+	creq->tx_ring_id = INVALID_HW_RING_ID_32BIT;
+	creq->cq_ring_id = INVALID_HW_RING_ID;
+
+	spin_lock_init(&creq->tx_lock);
+	spin_lock_init(&creq->mpc_ctx_lock);
+	spin_lock_init(&creq->bm_lock);
+
+	creq->bm_poll_info = kzalloc_obj(*creq->bm_poll_info, GFP_KERNEL);
+	if (!creq->bm_poll_info)
+		return -ENOMEM;
+
+	creq->bm_poll_info->bm_current_cons_indx = -1;
+
+	creq->bm_diag_counters = kzalloc_obj(*creq->bm_diag_counters, GFP_KERNEL);
+	if (!creq->bm_diag_counters) {
+		rc = -ENOMEM;
+		goto err_free_poll;
+	}
+
+	creq->mpc_tune_params = kzalloc_obj(*creq->mpc_tune_params, GFP_KERNEL);
+	if (!creq->mpc_tune_params) {
+		rc = -ENOMEM;
+		goto err_free_diag;
+	}
+	creq->mpc_tune_params->short_timeout = BNG_RE_MPC_ROCE_TMO_MSECS_SHORT;
+	creq->mpc_tune_params->long_timeout = BNG_RE_MPC_ROCE_TMO_MSECS_LONG;
+	creq->mpc_tune_params->max_retries = BNG_RE_MPC_ROCE_MAX_RETRIES;
+	creq->mpc_tune_params->retry_sleep = BNG_RE_MPC_ROCE_RETRY_SLEEP;
+
+	rc = bng_re_mpc_roce_alloc_stats(rdev);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "%s: stats_info alloc failed\n", __func__);
+		rc = -ENOMEM;
+		goto err_free_tune;
+	}
+
+	rc = bng_re_mpc_roce_alloc_hwq(rdev);
+	if (rc)
+		goto err_free_stats;
+
+	creq->tx_sw_ring = kcalloc(creq->tx_ring_mask + 1,
+				   sizeof(*creq->tx_sw_ring), GFP_KERNEL);
+	if (!creq->tx_sw_ring) {
+		rc = -ENOMEM;
+		goto err_free_hwq;
+	}
+
+	creq->mpc_cache = kmem_cache_create("bng_re_roce_mpc",
+					    sizeof(struct bng_re_roce_cmd_ctx), 0,
+					    SLAB_HWCACHE_ALIGN, NULL);
+	if (!creq->mpc_cache) {
+		dev_err(rdev_to_dev(rdev), "%s: mpc_cache create failed\n", __func__);
+		rc = -ENOMEM;
+		goto err_free_sw_ring;
+	}
+
+	atomic_set(&creq->pending, 0);
+	atomic_set(&creq->max_pending, 0);
+	creq->avail_buffer = ~0U;
+	creq->min_avail_buffer = ~0U;
+	creq->bm_mpc_stall = false;
+
+	rc = bng_re_mpc_rings_alloc(rdev);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "%s: mpc_rings_alloc failed rc=%d\n",
+			__func__, rc);
+		goto err_free_cache;
+	}
+
+	if (!auxr_dev || !auxr_dev->bar1) {
+		dev_err(rdev_to_dev(rdev), "%s: mpc_rings_alloc failed: bad auxr_dev info: auxr_dev=%p, bar1=%p\n",
+			__func__, auxr_dev, auxr_dev ? auxr_dev->bar1 : 0);
+		goto err_free_cache;
+	}
+
+	creq->tx_db_info.db = auxr_dev->bar1 + auxr_dev->l2_db_offset;
+
+	creq->tx_db_info.hwq = &creq->tx_hwq;
+	creq->tx_db_info.xid = creq->tx_ring_id;
+	creq->tx_db_info.seed = creq->tx_ring_id;
+	creq->tx_db_info.flags = 0;
+	spin_lock_init(&creq->tx_db_info.lock);
+	creq->tx_db_info.max_slot = 1;
+	creq->tx_db_info.res = res;
+	creq->tx_db_info.is_l2 = true;
+	creq->cq_db_info.toggle = 0;
+
+	creq->cq_db_info.db = auxr_dev->bar1 + auxr_dev->l2_db_offset;
+	creq->cq_db_info.hwq = &creq->cq_hwq;
+	creq->cq_db_info.xid = creq->cq_ring_id;
+	creq->cq_db_info.seed = creq->cq_ring_id;
+	creq->cq_db_info.flags = 0;
+	spin_lock_init(&creq->cq_db_info.lock);
+	creq->cq_db_info.max_slot = 1;
+	creq->cq_db_info.res = res;
+	/*
+	 * The MPC CQ is an L2 completion ring (RING_ALLOC_REQ_RING_TYPE_L2_CMPL),
+	 * so its arm doorbell must carry DBC_DBC64_PATH_L2. Without is_l2 the
+	 * CQ_ARMALL below goes out on the RoCE path, the CQ is never armed, and
+	 * firmware never raises an MPC NQ notification -> IRQ never fires and
+	 * MPC commands time out (-110). Matches thor3.
+	 */
+	creq->cq_db_info.is_l2 = true;
+
+	creq->tx_prod = 0;
+	creq->tx_cons = 0;
+	creq->tx_napi_idx = 0;
+
+	rc = bng_re_alloc_mpc_doorbells(rdev);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev),
+			"[%s:%lx:%d] Error allocating mpc dbs (err : %d)\n",
+			__func__, (unsigned long)current, __LINE__, rc);
+		goto err_free_cache;
+	}
+
+	set_bit(BNG_RE_FLAG_MPC_DB_PAGE_EN, &rdev->flags);
+	bng_re_ring_db(&creq->cq_db_info, DBC_DBC_TYPE_CQ_ARMALL);
+
+	return 0;
+
+err_free_cache:
+	bng_re_mpc_rings_free(rdev);
+	kmem_cache_destroy(creq->mpc_cache);
+	creq->mpc_cache = NULL;
+	kfree(creq->bm_stats_info);
+	creq->bm_stats_info = NULL;
+err_free_sw_ring:
+	kfree(creq->tx_sw_ring);
+	creq->tx_sw_ring = NULL;
+err_free_hwq:
+	bng_re_free_hwq(res, &creq->cq_hwq);
+	bng_re_free_hwq(res, &creq->tx_hwq);
+err_free_stats:
+	bng_re_mpc_roce_free_stats(rdev);
+err_free_tune:
+	kfree(creq->mpc_tune_params);
+	creq->mpc_tune_params = NULL;
+err_free_diag:
+	kfree(creq->bm_diag_counters);
+	creq->bm_diag_counters = NULL;
+err_free_poll:
+	kfree(creq->bm_poll_info);
+	creq->bm_poll_info = NULL;
+
+	return rc;
+}
+
+/**
+ * bng_re_mpc_roce_deinit_free - Tear down RoCE MPC channel and free resources
+ * @rdev: RoCE device
+ *
+ * Frees firmware rings, HWQs, TX software ring, kmem cache, stats, and auxiliary
+ * allocations created by bng_re_mpc_roce_alloc_init().
+ */
+void bng_re_mpc_roce_deinit_free(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	struct bng_re_res *res = &rdev->bng_res;
+
+	dev_dbg(rdev_to_dev(rdev), "%s: %p\n", __func__, rdev);
+
+	bng_re_mpc_rings_free(rdev);
+	bng_re_free_hwq(res, &creq->cq_hwq);
+	bng_re_free_hwq(res, &creq->tx_hwq);
+	kfree(creq->tx_sw_ring);
+	creq->tx_sw_ring = NULL;
+
+	kmem_cache_destroy(creq->mpc_cache);
+	creq->mpc_cache = NULL;
+
+	bng_re_mpc_roce_free_stats(rdev);
+	kfree(creq->mpc_tune_params);
+	kfree(creq->bm_diag_counters);
+	kfree(creq->bm_poll_info);
+	creq->mpc_tune_params = NULL;
+	creq->bm_diag_counters = NULL;
+	creq->bm_poll_info = NULL;
+}
+
+/**
+ * bng_re_mpc_roce_send - Post one MPC command to the TX ring and ring the doorbell
+ * @rdev: RoCE device
+ * @cmd: MPC command payload
+ * @cmd_len: Length of @cmd in bytes
+ * @handle: Opaque handle stored in the TX software ring (e.g. command context pointer)
+ * @mctx: Optional out; set to the address of the stored handle slot for error cleanup
+ *
+ * Splits the command across header and data BDs, updates HWQ producer with
+ * bng_hwq_incr_prod(), writes a memory barrier, and rings the producer DB.
+ *
+ * Return: 0 on success, %-EBUSY if the ring lacks space, %-EIO on queue indexing failure.
+ */
+static int bng_re_mpc_roce_send(struct bng_re_dev *rdev, void *cmd, uint cmd_len,
+				unsigned long handle, void **mctx)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	struct bng_re_hwq *tx_hwq = &creq->tx_hwq;
+	u32 bds, total_bds, free_slots, prod;
+	unsigned long flags;
+	struct tx_bd *txbd;
+
+	dev_dbg(rdev_to_dev(rdev), "[%s:%lx:%d] enter\n",
+		__func__, (unsigned long)current, __LINE__);
+
+	bds = DIV_ROUND_UP(cmd_len, BNG_RE_MPC_TX_STRIDE);
+	total_bds = bds + 1;	/* header BD + data BDs */
+
+	spin_lock_irqsave(&creq->tx_lock, flags);
+	free_slots = bng_re_mpc_tx_avail(creq);
+	if (free_slots < total_bds) {
+		spin_unlock_irqrestore(&creq->tx_lock, flags);
+		dev_dbg(rdev_to_dev(rdev), "%s: no space, need %u have %u\n",
+			__func__, total_bds, free_slots);
+		return -EBUSY;
+	}
+
+	prod = creq->tx_prod;
+
+	txbd = bng_re_get_qe(tx_hwq, prod & creq->tx_ring_mask, NULL);
+
+	dev_dbg(rdev_to_dev(rdev), "[1]%s, page:%d, index:%d, prod:%d,len:%d,bds:%d,total_bds:%d\n",
+		__func__,
+		0,
+		0,
+		prod,
+		cmd_len,
+		bds,
+		total_bds
+	);
+	if (!txbd) {
+		spin_unlock_irqrestore(&creq->tx_lock, flags);
+		dev_err(rdev_to_dev(rdev), "%s: get_qe failed at prod %u\n",
+			__func__, prod);
+		return -EIO;
+	}
+
+	creq->tx_sw_ring[prod & creq->tx_ring_mask].handle = handle;
+	creq->tx_sw_ring[prod & creq->tx_ring_mask].inline_bds = total_bds;
+	creq->tx_sw_ring[prod & creq->tx_ring_mask].last_cons = 0;  /* pending */
+	if (mctx)
+		*(unsigned long **)mctx = &creq->tx_sw_ring[prod & creq->tx_ring_mask].handle;
+
+	txbd->tx_bd_len_flags_type =
+		cpu_to_le32((cmd_len << TX_BD_LEN_SHIFT) | TX_BD_TYPE_MPC_TX_BD |
+			    (total_bds << TX_BD_FLAGS_BD_CNT_SHIFT));
+	txbd->tx_bd_opaque = BNG_RE_MPC_SET_TX_OPAQUE(creq->tx_napi_idx, prod,
+						      total_bds, creq->tx_ring_mask);
+	prod = ++creq->tx_prod;
+
+	/* Copy payload into following BD slots */
+	while (bds > 0) {
+		u32 chunk = min_t(u32, cmd_len, (uint)BNG_RE_MPC_TX_STRIDE);
+
+		txbd = bng_re_get_qe(tx_hwq, prod & creq->tx_ring_mask, NULL);
+		if (!txbd) {
+			spin_unlock_irqrestore(&creq->tx_lock, flags);
+			dev_err(rdev_to_dev(rdev), "%s: get_qe data failed\n", __func__);
+			return -EIO;
+		}
+		memcpy(txbd, cmd, chunk);
+		cmd += chunk;
+		cmd_len -= chunk;
+		prod = ++creq->tx_prod;
+		bds--;
+	}
+
+	/*
+	 * Advance hwq->prod by the total number of BDs posted.
+	 * bng_re_hwq_incr_prod keeps hwq->prod within [0, hwq->depth) and
+	 * toggles the epoch bit in tx_db_info.flags on wrap-around.  Both are
+	 * required for bng_re_ring_prod_db to write a correct doorbell.
+	 */
+	bng_hwq_incr_prod(&creq->tx_db_info, tx_hwq, total_bds);
+
+	dev_dbg(rdev_to_dev(rdev),
+		"[2]%s, page:%d, index:%d, prod:%d,len:%d,bds:%d,total_bds:%d\n",
+		__func__,
+		0,
+		0,
+		prod,
+		cmd_len,
+		bds,
+		total_bds
+	);
+	/* make sure memory is updated */
+	wmb();
+
+	bng_ring_prod_db(&creq->tx_db_info, DBC_DBC_TYPE_SQ);
+
+	dev_info(rdev_to_dev(rdev),
+		 "mpc db: db=%p xid=0x%x prod=%u max_slot=%u flags=0x%x is_l2=%d total_bds=%d\n",
+		 creq->tx_db_info.db, creq->tx_db_info.xid, tx_hwq->prod,
+		 creq->tx_db_info.max_slot, creq->tx_db_info.flags,
+		 creq->tx_db_info.is_l2, total_bds);
+
+	spin_unlock_irqrestore(&creq->tx_lock, flags);
+
+	return 0;
+}
+
+/**
+ * bng_re_mpc_dispatch_event_cmpl - Handle unsolicited MPC LONG completions (no TX ctx)
+ * @rdev: RoCE device
+ * @entry: Completion entry (32-byte LONG payload)
+ *
+ * For EVENT/RESP_CMPL, forwards to bng_re_mpc_handle_event_cmpl(). Other
+ * unsolicited types are logged. Mirrors the null-handle path in bnge MPC completion
+ * processing.
+ */
+static void bng_re_mpc_dispatch_event_cmpl(struct bng_re_dev *rdev,
+					   struct bng_re_cmpl_entry *entry)
+{
+	struct mpc_cmpl_hdr *hdr = (struct mpc_cmpl_hdr *)entry->cmpl;
+
+	if (hdr->req_type == MPC_CMD_HDR_REQ_TYPE_EVENT &&
+	    hdr->req_subtype == MPC_CMD_HDR_REQ_SUB_TYPE_EVENT_RESP_CMPL)
+		bng_re_mpc_handle_event_cmpl(rdev, entry->cmpl, entry->len);
+	else
+		dev_warn(rdev_to_dev(rdev),
+			 "%s: null handle, unsolicited mpc cmpl type:%u subtype:%u\n",
+			 __func__, hdr->req_type, hdr->req_subtype);
+}
+
+/**
+ * bng_re_mpc_roce_service_creq - Poll the MPC completion ring
+ * @rdev: RoCE device
+ * @budget: Maximum LONG completions to process this call
+ *
+ * Validates CQ epoch and LONG completion layout (two contiguous slots), handles
+ * PF/VF forward completions, unsolicited events, and solicited completions
+ * (opaque TX index, out-of-order-safe tx_cons advance, then bng_re_roce_mpc_cmp()).
+ *
+ * Return: 1 if the budget was fully consumed (more completions may remain), else 0.
+ */
+int bng_re_mpc_roce_service_creq(struct bng_re_dev *rdev, int budget)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	struct bng_re_hwq *cq_hwq = &creq->cq_hwq;
+	struct bng_re_cmpl_entry cmpl_entry;
+	struct mpc_cmpl_hdr *hdr = NULL;
+	static u64 last_poll_jiffies;
+	unsigned long handle = 0;
+	struct mpc_cmp *mpcmp2;
+	bool mpc_unsol = false;
+	struct mpc_cmp *mpcmp;
+	struct tx_cmp *txcmp;
+	unsigned long flags;
+	u32 iterations = 0;
+	u8 inline_bds = 0;
+	u32 cons_next;
+	u32 cmp_type;
+	u32 opaque;
+	u32 cons;
+	u16 idx;
+
+	last_poll_jiffies = get_jiffies_64();
+
+	spin_lock_irqsave(&creq->bm_lock, flags);
+
+	cons = cq_hwq->cons;
+
+	while (iterations < budget) {
+		/*
+		 * Valid polarity alternates each CQ lap (HW toggles when posting
+		 * at index 0 again).  bng_re_hwq_incr_cons() XORs the same
+		 * phase into cq_db_info.flags when cons wraps — not (cons & cp_bit)
+		 * with cp_bit == max_elements and wrapped cons (always 0..max-1).
+		 */
+		u32 cq_epoch = creq->cq_db_info.flags &
+			       BNG_QP_FLAG_EPOCH_CONS_MASK;
+
+		dma_rmb();
+		txcmp = bng_re_get_qe(cq_hwq, cons, NULL);
+		if (!txcmp) {
+			dev_err(rdev_to_dev(rdev), "%s: get_qe failed cons %u\n",
+				__func__, cons);
+			break;
+		}
+		if (!(!!(txcmp->tx_cmp_errors_v & cpu_to_le32(TX_CMP_V)) ==
+		      !cq_epoch))
+			break;
+
+		dma_rmb();
+		cmp_type = le32_to_cpu(((struct mpc_cmp *)txcmp)->mpc_cmp_client_subtype_type) &
+			   MPC_CMP_TYPE;
+		if (cmp_type != MPC_CMP_TYPE_MID_PATH_LONG) {
+			dev_err(rdev_to_dev(rdev), "%s: unexpected cmp type 0x%x\n",
+				__func__, cmp_type);
+			bng_re_hwq_incr_cons(cq_hwq->max_elements, &cons,
+					     1, &creq->cq_db_info.flags);
+			iterations++;
+			continue;
+		}
+
+		mpcmp = (struct mpc_cmp *)txcmp;
+		/*
+		 * Fetch and validate the second 16-byte slot of the
+		 * LONG completion before reading any data from it.
+		 * HW may write the two slots non-atomically; returning
+		 * without advancing cons lets the caller retry.
+		 */
+		cons_next = cons + 1;
+		if (cons_next >= cq_hwq->max_elements)
+			cons_next = 0;
+
+		mpcmp2 = bng_re_get_qe(cq_hwq, cons_next, NULL);
+		if (!mpcmp2) {
+			dev_err(rdev_to_dev(rdev),
+				"%s: get_qe slot2 failed at cons %u\n",
+				__func__, cons_next);
+			break;
+		}
+
+		/* Same HW write as slot 1 — same V polarity / consumer epoch */
+		if (!(!!(mpcmp2->mpc_cmp_v & cpu_to_le32(MPC_CMP_V)) ==
+		      !cq_epoch)) {
+			dev_dbg(rdev_to_dev(rdev),
+				"%s: slot2 not valid yet at cons %u\n",
+				__func__, cons_next);
+			break;
+		}
+
+		/* Ensure slot2 valid bit is read before its payload */
+		dma_rmb();
+
+		/*
+		 * Safety check: the two slots must be contiguous in
+		 * virtual memory (same page).  PAGE_SIZE is guaranteed
+		 * to be a multiple of sizeof(mpc_qp_modify_cmpl) by the
+		 * BUILD_BUG_ON in bng_re_mpc_roce_alloc_hwq, so this
+		 * path should never be reached in practice.
+		 */
+		if (unlikely((char *)mpcmp2 !=
+			     (char *)mpcmp + BNG_RE_MPC_CQ_STRIDE)) {
+			dev_err(rdev_to_dev(rdev),
+				"%s: LONG cmpl sl non-contig [%lx,%lx] cons %u/%u - skip\n",
+				__func__,
+				(unsigned long)mpcmp,
+				(unsigned long)mpcmp2,
+				cons,
+				cons_next);
+			bng_re_hwq_incr_cons(cq_hwq->max_elements,
+					     &cons, 2,
+					     &creq->cq_db_info.flags);
+			cq_hwq->cons = cons;
+			iterations++;
+			continue;
+		}
+
+		/*
+		 * IRQs are already disabled by the outer
+		 * bm_lock irqsave; use a plain spin_lock here
+		 * so we do not overwrite 'flags' and corrupt
+		 * the IRQ state restored when bm_lock is
+		 * released.
+		 */
+		hdr = (struct mpc_cmpl_hdr *)mpcmp;
+		mpc_unsol =
+			(hdr->req_type == MPC_CMD_HDR_REQ_TYPE_EVENT &&
+			 hdr->req_subtype ==
+			 MPC_CMD_HDR_REQ_SUB_TYPE_EVENT_RESP_CMPL);
+
+		cmpl_entry.cmpl = mpcmp;
+		cmpl_entry.len = sizeof(*mpcmp) * 2;
+
+		if (mpc_unsol) {
+			/*
+			 * Unsolicited EVENT from firmware: no TX ring
+			 * slot was consumed, so tx_cons must not change.
+			 */
+			bng_re_mpc_dispatch_event_cmpl(rdev, &cmpl_entry);
+		} else {
+			opaque = mpcmp->mpc_cmp_opaque;
+			idx = BNG_RE_MPC_TX_OPAQUE_IDX(opaque);
+			/*
+			 * Solicited completion.  Mark the slot done and
+			 * advance tx_cons using the out-of-order-safe
+			 * mechanism (mirrors bnge_adv_mpc_cons_re):
+			 *
+			 * - Only advance from the current consumer position.
+			 *   If this completion arrived out of order (i.e.
+			 *   the slot is not the oldest outstanding entry),
+			 *   mark last_cons and leave tx_cons unchanged; the
+			 *   consumer will be swept forward when the older
+			 *   entry's completion arrives.
+			 * - inline_bds is NOT cleared here so the advance
+			 *   function can use it to step past the slot.
+			 */
+			spin_lock(&creq->mpc_ctx_lock);
+			if (idx <= creq->tx_ring_mask) {
+				inline_bds = creq->tx_sw_ring[idx].inline_bds;
+				handle = creq->tx_sw_ring[idx].handle;
+				if (handle) {
+					/*
+					 * Acquire a reference on the ctx while
+					 * still under the lock so that
+					 * bng_re_roce_mpc_xmit cannot free it
+					 * between here and the cmp call below.
+					 * Zero the slot so a concurrent or
+					 * future xmit error-path clear sees an
+					 * already-consumed handle.
+					 */
+					refcount_inc(&((struct bng_re_roce_cmd_ctx *)
+						       handle)->refcnt);
+					creq->tx_sw_ring[idx].handle = 0;
+				}
+				creq->tx_sw_ring[idx].last_cons =
+					BNG_RE_MPC_INV_HDL;
+			}
+			if ((creq->tx_cons & creq->tx_ring_mask) == idx)
+				bng_re_mpc_adv_tx_cons(creq);
+			spin_unlock(&creq->mpc_ctx_lock);
+
+			if (!handle) {
+				dev_warn(rdev_to_dev(rdev),
+					 "%s: null ctx at idx %u, opaque: %x %s 0x%x.%x\n",
+					 __func__, idx, opaque,
+					 "skip processing MPC completion, req_type",
+					 hdr->req_type,
+					 hdr->req_subtype);
+			} else {
+				struct bng_re_roce_cmd_ctx *cmp_ctx =
+					(struct bng_re_roce_cmd_ctx *)handle;
+
+				bng_re_roce_mpc_cmp(rdev, handle, &cmpl_entry);
+				if (refcount_dec_and_test(&cmp_ctx->refcnt))
+					kmem_cache_free(creq->mpc_cache, cmp_ctx);
+			}
+		}
+
+		/* LONG completion always occupies two ring slots */
+		bng_re_hwq_incr_cons(cq_hwq->max_elements, &cons,
+				     2, &creq->cq_db_info.flags);
+		cq_hwq->cons = cons;
+		iterations++;
+	}
+
+	creq->cq_hwq.cons = cons;
+	spin_unlock_irqrestore(&creq->bm_lock, flags);
+
+	return (iterations >= budget) ? 1 : 0;
+}
+
+int bng_re_mpc_roce_service_cne(struct bng_re_dev *rdev, void *nq_cmp, int budget)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	u64 dbr_type = DBC_DBC_TYPE_CQ_ARMALL;
+	struct nq_cn *nqcne = nq_cmp;
+	int has_more_work = 0;
+	u16 type;
+
+	if (nqcne) {
+		type = le16_to_cpu(nqcne->type);
+		if ((type & NQ_CN_TYPE_MASK) == NQ_CN_TYPE_CQ_NOTIFICATION)
+			creq->cq_db_info.toggle = ((type) & NQ_CN_TOGGLE_MASK) >> NQ_CN_TOGGLE_SFT;
+	}
+
+	has_more_work = bng_re_mpc_roce_service_creq(rdev, budget);
+
+	if (has_more_work)
+		dbr_type = DBC_DBC_TYPE_CQ;
+
+	bng_re_ring_db(&creq->cq_db_info, dbr_type);
+
+	return has_more_work;
+}
+
+/**
+ * bng_re_roce_mpc_xmit - Send an MPC command and wait for or poll its completion
+ * @rdev: RoCE device
+ * @cmd: MPC command buffer
+ * @cmd_len: Length of @cmd
+ * @cmpl: Caller buffer for completion payload (copied from internal context)
+ * @cmpl_len: Max bytes to copy into @cmpl
+ * @poll_cmp: If true, busy-poll completion; else use completion / timed wait
+ *
+ * Allocates a per-command context, posts via bng_re_mpc_roce_send() with EBUSY
+ * retries, services the CQ as needed, updates diagnostics and optional stall
+ * detection, and records performance stats.
+ *
+ * Return: 0 on success, negative errno on validation, stall, timeout, or I/O errors.
+ */
+int bng_re_roce_mpc_xmit(struct bng_re_dev *rdev, void *cmd, uint cmd_len,
+			 void *cmpl, uint cmpl_len, bool poll_cmp)
+{
+	struct bng_re_mpc_roce_creq_info *creq;
+	unsigned long tx_start_time = jiffies;
+	struct bng_re_mpc_diag_counters *dc;
+	struct bng_re_roce_cmd_ctx *ctx;
+	unsigned long poll_end_time = 0;
+	unsigned long tx_end_time = 0;
+	unsigned int max_pending = 0;
+	unsigned long max_timeout;
+	unsigned long retries = 0;
+	bool sent_started = false;
+	unsigned long tmo_left;
+	unsigned long deadline;
+	unsigned long timeout;
+	unsigned long flags;
+	u16 retry_sleep_ms;
+	void *pctx = NULL;
+	int cnt;
+	int rc;
+
+	dev_dbg(rdev_to_dev(rdev), "%s: enter, poll_cmp:%d\n", __func__, poll_cmp);
+
+	creq = &rdev->mpc_roce_creq;
+	dc = creq->bm_diag_counters;
+
+	if (!cmd || !cmpl) {
+		dev_err(rdev_to_dev(rdev), "%s: NULL cmd or cmpl\n", __func__);
+		return -EINVAL;
+	}
+	if (!creq->mpc_tune_params || !dc || !creq->mpc_cache) {
+		dev_err(rdev_to_dev(rdev), "%s: MPC channel not initialized\n", __func__);
+		return -EINVAL;
+	}
+
+	max_timeout = creq->mpc_tune_params->short_timeout;
+	retry_sleep_ms = creq->mpc_tune_params->retry_sleep;
+
+	atomic_inc(&creq->pending);
+	atomic_inc(&dc->bm_mpc_verb_try);
+
+	if (creq->bm_mpc_stall || test_bit(BNG_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags) ||
+	    creq->bm_mpc_uninstall_pending) {
+		rc = -EHOSTUNREACH;
+		atomic_inc(&dc->bm_mpc_stalled_err);
+		dev_warn(rdev_to_dev(rdev), "%s QUIT(1) as %s:%d or %s:%d or %s:%d",
+			 __func__,
+			 "mpc stall detected",
+			 creq->bm_mpc_stall,
+			 "HW FATAL Cond(stall)",
+			 test_bit(BNG_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags),
+			 "driver uninit in progress",
+		creq->bm_mpc_uninstall_pending);
+		goto exit;
+	}
+	/* make sure memory is updated */
+	smp_mb__after_atomic();
+
+	ctx = kmem_cache_zalloc(creq->mpc_cache, GFP_ATOMIC);
+
+	if (!ctx) {
+		rc = -ENOMEM;
+		dev_err(rdev_to_dev(rdev), "%s: ctx alloc failed\n", __func__);
+		goto exit;
+	}
+	refcount_set(&ctx->refcnt, 1);
+	ctx->poll_cmp = poll_cmp;
+	if (!poll_cmp) {
+		init_completion(&ctx->cmp);
+		might_sleep();
+		retries = creq->mpc_tune_params->max_retries;
+		max_timeout = creq->mpc_tune_params->long_timeout;
+	}
+
+	do {
+		atomic_inc(&dc->bm_mpc_sent_try);
+		rc = bng_re_mpc_roce_send(rdev, cmd, cmd_len, (unsigned long)ctx, &pctx);
+		if (rc == -EBUSY) {
+			atomic_inc(&dc->bm_mpc_sent_started_ebusy);
+		} else if (!rc) {
+			atomic_inc(&dc->bm_mpc_sent_started_ok);
+			sent_started = true;
+		} else {
+			atomic_inc(&dc->bm_mpc_sent_started_misc_err);
+		}
+
+		if (rc != -EBUSY) {
+			dev_dbg(rdev_to_dev(rdev), "[%s,%lx]: msg %x.%x BREAK: sleep retry remaining: %ld. outst msgs:%d,rc:%d",
+				__func__,
+				(unsigned long)current,
+				((u8 *)cmd)[0],
+				((u8 *)cmd)[1],
+				retries,
+				atomic_read(&creq->pending),
+				rc);
+			break;
+		}
+		/* -EBUSY: one try per (initial + max_retries); last EBUSY exits here */
+		if (!retries) {
+			dev_dbg(rdev_to_dev(rdev), "[%s,%lx]: msg %x.%x BREAK: no retries left. outst msgs:%d,rc:%d",
+				__func__,
+				(unsigned long)current,
+				((u8 *)cmd)[0],
+				((u8 *)cmd)[1],
+				atomic_read(&creq->pending),
+				rc);
+			break;
+		}
+		dev_warn(rdev_to_dev(rdev), "[%s,%lx]: msg %x.%x sleep retry remaining: %ld. outstanding msgs:%d",
+			 __func__,
+			 (unsigned long)current,
+			 ((u8 *)cmd)[0],
+			 ((u8 *)cmd)[1],
+			 retries,
+			 atomic_read(&creq->pending));
+		msleep(retry_sleep_ms);
+		retries--;
+		if (creq->bm_mpc_stall || test_bit(BNG_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags) ||
+		    creq->bm_mpc_uninstall_pending
+		) {
+			rc = -EHOSTUNREACH;
+			atomic_inc(&dc->bm_mpc_stalled_err);
+			dev_warn(rdev_to_dev(rdev), "%s QUIT(2) as %s:%d or %s:%d or %s:%d",
+				 __func__,
+				 "mpc stall detected",
+				 creq->bm_mpc_stall,
+				 "HW FATAL Cond(stall)",
+				 test_bit(BNG_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags),
+				 "driver uninit in progress",
+		creq->bm_mpc_uninstall_pending);
+			break;
+		}
+	} while (true);
+
+	tx_end_time = jiffies;
+
+	if (rc)
+		goto xmit_done;
+
+	if (poll_cmp) {
+		deadline = jiffies + msecs_to_jiffies(max_timeout);
+		do {
+			bool avail = READ_ONCE(ctx->cmpl_available);
+			/* make sure completion is available */
+			smp_rmb();
+			/* check for completion availability */
+			if (avail)
+				break;
+
+			udelay(9);
+			bng_re_mpc_roce_service_creq(rdev, 32);
+			if (time_after_eq(jiffies, deadline)) {
+				rc = -ETIMEDOUT;
+				goto xmit_done;
+			}
+			if (creq->bm_mpc_stall ||
+			    test_bit(BNG_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags) ||
+			    creq->bm_mpc_uninstall_pending
+			) {
+				rc = -EHOSTUNREACH;
+				atomic_inc(&dc->bm_mpc_stalled_err);
+				dev_warn(rdev_to_dev(rdev), "%s QUIT(3) as %s:%d or %s:%d or %s:%d",
+					 __func__,
+					 "mpc stall detected",
+					 creq->bm_mpc_stall,
+					 "HW FATAL Cond(stall)",
+					 test_bit(BNG_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags),
+					 "driver uninit in progress",
+					 creq->bm_mpc_uninstall_pending);
+				goto xmit_done;
+			}
+		} while (true);
+	} else {
+		if (max_timeout < 100) {
+			dev_err(rdev_to_dev(rdev),
+				"%s: long_timeout (%lu ms) < 100; poll_cmp=false wait loop is underspecified\n",
+				__func__, max_timeout);
+		}
+		timeout = max_timeout ?: 1;
+		/*
+		 * timeout == max_timeout here, so this is always 1 -- except
+		 * when max_timeout is 0, which would otherwise divide by zero.
+		 */
+		cnt = max_t(int, 1, (int)(max_timeout / timeout));
+
+		do {
+			tmo_left = wait_for_completion_timeout(&ctx->cmp,
+							       msecs_to_jiffies(timeout));
+			if (!tmo_left)
+				break;
+			dev_dbg(rdev_to_dev(rdev), "%s:%lx Wait For Completion: iteration:%d\n",
+				__func__, (unsigned long)current, cnt);
+			cnt--;
+			if (creq->bm_mpc_stall ||
+			    test_bit(BNG_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags) ||
+			    creq->bm_mpc_uninstall_pending) {
+				rc = -EHOSTUNREACH;
+				atomic_inc(&dc->bm_mpc_stalled_err);
+				dev_warn(rdev_to_dev(rdev), "%s QUIT(4) as %s:%d or %s:%d or %s:%d",
+					 __func__,
+					 "mpc stall detected",
+					 creq->bm_mpc_stall,
+					 "HW FATAL Cond(stall)",
+					 test_bit(BNG_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags),
+				 "driver uninit in progress",
+					 creq->bm_mpc_uninstall_pending);
+				goto xmit_done;
+			}
+		} while (cnt);
+		if (!tmo_left) {
+			rc = -ETIMEDOUT;
+			goto xmit_done;
+		}
+	}
+
+	memcpy(cmpl, &ctx->roce_cmp, min(cmpl_len, (uint)sizeof(ctx->roce_cmp)));
+
+xmit_done:
+	if (rc) {
+		int consecutive_errs;
+
+		if (sent_started)
+			atomic_inc(&dc->bm_mpc_sent_response_err);
+
+		dev_warn(rdev_to_dev(rdev), "RoCE MP cmd %08x failed with error:%d\n"
+			 "verb try:%d,sent try:%d,sent s.ok:%d,ebusy:%d,resp ok:%d,reps err:%d,%s:%d,%s:%d",
+			 *((u32 *)cmd), rc,
+			 atomic_read(&dc->bm_mpc_verb_try),
+			 atomic_read(&dc->bm_mpc_sent_try),
+			 atomic_read(&dc->bm_mpc_sent_started_ok),
+			 atomic_read(&dc->bm_mpc_sent_started_ebusy),
+			 atomic_read(&dc->bm_mpc_sent_response_ok),
+			 atomic_read(&dc->bm_mpc_sent_response_err),
+			 "pending",
+			 atomic_read(&creq->pending),
+			 "stalled",
+			 atomic_read(&dc->bm_mpc_stalled_err));
+		spin_lock_irqsave(&creq->mpc_ctx_lock, flags);
+		if (pctx)
+			*(unsigned long **)pctx = 0;
+		spin_unlock_irqrestore(&creq->mpc_ctx_lock, flags);
+		dump_tx_cmpl_ring_info(rdev);
+
+		if (rc == -EBUSY)
+			atomic_inc(&dc->bm_mpc_fatal_ebusy);
+		else if (rc == -ETIMEDOUT)
+			atomic_inc(&dc->bm_mpc_sent_timeout);
+		else
+			atomic_inc(&dc->bm_mpc_misc_err);
+
+		consecutive_errs = atomic_inc_return(&dc->bm_mpc_consecutive_sent_err);
+
+#ifdef MPC_STALL_DETECTION
+		if (consecutive_errs > BNGE_MPC_ROCE_ERR_THRESHOLD) {
+			dev_warn(rdev_to_dev(rdev),
+				 "%s:%d consecutive err;MPC ch marked stalled\n",
+				 __func__,
+				 consecutive_errs);
+			creq->bm_mpc_stall = true;
+		}
+#endif
+	} else {
+		atomic_inc(&dc->bm_mpc_sent_response_ok);
+		atomic_set(&dc->bm_mpc_consecutive_sent_err, 0);
+	}
+	if (refcount_dec_and_test(&ctx->refcnt))
+		kmem_cache_free(creq->mpc_cache, ctx);
+ exit:
+	max_pending = max(atomic_dec_return(&creq->pending),
+			  atomic_read(&creq->max_pending));
+	atomic_set(&creq->max_pending, max_pending);
+
+	poll_end_time = jiffies;
+
+	spin_lock_irqsave(&creq->mpc_ctx_lock, flags);
+	/* Track available buffer space */
+	creq->avail_buffer = bng_re_mpc_tx_avail(creq);
+	creq->min_avail_buffer = min(creq->avail_buffer,
+				     creq->min_avail_buffer);
+	bng_re_mpc_roce_add_perf_stats(rdev,
+				       ((u8 *)cmd)[0],
+				       ((u8 *)cmd)[1],
+				       (u32)jiffies_to_msecs(poll_end_time - tx_end_time));
+	spin_unlock_irqrestore(&creq->mpc_ctx_lock, flags);
+	bnge_re_print_mpc_msg(rdev, cmd, cmd_len, tx_start_time,
+			      tx_end_time, poll_end_time, rc, retries);
+	return rc;
+}
+
+void bnge_re_print_mpc_msg(struct bng_re_dev *rdev,
+			   u8 *cmd,
+			   uint cmd_len,
+			   unsigned long tx_start_time,
+			   unsigned long tx_end_time,
+			   unsigned long poll_end_time,
+			   int rc,
+			   int retries_left)
+{
+	unsigned long poll_duration = jiffies_to_msecs(poll_end_time - tx_end_time);
+	unsigned long tx_duration = jiffies_to_msecs(tx_end_time - tx_start_time);
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	u8 req_subtype = *(cmd + 1);
+	u8 req_type = *cmd;
+
+	dev_dbg(rdev_to_dev(rdev),
+		"MPC_TX mtyp:%x:%x,len:%d,tx st time:%ld,enq dur:%ld,comp dur:%ld,rc %d,outst:%d,max_pend:%d,avail_buf:%u,min_avail_buf:%u,retries_left:%d\n",
+		req_type,
+		req_subtype,
+		cmd_len,
+		tx_start_time,
+		tx_duration,
+		poll_duration,
+		rc,
+		atomic_read(&creq->pending),
+		atomic_read(&creq->max_pending),
+		creq->avail_buffer,
+		creq->min_avail_buffer,
+		retries_left);
+}
+
+/**
+ * bng_re_mpc_rings_alloc - Allocate MPC TX and CQ rings with firmware
+ * @rdev: RoCE device
+ *
+ * Must be called after the MPC TX and CQ HWQs are allocated via
+ * bng_re_alloc_init_hwq(). Issues HWRM_RING_ALLOC for L2 completion then TX
+ * (MPC primate channel), wiring CQ ring id and page tables.
+ *
+ * Return: 0 on success, negative errno from firmware or %-ENODEV if detached.
+ */
+int bng_re_mpc_rings_alloc(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	struct bng_re_chip_ctx *cctx = rdev->chip_ctx;
+	struct hwrm_ring_alloc_input req = {0};
+	struct hwrm_ring_alloc_output resp;
+	struct bnge_fw_msg fw_msg = {};
+	int cq_pages, tx_pages;
+	int rc;
+
+	dev_dbg(rdev_to_dev(rdev), "%s: %p", __func__, rdev);
+
+	if (test_bit(BNG_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags)) {
+		dev_err(rdev_to_dev(rdev), "%s: device detached\n", __func__);
+		return -ENODEV;
+	}
+
+	cq_pages = creq->cq_hwq.pbl[creq->cq_hwq.level].pg_count;
+	tx_pages = creq->tx_hwq.pbl[creq->tx_hwq.level].pg_count;
+
+	/* 1. Allocate CQ (completion) ring first */
+	bng_re_init_hwrm_hdr((struct input *)&req, HWRM_RING_ALLOC);
+	req.ring_type = RING_ALLOC_REQ_RING_TYPE_L2_CMPL;
+	req.length = cpu_to_le32(creq->cq_ring_mask + 1);
+	req.logical_id = cpu_to_le16(creq->bm_lr_index);
+	req.page_tbl_addr = cpu_to_le64(creq->cq_hwq.pbl[BNG_PBL_LVL_0].pg_map_arr[0]);
+	if (cq_pages > 1) {
+		req.page_size = BNGE_PAGE_SHIFT;
+		req.page_tbl_depth = 1;
+	} else {
+		req.page_size = 4;
+		req.page_tbl_depth = 0;
+	}
+	req.fbo = 0;
+
+	req.enables = cpu_to_le32(RING_ALLOC_REQ_ENABLES_NQ_RING_ID_VALID);
+
+	req.nq_ring_id = cpu_to_le16(creq->bm_nq_ring_id);
+	if (cctx->modes.st_tag_supported) {
+		req.steering_tag = cpu_to_le16(BNG_RE_STEERING_TO_HOST);
+		req.enables |= cpu_to_le32(RING_ALLOC_REQ_ENABLES_STEERING_TAG_VALID);
+	}
+	req.flags |=
+		cpu_to_le16(RING_ALLOC_REQ_FLAGS_DISABLE_CQ_OVERFLOW_DETECTION);
+
+	bng_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
+			   sizeof(resp), BNGE_DFLT_HWRM_CMD_TIMEOUT);
+	rc = bnge_send_msg(rdev->aux_dev, &fw_msg);
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "%s: CQ ring alloc failed rc=%d\n",
+			__func__, rc);
+		return rc;
+	}
+	creq->cq_ring_id = (u16)le32_to_cpu(resp.ring_id);
+	dev_dbg(rdev_to_dev(rdev), "%s: CQ ring_id=0x%x\n", __func__, creq->cq_ring_id);
+
+	/* 2. Allocate TX ring (associated with CQ) */
+	memset(&req, 0, sizeof(req));
+	bng_re_init_hwrm_hdr((void *)&req, HWRM_RING_ALLOC);
+	req.ring_type = RING_ALLOC_REQ_RING_TYPE_TX;
+	req.length = cpu_to_le32(creq->tx_ring_mask + 1);
+	req.logical_id = cpu_to_le16(creq->bm_lr_index);
+	req.cmpl_ring_id = cpu_to_le16(creq->cq_ring_id);
+	req.stat_ctx_id = cpu_to_le32(creq->bm_stat_index);
+	req.page_tbl_addr = cpu_to_le64(creq->tx_hwq.pbl[BNG_PBL_LVL_0].pg_map_arr[0]);
+	if (tx_pages > 1) {
+		req.page_size = BNGE_PAGE_SHIFT;
+		req.page_tbl_depth = 1;
+	} else {
+		req.page_size = 4;
+		req.page_tbl_depth = 0;
+	}
+	req.fbo = 0;
+	req.enables = cpu_to_le32(RING_ALLOC_REQ_ENABLES_MPC_CHNLS_TYPE);
+	req.mpc_chnls_type = RING_ALLOC_REQ_MPC_CHNLS_TYPE_PRIMATE;
+	if (cctx->modes.st_tag_supported) {
+		req.steering_tag = cpu_to_le16(BNG_RE_STEERING_TO_HOST);
+		req.enables |= cpu_to_le32(RING_ALLOC_REQ_ENABLES_STEERING_TAG_VALID);
+	}
+
+	bng_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
+			   sizeof(resp), BNGE_DFLT_HWRM_CMD_TIMEOUT);
+	rc = bnge_send_msg(rdev->aux_dev, &fw_msg);
+
+	if (rc) {
+		dev_err(rdev_to_dev(rdev), "%s: TX ring alloc failed rc=%d\n",
+			__func__, rc);
+		bng_re_net_ring_free(rdev, creq->cq_ring_id,
+				     RING_FREE_REQ_RING_TYPE_L2_CMPL);
+		creq->cq_ring_id = INVALID_HW_RING_ID;
+		return rc;
+	}
+	creq->tx_ring_id = le32_to_cpu(resp.ring_id);
+	dev_dbg(rdev_to_dev(rdev), "%s: TX ring_id=0x%x\n", __func__, creq->tx_ring_id);
+
+	dev_info(rdev_to_dev(rdev),
+		 "mpc rings: cq_ring_id=0x%x tx_ring_id=0x%x lr_index=%u nq_ring_id=%u stat_index=%u\n",
+		 creq->cq_ring_id, creq->tx_ring_id, creq->bm_lr_index,
+		 creq->bm_nq_ring_id, creq->bm_stat_index);
+
+	return 0;
+}
+
+/**
+ * bng_re_mpc_rings_free - Free MPC TX and CQ rings with firmware
+ * @rdev: RoCE device
+ *
+ * Frees the TX ring first when allocated, then the L2 completion ring.
+ */
+void bng_re_mpc_rings_free(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+
+	dev_dbg(rdev_to_dev(rdev), "%s: %p", __func__, creq);
+
+	if (creq->tx_ring_id != INVALID_HW_RING_ID_32BIT) {
+		bng_re_net_ring_free(rdev, creq->tx_ring_id,
+				     RING_FREE_REQ_RING_TYPE_TX);
+		creq->tx_ring_id = INVALID_HW_RING_ID;
+	}
+	if (creq->cq_ring_id != INVALID_HW_RING_ID_32BIT) {
+		bng_re_net_ring_free(rdev, creq->cq_ring_id,
+				     RING_FREE_REQ_RING_TYPE_L2_CMPL);
+		creq->cq_ring_id = INVALID_HW_RING_ID;
+	}
+}
+
+/******************************************************
+ * Stats section                                       *
+ *****************************************************/
+
+/**
+ * bng_re_mpc_roce_alloc_stats - Allocate MPC performance statistics structures
+ * @rdev: RoCE device
+ *
+ * Allocates latency histograms and per-verb latency ring buffers under
+ * mpc_roce_creq.bm_stats_info. Enables stats only if every allocation succeeds.
+ *
+ * Return: 0 on success, %-ENOMEM on failure (partial allocations freed).
+ */
+int bng_re_mpc_roce_alloc_stats(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_roce_stats_info *p;
+
+	p = vzalloc(sizeof(*p));
+	if (!p)
+		return -ENOMEM;
+
+	p->bms_stats_enabled = false;
+	p->bms_qp_modify_stats = vzalloc(sizeof(u64) * BNG_RE_MPC_MAX_STAT_INDEX);
+	p->bms_ah_modify_stats = vzalloc(sizeof(u64) * BNG_RE_MPC_MAX_STAT_INDEX);
+	p->bms_other_stats = vzalloc(sizeof(u64) * BNG_RE_MPC_MAX_STAT_INDEX);
+	p->bms_lat_slab_sec = vzalloc(sizeof(u32) *
+				      BNG_RE_MPC_MAX_LATENCY_SEC_SLAB_INDEX);
+	p->bms_lat_slab_msec = vzalloc(sizeof(u32) *
+				       BNG_RE_MPC_MAX_LATENCY_MSEC_SLAB_INDEX);
+	rdev->mpc_roce_creq.bm_stats_info = p;
+
+	if (p->bms_qp_modify_stats &&
+	    p->bms_ah_modify_stats &&
+	    p->bms_other_stats &&
+	    p->bms_lat_slab_sec &&
+	    p->bms_lat_slab_msec) {
+		p->bms_stats_enabled = true;
+		return 0;
+	}
+	bng_re_mpc_roce_free_stats(rdev);
+	return -ENOMEM;
+}
+
+/**
+ * bng_re_mpc_roce_free_stats - Free MPC performance statistics
+ * @rdev: RoCE device
+ */
+void bng_re_mpc_roce_free_stats(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_roce_stats_info *p = rdev->mpc_roce_creq.bm_stats_info;
+
+	if (!p)
+		return;
+
+	if (p->bms_qp_modify_stats)
+		vfree(p->bms_qp_modify_stats);
+	if (p->bms_ah_modify_stats)
+		vfree(p->bms_ah_modify_stats);
+	if (p->bms_other_stats)
+		vfree(p->bms_other_stats);
+	if (p->bms_lat_slab_sec)
+		vfree(p->bms_lat_slab_sec);
+	if (p->bms_lat_slab_msec)
+		vfree(p->bms_lat_slab_msec);
+
+	p->bms_stats_enabled = false;
+	rdev->mpc_roce_creq.bm_stats_info = NULL;
+}
+
+/**
+ * bng_re_mpc_roce_add_perf_stats - Record one MPC round-trip latency sample
+ * @rdev: RoCE device
+ * @req_type: MPC command header req_type
+ * @req_subtype: MPC command header req_subtype
+ * @latency_msec: Elapsed time from post to completion, in milliseconds
+ *
+ * Updates second- and millisecond-resolution histograms and stores
+ * the latency in the rotating sample array for QP modify, AH modify, or other.
+ */
+void bng_re_mpc_roce_add_perf_stats(struct bng_re_dev *rdev,
+				    u8 req_type,
+				    u8 req_subtype,
+				    u32 latency_msec)
+{
+	struct bng_re_mpc_roce_stats_info *p =
+		rdev->mpc_roce_creq.bm_stats_info;
+	u64 *dest_stats_ptr = NULL;
+	u32 dest_stats_id;
+
+	if (!p || !p->bms_stats_enabled)
+		return;
+
+	if (latency_msec / 1000 < BNG_RE_MPC_MAX_LATENCY_SEC_SLAB_INDEX)
+		p->bms_lat_slab_sec[latency_msec / 1000]++;
+
+	if (latency_msec < BNG_RE_MPC_MAX_LATENCY_MSEC_SLAB_INDEX)
+		p->bms_lat_slab_msec[latency_msec]++;
+
+	if (req_type == MPC_CMD_HDR_REQ_TYPE_RCA &&
+	    req_subtype == MPC_CMD_HDR_REQ_SUB_TYPE_RCA_QP_MODIFY) {
+		dest_stats_id = p->bms_qp_modify_stats_id++;
+		dest_stats_id = dest_stats_id % BNG_RE_MPC_MAX_STAT_INDEX;
+		dest_stats_ptr = &p->bms_qp_modify_stats[dest_stats_id];
+		/* stopped here */
+	} else if (((req_type == MPC_CMD_HDR_REQ_TYPE_RCA) ||
+		    (req_type == MPC_CMD_HDR_REQ_TYPE_PFVF)) &&
+		   (req_subtype == MPC_CMD_HDR_REQ_SUB_TYPE_RCA_AH_MODIFY)) {
+		dest_stats_id = p->bms_ah_modify_stats_id++;
+		dest_stats_id = dest_stats_id % BNG_RE_MPC_MAX_STAT_INDEX;
+		dest_stats_ptr = &p->bms_ah_modify_stats[dest_stats_id];
+	} else {
+		dest_stats_id = p->bms_other_stats_id++;
+		dest_stats_id = dest_stats_id % BNG_RE_MPC_MAX_STAT_INDEX;
+		dest_stats_ptr = &p->bms_other_stats[dest_stats_id];
+	}
+	if (dest_stats_ptr)
+		*dest_stats_ptr = latency_msec;
+}
+
+/**
+ * bng_re_mpc_roce_diag_counters_debugfs_show - Print MPC diagnostic counters to seq_file
+ * @rdev: RoCE device
+ * @s: debugfs seq_file output
+ *
+ * Return: 0 on success, %-ENOMEM if diagnostic counters are not allocated.
+ */
+int bng_re_mpc_roce_diag_counters_debugfs_show(struct bng_re_dev *rdev,
+					       struct seq_file *s)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	struct bng_re_mpc_diag_counters *mpc_diag_counters =
+		creq->bm_diag_counters;
+
+	if (!mpc_diag_counters)
+		return -ENOMEM;
+
+	seq_printf(s,
+		   "%s:\n%s: %d\n%s: %d\n%s: %d\n%s: %d\n%s: %d\n%s: %d\n",
+		   "RoCE MP cmd stats",
+		   "verb try",
+		   atomic_read(&mpc_diag_counters->bm_mpc_verb_try),
+		   "sent try",
+		   atomic_read(&mpc_diag_counters->bm_mpc_sent_try),
+		   "sent s.ok",
+		   atomic_read(&mpc_diag_counters->bm_mpc_sent_started_ok),
+		   "ebusy",
+		   atomic_read(&mpc_diag_counters->bm_mpc_sent_started_ebusy),
+		   "sent s.misc err",
+		   atomic_read(&mpc_diag_counters->bm_mpc_sent_started_misc_err),
+		   "resp ok",
+		   atomic_read(&mpc_diag_counters->bm_mpc_sent_response_ok));
+	seq_printf(s,
+		   "%s: %d\n%s: %d\n%s: %d\n%s: %u\n%s: %u\n",
+		   "resp err",
+		   atomic_read(&mpc_diag_counters->bm_mpc_sent_response_err),
+		   "pending",
+		   atomic_read(&creq->pending),
+		   "max_pending",
+		   atomic_read(&creq->max_pending),
+		   "avail_buf",
+		   creq->avail_buffer,
+		   "min_avail_buf",
+		   creq->min_avail_buffer);
+	seq_puts(s, ".... MP cmd stats:\n");
+	seq_printf(s, "fatal ebusy: %d\nsent timeout: %d\nmisc err: %d\n",
+		   atomic_read(&mpc_diag_counters->bm_mpc_fatal_ebusy),
+		   atomic_read(&mpc_diag_counters->bm_mpc_sent_timeout),
+		   atomic_read(&mpc_diag_counters->bm_mpc_misc_err));
+	seq_printf(s, "consecutive errs: %d\nchannel stalled: %d\nstalled errs:%d\n",
+		   atomic_read(&mpc_diag_counters->bm_mpc_consecutive_sent_err),
+		   creq->bm_mpc_stall,
+		   atomic_read(&mpc_diag_counters->bm_mpc_stalled_err));
+
+	return 0;
+}
+
+/**
+ * bng_re_mpc_roce_perf_debugfs_show - Print MPC latency / perf stats to seq_file
+ * @rdev: RoCE device
+ * @s: debugfs seq_file output
+ * @level: Verbosity (0 = slabs in seconds only; 1 adds msec slabs; 3 adds per-slot
+ *	   totals; 10+ dumps each index line for QP/AH/other arrays)
+ *
+ * Return: 0 on success, %-ENOMEM if stats are disabled or missing.
+ */
+int bng_re_mpc_roce_perf_debugfs_show(struct bng_re_dev *rdev,
+				      struct seq_file *s,
+				      u8 level)
+{
+	struct bng_re_mpc_roce_stats_info *p = rdev->mpc_roce_creq.bm_stats_info;
+	u64 qp_modify_total_msec = 0;
+	u64 ah_modify_total_msec = 0;
+	u64 other_total_msec = 0;
+	int qp_modify_total = 0;
+	int ah_modify_total = 0;
+	bool add_entry = false;
+	int other_total = 0;
+	int i = 0;
+
+	seq_puts(s, "==\n");
+
+	seq_printf(s, "bng_re mpc roce perf stats enabled:%s\n",
+		   (p && p->bms_stats_enabled) ? "Enabled" : "Disabled");
+
+	if (!(p && p->bms_stats_enabled))
+		return -ENOMEM;
+
+	for (i = 0; i < BNG_RE_MPC_MAX_LATENCY_SEC_SLAB_INDEX; i++) {
+		if (p->bms_lat_slab_sec[i])
+			seq_printf(s, "\tlatency_slab [%d - %d] sec = %d\n",
+				   i, i + 1, p->bms_lat_slab_sec[i]);
+	}
+	if (level < 1)
+		goto exit;
+
+	seq_puts(s, "==\n");
+	for (i = 0; i < BNG_RE_MPC_MAX_LATENCY_MSEC_SLAB_INDEX; i++) {
+		if (p->bms_lat_slab_msec[i])
+			seq_printf(s, "\tlatency_slab [%d - %d] msec = %d\n",
+				   i, i + 1, p->bms_lat_slab_msec[i]);
+	}
+
+	if (level < 3)
+		goto exit;
+
+	seq_puts(s, "==\n");
+	for (i = 0; i < BNG_RE_MPC_MAX_STAT_INDEX; i++) {
+		if (p->bms_qp_modify_stats[i] > 0) {
+			qp_modify_total++;
+			qp_modify_total_msec += p->bms_qp_modify_stats[i];
+			add_entry = true;
+		}
+		if (p->bms_ah_modify_stats[i] > 0) {
+			ah_modify_total++;
+			ah_modify_total_msec += p->bms_ah_modify_stats[i];
+			add_entry = true;
+		}
+		if (p->bms_other_stats[i] > 0) {
+			other_total++;
+			other_total_msec += p->bms_other_stats[i];
+			add_entry = true;
+		}
+
+		if (level >= 10) {
+			if (add_entry)
+				seq_printf(s, "<qp_modify> %lld <ah_modify> %lld <other> %lld\n",
+					   p->bms_qp_modify_stats[i],
+					   p->bms_ah_modify_stats[i],
+					   p->bms_other_stats[i]);
+		}
+
+		add_entry = false;
+	}
+
+	seq_puts(s, "==\n");
+	seq_printf(s, "Total qp_modify %d in msec %lld\n",
+		   qp_modify_total, qp_modify_total_msec);
+	seq_printf(s, "Total ah_modify %d in msec %lld\n",
+		   ah_modify_total, ah_modify_total_msec);
+	seq_printf(s, "Total other %d in msec %lld\n",
+		   other_total, other_total_msec);
+exit:
+	seq_puts(s, "\n");
+
+	return 0;
+}
+
+/**
+ * bng_re_mpc_roce_perf_debugfs_clear - Zero MPC perf histograms and sample arrays
+ * @rdev: RoCE device
+ */
+void bng_re_mpc_roce_perf_debugfs_clear(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_roce_stats_info *p = rdev->mpc_roce_creq.bm_stats_info;
+	int i;
+
+	if (!(p && p->bms_stats_enabled))
+		return;
+
+	for (i = 0; i < BNG_RE_MPC_MAX_LATENCY_MSEC_SLAB_INDEX; i++)
+		p->bms_lat_slab_msec[i] = 0;
+
+	for (i = 0; i < BNG_RE_MPC_MAX_LATENCY_SEC_SLAB_INDEX; i++)
+		p->bms_lat_slab_sec[i] = 0;
+
+	for (i = 0; i < BNG_RE_MPC_MAX_STAT_INDEX; i++) {
+		p->bms_qp_modify_stats[i] = 0;
+		p->bms_ah_modify_stats[i] = 0;
+		p->bms_other_stats[i] = 0;
+	}
+}
+
+/**
+ * bng_re_mpc_roce_diag_counters_clear - Reset MPC xmit/diagnostic atomics to zero
+ * @rdev: RoCE device
+ */
+void bng_re_mpc_roce_diag_counters_clear(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_diag_counters *mpc_diag_counters =
+					rdev->mpc_roce_creq.bm_diag_counters;
+
+	if (!mpc_diag_counters)
+		return;
+
+	atomic_set(&mpc_diag_counters->bm_mpc_verb_try, 0);
+	atomic_set(&mpc_diag_counters->bm_mpc_sent_try, 0);
+	atomic_set(&mpc_diag_counters->bm_mpc_sent_started_ok, 0);
+	atomic_set(&mpc_diag_counters->bm_mpc_sent_started_ebusy, 0);
+	atomic_set(&mpc_diag_counters->bm_mpc_sent_started_misc_err, 0);
+	atomic_set(&mpc_diag_counters->bm_mpc_sent_response_ok, 0);
+	atomic_set(&mpc_diag_counters->bm_mpc_sent_response_err, 0);
+	atomic_set(&mpc_diag_counters->bm_mpc_fatal_ebusy, 0);
+	atomic_set(&mpc_diag_counters->bm_mpc_sent_timeout, 0);
+	atomic_set(&mpc_diag_counters->bm_mpc_misc_err, 0);
+	atomic_set(&mpc_diag_counters->bm_mpc_consecutive_sent_err, 0);
+	atomic_set(&mpc_diag_counters->bm_mpc_stalled_err, 0);
+}
+
+/**
+ * bng_re_snapdump_mpc_stats - Collect MPC performance and latency stats for coredump.
+ * @rdev:	RoCE device
+ * @buf:	Dump buffer
+ * @buf_len:	Buffer length
+ * Returns:	Number of bytes written
+ */
+u32 bng_re_snapdump_mpc_stats(struct bng_re_dev *rdev, void *buf, u32 buf_len)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	struct bng_re_mpc_roce_stats_info *p = creq->bm_stats_info;
+	struct bng_re_mpc_diag_counters *mpc_diag =
+		creq->bm_diag_counters;
+	u32 len = 0;
+	int i;
+
+	dev_dbg(rdev_to_dev(rdev), "%s: buf_len:%d\n", __func__, buf_len);
+
+	/* Collect MPC perf stats if enabled */
+	if (p && p->bms_stats_enabled) {
+		len += snprintf(buf + len, buf_len - len, "==\n");
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len,
+				"bnge mpc roce perf stats enabled:%s\n",
+				p->bms_stats_enabled ? "Enabled" : "Disabled");
+		if (len >= buf_len)
+			return len;
+
+		for (i = 0; i < BNG_RE_MPC_MAX_LATENCY_SEC_SLAB_INDEX; i++) {
+			if (p->bms_lat_slab_sec[i]) {
+				len += snprintf(buf + len, buf_len - len,
+						"\tlatency_slab [%d - %d] sec = %d\n",
+						i, i + 1, p->bms_lat_slab_sec[i]);
+				if (len >= buf_len)
+					return len;
+			}
+		}
+
+		len += snprintf(buf + len, buf_len - len, "==\n");
+		if (len >= buf_len)
+			return len;
+
+		for (i = 0; i < BNG_RE_MPC_MAX_LATENCY_MSEC_SLAB_INDEX; i++) {
+			if (p->bms_lat_slab_msec[i]) {
+				len += snprintf(buf + len, buf_len - len,
+						"\tlatency_slab [%d - %d] msec = %d\n",
+						i, i + 1, p->bms_lat_slab_msec[i]);
+				if (len >= buf_len)
+					return len;
+			}
+		}
+	}
+
+	/* Collect MPC diagnostic counters */
+	if (mpc_diag && creq->mpc_cache) {
+		len += snprintf(buf + len, buf_len - len, "RoCE MP cmd stats:\n");
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "verb try: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_verb_try));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "sent try: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_sent_try));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "sent s.ok: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_sent_started_ok));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "pending: %d\n",
+				atomic_read(&creq->pending));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "max_pending: %d\n",
+				atomic_read(&creq->max_pending));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "avail_buf: %u\n",
+				creq->avail_buffer);
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "min_avail_buf: %u\n",
+				creq->min_avail_buffer);
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "ebusy: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_sent_started_ebusy));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "sent s.misc err: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_sent_started_misc_err));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "resp ok: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_sent_response_ok));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "resp err: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_sent_response_err));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, ".... MP cmd stats:\n");
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "fatal ebusy: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_fatal_ebusy));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "sent timeout: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_sent_timeout));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "misc err: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_misc_err));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "consecutive sent err: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_consecutive_sent_err));
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "channel stalled: %d\n",
+				creq->bm_mpc_stall);
+		if (len >= buf_len)
+			return len;
+
+		len += snprintf(buf + len, buf_len - len, "stalled err: %d\n",
+				atomic_read(&mpc_diag->bm_mpc_stalled_err));
+		if (len >= buf_len)
+			return len;
+	}
+
+	return len;
+}
+
+/**
+ * dump_tx_cmpl_ring_info - Log TX/CQ producer-consumer state and recent CQ slots
+ * @rdev: RoCE device
+ *
+ * Takes tx_lock for ring indices and bm_lock while dumping poll timing and a
+ * short hex decode window around the last stalled consumer index.
+ */
+void dump_tx_cmpl_ring_info(struct bng_re_dev *rdev)
+{
+	struct bng_re_mpc_roce_creq_info *creq = &rdev->mpc_roce_creq;
+	struct bng_re_mpc_poll_info *poll_info = creq->bm_poll_info;
+	u64 curr_jiffies = get_jiffies_64();
+	u32 start_raw_index = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&creq->tx_lock, flags);
+	dev_warn(rdev_to_dev(rdev),
+		 "[%s.%lx] curr ms:%d,tx ring prod,cons,cq_cons:%d,%d,%d,tx_ring_size:%d,cmpl_ring_size:%d\n",
+		 __func__,
+		 (unsigned long)current,
+		 jiffies_to_msecs(curr_jiffies),
+		 READ_ONCE(creq->tx_prod),
+		 READ_ONCE(creq->tx_cons),
+		 READ_ONCE(creq->cq_hwq.cons),
+		 creq->tx_hwq.max_elements,
+		 creq->cq_hwq.max_elements);
+	spin_unlock_irqrestore(&creq->tx_lock, flags);
+
+	spin_lock_irqsave(&creq->bm_lock, flags);
+	dev_warn(rdev_to_dev(rdev), "[%s.%lx] %s:%d,%d;%s:%d,%s:%d,%s:%d,%d",
+		 __func__,
+		 (unsigned long)current,
+		 "last_poll_st/end",
+		 jiffies_to_msecs(poll_info->bm_last_poll_work_poll_jiffies_start),
+		 jiffies_to_msecs(poll_info->bm_last_poll_work_poll_jiffies_end),
+		 "max_ms_b_polls",
+		 jiffies_to_msecs(poll_info->bm_max_poll_work_poll_jiffies),
+		 "curr cons",
+		 poll_info->bm_current_cons_indx,
+		 "ms on curr cons[st/diff]",
+		 jiffies_to_msecs(poll_info->bm_start_time_on_current_cons_indx),
+		 jiffies_to_msecs(poll_info->bm_curr_time_on_current_cons_indx));
+	if (poll_info->bm_current_cons_indx >= 5)
+		start_raw_index = poll_info->bm_current_cons_indx - 5;
+
+	spin_unlock_irqrestore(&creq->bm_lock, flags);
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_re_mpc_roce.h b/drivers/infiniband/hw/bng_re/bng_re_mpc_roce.h
new file mode 100644
index 000000000000..152471462048
--- /dev/null
+++ b/drivers/infiniband/hw/bng_re/bng_re_mpc_roce.h
@@ -0,0 +1,218 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2025 Broadcom. */
+
+#ifndef __BNG_RE_MPC_ROCE_H__
+#define __BNG_RE_MPC_ROCE_H__
+
+#include <linux/stddef.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/refcount.h>
+
+#include "bng_roce_hsi.h"
+#include "bng_re.h"
+#include "bng_res.h"
+
+/* RoCE MPC diagnostics and knobs (mirrors bnge for compatibility) */
+#define BNG_RE_MPC_MAX_LATENCY_SEC_SLAB_INDEX	201
+#define BNG_RE_MPC_MAX_LATENCY_MSEC_SLAB_INDEX	3000
+#define BNG_RE_MPC_MAX_STAT_INDEX		0x3FFFF
+
+#define BNG_RE_MPC_ROCE_TMO_MSECS_SHORT	8000  /* for nonblocking context */
+#ifdef BNGE_FPGA
+#define BNG_RE_MPC_ROCE_TMO_MSECS_LONG		100000  /* for normal context */
+#define BNG_RE_MPC_ROCE_RETRY_SLEEP	2000  /* ms */
+#else
+#define BNG_RE_MPC_ROCE_TMO_MSECS_LONG		 40000  /* for normal context */
+#define BNG_RE_MPC_ROCE_RETRY_SLEEP	200  /* ms */
+#endif
+#define BNG_RE_MPC_ROCE_MAX_RETRIES	32
+#define BNG_RE_MPC_ROCE_ERR_THRESHOLD     10
+
+/* bng_re_mpc_poll_info, bng_re_mpc_diag_counters, bng_re_mpc_tune_params,
+ * bng_re_mpc_roce_stats_info are defined in bng_re.h — include that instead.
+ */
+#define MPC_ROCE_COMPL_MAX_SIZE 32
+
+/*
+ * Single work item for all PF→VF forwarded MPC completions.
+ * bng_re_mpc_process_vf_completion() dispatches on req_subtype internally,
+ * so no per-operation struct is needed.
+ */
+struct bng_re_vf_pfvf_cmpl_work {
+	struct work_struct work;
+	struct bng_re_dev *rdev;
+	u8  roce_cmp[MPC_ROCE_COMPL_MAX_SIZE];
+};
+
+struct bng_re_cmpl_entry {
+	void *cmpl;
+	u32 len;
+};
+
+struct mpc_cmp {
+	__le32 mpc_cmp_client_subtype_type;
+	#define MPC_CMP_TYPE					(0x3f << 0)
+	 #define MPC_CMP_TYPE_MID_PATH_SHORT			 0x1e
+	 #define MPC_CMP_TYPE_MID_PATH_LONG			 0x1f
+	#define MPC_CMP_SUBTYPE					0xf00
+	#define MPC_CMP_SUBTYPE_SFT				 8
+	 #define MPC_CMP_SUBTYPE_SOLICITED			 (0x0 << 8)
+	 #define MPC_CMP_SUBTYPE_ERR				 (0x1 << 8)
+	 #define MPC_CMP_SUBTYPE_RESYNC				 (0x2 << 8)
+	#define MPC_CMP_CLIENT					(0xf << 12)
+	 #define MPC_CMP_CLIENT_SFT				 12
+	 #define MPC_CMP_CLIENT_TCE				 (0x0 << 12)
+	 #define MPC_CMP_CLIENT_RCE				 (0x1 << 12)
+	 #define MPC_CMP_CLIENT_TE_CFA				 (0x2 << 12)
+	 #define MPC_CMP_CLIENT_RE_CFA				 (0x3 << 12)
+	 #define MPC_CMP_CLIENT_PRIMATE				 (0x4 << 12)
+	u32 mpc_cmp_opaque;
+	__le32 mpc_cmp_v;
+	#define MPC_CMP_V					BIT(0)
+	__le32 mpc_cmp_filler;
+};
+
+struct bng_re_roce_cmd_ctx {
+	struct completion cmp;
+	u8		  roce_cmp[MPC_ROCE_COMPL_MAX_SIZE];
+	bool	 poll_cmp;
+	bool     cmpl_available;
+	/*
+	 * Shared ownership between bng_re_roce_mpc_xmit (always holds 1 ref)
+	 * and bng_re_mpc_roce_service_creq (acquires +1 while processing a
+	 * completion for this ctx).  Whoever decrements to zero frees the
+	 * object.  This prevents the use-after-free where a late completion
+	 * writes into a ctx that xmit has already freed on a timeout/error
+	 * path.
+	 */
+	refcount_t refcnt;
+};
+
+/* Same message types as bnge */
+#define BNG_RE_MPC_TX_RING_SIZE	512
+#define BNG_RE_MPC_CQ_RING_SIZE	(BNG_RE_MPC_TX_RING_SIZE * 4)
+#define BNG_RE_MPC_TX_STRIDE	16	/* sizeof(struct tx_bd) */
+#define BNG_RE_MPC_CQ_STRIDE	16	/* sizeof(struct tx_cmp) */
+#define BNG_RE_MPC_INV_HDL	(-1UL)
+
+#define MAX_ADV_ITERATIONS      (1000)
+
+#ifndef TX_OPAQUE_IDX_MASK
+#define TX_OPAQUE_IDX_MASK	0x0000ffff
+#endif
+#ifndef TX_OPAQUE_BDS_SHIFT
+#define TX_OPAQUE_BDS_SHIFT	16
+#endif
+#ifndef TX_OPAQUE_RING_SHIFT
+#define TX_OPAQUE_RING_SHIFT	24
+#endif
+#ifndef TX_BD_TYPE_MPC_TX_BD
+#define TX_BD_TYPE_MPC_TX_BD	(0x08 << 0)
+#endif
+#ifndef BNGE_DFLT_HWRM_CMD_TIMEOUT
+#define BNGE_DFLT_HWRM_CMD_TIMEOUT	500
+#endif
+
+#define BNG_RE_MPC_SET_TX_OPAQUE(tx_napi_idx, idx, bds, tx_ring_mask) \
+	(((tx_napi_idx) << TX_OPAQUE_RING_SHIFT) | \
+	 ((bds) << TX_OPAQUE_BDS_SHIFT) | ((idx) & (tx_ring_mask)))
+
+#define BNG_RE_MPC_TX_OPAQUE_IDX(opq)	((opq) & TX_OPAQUE_IDX_MASK)
+
+static inline void bng_re_roce_mpc_set_stall(struct bng_re_dev *rdev)
+{
+	dev_warn(rdev_to_dev(rdev), "%s: MPC ch marked stalled\n", __func__);
+	rdev->mpc_roce_creq.bm_mpc_stall = true;
+}
+
+struct bng_re_mpc_roce_creq_info *bng_re_mpc_roce_tx_ring(struct bng_re_dev *rdev);
+
+void bng_re_ulp_vf_qp_req(struct bng_re_dev *rdev, void *cmpl, u32 cmpl_len);
+void bng_re_mpc_process_vf_completion(struct bng_re_dev *rdev, void *cmpl, u32 cmpl_len);
+
+void bng_re_mpc_roce_set_stall(struct bng_re_dev *rdev);
+
+int bng_re_mpc_roce_alloc_init(struct bng_re_dev *rdev);
+
+void bng_re_mpc_roce_deinit_free(struct bng_re_dev *rdev);
+
+int bng_re_mpc_roce_service_creq(struct bng_re_dev *rdev, int budget);
+
+int bng_re_mpc_roce_service_cne(struct bng_re_dev *rdev, void *nq_cmp, int budget);
+
+int bng_re_mpc_roce_xmit(struct bng_re_dev *rdev, void *cmd, uint cmd_len,
+			 void *cmpl, uint cmpl_len, bool poll_cmp);
+int bng_re_mpc_roce_diag_counters_debugfs_show(struct bng_re_dev *rdev,
+					       struct seq_file *s);
+int bng_re_mpc_roce_perf_debugfs_show(struct bng_re_dev *rdev,
+				      struct seq_file *s, u8 level);
+void bng_re_mpc_roce_perf_debugfs_clear(struct bng_re_dev *rdev);
+
+void bng_re_mpc_roce_diag_counters_clear(struct bng_re_dev *rdev);
+
+int bng_re_mpc_rings_alloc(struct bng_re_dev *rdev);
+void bng_re_mpc_rings_free(struct bng_re_dev *rdev);
+
+int bng_re_mpc_roce_alloc_stats(struct bng_re_dev *rdev);
+void bng_re_mpc_roce_free_stats(struct bng_re_dev *rdev);
+
+void bng_re_mpc_roce_add_perf_stats(struct bng_re_dev *rdev,
+				    u8 req_type,
+				    u8 req_subtype,
+				    u32 latency_msec);
+
+int bng_re_mpc_roce_diag_counters_debugfs_show(struct bng_re_dev *rdev,
+					       struct seq_file *s);
+
+void bnge_re_print_mpc_msg(struct bng_re_dev *rdev,
+			   u8 *cmd,
+			   uint cmd_len,
+			   unsigned long tx_start_time,
+			   unsigned long tx_end_time,
+			   unsigned long poll_end_time,
+			   int rc,
+			   int retries_left);
+
+void dump_tx_cmpl_ring_info(struct bng_re_dev *rdev);
+
+void bng_re_mpc_handle_event_cmpl(struct bng_re_dev *rdev,
+				  void *cmpl, u32 cmpl_len);
+
+void bng_re_mpc_rings_free(struct bng_re_dev *rdev);
+u32 bng_re_snapdump_mpc_stats(struct bng_re_dev *rdev, void *buf, u32 buf_len);
+void bng_re_mpc_process_vf_completion(struct bng_re_dev *rdev, void *cmpl, u32 cmpl_len);
+
+void bng_re_ulp_vf_qp_req(struct bng_re_dev *rdev, void *cmpl, u32 cmpl_len);
+
+void bng_re_roce_mpc_cmp(struct bng_re_dev *rdev, unsigned long handle,
+			 struct bng_re_cmpl_entry *cmpl);
+int bng_re_roce_mpc_xmit(struct bng_re_dev *rdev, void *cmd, uint cmd_len,
+			 void *cmpl, uint cmpl_len, bool poll_cmp);
+int bng_re_roce_mpc_diag_counters_debugfs_show(struct bng_re_dev *rdev,
+					       struct seq_file *s);
+int bng_re_roce_mpc_perf_debugfs_show(struct bng_re_dev *rdev,
+				      struct seq_file *s, u8 level);
+void bng_re_roce_mpc_perf_debugfs_clear(struct bng_re_dev *rdev);
+void bng_re_roce_mpc_diag_counters_clear(struct bng_re_dev *rdev);
+
+int bng_mpc_start_background_poll(struct bng_re_dev *rdev,
+				  struct task_struct **new_thread);
+void bng_mpc_stop_background_poll(struct bng_re_dev *rdev,
+				  struct task_struct **thread);
+
+int bng_alloc_init_mpc(struct bng_re_dev *rdev);
+int bng_deinit_mpc(struct bng_re_dev *rdev);
+void bng_mpc_stop_irq(struct bng_mpc_ctx *mpc, bool kill);
+
+int bng_re_alloc_mpc_doorbells(struct bng_re_dev *rdev);
+void bng_re_unalloc_mpc_doorbells(struct bng_re_dev *rdev);
+void bng_re_check_mpc_pending_empty(struct bng_re_dev *rdev);
+
+void bng_re_vf_pfvf_cmpl_wq_task(struct work_struct *work);
+
+#endif
diff --git a/drivers/infiniband/hw/bng_re/bng_res.c b/drivers/infiniband/hw/bng_re/bng_res.c
index f6e3528e7f4c..be6d5099aa35 100644
--- a/drivers/infiniband/hw/bng_re/bng_res.c
+++ b/drivers/infiniband/hw/bng_re/bng_res.c
@@ -8,6 +8,7 @@
 #include <linux/bnge/hsi.h>
 #include "bng_res.h"
 #include "bng_roce_hsi.h"
+#include "bng_sp.h"
 
 /* Stats */
 void bng_re_free_stats_ctx_mem(struct pci_dev *pdev,
@@ -50,7 +51,7 @@ static void bng_free_pbl(struct bng_re_res  *res, struct bng_re_pbl *pbl)
 					  pbl->pg_map_arr[i]);
 		else
 			dev_warn(&pdev->dev,
-					"PBL free pg_arr[%d] empty?!\n", i);
+				 "PBL free pg_arr[%d] empty?!\n", i);
 		pbl->pg_arr[i] = NULL;
 	}
 
@@ -90,9 +91,9 @@ static int bng_alloc_pbl(struct bng_re_res  *res,
 
 	for (i = 0; i < pages; i++) {
 		pbl->pg_arr[i] = dma_alloc_coherent(&pdev->dev,
-				pbl->pg_size,
-				&pbl->pg_map_arr[i],
-				GFP_KERNEL);
+						    pbl->pg_size,
+						    &pbl->pg_map_arr[i],
+						    GFP_KERNEL);
 		if (!pbl->pg_arr[i])
 			goto fail;
 		pbl->pg_count++;
@@ -192,7 +193,7 @@ int bng_re_alloc_init_hwq(struct bng_re_hwq *hwq,
 
 			/* Alloc or init PTEs */
 			rc = bng_alloc_pbl(res, &hwq->pbl[BNG_PBL_LVL_2],
-					 hwq_attr->sginfo);
+					   hwq_attr->sginfo);
 			if (rc)
 				goto fail;
 			hwq->level = BNG_PBL_LVL_2;
@@ -231,7 +232,7 @@ int bng_re_alloc_init_hwq(struct bng_re_hwq *hwq,
 				goto fail;
 			/* Alloc or init  PTEs */
 			rc = bng_alloc_pbl(res, &hwq->pbl[BNG_PBL_LVL_1],
-					 hwq_attr->sginfo);
+					   hwq_attr->sginfo);
 			if (rc)
 				goto fail;
 			hwq->level = BNG_PBL_LVL_1;
@@ -277,3 +278,104 @@ int bng_re_alloc_init_hwq(struct bng_re_hwq *hwq,
 	bng_re_free_hwq(res, hwq);
 	return -ENOMEM;
 }
+
+void bng_res_unmap_db_bar(struct bng_re_res *res)
+{
+	struct bng_re_reg_desc *reg;
+
+	reg = &res->dpi_tbl.ucreg;
+	if (reg->bar_reg)
+		pci_iounmap(res->pdev, reg->bar_reg);
+	reg->bar_reg = NULL;
+	reg->bar_base = 0;
+	reg->len = 0;
+	reg->bar_id = 0;
+}
+
+int bng_res_map_db_bar(struct bng_re_res *res)
+{
+	struct bng_re_reg_desc *ucreg;
+	struct bng_re_reg_desc *wcreg;
+
+	wcreg = &res->dpi_tbl.wcreg;
+	wcreg->bar_id = RCFW_DBR_PCI_BAR_REGION;
+	wcreg->bar_base = pci_resource_start(res->pdev, wcreg->bar_id);
+
+	ucreg = &res->dpi_tbl.ucreg;
+	ucreg->bar_id = RCFW_DBR_PCI_BAR_REGION;
+	ucreg->bar_base = pci_resource_start(res->pdev, ucreg->bar_id);
+	ucreg->len = ucreg->offset + PAGE_SIZE;
+	if (!ucreg->len) {
+		dev_err(&res->pdev->dev, "invalid dbr length %d",
+			(int)ucreg->len);
+		return -EINVAL;
+	}
+	ucreg->bar_reg = ioremap(ucreg->bar_base, ucreg->len);
+	if (!ucreg->bar_reg) {
+		dev_err(&res->pdev->dev, "privileged dpi map failed!");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void bng_res_free_dpi_tbl(struct bng_re_dpi_tbl *dpit)
+{
+	kfree(dpit->tbl);
+	kfree(dpit->app_tbl);
+	dpit->tbl = NULL;
+	dpit->app_tbl = NULL;
+	dpit->max = 0;
+}
+
+static int bng_res_alloc_dpi_tbl(struct bng_re_res *res,
+				 struct bng_re_dev_attr *dev_attr)
+{
+	struct bng_re_dpi_tbl *dpit;
+	struct bng_re_reg_desc *reg;
+	unsigned long bar_len;
+	u32 bytes;
+
+	dpit = &res->dpi_tbl;
+	reg = &dpit->wcreg;
+
+	bar_len = pci_resource_len(res->pdev, reg->bar_id);
+
+	dpit->max = (bar_len - reg->offset) / PAGE_SIZE;
+	if (dev_attr->max_dpi)
+		dpit->max = min_t(u32, dpit->max, dev_attr->max_dpi);
+
+	dpit->app_tbl = kcalloc(dpit->max, sizeof(void *), GFP_KERNEL);
+	if (!dpit->app_tbl)
+		return -ENOMEM;
+
+	bytes = (dpit->max + 7) >> 3;
+	dpit->tbl = kmalloc(bytes, GFP_KERNEL);
+	if (!dpit->tbl) {
+		kfree(dpit->app_tbl);
+		dpit->app_tbl = NULL;
+		dev_err(&res->pdev->dev,
+			"DPI tbl allocation failed for size = %d", bytes);
+		return -ENOMEM;
+	}
+
+	memset((u8 *)dpit->tbl, 0xFF, bytes);
+	dpit->priv_db = dpit->ucreg.bar_reg + dpit->ucreg.offset;
+	return 0;
+}
+
+void bng_res_free_tbls(struct bng_re_res *res)
+{
+	bng_res_free_dpi_tbl(&res->dpi_tbl);
+}
+
+int bng_res_alloc_init_tbls(struct bng_re_res *res)
+{
+	int rc;
+
+	rc = bng_res_alloc_dpi_tbl(res, res->dattr);
+	if (rc)
+		dev_err(&res->pdev->dev, "DPI tbl alloc failed\n");
+
+	return rc;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_res.h b/drivers/infiniband/hw/bng_re/bng_res.h
index 2c4e9191ad1c..9745609190d9 100644
--- a/drivers/infiniband/hw/bng_re/bng_res.h
+++ b/drivers/infiniband/hw/bng_re/bng_res.h
@@ -5,6 +5,10 @@
 #define __BNG_RES_H__
 
 #include "bng_roce_hsi.h"
+#include "xid_allocator.h"
+#include <linux/bnge/hsi.h>
+
+#define BNG_NQE_MAX_CNT		(128 * 1024)
 
 #define BNG_ROCE_FW_MAX_TIMEOUT	60
 
@@ -14,10 +18,10 @@
 #define PTR_IDX(x)		((x) & PTR_MAX_IDX_PER_PG)
 
 #define HWQ_CMP(idx, hwq)	((idx) & ((hwq)->max_elements - 1))
-#define HWQ_FREE_SLOTS(hwq)	(hwq->max_elements - \
-				((HWQ_CMP(hwq->prod, hwq)\
-				- HWQ_CMP(hwq->cons, hwq))\
-				& (hwq->max_elements - 1)))
+#define HWQ_FREE_SLOTS(hwq)	((hwq)->max_elements - \
+				((HWQ_CMP((hwq)->prod, hwq)\
+				- HWQ_CMP((hwq)->cons, hwq))\
+				& ((hwq)->max_elements - 1)))
 
 #define MAX_PBL_LVL_0_PGS		1
 #define MAX_PBL_LVL_1_PGS		512
@@ -32,6 +36,8 @@
 
 #define BNG_MAX_TQM_ALLOC_REQ	48
 
+#define RCFW_DBR_PCI_BAR_REGION		2
+
 struct bng_re_reg_desc {
 	u8		bar_id;
 	resource_size_t	bar_base;
@@ -43,11 +49,16 @@ struct bng_re_reg_desc {
 struct bng_re_db_info {
 	void __iomem		*db;
 	void __iomem		*priv_db;
+	void			*dbc; /* HDBR registration handle (optional) */
 	struct bng_re_hwq	*hwq;
 	u32			xid;
+	u32			seed;
 	u32			max_slot;
 	u32                     flags;
 	u8			toggle;
+	spinlock_t		lock; /* protects concurrent doorbell ring updates */
+	struct bng_re_res	*res;
+	bool			is_l2;
 };
 
 enum bng_re_db_info_flags_mask {
@@ -57,16 +68,29 @@ enum bng_re_db_info_flags_mask {
 	BNG_RE_FLAG_EPOCH_PROD_MASK         = 0x2UL,
 };
 
+#define BNG_QP_FLAG_EPOCH_CONS_MASK	BNG_RE_FLAG_EPOCH_CONS_MASK
+
 enum bng_re_db_epoch_flag_shift {
 	BNG_RE_DB_EPOCH_CONS_SHIFT  = BNG_RE_DBR_EPOCH_SHIFT,
 	BNG_RE_DB_EPOCH_PROD_SHIFT  = (BNG_RE_DBR_EPOCH_SHIFT - 1),
 };
 
+struct bng_re_drv_modes {
+	u8				wqe_mode;
+	bool				db_push;
+	bool				dbr_pacing;
+	u32				toggle_bits;
+	u8				roce_mirror;
+	u8				dbr_primary_pf;
+	bool				st_tag_supported;
+};
+
 struct bng_re_chip_ctx {
 	u16	chip_num;
 	u16	hw_stats_size;
 	u64	hwrm_intf_ver;
 	u16	hwrm_cmd_max_timeout;
+	struct bng_re_drv_modes modes;
 };
 
 struct bng_re_pbl {
@@ -132,10 +156,23 @@ struct bng_re_stats {
 	u32				fw_id;
 };
 
+/* DPI table */
+struct bng_re_dpi_tbl {
+	void			**app_tbl;
+	unsigned long		*tbl;
+	u16			max;
+	struct bng_re_reg_desc	ucreg; /* Hold entire DB bar. */
+	struct bng_re_reg_desc	wcreg;
+	void __iomem		*priv_db;
+};
+
 struct bng_re_res {
 	struct pci_dev			*pdev;
 	struct bng_re_chip_ctx		*cctx;
 	struct bng_re_dev_attr		*dattr;
+	struct bng_re_dpi_tbl		dpi_tbl;
+	struct xid_manager		*qp_xids;
+	struct xid_manager		*ah_xids;
 };
 
 static inline void *bng_re_get_qe(struct bng_re_hwq *hwq,
@@ -195,6 +232,34 @@ static inline void bng_re_hwq_incr_cons(u32 max_elements, u32 *cons, u32 cnt,
 	}
 }
 
+static inline void bng_hwq_incr_prod(struct bng_re_db_info *dbinfo,
+				     struct bng_re_hwq *hwq, u32 cnt)
+{
+	/* move prod and update toggle/epoch if wrap around */
+	hwq->prod += cnt;
+	if (hwq->prod >= hwq->depth) {
+		hwq->prod %= hwq->depth;
+		dbinfo->flags ^= 1UL << BNG_RE_FLAG_EPOCH_PROD_SHIFT;
+	}
+}
+
+static inline void bng_ring_prod_db(struct bng_re_db_info *info, u32 type)
+{
+	u64 key = 0;
+	u32 indx;
+
+	indx = (((info->hwq->prod / info->max_slot) & DBC_DBC_INDEX_MASK) |
+		((info->flags & BNG_RE_FLAG_EPOCH_PROD_MASK) <<
+		 BNG_RE_DB_EPOCH_PROD_SHIFT));
+
+	key = BNG_RE_INIT_DBHDR(info->xid, type, indx, 0);
+
+	if (info->is_l2)
+		key |= DBC_DBC64_PATH_L2;
+
+	writeq(key, info->db);
+}
+
 static inline bool _is_max_srq_ext_supported(u16 dev_cap_ext_flags_2)
 {
 	return !!(dev_cap_ext_flags_2 & CREQ_QUERY_FUNC_RESP_SB_MAX_SRQ_EXTENDED);
@@ -212,4 +277,9 @@ void bng_re_free_stats_ctx_mem(struct pci_dev *pdev,
 int bng_re_alloc_stats_ctx_mem(struct pci_dev *pdev,
 			       struct bng_re_chip_ctx *cctx,
 			       struct bng_re_stats *stats);
+
+void bng_res_unmap_db_bar(struct bng_re_res *res);
+int bng_res_map_db_bar(struct bng_re_res *res);
+void bng_res_free_tbls(struct bng_re_res *res);
+int bng_res_alloc_init_tbls(struct bng_re_res *res);
 #endif
diff --git a/drivers/infiniband/hw/bng_re/bng_roce_hsi.h b/drivers/infiniband/hw/bng_re/bng_roce_hsi.h
index 5ebd7ba90b7b..6c9d45464ef6 100644
--- a/drivers/infiniband/hw/bng_re/bng_roce_hsi.h
+++ b/drivers/infiniband/hw/bng_re/bng_roce_hsi.h
@@ -6447,4 +6447,98 @@ struct ptu_pde {
 	#define PTU_PDE_PAGE_SFT   12
 };
 
+/* mpc_qp_modify_cmpl (size:256b/32B) */
+struct mpc_qp_modify_cmpl {
+	u8	cmpl_type_reserved;
+	#define MPC_QP_MODIFY_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_MASK         0x3fUL
+	#define MPC_QP_MODIFY_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_SFT          0
+	#define MPC_QP_MODIFY_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_MPC_CMP_SHORT  0x1eUL
+	#define MPC_QP_MODIFY_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_MPC_CMP_LONG   0x1fUL
+	#define MPC_QP_MODIFY_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_LAST \
+		MPC_QP_MODIFY_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_MPC_CMP_LONG
+	u8	error_code_mp_client;
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_MP_CLIENT_ERROR_CODE_MASK 0xfUL
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_MP_CLIENT_ERROR_CODE_SFT 0
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_MP_CLIENT_MP_CLIENT_MASK 0xf0UL
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_MP_CLIENT_MP_CLIENT_SFT  4
+	u8	req_type;
+	u8	req_subtype;
+	__le32	opaque;
+	u8	v;
+	#define MPC_QP_MODIFY_CMPL_V     0x1UL
+	u8	reserved_0[7];
+	__le32	xid;
+	__le16	error_code;
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_SUCCESS           0x0UL
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_FAIL              0x1UL
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_RESOURCES         0x2UL
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_INVALID_CMD       0x3UL
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_NOT_IMPLEMENTED   0x4UL
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_INVALID_PARAMETER 0x5UL
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_HARDWARE_ERROR    0x6UL
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_INTERNAL_ERROR    0x7UL
+	#define MPC_QP_MODIFY_CMPL_ERROR_CODE_LAST \
+		MPC_QP_MODIFY_CMPL_ERROR_CODE_INTERNAL_ERROR
+	u8	pingpong_push_state_index_enabled;
+	#define MPC_QP_MODIFY_CMPL_PINGPONG_PUSH_ENABLED     0x1UL
+	#define MPC_QP_MODIFY_CMPL_PINGPONG_PUSH_INDEX_MASK  0xeUL
+	#define MPC_QP_MODIFY_CMPL_PINGPONG_PUSH_INDEX_SFT   1
+	#define MPC_QP_MODIFY_CMPL_PINGPONG_PUSH_STATE       0x10UL
+	u8	flags;
+	#define MPC_QP_MODIFY_CMPL_FLAGS_FLAGS_MASK          0xffUL
+	#define MPC_QP_MODIFY_CMPL_FLAGS_FLAGS_SFT           0
+	#define MPC_QP_MODIFY_CMPL_FLAGS_FLAGS_QP_MD_COMPLETE  0x0UL
+	#define MPC_QP_MODIFY_CMPL_FLAGS_FLAGS_QP_MD_PENDING   0x1UL
+	#define MPC_QP_MODIFY_CMPL_FLAGS_FLAGS_LAST \
+		MPC_QP_MODIFY_CMPL_FLAGS_FLAGS_QP_MD_PENDING
+	u8	v2;
+	#define MPC_QP_MODIFY_CMPL_V2     0x1UL
+	u8	reserved_3[3];
+	__le32	lag_src_mac;
+};
+
+/* mpc_event_resp_cmpl (size:256b/32B) */
+struct mpc_event_resp_cmpl {
+	u8	cmpl_type_reserved;
+	#define MPC_EVENT_RESP_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_MASK         0x3fUL
+	#define MPC_EVENT_RESP_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_SFT          0
+	#define MPC_EVENT_RESP_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_MPC_CMP_SHORT  0x1eUL
+	#define MPC_EVENT_RESP_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_MPC_CMP_LONG   0x1fUL
+	#define MPC_EVENT_RESP_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_LAST \
+		MPC_EVENT_RESP_CMPL_CMPL_TYPE_RESERVED_CMPL_TYPE_MPC_CMP_LONG
+	u8	error_code_mp_client;
+	#define MPC_EVENT_RESP_CMPL_ERROR_CODE_MP_CLIENT_ERROR_CODE_MASK 0xfUL
+	#define MPC_EVENT_RESP_CMPL_ERROR_CODE_MP_CLIENT_ERROR_CODE_SFT 0
+	#define MPC_EVENT_RESP_CMPL_ERROR_CODE_MP_CLIENT_MP_CLIENT_MASK 0xf0UL
+	#define MPC_EVENT_RESP_CMPL_ERROR_CODE_MP_CLIENT_MP_CLIENT_SFT  4
+	u8	req_type;
+	u8	req_subtype;
+	__le32	opaque;
+	u8	v;
+	#define MPC_EVENT_RESP_CMPL_V     0x1UL
+	u8	reserved_0[1];
+	__le16	error_code;
+	#define MPC_EVENT_RESP_CMPL_ERROR_CODE_SUCCESS 0x0UL
+	#define MPC_EVENT_RESP_CMPL_ERROR_CODE_FAIL    0x1UL
+	#define MPC_EVENT_RESP_CMPL_ERROR_CODE_LAST   MPC_EVENT_RESP_CMPL_ERROR_CODE_FAIL
+	__le32	xid;
+	__le32	event_type;
+	#define MPC_EVENT_RESP_CMPL_EVENT_TYPE_EVENT_TYPE_MASK    0xffffffffUL
+	#define MPC_EVENT_RESP_CMPL_EVENT_TYPE_EVENT_TYPE_SFT     0
+	#define MPC_EVENT_RESP_CMPL_EVENT_TYPE_EVENT_TYPE_QP_EVENT  0x1UL
+	#define MPC_EVENT_RESP_CMPL_EVENT_TYPE_EVENT_TYPE_LAST \
+		MPC_EVENT_RESP_CMPL_EVENT_TYPE_EVENT_TYPE_QP_EVENT
+	__le32	event_data;
+	#define MPC_EVENT_RESP_CMPL_EVENT_DATA_EVENT_TYPE_MASK              0xffffffffUL
+	#define MPC_EVENT_RESP_CMPL_EVENT_DATA_EVENT_TYPE_SFT               0
+	#define MPC_EVENT_RESP_CMPL_EVENT_DATA_EVENT_TYPE_FASTQP_MD_COMPLETE  0x0UL
+	#define MPC_EVENT_RESP_CMPL_EVENT_DATA_EVENT_TYPE_FASTQP_MD_PENDING   0x1UL
+	#define MPC_EVENT_RESP_CMPL_EVENT_DATA_EVENT_TYPE_LAST \
+		MPC_EVENT_RESP_CMPL_EVENT_DATA_EVENT_TYPE_FASTQP_MD_PENDING
+	u8	v2;
+	#define MPC_EVENT_RESP_CMPL_V2     0x1UL
+	u8	reserved_1[3];
+	__le32	resp_data;
+};
+
 #endif /* _BNG_RE_HSI_H_ */
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.h b/drivers/infiniband/hw/bng_re/bng_sp.h
index e15190515ed1..91faa5ac7464 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.h
+++ b/drivers/infiniband/hw/bng_re/bng_sp.h
@@ -9,6 +9,10 @@
 #define BNG_VAR_MAX_WQE		4352
 #define BNG_VAR_MAX_SGE		13
 
+#define NQE_CMP_VALID(hdr, pass)                        \
+	(!!(le32_to_cpu((hdr)->info63_v[0]) & NQ_BASE_V) ==   \
+	   !((pass) & BNG_RE_FLAG_EPOCH_CONS_MASK))
+
 struct bng_re_dev_attr {
 #define FW_VER_ARR_LEN			4
 	u8				fw_ver[FW_VER_ARR_LEN];
diff --git a/drivers/infiniband/hw/bng_re/bng_xid.c b/drivers/infiniband/hw/bng_re/bng_xid.c
new file mode 100644
index 000000000000..6070183d9120
--- /dev/null
+++ b/drivers/infiniband/hw/bng_re/bng_xid.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2025 Broadcom.
+
+#include <linux/bitops.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+
+#include "bng_re.h"
+#include "bng_res.h"
+#include "bng_sp.h"
+#include "bng_xid.h"
+#include "bng_fw.h"
+
+int bng_re_qp_alloc_xid_and_iqm(struct bng_re_res *res, u8 qp_type,
+				int num_xids, u32 max_wqe, int vf_id,
+				void *iqm_res, int *xid)
+{
+	dev_dbg(&res->pdev->dev,
+		"XID+IQM: enter qp_type=%u num_xids=%d max_wqe=%u vf_id=%d qp_xids=%p\n",
+		qp_type, num_xids, max_wqe, vf_id, res->qp_xids);
+
+	if (qp_type == CMDQ_CREATE_QP_TYPE_GSI) {
+		*xid = 1;
+		dev_dbg(&res->pdev->dev, "XID+IQM: GSI fixed xid=%d\n", *xid);
+		return 0;
+	}
+	if (qp_type == CMDQ_CREATE_QP_TYPE_RC) {
+		/* IQM not implemented yet */
+		return -EOPNOTSUPP;
+	}
+	if (!res->qp_xids) {
+		dev_dbg(&res->pdev->dev,
+			"XID+IQM: no driver qp_xids pool -> ENODEV\n");
+		return -ENODEV;
+	}
+	*xid = bng_re_xm_alloc_range(res->qp_xids, num_xids, vf_id);
+	if (*xid < 0) {
+		dev_dbg(&res->pdev->dev,
+			"XID+IQM: xm_alloc_range failed ret=%d num_xids=%d vf_id=%d\n",
+			*xid, num_xids, vf_id);
+		{
+			struct xid_public_stats st;
+
+			bng_re_xm_get_stats(res->qp_xids, &st);
+			dev_warn(&res->pdev->dev,
+				 "QP xid allocation failed, curr_active=%d max_active=%d alloc_ids=%llu\n",
+				 bng_re_xm_curr_active_get(res->qp_xids),
+				 bng_re_xm_max_active_get(res->qp_xids),
+				 st.xp_current_alloc_ids);
+		}
+		return -ENOMEM;
+	}
+	dev_dbg(&res->pdev->dev, "XID+IQM: xm_alloc ok xid=%d\n", *xid);
+	return 0;
+}
+
+void bng_re_qp_free_xid_and_iqm(struct bng_re_res *res, u8 qp_type, int xid,
+				void *iqm_res, bool free_qp_xid)
+{
+	if (qp_type == CMDQ_CREATE_QP_TYPE_GSI)
+		return;
+
+	if (free_qp_xid && res->qp_xids)
+		bng_re_xm_free_range(res->qp_xids, xid, true);
+}
+
+int bng_re_init_xid_tables(struct bng_re_dev *rdev)
+{
+	struct bng_re_res *res = &rdev->bng_res;
+	int qp_start = 2;
+	int qp_num_ids;
+	int qp_max;
+	int rc;
+
+	qp_max = (int)rdev->dev_attr->max_qp;
+	if (qp_max < 1)
+		return -EINVAL;
+	qp_num_ids = qp_max + 1024;
+
+	res->qp_xids = bng_re_xm_init(qp_start, qp_num_ids, qp_max, BNG_RE_XID_AVOID_REUSE);
+	if (!res->qp_xids)
+		return -ENOMEM;
+
+	res->ah_xids = bng_re_xm_init(0, (int)rdev->dev_attr->max_ah,
+				      (int)rdev->dev_attr->max_ah,
+				      BNG_RE_XID_AVOID_REUSE);
+	if (!res->ah_xids) {
+		rc = -ENOMEM;
+		goto free_qp_xm;
+	}
+
+	return 0;
+
+free_qp_xm:
+	bng_re_xm_destroy(res->qp_xids);
+	res->qp_xids = NULL;
+	return rc;
+}
+
+void bng_re_free_xid_tables(struct bng_re_res *res)
+{
+	if (res->ah_xids) {
+		bng_re_xm_destroy(res->ah_xids);
+		res->ah_xids = NULL;
+	}
+	if (res->qp_xids) {
+		bng_re_xm_destroy(res->qp_xids);
+		res->qp_xids = NULL;
+	}
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_xid.h b/drivers/infiniband/hw/bng_re/bng_xid.h
new file mode 100644
index 000000000000..f76babb546cf
--- /dev/null
+++ b/drivers/infiniband/hw/bng_re/bng_xid.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2025 Broadcom. */
+
+#ifndef __BNG_XID_H__
+#define __BNG_XID_H__
+
+#include <linux/kernel.h>
+
+#include "bng_roce_hsi.h"
+#include "xid_allocator.h"
+
+struct bng_re_dev;
+struct bng_re_res;
+
+#define ROUND_UP_SIZE_BNG(n, sz) round_up(n, sz)
+
+int bng_re_qp_alloc_xid_and_iqm(struct bng_re_res *res, u8 qp_type,
+				int num_xids, u32 max_wqe, int vf_id,
+				void *iqm_res, int *xid);
+void bng_re_qp_free_xid_and_iqm(struct bng_re_res *res, u8 qp_type, int xid,
+				void *iqm_res, bool free_qp_xid);
+
+int bng_re_init_xid_tables(struct bng_re_dev *rdev);
+void bng_re_free_xid_tables(struct bng_re_res *res);
+
+#endif /* __BNG_XID_H__ */
diff --git a/drivers/infiniband/hw/bng_re/bng_xid_allocator.c b/drivers/infiniband/hw/bng_re/bng_xid_allocator.c
new file mode 100644
index 000000000000..41dfb83a0a92
--- /dev/null
+++ b/drivers/infiniband/hw/bng_re/bng_xid_allocator.c
@@ -0,0 +1,870 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2025 Broadcom.
+
+#include "xid_allocator.h"
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/stddef.h>
+/* #include <string.h> - required for standalone compile */
+
+#define DEBUG_XID (g_debug_xid)
+
+int g_debug_xid;
+
+static void bng_re_xm_consolidate_ranges(struct xid_manager *xm,
+					 struct xid_node_info *prev,
+					 struct rb_root *tree
+);
+
+static int bng_re_xm_trans_range_by_pointer(struct xid_manager *xm, struct xid_node_info *nd);
+
+/**
+ * bng_re_xm_rb_insert - common fn for inserting range into rb tree
+ *
+ *	@param	root - root of rb tree to insert into
+ *	@param	data - range to insert
+ *	@param	fn - function for compare
+ *	@param	return - true for success, false for an issue (duplicate key)
+ */
+static int bng_re_xm_rb_insert(struct rb_root *root, struct xid_node_info *data,
+			       rb_compare_fn_t fn)
+{
+	struct rb_node **new = &root->rb_node, *parent = NULL;
+
+	/* Figure out where to put new node */
+	while (*new) {
+		struct xid_node_info *this = container_of(*new, struct xid_node_info, node);
+		int result = fn(data, this);
+
+		parent = *new;
+		if (result < 0)
+			new = &((*new)->rb_left);
+		else if (result > 0)
+			new = &((*new)->rb_right);
+		else
+			return false;
+	}
+
+	/* Add new node and rebalance tree. */
+	rb_link_node(&data->node, parent, new);
+	rb_insert_color(&data->node, root);
+
+	return true;
+}
+
+static int bng_re_xi_free_compare(void *left, void *right)
+{
+	struct xid_node_info *lp = (struct xid_node_info *)left;
+	struct xid_node_info *rp = (struct xid_node_info *)right;
+
+	if (lp->xi_num_ids != rp->xi_num_ids)
+		return lp->xi_num_ids - rp->xi_num_ids;
+
+	return lp->xi_starting_id - rp->xi_starting_id;
+}
+
+static int bng_re_xi_alloced_compare(void *left, void *right)
+{
+	struct xid_node_info *lp = (struct xid_node_info *)left;
+	struct xid_node_info *rp = (struct xid_node_info *)right;
+
+	return lp->xi_starting_id - rp->xi_starting_id;
+}
+
+/**************************************************
+ * util fns for the id based tree				  *
+ **************************************************/
+
+/**
+ * bng_re_xm_insert_by_id -  insert info into xid based tree.	Info is a range
+ *of available ids
+ *
+ *	@param	root - root of rb tree to insert into
+ *	@param	data - range to insert
+ *	@param	return - 0 for success, -1 for error
+ */
+static int bng_re_xm_insert_by_id(struct rb_root *root,
+				  struct xid_node_info *data)
+{
+	return bng_re_xm_rb_insert(root, data, bng_re_xi_alloced_compare);
+}
+
+/**
+ * bng_re_xm_search_by_id -  search xid based tree.
+ *
+ *	@param	root - root of rb tree to search
+ *	@param	xid - xid to search
+ *	@param	return - range which was found; or NULL
+ */
+static struct xid_node_info *bng_re_xm_search_by_id(struct rb_root *root, int xid)
+{
+	struct rb_node *node = root->rb_node;
+
+	while (node) {
+		struct xid_node_info *data = container_of(node, struct xid_node_info, node);
+		int result;
+
+		result = xid - data->xi_starting_id;
+
+		if (result < 0)
+			node = node->rb_left;
+		else if (result > 0)
+			node = node->rb_right;
+		else
+			return data;
+	}
+	return NULL;
+}
+
+/**************************************************
+ * util fns for the free range based tree		  *
+ **************************************************/
+
+/**
+ * bng_re_xm_insert_by_free_range -  insert info into range based tree.
+ *							  Info is a range of ids. Order by
+ *range size.
+ *
+ *	@param	root - root of rb tree to insert into
+ *	@param	data - range to insert
+ *	@return      - 0 for success, -1 for error
+ */
+static int bng_re_xm_insert_by_free_range(struct rb_root *root,
+					  struct xid_node_info *data)
+{
+	return bng_re_xm_rb_insert(root, data, bng_re_xi_free_compare);
+}
+
+/**
+ * bng_re_xm_search_best_free -  look for best range for requested number of
+ *   ids.
+ *
+ *	@param	root - root of rb tree to insert into
+ *	@param	ids_required - number of ids needed
+ *	@return	         - best matching range
+ */
+static struct xid_node_info *bng_re_xm_search_best_free(struct rb_root *root,
+							int ids_required)
+{
+	struct rb_node *node = root->rb_node;
+	struct xid_node_info *best = NULL;
+
+	while (node) {
+		struct xid_node_info *data = container_of(node, struct xid_node_info, node);
+
+		if (data->xi_num_ids == ids_required) {
+			best = data;
+			break;
+		} else if (data->xi_num_ids > ids_required) {
+			best = data;
+			node = node->rb_left;
+		} else {
+			node = node->rb_right;
+		}
+	}
+	return best;
+}
+
+/**
+ * bng_re_xm_reset_pending_ranges -
+ *
+ *	@param	root - root of rb tree to insert into
+ */
+static	int bng_re_xm_reset_pending_ranges(struct xid_manager *xm)
+{
+	struct rb_root *root = &xm->xm_pending_tree;
+	struct rb_node *node = root->rb_node;
+	struct xid_node_info *data = NULL;
+	int num_resets = 0;
+	/* pending => free tree */
+	while (node) {
+		data = container_of(node, struct xid_node_info, node);
+		num_resets++;
+		bng_re_xm_trans_range_by_pointer(xm, data);
+		node = root->rb_node;
+	}
+	return num_resets;
+}
+
+/**
+ * bng_re_xm_search_best_free_wrapper -  look for best range for requested number of
+ *ids.
+ *
+ *	@param	root - root of rb tree to insert into
+ *	@param	ids_required - number of ids needed
+ *	@param	best range or NULL
+ */
+static struct xid_node_info *bng_re_xm_search_best_free_wrapper(struct xid_manager *xm,
+								int ids_required)
+{
+	struct xid_node_info *best = NULL;
+	int num_resets;
+
+	best = bng_re_xm_search_best_free(&xm->xm_free_tree, ids_required);
+	if (!best) {
+		num_resets = bng_re_xm_reset_pending_ranges(xm);
+		if (num_resets > 0)
+			best = bng_re_xm_search_best_free(&xm->xm_free_tree, ids_required);
+	}
+	return best;
+}
+
+/* for all trees - common removal function */
+static void bng_re_xm_del_from_tree(struct rb_root *root,
+				    struct xid_node_info *data)
+{
+	if (data)
+		rb_erase(&data->node, root);
+}
+
+/**************************************************
+ * util fns for the xid_node_info				  *
+ **************************************************/
+
+static struct xid_node_info *bng_re_xm_tree_info_alloc(void)
+{
+	struct xid_node_info *xi = (struct xid_node_info *)CALLOC(1, sizeof(struct xid_node_info));
+	return xi;
+}
+
+static void bng_re_xm_tree_info_del(struct xid_node_info *xi)
+{
+	memset(xi, 0xa5, sizeof(*xi));
+	FREE(xi);
+}
+
+/**
+ *	bng_re_xm_init - initialize xid manager structure
+ *
+ *	@param	start_id - starting id
+ *	@param	max_ids - size of id pool
+ *	@param	max_active_ids - cap on active IDs (caller passes e.g. max_ids for AH/IQM)
+ *	@param	avoid_reuse - whether or not to avoid immediate xid reuse
+ *
+ *	@return - xid manager, or NULL on failure (e.g. max_active_ids > max_ids)
+ */
+struct xid_manager *bng_re_xm_init(int start_id, int max_ids, int max_active_ids,
+				   bool avoid_reuse)
+{
+	struct xid_manager *p = CALLOC(1, sizeof(struct xid_manager));
+	struct xid_node_info *xi = NULL;
+
+	if (!p)
+		return NULL;
+	if (max_active_ids > max_ids)
+		goto err;
+	spin_lock_init(&p->xm_lock);
+	p->xm_free_tree = RB_ROOT;
+	p->xm_allocated_tree = RB_ROOT;
+	p->xm_pending_tree = RB_ROOT;
+	p->xm_num_ids = max_ids;
+	p->xm_starting_id = start_id;
+	p->xm_max_active_ids = max_active_ids;
+	p->xm_curr_active_ids = 0;
+	/* Add initial range to the free tree */
+	xi = bng_re_xm_tree_info_alloc();
+	xi->xi_starting_id = start_id;
+	xi->xi_num_ids = max_ids;
+	xi->xi_state = X_FREED;
+	bng_re_xm_insert_by_free_range(&p->xm_free_tree, xi);
+	p->xm_head = xi;
+	p->xm_avoid_reuse = avoid_reuse;
+	/* Initialize current counters - start with all IDs in free state */
+	p->xm_stats.xs_current_free_ids = max_ids;
+	p->xm_stats.xs_current_alloc_ids = 0;
+	p->xm_stats.xs_current_pending_free_ids = 0;
+	p->xm_stats.xs_max_alloc_ids = 0;
+	return p;
+err:
+	FREE(p);
+	return NULL;
+}
+
+static struct xid_node_info *bng_re_xm_find_best_free_range(struct xid_manager *xm,
+							    int num_ids)
+{
+	struct xid_node_info *best = NULL;
+
+	best = bng_re_xm_search_best_free_wrapper(xm, num_ids);
+
+	return best;
+}
+
+/**
+ *	bng_re_xm_alloc_range - Allocate a range from the free pool
+ *
+ *	@param	xm -
+ *	@param	num_ids - number of ids required
+ *	@param	tag - tag for the allocation
+ *
+ *	@return - starting id for the range, or negative on failure
+ */
+int bng_re_xm_alloc_range(struct xid_manager *xm, int num_ids, int tag)
+{
+	struct xid_node_info *xi_alloced;
+	struct xid_node_info *xi_free;
+	int starting_id = -1;
+	unsigned long flags;
+
+	spin_lock_irqsave(&xm->xm_lock, flags);
+	if (xm->xm_curr_active_ids >= xm->xm_max_active_ids) {
+		xm->xm_stats.xs_alloc_err_active_limit_ctr++;
+		goto exit;
+	}
+	xi_free = bng_re_xm_find_best_free_range(xm, num_ids);
+
+	if (!xi_free) {
+		/* couldnt find that joint */
+		xm->xm_stats.xs_alloc_err_ctr++;
+		goto exit;
+	}
+
+	/*remove it from the tree because; after we change the num ids
+	 * it has to be reinserted into the optimal position
+	 */
+	bng_re_xm_del_from_tree(&xm->xm_free_tree, xi_free);
+
+	if (num_ids == xi_free->xi_num_ids) {
+		/* an exact fit.	 Just move it to the allocated tree */
+		xi_free->xi_state = X_ALLOCED;
+		bng_re_xm_insert_by_id(&xm->xm_allocated_tree, xi_free);
+		starting_id = xi_free->xi_starting_id;
+		xi_free->xi_tag = tag;
+		goto count_exit;
+	}
+	/* not exact match. need a range split */
+	xi_alloced = bng_re_xm_tree_info_alloc();
+	*xi_alloced = *xi_free;
+	xi_alloced->xi_next = xi_free;
+	xi_alloced->xi_num_ids = num_ids;
+	xi_alloced->xi_state = X_ALLOCED;
+	xi_alloced->xi_tag = tag;
+	if (xi_free->xi_prev)
+		xi_free->xi_prev->xi_next = xi_alloced;
+	/* We copied over the other fields already : starting id, prev ptr */
+	bng_re_xm_insert_by_id(&xm->xm_allocated_tree, xi_alloced);
+
+	/* adjust the range of the free entries */
+	xi_free->xi_prev = xi_alloced;
+	xi_free->xi_starting_id += num_ids;
+	xi_free->xi_num_ids -= num_ids;
+	/* Now reinsert into the free tree */
+	bng_re_xm_insert_by_free_range(&xm->xm_free_tree, xi_free);
+	if (xm->xm_head == xi_free) {
+		/*newly alloced entry may be the first one */
+		xm->xm_head = xi_alloced;
+	}
+	starting_id = xi_alloced->xi_starting_id;
+count_exit:
+	/* Update current counters: move IDs to allocated tree */
+	xm->xm_stats.xs_current_free_ids -= num_ids;
+	xm->xm_stats.xs_current_alloc_ids += num_ids;
+	xm->xm_curr_active_ids++;
+	/* Update maximum allocated IDs if we reached a new high */
+	if (xm->xm_stats.xs_current_alloc_ids > xm->xm_stats.xs_max_alloc_ids)
+		xm->xm_stats.xs_max_alloc_ids = xm->xm_stats.xs_current_alloc_ids;
+	xm->xm_stats.xs_alloc_op_ctr++;
+	xm->xm_stats.xs_alloc_count_ctr += num_ids;
+exit:
+	spin_unlock_irqrestore(&xm->xm_lock, flags);
+	return starting_id;
+}
+
+/**
+ *	bng_re_xm_free_range - find a range by id and free it, optionally
+ *	decrementing the active-id count.
+ *
+ *	@param	xm - xid manager
+ *	@param	id - id of range to free, or BNG_RE_XID_DECR_ONLY for decr only
+ *	@param	decr_active - if true, decrement curr_active_ids; for normal id
+ *		also remove from tree. For BNG_RE_XID_DECR_ONLY must be true.
+ *	@return - 0 for success, negative on error
+ */
+int bng_re_xm_free_range(struct xid_manager *xm, int id, bool decr_active)
+{
+	struct xid_node_info *xi_alloced;
+	unsigned long flags;
+	int rc = -1;
+	int num_ids;
+
+	spin_lock_irqsave(&xm->xm_lock, flags);
+
+	/*	dump_stack(); */
+	if (id == BNG_RE_XID_DECR_ONLY) {
+		if (!decr_active) {
+			/* spec: log error */
+			XID_PRINT("xid free: BNG_RE_XID_DECR_ONLY with decr_active false\n");
+			goto exit;
+		}
+		xm->xm_curr_active_ids--;
+		xm->xm_stats.xs_free_decr_only++;
+		rc = 0;
+		goto exit;
+	}
+
+	xi_alloced = bng_re_xm_search_by_id(&xm->xm_allocated_tree, id);
+	if (!xi_alloced) {
+		xm->xm_stats.xs_free_err_ctr++;
+		goto exit;
+	}
+	num_ids = xi_alloced->xi_num_ids;
+	bng_re_xm_trans_range_by_pointer(xm, xi_alloced);
+	xm->xm_stats.xs_free_op_ctr++;
+	xm->xm_stats.xs_free_count_ctr += num_ids;
+	if (decr_active) {
+		xm->xm_curr_active_ids--;
+		xm->xm_stats.xs_free_decr_and_remove++;
+	} else {
+		xm->xm_stats.xs_free_remove_only++;
+	}
+	rc = 0;
+exit:
+	spin_unlock_irqrestore(&xm->xm_lock, flags);
+	return rc;
+}
+
+#ifdef STANDALONE_BUILD
+struct xid_node_info *bng_re_xm_find_allocated(struct xid_manager *xm, int id)
+{
+	struct xid_node_info *n;
+
+	n = bng_re_xm_search_by_id(&xm->xm_allocated_tree, id);
+	return n;
+}
+#endif
+
+bool bng_re_xm_is_id_allocated(struct xid_manager *xm, int id)
+{
+	struct xid_node_info *n = NULL;
+
+	n = bng_re_xm_search_by_id(&xm->xm_allocated_tree, id);
+
+	return n ? true : false;
+}
+
+/**
+ *	bng_re_xm_trans_range_by_pointer - trans range to next tree
+ *
+ *	@param	xm -
+ *	@param	 struct xid_node_info * - node to free
+ *	@param	 new_state = new state to go to
+ *	@return - 0 for success
+ */
+static int bng_re_xm_trans_range_by_pointer(struct xid_manager *xm, struct xid_node_info *nd)
+{
+	struct rb_root *curr_tree;
+	struct rb_root *new_tree;
+	int target_state;
+
+	if (xm->xm_avoid_reuse) {
+		if (nd->xi_state == X_ALLOCED) {
+			curr_tree = &xm->xm_allocated_tree;
+			new_tree = &xm->xm_pending_tree;
+			target_state = X_FREE_PENDING;
+		} else if (nd->xi_state == X_FREE_PENDING) {
+			curr_tree = &xm->xm_pending_tree;
+			new_tree = &xm->xm_free_tree;
+			target_state = X_FREED;
+		} else {
+			return -1;
+		}
+	} else {
+		if (nd->xi_state == X_ALLOCED) {
+			curr_tree = &xm->xm_allocated_tree;
+			new_tree = &xm->xm_free_tree;
+			target_state = X_FREED;
+		} else {
+			return -1;
+		}
+	}
+
+	bng_re_xm_del_from_tree(curr_tree, nd);
+
+	/* Update current counters based on state transition */
+	if (nd->xi_state == X_ALLOCED && target_state == X_FREE_PENDING) {
+		/* ALLOCED -> PENDING: move IDs from allocated to pending */
+		xm->xm_stats.xs_current_alloc_ids -= nd->xi_num_ids;
+		xm->xm_stats.xs_current_pending_free_ids += nd->xi_num_ids;
+	} else if (nd->xi_state == X_FREE_PENDING && target_state == X_FREED) {
+		/* PENDING -> FREE: move IDs from pending to free */
+		xm->xm_stats.xs_current_pending_free_ids -= nd->xi_num_ids;
+		xm->xm_stats.xs_current_free_ids += nd->xi_num_ids;
+	} else if (nd->xi_state == X_ALLOCED && target_state == X_FREED) {
+		/* ALLOCED -> FREE (direct): move IDs from allocated to free */
+		xm->xm_stats.xs_current_alloc_ids -= nd->xi_num_ids;
+		xm->xm_stats.xs_current_free_ids += nd->xi_num_ids;
+	}
+
+	nd->xi_state = target_state;
+	bng_re_xm_insert_by_free_range(new_tree, nd);
+
+	if (nd->xi_next && nd->xi_next->xi_state == target_state)
+		bng_re_xm_consolidate_ranges(xm, nd, new_tree);
+	if (nd->xi_prev && nd->xi_prev->xi_state == target_state)
+		bng_re_xm_consolidate_ranges(xm, nd->xi_prev, new_tree);
+	return 0;
+}
+
+/**
+ *	bng_re_xm_consolidate_ranges - combine 2 ranges.
+ *
+ *	@param	xm - xid manager
+ *	@param	prev - previous range; which will include
+ *				   the next block after this call
+ */
+static void bng_re_xm_consolidate_ranges(struct xid_manager *xm,
+					 struct xid_node_info *prev,
+					 struct rb_root *root)
+{
+	struct xid_node_info *next;
+
+	next = prev->xi_next;
+
+	bng_re_xm_del_from_tree(root, prev);
+	bng_re_xm_del_from_tree(root, next);
+
+	prev->xi_num_ids += next->xi_num_ids;
+	prev->xi_next = next->xi_next;
+	if (next->xi_next)
+		next->xi_next->xi_prev = prev;
+
+	/* note we only consolidate in free or free pending trees */
+	bng_re_xm_insert_by_free_range(root, prev);
+	bng_re_xm_tree_info_del(next);
+}
+
+static char *bng_re_map_xi_state_to_string(int state)
+{
+	switch (state) {
+	case X_FREED:
+		return("FREED");
+	case X_FREE_PENDING:
+		return ("FREE_PENDING");
+	case X_ALLOCED:
+		return("ALLOCED");
+	}
+	return("unknown");
+}
+
+static bool bng_re_xm_print_one_range(void *p)
+{
+	struct xid_node_info *info = (struct xid_node_info *)p;
+	char *state = bng_re_map_xi_state_to_string(info->xi_state);
+
+	if (info && state) {
+		XID_PRINT("    info:[%p](start:%d,num_ids:%d,xi_state:%s,nxt:%p,prev:%p,tag:%d\n ",
+			  info, info->xi_starting_id, info->xi_num_ids,
+			  state, info->xi_next, info->xi_prev, info->xi_tag);
+	}
+	return false;
+}
+
+/* FIXME: move to xm manager */
+struct xid_node_info *g_searched_node;
+int g_searched_id;
+
+#ifdef STANDALONE_BUILD
+/**
+ *	bng_re_xm_search_free_node_for_id -  Find a node with a specific id
+ *
+ *	@param	p - node whose id we're searching for
+ */
+bool bng_re_xm_search_free_node_for_id(void *p)
+{
+	struct xid_node_info *info = (struct xid_node_info *)p;
+
+	if (info->xi_starting_id == g_searched_id) {
+		g_searched_node = info;
+		return true;
+	}
+	return false;
+}
+#endif
+
+/**
+ * bng_re_xm_rb_in_order_tree -  traverse rb tree in order and execute a
+ *function
+ *
+ *	@param	root - root of rb tree to insert into
+ *	@param	fn - range function to execute
+ */
+static void bng_re_xm_rb_in_order_tree(struct rb_root *root,
+				       rb_print_fn_t fn)
+{
+	struct rb_node *next_nd;
+	struct rb_node *nd;
+	bool quit = false;
+
+	nd = rb_first(root);
+
+	while (nd) {
+		next_nd = rb_next(nd);
+		quit = fn(nd);
+		if (quit)
+			break;
+		nd = next_nd;
+	}
+}
+
+/**
+ * bng_re_xm_print_all_ranges -  debug fn to print range for one xid manager
+ *
+ *	@param	xm - xid manager
+ */
+static void bng_re_xm_print_all_ranges(struct xid_manager *xm)
+{
+	/* first have to find 0 elem */
+	struct xid_node_info *p;
+
+	p = xm->xm_head;
+	while (p) {
+		bng_re_xm_print_one_range(p);
+		p = p->xi_next;
+	}
+}
+
+static void bng_re_xm_print_free_tree(struct xid_manager *xm)
+{
+	bng_re_xm_rb_in_order_tree(&xm->xm_free_tree,
+				   bng_re_xm_print_one_range);
+}
+
+static void bng_re_xm_print_allocated_tree(struct xid_manager *xm)
+{
+	bng_re_xm_rb_in_order_tree(&xm->xm_allocated_tree,
+				   bng_re_xm_print_one_range);
+}
+
+static void bng_re_xm_print_pending_tree(struct xid_manager *xm)
+{
+	bng_re_xm_rb_in_order_tree(&xm->xm_pending_tree,
+				   bng_re_xm_print_one_range);
+}
+
+void bng_re_xm_print_all_info(struct xid_manager *xm)
+{
+	struct xid_public_stats stats;
+
+	XID_PRINT("   ====================\n");
+	XID_PRINT("   FREE tree\n");
+	bng_re_xm_print_free_tree(xm);
+	XID_PRINT("   ====================\n");
+	XID_PRINT("   ALLOC tree\n");
+	bng_re_xm_print_allocated_tree(xm);
+	XID_PRINT("   ====================\n");
+	XID_PRINT("   FREE pending tree\n");
+	bng_re_xm_print_pending_tree(xm);
+	XID_PRINT("   ====================\n");
+	XID_PRINT("   MEM list\n");
+	bng_re_xm_print_all_ranges(xm);
+	XID_PRINT("   ====================\n");
+	bng_re_xm_get_stats(xm, &stats);
+	XID_PRINT("   Stats:alloc_op:%lu,allced_ids:%lu,allc_errs:%lu,allc_err_active_limit:%lu\n",
+		  stats.xp_alloc_op_ctr,
+		  stats.xp_alloc_count_ctr,
+		  stats.xp_alloc_err_ctr,
+		  stats.xp_alloc_err_active_limit_ctr);
+	XID_PRINT("   Stats: free_op:%lu, freed_ids:%lu, free_errs:%lu\n",
+		  stats.xp_free_op_ctr,
+		  stats.xp_free_count_ctr,
+		  stats.xp_free_err_ctr);
+	XID_PRINT("   Gauge: starting id:%lu, num_ids:%lu, largest block:%lu\n",
+		  stats.xp_starting_id_ge,
+		  stats.xp_num_ids_ge,
+		  stats.xp_largest_free_block_ge);
+	XID_PRINT("   Current: alloc_ids:%lu, pending_ids:%lu, free_ids:%lu\n",
+		  stats.xp_current_alloc_ids,
+		  stats.xp_current_pending_free_ids,
+		  stats.xp_current_free_ids);
+	XID_PRINT("   Peak: max_alloc_ids:%lu (%.1f%% of capacity)\n",
+		  stats.xp_max_alloc_ids,
+		  stats.xp_num_ids_ge > 0 ?
+		  (stats.xp_max_alloc_ids * 100.0) / stats.xp_num_ids_ge : 0.0);
+}
+
+/**
+ * bng_re_xm_free_node_matching_tag- optionally free a node if it matches
+ *   a tag.  Handle repercussions of node free.
+ *
+ *	@param	xm - xid manager
+ *	@param	tag - tag id to free
+ *	@param	nd - node to (maybe) free
+ *
+ *	@return next node
+ */
+static struct xid_node_info *bng_re_xm_free_node_matching_tag(struct xid_manager *xm,
+							      int tag,
+							      struct xid_node_info *nd)
+{
+	struct xid_node_info *next;
+
+	next = nd->xi_next;
+	if (nd && nd->xi_tag == tag && nd->xi_state == X_ALLOCED) {
+		/* before we free anything- have to calculate the next. */
+		if (next) {
+			/* if the next node is not allocated,
+			 * then it may be consolidated and freed. we need to
+			 * go to the one after.
+			 */
+			if (xm->xm_avoid_reuse) {
+				if (next->xi_state == X_FREE_PENDING)
+					next = next->xi_next;
+			}  else {
+				if (next->xi_state == X_FREED)
+					next = next->xi_next;
+			}
+		}
+		bng_re_xm_trans_range_by_pointer(xm, nd);
+	}
+	return next;
+}
+
+/**
+ * bng_re_xm_free_tag -  free all entries which match a tag
+ *   We do this by finding the first allocated node in alloced tree;
+ *   then walking the linked list of ranges to find matches.
+ *
+ *	@param	xm - xid manager
+ *	@param	tag - tag id to free
+ */
+void bng_re_xm_free_tag(struct xid_manager *xm, int tag)
+{
+	struct xid_node_info *nd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&xm->xm_lock, flags);
+	nd = (struct xid_node_info *)rb_first(&xm->xm_allocated_tree);
+	while (nd)
+		nd = bng_re_xm_free_node_matching_tag(xm, tag, nd);
+
+	spin_unlock_irqrestore(&xm->xm_lock, flags);
+}
+
+static int bng_re_xm_get_largest_free_block(struct xid_manager *xm)
+{
+	struct xid_node_info *nd;
+	int num_ids = 0;
+
+	nd = (struct xid_node_info *)rb_last(&xm->xm_free_tree);
+	if (nd)
+		num_ids = nd->xi_num_ids;
+	return num_ids;
+}
+
+/**
+ * bng_re_xm_get_stats -  get the stats of this xid manager for external consumption
+ *
+ *	@param	xm - xid manager
+ */
+void bng_re_xm_get_stats(struct xid_manager *xm, struct xid_public_stats *stats)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xm->xm_lock, flags);
+
+	memset(stats, 0, sizeof(*stats));
+
+	stats->xp_alloc_op_ctr = xm->xm_stats.xs_alloc_op_ctr;
+	stats->xp_alloc_count_ctr = xm->xm_stats.xs_alloc_count_ctr;
+	stats->xp_alloc_err_ctr = xm->xm_stats.xs_alloc_err_ctr;
+	stats->xp_alloc_err_active_limit_ctr = xm->xm_stats.xs_alloc_err_active_limit_ctr;
+	stats->xp_free_op_ctr = xm->xm_stats.xs_free_op_ctr;
+	stats->xp_free_count_ctr = xm->xm_stats.xs_free_count_ctr;
+	stats->xp_free_err_ctr = xm->xm_stats.xs_free_err_ctr;
+	stats->xp_starting_id_ge = xm->xm_starting_id;
+	stats->xp_num_ids_ge = xm->xm_num_ids;
+	stats->xp_largest_free_block_ge = bng_re_xm_get_largest_free_block(xm);
+	stats->xp_current_alloc_ids = xm->xm_stats.xs_current_alloc_ids;
+	stats->xp_current_pending_free_ids = xm->xm_stats.xs_current_pending_free_ids;
+	stats->xp_current_free_ids = xm->xm_stats.xs_current_free_ids;
+	stats->xp_max_alloc_ids = xm->xm_stats.xs_max_alloc_ids;
+	stats->xp_max_active_ids = (u64)xm->xm_max_active_ids;
+	stats->xp_curr_active_ids = (u64)xm->xm_curr_active_ids;
+	stats->xp_free_decr_and_remove = xm->xm_stats.xs_free_decr_and_remove;
+	stats->xp_free_decr_only = xm->xm_stats.xs_free_decr_only;
+	stats->xp_free_remove_only = xm->xm_stats.xs_free_remove_only;
+	stats->xp_current_pending_entries = (u64)(xm->xm_stats.xs_current_alloc_ids -
+						  xm->xm_curr_active_ids);
+	if (stats->xp_current_pending_entries > stats->xp_current_alloc_ids)
+		stats->xp_current_pending_entries = 0;
+	spin_unlock_irqrestore(&xm->xm_lock, flags);
+}
+
+void bng_re_xm_curr_active_set(struct xid_manager *xm, int val)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xm->xm_lock, flags);
+	xm->xm_curr_active_ids = val;
+	spin_unlock_irqrestore(&xm->xm_lock, flags);
+}
+
+void bng_re_xm_curr_active_inc(struct xid_manager *xm)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xm->xm_lock, flags);
+	xm->xm_curr_active_ids++;
+	spin_unlock_irqrestore(&xm->xm_lock, flags);
+}
+
+void bng_re_xm_curr_active_dec(struct xid_manager *xm)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xm->xm_lock, flags);
+	xm->xm_curr_active_ids--;
+	spin_unlock_irqrestore(&xm->xm_lock, flags);
+}
+
+int bng_re_xm_curr_active_get(struct xid_manager *xm)
+{
+	unsigned long flags;
+	int v;
+
+	spin_lock_irqsave(&xm->xm_lock, flags);
+	v = xm->xm_curr_active_ids;
+	spin_unlock_irqrestore(&xm->xm_lock, flags);
+	return v;
+}
+
+int bng_re_xm_max_active_get(struct xid_manager *xm)
+{
+	unsigned long flags;
+	int v;
+
+	spin_lock_irqsave(&xm->xm_lock, flags);
+	v = xm->xm_max_active_ids;
+	spin_unlock_irqrestore(&xm->xm_lock, flags);
+	return v;
+}
+
+static void bng_re_xm_destroy_tree(struct rb_root *root)
+{
+	struct xid_node_info *kn;
+	struct rb_node *n;
+
+	while ((n = rb_first(root))) {
+		kn = rb_entry(n, struct xid_node_info, node);
+		rb_erase(n, root);
+		bng_re_xm_tree_info_del(kn);
+	}
+}
+
+void bng_re_xm_destroy(struct xid_manager *xm)
+{
+	unsigned long flags;
+
+	if (!xm)
+		return;
+	spin_lock_irqsave(&xm->xm_lock, flags);
+	bng_re_xm_destroy_tree(&xm->xm_free_tree);
+	bng_re_xm_destroy_tree(&xm->xm_allocated_tree);
+	bng_re_xm_destroy_tree(&xm->xm_pending_tree);
+	xm->xm_head = NULL;
+	spin_unlock_irqrestore(&xm->xm_lock, flags);
+	kfree(xm);
+}
+
+/* temp */
diff --git a/drivers/infiniband/hw/bng_re/xid_allocator.h b/drivers/infiniband/hw/bng_re/xid_allocator.h
new file mode 100644
index 000000000000..db9c77f63986
--- /dev/null
+++ b/drivers/infiniband/hw/bng_re/xid_allocator.h
@@ -0,0 +1,114 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2026 Broadcom */
+
+#ifndef XID_ALLOCATOR_H
+#define XID_ALLOCATOR_H
+
+#include <linux/rbtree.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+
+#define CALLOC(NMEMB, SIZE)  kcalloc(NMEMB, SIZE, GFP_ATOMIC)
+#define FREE(PTR)            kfree(PTR)
+#define XID_PRINT(...)
+#define ASSERT(...)          WARN_ON(__VA_ARGS__)
+
+typedef bool (*rb_print_fn_t)(void *);
+typedef int (*rb_compare_fn_t)(void *, void *);
+
+enum xid_range_state {
+	X_FREED = 1,
+	X_FREE_PENDING = 2,
+	X_ALLOCED = 3
+};
+
+/*Info block for an XID range */
+struct xid_node_info {
+	struct rb_node node;
+	int xi_starting_id;
+	int xi_num_ids;
+	enum xid_range_state xi_state;
+	/*
+	 * Note the linked list maintains the ranges in order
+	 *	of id ; whether they are in allocated tree or free tree
+	 */
+	struct xid_node_info *xi_next;
+	struct xid_node_info *xi_prev;
+	int xi_tag;  /* tag can identify VFs or other distinctions */
+};
+
+/* stats for an xid manager */
+struct xid_private_stats {
+	u64  xs_alloc_op_ctr; /* how many alloc ops were done */
+	u64  xs_alloc_count_ctr;   /* how many ids were alloced */
+	u64  xs_alloc_err_ctr;	   /* how many errs during alloc */
+	u64  xs_alloc_err_active_limit_ctr; /* alloc failures due to curr_active >= max_active */
+	u64  xs_free_op_ctr;  /* how many free ops were done */
+	u64  xs_free_count_ctr;	   /* how many ids were freed */
+	u64  xs_free_err_ctr;	   /*  errs during free */
+	u64  xs_current_alloc_ids;   /* current number of allocated IDs */
+	u64  xs_current_pending_free_ids; /* current number of pending IDs */
+	u64  xs_current_free_ids;    /* current number of free IDs */
+	u64  xs_max_alloc_ids;       /* maximum number of allocated IDs reached */
+	/* Deferred QP XID: free operations by semantics */
+	u64  xs_free_decr_and_remove;
+	u64  xs_free_decr_only;
+	u64  xs_free_remove_only;
+};
+
+struct xid_public_stats {
+	u64  xp_alloc_op_ctr; /* how many alloc ops were done */
+	u64  xp_alloc_count_ctr;   /* how many ids were alloced */
+	u64  xp_alloc_err_ctr;	   /* how many errs during alloc */
+	u64  xp_alloc_err_active_limit_ctr; /* alloc errs due to curr_active >= max_active */
+	u64  xp_free_op_ctr;  /* how many free ops were done */
+	u64  xp_free_count_ctr;	   /* how many ids were freed */
+	u64  xp_free_err_ctr;	   /*  errs during free */
+	u64  xp_starting_id_ge;		   /* start id */
+	u64  xp_num_ids_ge;		   /* num ids */
+	u64  xp_largest_free_block_ge;	/* largest free block */
+	u64  xp_current_alloc_ids;   /* current number of allocated IDs */
+	u64  xp_current_pending_free_ids; /* current number of pending IDs */
+	u64  xp_current_free_ids;    /* current number of free IDs */
+	u64  xp_max_alloc_ids;       /* maximum number of allocated IDs reached */
+	u64  xp_max_active_ids;      /* cap on active IDs */
+	u64  xp_curr_active_ids;     /* current active IDs */
+	u64  xp_free_decr_and_remove;
+	u64  xp_free_decr_only;
+	u64  xp_free_remove_only;
+	u64  xp_current_pending_entries; /* current_alloc_ids - curr_active_ids */
+};
+
+/* Special XID value for "decrement active count only" (no tree removal). */
+
+struct xid_manager {
+	struct rb_root xm_free_tree;
+	struct rb_root xm_allocated_tree;
+	struct rb_root xm_pending_tree;
+	struct xid_private_stats  xm_stats;
+	int xm_starting_id;
+	int xm_num_ids;
+	spinlock_t xm_lock; /* lock this instance of xm */
+	struct xid_node_info *xm_head;
+	bool xm_avoid_reuse;
+	int xm_max_active_ids;
+	int xm_curr_active_ids;
+};
+
+/* public api */
+struct xid_manager *bng_re_xm_init(int start_id, int max_ids, int max_active_ids,
+				   bool avoid_reuse);
+int bng_re_xm_alloc_range(struct xid_manager *xm, int num_ids, int tag);
+int bng_re_xm_free_range(struct xid_manager *xm, int id, bool decr_active);
+void bng_re_xm_print_all_info(struct xid_manager *xm);
+void bng_re_xm_free_tag(struct xid_manager *xm, int tag);
+void bng_re_xm_get_stats(struct xid_manager *xm, struct xid_public_stats *stats);
+bool bng_re_xm_is_id_allocated(struct xid_manager *xm, int id);
+void bng_re_xm_curr_active_set(struct xid_manager *xm, int val);
+void bng_re_xm_curr_active_inc(struct xid_manager *xm);
+void bng_re_xm_curr_active_dec(struct xid_manager *xm);
+int bng_re_xm_curr_active_get(struct xid_manager *xm);
+int bng_re_xm_max_active_get(struct xid_manager *xm);
+void bng_re_xm_destroy(struct xid_manager *xm);
+#define BNG_RE_XID_DECR_ONLY (-1)
+#endif
-- 
2.43.5

