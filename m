Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40EA4B04AC;
	Thu, 24 Sep 2026 17:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271100; cv=none; b=djmuW7scFVDvbl76c27lQxmavP08alfCadqKmS2SzX/BmFp5bHuBkZfwdfqIFB38rfDIJYXVPtzKO8tLUZyLDDCtBC6xNN7RdyGTcU+8kbfHF/uARr0SFYmHBadkzjq7nlaomwkPB3UCYW+RffB1OSu3u7RVJ6Woaq6nkuJWhJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271100; c=relaxed/simple;
	bh=VjxcgofiGH/t3NCS0XDXhA6xloEN/E64yUPwWoQIcJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqHRsKfWx6dCfQ1lQ7h/xri5r/B1/gCQ4MDMo5x2J6hPgphVag56ThKKjP9MDV8IHdqtXeCsPnSvXUS8Jgf1BorTYZDvG2JJWS+d/tyUriAzUevzHnBDxryl333MEntCiHGgrxoEaoTnZR/vcmdckNvpDNnatVXfFZO5ghY1/dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=nTrOnujR; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="nTrOnujR"
Received: from CPC-mawas-YGKSX.localdomain (unknown [70.37.26.38])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4935620B7168;
	Thu, 24 Sep 2026 10:30:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4935620B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1790271049;
	bh=uIb1eiHdIVb8bSc31QhDyyARh/K9Wk+i1CzUbq5AENA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTrOnujRYO03Yz6WFJccQu8EhjOzxS4NmaVOrMAZjhiDENl0jLe1+V07ErJvZ9Tro
	 FwZBvK3DPNxVID/D73osbsCThhMaND/cpOo9VLNkOx5EI7MGlKy9Hkp+w7F7/IuCfC
	 rfuDyalpX5xrzcwdlBnRcvdCacHu0159s6ahFGmM=
From: Manish Awasthi <mawasthi@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com
Cc: horms@kernel.org,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	nipun.gupta@amd.com,
	nikhil.agarwal@amd.com,
	gargaditya@linux.microsoft.com,
	ernis@linux.microsoft.com,
	kees@kernel.org,
	paulros@microsoft.com,
	mawasthi@microsoft.com
Subject: [PATCH net-next 3/4] net: mana: Build the PCI transport as a separate module
Date: Thu, 24 Sep 2026 17:30:53 +0000
Message-ID: <20260924173054.589291-4-mawasthi@linux.microsoft.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Build the shared GDMA and Ethernet code as gdma_core.ko, selected by
MICROSOFT_GDMA_CORE. Build the PCI transport separately as mana.ko and
export the required core symbols.

Preserve the PCI module name, device table, and mana.eth/mana.rdma
auxiliary-device names. Each transport registers its own bus driver.

Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>
---
 drivers/net/ethernet/microsoft/Kconfig        | 12 ++++++---
 drivers/net/ethernet/microsoft/Makefile       |  2 +-
 drivers/net/ethernet/microsoft/mana/Makefile  |  7 ++++--
 .../net/ethernet/microsoft/mana/gdma_main.c   | 25 ++++++-------------
 .../net/ethernet/microsoft/mana/gdma_pci.c    | 11 ++++++--
 drivers/net/ethernet/microsoft/mana/mana_en.c |  7 +++++-
 include/net/mana/gdma.h                       |  3 ---
 7 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/Kconfig b/drivers/net/ethernet/microsoft/Kconfig
index e9be18c92ca5..ee5bc1c1bf59 100644
--- a/drivers/net/ethernet/microsoft/Kconfig
+++ b/drivers/net/ethernet/microsoft/Kconfig
@@ -15,15 +15,19 @@ config NET_VENDOR_MICROSOFT
 
 if NET_VENDOR_MICROSOFT
 
+config MICROSOFT_GDMA_CORE
+	tristate
+	select AUXILIARY_BUS
+	select DIMLIB
+	select PAGE_POOL
+	select NET_SHAPER
+
 config MICROSOFT_MANA
 	tristate "Microsoft Azure Network Adapter (MANA) support"
 	depends on PCI_MSI
 	depends on X86_64 || (ARM64 && !CPU_BIG_ENDIAN)
 	depends on PCI_HYPERV
-	select AUXILIARY_BUS
-	select DIMLIB
-	select PAGE_POOL
-	select NET_SHAPER
+	select MICROSOFT_GDMA_CORE
 	help
 	  This driver supports Microsoft Azure Network Adapter (MANA).
 	  So far, the driver is only supported on X86_64.
diff --git a/drivers/net/ethernet/microsoft/Makefile b/drivers/net/ethernet/microsoft/Makefile
index d2ddc218135f..c3b6dafdf473 100644
--- a/drivers/net/ethernet/microsoft/Makefile
+++ b/drivers/net/ethernet/microsoft/Makefile
@@ -2,4 +2,4 @@
 # Makefile for the Microsoft Azure network device driver.
 #
 
-obj-$(CONFIG_MICROSOFT_MANA) += mana/
+obj-$(CONFIG_MICROSOFT_GDMA_CORE) += mana/
diff --git a/drivers/net/ethernet/microsoft/mana/Makefile b/drivers/net/ethernet/microsoft/mana/Makefile
index 6705bf65c92c..72c03fb6e441 100644
--- a/drivers/net/ethernet/microsoft/mana/Makefile
+++ b/drivers/net/ethernet/microsoft/mana/Makefile
@@ -2,6 +2,9 @@
 #
 # Makefile for the Microsoft Azure Network Adapter driver
 
