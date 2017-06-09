From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 02/11] IB: nes: convert to use DRIVER_ATTR_RW
Date: Fri,  9 Jun 2017 11:03:05 +0200
Message-ID: <20170609090314.13991-2-gregkh@linuxfoundation.org>
References: <20170609090314.13991-1-gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170609090314.13991-1-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We are trying to get rid of DRIVER_ATTR(), and all of the nes.c driver
attributes can be trivially changed to use DRIVER_ATTR_RW(), making the
code smaller and easier to manage over time.

Cc: Faisal Latif <faisal.latif@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: <linux-rdma@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/nes/nes.c | 80 ++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 49 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 5b9601014f0c..a30aa6527f7e 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -815,7 +815,7 @@ static struct pci_driver nes_pci_driver = {
 	.remove = nes_remove,
 };
 
-static ssize_t nes_show_adapter(struct device_driver *ddp, char *buf)
+static ssize_t adapter_show(struct device_driver *ddp, char *buf)
 {
 	unsigned int  devfn = 0xffffffff;
 	unsigned char bus_number = 0xff;
@@ -834,7 +834,7 @@ static ssize_t nes_show_adapter(struct device_driver *ddp, char *buf)
 	return snprintf(buf, PAGE_SIZE, "%x:%x\n", bus_number, devfn);
 }
 
