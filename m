From: <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: patch "IB: nes: convert to use DRIVER_ATTR_RW" added to driver-core-next
Date: Tue, 13 Jun 2017 07:58:50 +0200
Message-ID: <149733353020069@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    IB: nes: convert to use DRIVER_ATTR_RW

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


>From c1357e452dc2b0a8c4826144d780e9a552782afe Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Date: Fri, 9 Jun 2017 11:03:05 +0200
Subject: IB: nes: convert to use DRIVER_ATTR_RW

We are trying to get rid of DRIVER_ATTR(), and all of the nes.c driver
attributes can be trivially changed to use DRIVER_ATTR_RW(), making the
code smaller and easier to manage over time.

Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reviewed-by: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
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


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