+obj-$(CONFIG_MICROSOFT_GDMA_CORE) += gdma_core.o
+gdma_core-y := gdma_main.o shm_channel.o hw_channel.o mana_en.o mana_ethtool.o \
+	       mana_bpf.o
+
 obj-$(CONFIG_MICROSOFT_MANA) += mana.o
-mana-y := gdma_main.o shm_channel.o hw_channel.o mana_en.o mana_ethtool.o mana_bpf.o \
-	  gdma_pci.o
+mana-y := gdma_pci.o
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 531170e58a62..ae0ed700b3b9 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1991,6 +1991,7 @@ int mana_gd_setup(struct gdma_context *gc)
 	dev_err(gc->dev, "%s failed (error %d)\n", __func__, err);
 	return err;
 }
+EXPORT_SYMBOL_NS(mana_gd_setup, "NET_MANA");
 
 void mana_gd_cleanup(struct gdma_context *gc)
 {
@@ -2005,36 +2006,24 @@ void mana_gd_cleanup(struct gdma_context *gc)
 
 	dev_dbg(gc->dev, "mana gdma cleanup successful\n");
 }
+EXPORT_SYMBOL_NS(mana_gd_cleanup, "NET_MANA");
 
-static int __init mana_driver_init(void)
+static int __init gdma_core_init(void)
 {
-	int err;
-
 	mana_debugfs_root = debugfs_create_dir("mana", NULL);
 
-	err = mana_pci_driver_register();
-	if (err)
-		goto err_debugfs;
-
 	return 0;
-
-err_debugfs:
-	debugfs_remove(mana_debugfs_root);
-	mana_debugfs_root = NULL;
-	return err;
 }
 
-static void __exit mana_driver_exit(void)
+static void __exit gdma_core_exit(void)
 {
-	mana_pci_driver_unregister();
-
 	debugfs_remove(mana_debugfs_root);
 
 	mana_debugfs_root = NULL;
 }
 
-module_init(mana_driver_init);
-module_exit(mana_driver_exit);
+module_init(gdma_core_init);
+module_exit(gdma_core_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_DESCRIPTION("Microsoft Azure Network Adapter driver");
+MODULE_DESCRIPTION("Microsoft Azure Network Adapter GDMA core");
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_pci.c b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
index 4f6a77f55e5a..92a1e66e18b7 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_pci.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
@@ -878,7 +878,7 @@ static struct pci_driver mana_driver = {
 
 MODULE_DEVICE_TABLE(pci, mana_id_table);
 
-int mana_pci_driver_register(void)
+static int __init mana_driver_init(void)
 {
 	INIT_LIST_HEAD(&mana_dev_recovery_work.dev_list);
 	spin_lock_init(&mana_dev_recovery_work.lock);
@@ -888,7 +888,7 @@ int mana_pci_driver_register(void)
 	return pci_register_driver(&mana_driver);
 }
 
-void mana_pci_driver_unregister(void)
+static void __exit mana_driver_exit(void)
 {
 	struct mana_dev_recovery *dev;
 	unsigned long flags;
@@ -907,3 +907,10 @@ void mana_pci_driver_unregister(void)
 
 	pci_unregister_driver(&mana_driver);
 }
+
+module_init(mana_driver_init);
+module_exit(mana_driver_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("Microsoft Azure Network Adapter driver");
+MODULE_IMPORT_NS("NET_MANA");
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 62b89b3d6072..16a9d192c099 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3957,7 +3957,8 @@ static int add_adev(struct gdma_dev *gd, const char *name)
 
 	/* madev is owned by the auxiliary device */
 	madev = NULL;
-	ret = auxiliary_device_add(adev);
+	/* Keep the established mana.{eth,rdma} auxiliary match names. */
+	ret = __auxiliary_device_add(adev, "mana");
 	if (ret)
 		goto add_fail;
 
@@ -4194,6 +4195,7 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 
 	return err;
 }
+EXPORT_SYMBOL_NS(mana_probe, "NET_MANA");
 
 void mana_remove(struct gdma_dev *gd, bool suspending)
 {
@@ -4272,6 +4274,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	kfree(ac);
 	dev_dbg(dev, "%s succeeded\n", __func__);
 }
+EXPORT_SYMBOL_NS(mana_remove, "NET_MANA");
 
 int mana_rdma_probe(struct gdma_dev *gd)
 {
@@ -4307,6 +4310,7 @@ int mana_rdma_probe(struct gdma_dev *gd)
 
 	return err;
 }
+EXPORT_SYMBOL_NS(mana_rdma_probe, "NET_MANA");
 
 void mana_rdma_remove(struct gdma_dev *gd)
 {
@@ -4327,6 +4331,7 @@ void mana_rdma_remove(struct gdma_dev *gd)
 
 	mana_gd_deregister_device(gd);
 }
+EXPORT_SYMBOL_NS(mana_rdma_remove, "NET_MANA");
 
 struct net_device *mana_get_primary_netdev(struct mana_context *ac,
 					   u32 port_index,
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 238ff8b9f067..cdec5558304f 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -1175,7 +1175,4 @@ int mana_gd_query_device_cfg(struct gdma_context *gc, u32 proto_major_ver,
 			     u16 *max_num_vports, u8 *bm_hostmode);
 int mana_gd_dev_reset(struct gdma_context *gc);
 
-int mana_pci_driver_register(void);
-void mana_pci_driver_unregister(void);
-
 #endif /* _GDMA_H */
-- 
2.54.0