-static ssize_t nes_store_adapter(struct device_driver *ddp,
+static ssize_t adapter_store(struct device_driver *ddp,
 	const char *buf, size_t count)
 {
 	char *p = (char *)buf;
@@ -843,7 +843,7 @@ static ssize_t nes_store_adapter(struct device_driver *ddp,
 	return strnlen(buf, count);
 }
 
-static ssize_t nes_show_ee_cmd(struct device_driver *ddp, char *buf)
+static ssize_t eeprom_cmd_show(struct device_driver *ddp, char *buf)
 {
 	u32 eeprom_cmd = 0xdead;
 	u32 i = 0;
@@ -859,7 +859,7 @@ static ssize_t nes_show_ee_cmd(struct device_driver *ddp, char *buf)
 	return snprintf(buf, PAGE_SIZE, "0x%x\n", eeprom_cmd);
 }
 
-static ssize_t nes_store_ee_cmd(struct device_driver *ddp,
+static ssize_t eeprom_cmd_store(struct device_driver *ddp,
 	const char *buf, size_t count)
 {
 	char *p = (char *)buf;
@@ -880,7 +880,7 @@ static ssize_t nes_store_ee_cmd(struct device_driver *ddp,
 	return strnlen(buf, count);
 }
 
-static ssize_t nes_show_ee_data(struct device_driver *ddp, char *buf)
+static ssize_t eeprom_data_show(struct device_driver *ddp, char *buf)
 {
 	u32 eeprom_data = 0xdead;
 	u32 i = 0;
@@ -897,7 +897,7 @@ static ssize_t nes_show_ee_data(struct device_driver *ddp, char *buf)
 	return  snprintf(buf, PAGE_SIZE, "0x%x\n", eeprom_data);
 }
 
-static ssize_t nes_store_ee_data(struct device_driver *ddp,
+static ssize_t eeprom_data_store(struct device_driver *ddp,
 	const char *buf, size_t count)
 {
 	char *p = (char *)buf;
@@ -918,7 +918,7 @@ static ssize_t nes_store_ee_data(struct device_driver *ddp,
 	return strnlen(buf, count);
 }
 
-static ssize_t nes_show_flash_cmd(struct device_driver *ddp, char *buf)
+static ssize_t flash_cmd_show(struct device_driver *ddp, char *buf)
 {
 	u32 flash_cmd = 0xdead;
 	u32 i = 0;
@@ -935,7 +935,7 @@ static ssize_t nes_show_flash_cmd(struct device_driver *ddp, char *buf)
 	return  snprintf(buf, PAGE_SIZE, "0x%x\n", flash_cmd);
 }
 
-static ssize_t nes_store_flash_cmd(struct device_driver *ddp,
+static ssize_t flash_cmd_store(struct device_driver *ddp,
 	const char *buf, size_t count)
 {
 	char *p = (char *)buf;
@@ -956,7 +956,7 @@ static ssize_t nes_store_flash_cmd(struct device_driver *ddp,
 	return strnlen(buf, count);
 }
 
-static ssize_t nes_show_flash_data(struct device_driver *ddp, char *buf)
+static ssize_t flash_data_show(struct device_driver *ddp, char *buf)
 {
 	u32 flash_data = 0xdead;
 	u32 i = 0;
@@ -973,7 +973,7 @@ static ssize_t nes_show_flash_data(struct device_driver *ddp, char *buf)
 	return  snprintf(buf, PAGE_SIZE, "0x%x\n", flash_data);
 }
 
-static ssize_t nes_store_flash_data(struct device_driver *ddp,
+static ssize_t flash_data_store(struct device_driver *ddp,
 	const char *buf, size_t count)
 {
 	char *p = (char *)buf;
@@ -994,12 +994,12 @@ static ssize_t nes_store_flash_data(struct device_driver *ddp,
 	return strnlen(buf, count);
 }
 
-static ssize_t nes_show_nonidx_addr(struct device_driver *ddp, char *buf)
+static ssize_t nonidx_addr_show(struct device_driver *ddp, char *buf)
 {
 	return  snprintf(buf, PAGE_SIZE, "0x%x\n", sysfs_nonidx_addr);
 }
 
-static ssize_t nes_store_nonidx_addr(struct device_driver *ddp,
+static ssize_t nonidx_addr_store(struct device_driver *ddp,
 	const char *buf, size_t count)
 {
 	char *p = (char *)buf;
@@ -1010,7 +1010,7 @@ static ssize_t nes_store_nonidx_addr(struct device_driver *ddp,
 	return strnlen(buf, count);
 }
 
-static ssize_t nes_show_nonidx_data(struct device_driver *ddp, char *buf)
+static ssize_t nonidx_data_show(struct device_driver *ddp, char *buf)
 {
 	u32 nonidx_data = 0xdead;
 	u32 i = 0;
@@ -1027,7 +1027,7 @@ static ssize_t nes_show_nonidx_data(struct device_driver *ddp, char *buf)
 	return  snprintf(buf, PAGE_SIZE, "0x%x\n", nonidx_data);
 }
 
-static ssize_t nes_store_nonidx_data(struct device_driver *ddp,
+static ssize_t nonidx_data_store(struct device_driver *ddp,
 	const char *buf, size_t count)
 {
 	char *p = (char *)buf;
@@ -1048,12 +1048,12 @@ static ssize_t nes_store_nonidx_data(struct device_driver *ddp,
 	return strnlen(buf, count);
 }
 
-static ssize_t nes_show_idx_addr(struct device_driver *ddp, char *buf)
+static ssize_t idx_addr_show(struct device_driver *ddp, char *buf)
 {
 	return  snprintf(buf, PAGE_SIZE, "0x%x\n", sysfs_idx_addr);
 }
 
-static ssize_t nes_store_idx_addr(struct device_driver *ddp,
+static ssize_t idx_addr_store(struct device_driver *ddp,
 	const char *buf, size_t count)
 {
 	char *p = (char *)buf;
@@ -1064,7 +1064,7 @@ static ssize_t nes_store_idx_addr(struct device_driver *ddp,
 	return strnlen(buf, count);
 }
 
-static ssize_t nes_show_idx_data(struct device_driver *ddp, char *buf)
+static ssize_t idx_data_show(struct device_driver *ddp, char *buf)
 {
 	u32 idx_data = 0xdead;
 	u32 i = 0;
@@ -1081,7 +1081,7 @@ static ssize_t nes_show_idx_data(struct device_driver *ddp, char *buf)
 	return  snprintf(buf, PAGE_SIZE, "0x%x\n", idx_data);
 }
 
-static ssize_t nes_store_idx_data(struct device_driver *ddp,
+static ssize_t idx_data_store(struct device_driver *ddp,
 	const char *buf, size_t count)
 {
 	char *p = (char *)buf;
@@ -1102,11 +1102,7 @@ static ssize_t nes_store_idx_data(struct device_driver *ddp,
 	return strnlen(buf, count);
 }
 
-
-/**
- * nes_show_wqm_quanta
- */
-static ssize_t nes_show_wqm_quanta(struct device_driver *ddp, char *buf)
+static ssize_t wqm_quanta_show(struct device_driver *ddp, char *buf)
 {
 	u32 wqm_quanta_value = 0xdead;
 	u32 i = 0;
@@ -1123,12 +1119,8 @@ static ssize_t nes_show_wqm_quanta(struct device_driver *ddp, char *buf)
 	return  snprintf(buf, PAGE_SIZE, "0x%X\n", wqm_quanta_value);
 }
 
-
-/**
- * nes_store_wqm_quanta
- */
-static ssize_t nes_store_wqm_quanta(struct device_driver *ddp,
-					const char *buf, size_t count)
+static ssize_t wqm_quanta_store(struct device_driver *ddp, const char *buf,
+				size_t count)
 {
 	unsigned long wqm_quanta_value;
 	u32 wqm_config1;
@@ -1153,26 +1145,16 @@ static ssize_t nes_store_wqm_quanta(struct device_driver *ddp,
 	return strnlen(buf, count);
 }
 
-static DRIVER_ATTR(adapter, S_IRUSR | S_IWUSR,
-		   nes_show_adapter, nes_store_adapter);
-static DRIVER_ATTR(eeprom_cmd, S_IRUSR | S_IWUSR,
-		   nes_show_ee_cmd, nes_store_ee_cmd);
-static DRIVER_ATTR(eeprom_data, S_IRUSR | S_IWUSR,
-		   nes_show_ee_data, nes_store_ee_data);
-static DRIVER_ATTR(flash_cmd, S_IRUSR | S_IWUSR,
-		   nes_show_flash_cmd, nes_store_flash_cmd);
-static DRIVER_ATTR(flash_data, S_IRUSR | S_IWUSR,
-		   nes_show_flash_data, nes_store_flash_data);
-static DRIVER_ATTR(nonidx_addr, S_IRUSR | S_IWUSR,
-		   nes_show_nonidx_addr, nes_store_nonidx_addr);
-static DRIVER_ATTR(nonidx_data, S_IRUSR | S_IWUSR,
-		   nes_show_nonidx_data, nes_store_nonidx_data);
-static DRIVER_ATTR(idx_addr, S_IRUSR | S_IWUSR,
-		   nes_show_idx_addr, nes_store_idx_addr);
-static DRIVER_ATTR(idx_data, S_IRUSR | S_IWUSR,
-		   nes_show_idx_data, nes_store_idx_data);
-static DRIVER_ATTR(wqm_quanta, S_IRUSR | S_IWUSR,
-		   nes_show_wqm_quanta, nes_store_wqm_quanta);
+static DRIVER_ATTR_RW(adapter);
+static DRIVER_ATTR_RW(eeprom_cmd);
+static DRIVER_ATTR_RW(eeprom_data);
+static DRIVER_ATTR_RW(flash_cmd);
+static DRIVER_ATTR_RW(flash_data);
+static DRIVER_ATTR_RW(nonidx_addr);
+static DRIVER_ATTR_RW(nonidx_data);
+static DRIVER_ATTR_RW(idx_addr);
+static DRIVER_ATTR_RW(idx_data);
+static DRIVER_ATTR_RW(wqm_quanta);
 
 static int nes_create_driver_sysfs(struct pci_driver *drv)
 {
-- 
2.13.1
