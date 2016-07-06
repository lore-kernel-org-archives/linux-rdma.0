From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 for-next 11/18] IB/hfi1: Use built-in i2c bit-shift bus
 adapter
Date: Wed, 06 Jul 2016 17:28:52 -0400
Message-ID: <20160706212814.3361.77286.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use built-in i2c bit-shift bus adapter to control the
i2c busses on the chip.

Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 v2 - address conflict issue with rc patches

 drivers/infiniband/hw/hfi1/Kconfig |    3 
 drivers/infiniband/hw/hfi1/chip.c  |    5 
 drivers/infiniband/hw/hfi1/hfi.h   |   11 +
 drivers/infiniband/hw/hfi1/init.c  |   27 ++
 drivers/infiniband/hw/hfi1/qsfp.c  |  407 +++++++++++++++++++++++++++---------
 drivers/infiniband/hw/hfi1/qsfp.h  |    3 
 6 files changed, 341 insertions(+), 115 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/Kconfig b/drivers/infiniband/hw/hfi1/Kconfig
index a925fb0..bac1860 100644
--- a/drivers/infiniband/hw/hfi1/Kconfig
+++ b/drivers/infiniband/hw/hfi1/Kconfig
@@ -1,8 +1,9 @@
 config INFINIBAND_HFI1
 	tristate "Intel OPA Gen1 support"
-	depends on X86_64 && INFINIBAND_RDMAVT
+	depends on X86_64 && INFINIBAND_RDMAVT && I2C
 	select MMU_NOTIFIER
 	select CRC32
+	select I2C_ALGOBIT
 	default m
 	---help---
 	This is a low-level driver for Intel OPA Gen1 adapter.
diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 0de6c0c..22bfe0e 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14165,6 +14165,11 @@ static int init_asic_data(struct hfi1_devdata *dd)
 	}
 	dd->asic_data->dds[dd->hfi1_id] = dd; /* self back-pointer */
 	spin_unlock_irqrestore(&hfi1_devs_lock, flags);
+
+	/* first one through - set up i2c devices */
+	if (!peer)
+		ret = set_up_i2c(dd, dd->asic_data);
+
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index fd67e98..c433eb8 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -62,6 +62,8 @@
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
 #include <rdma/rdma_vt.h>
 
 #include "chip_registers.h"
@@ -805,10 +807,19 @@ struct hfi1_temp {
 	u8 triggers;      /* temperature triggers */
 };
 
+struct hfi1_i2c_bus {
+	struct hfi1_devdata *controlling_dd; /* current controlling device */
+	struct i2c_adapter adapter;	/* bus details */
+	struct i2c_algo_bit_data algo;	/* bus algorithm details */
+	int num;			/* bus number, 0 or 1 */
+};
+
 /* common data between shared ASIC HFIs */
 struct hfi1_asic_data {
 	struct hfi1_devdata *dds[2];	/* back pointers */
 	struct mutex asic_resource_mutex;
+	struct hfi1_i2c_bus *i2c_bus0;
+	struct hfi1_i2c_bus *i2c_bus1;
 };
 
 /* device data struct now contains only "general per-device" info.
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 1620d68..ec77c7e 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -973,34 +973,45 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 
 /*
  * Release our hold on the shared asic data.  If we are the last one,
- * free the structure.  Must be holding hfi1_devs_lock.
+ * return the structure to be finalized outside the lock.  Must be
+ * holding hfi1_devs_lock.
  */
-static void release_asic_data(struct hfi1_devdata *dd)
+static struct hfi1_asic_data *release_asic_data(struct hfi1_devdata *dd)
 {
+	struct hfi1_asic_data *ad;
 	int other;
 
 	if (!dd->asic_data)
-		return;
+		return NULL;
 	dd->asic_data->dds[dd->hfi1_id] = NULL;
 	other = dd->hfi1_id ? 0 : 1;
-	if (!dd->asic_data->dds[other]) {
-		/* we are the last holder, free it */
-		kfree(dd->asic_data);
-	}
+	ad = dd->asic_data;
 	dd->asic_data = NULL;
+	/* return NULL if the other dd still has a link */
+	return ad->dds[other] ? NULL : ad;
+}
+
+static void finalize_asic_data(struct hfi1_devdata *dd,
+			       struct hfi1_asic_data *ad)
+{
+	clean_up_i2c(dd, ad);
+	kfree(ad);
 }
 
 static void __hfi1_free_devdata(struct kobject *kobj)
 {
 	struct hfi1_devdata *dd =
 		container_of(kobj, struct hfi1_devdata, kobj);
+	struct hfi1_asic_data *ad;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hfi1_devs_lock, flags);
 	idr_remove(&hfi1_unit_table, dd->unit);
 	list_del(&dd->list);
-	release_asic_data(dd);
+	ad = release_asic_data(dd);
 	spin_unlock_irqrestore(&hfi1_devs_lock, flags);
+	if (ad)
+		finalize_asic_data(dd, ad);
 	free_platform_config(dd);
 	rcu_barrier(); /* wait for rcu callbacks to complete */
 	free_percpu(dd->int_counter);
diff --git a/drivers/infiniband/hw/hfi1/qsfp.c b/drivers/infiniband/hw/hfi1/qsfp.c
index 6fca2a0..a207717 100644
--- a/drivers/infiniband/hw/hfi1/qsfp.c
+++ b/drivers/infiniband/hw/hfi1/qsfp.c
@@ -50,46 +50,285 @@
 #include <linux/vmalloc.h>
 
 #include "hfi.h"
-#include "twsi.h"
+
+/* for the given bus number, return the CSR for reading an i2c line */
+static inline u32 i2c_in_csr(u32 bus_num)
+{
+	return bus_num ? ASIC_QSFP2_IN : ASIC_QSFP1_IN;
+}
+
+/* for the given bus number, return the CSR for writing an i2c line */
+static inline u32 i2c_oe_csr(u32 bus_num)
+{
+	return bus_num ? ASIC_QSFP2_OE : ASIC_QSFP1_OE;
+}
+
+static void hfi1_setsda(void *data, int state)
+{
+	struct hfi1_i2c_bus *bus = (struct hfi1_i2c_bus *)data;
+	struct hfi1_devdata *dd = bus->controlling_dd;
+	u64 reg;
+	u32 target_oe;
+
+	target_oe = i2c_oe_csr(bus->num);
+	reg = read_csr(dd, target_oe);
+	/*
+	 * The OE bit value is inverted and connected to the pin.  When
+	 * OE is 0 the pin is left to be pulled up, when the OE is 1
+	 * the pin is driven low.  This matches the "open drain" or "open
+	 * collector" convention.
+	 */
+	if (state)
+		reg &= ~QSFP_HFI0_I2CDAT;
+	else
+		reg |= QSFP_HFI0_I2CDAT;
+	write_csr(dd, target_oe, reg);
+	/* do a read to force the write into the chip */
+	(void)read_csr(dd, target_oe);
+}
+
+static void hfi1_setscl(void *data, int state)
+{
+	struct hfi1_i2c_bus *bus = (struct hfi1_i2c_bus *)data;
+	struct hfi1_devdata *dd = bus->controlling_dd;
+	u64 reg;
+	u32 target_oe;
+
+	target_oe = i2c_oe_csr(bus->num);
+	reg = read_csr(dd, target_oe);
+	/*
+	 * The OE bit value is inverted and connected to the pin.  When
+	 * OE is 0 the pin is left to be pulled up, when the OE is 1
+	 * the pin is driven low.  This matches the "open drain" or "open
+	 * collector" convention.
+	 */
+	if (state)
+		reg &= ~QSFP_HFI0_I2CCLK;
+	else
+		reg |= QSFP_HFI0_I2CCLK;
+	write_csr(dd, target_oe, reg);
+	/* do a read to force the write into the chip */
+	(void)read_csr(dd, target_oe);
+}
+
+static int hfi1_getsda(void *data)
+{
+	struct hfi1_i2c_bus *bus = (struct hfi1_i2c_bus *)data;
+	u64 reg;
+	u32 target_in;
+
+	hfi1_setsda(data, 1);	/* clear OE so we do not pull line down */
+	udelay(2);		/* 1us pull up + 250ns hold */
+
+	target_in = i2c_in_csr(bus->num);
+	reg = read_csr(bus->controlling_dd, target_in);
+	return !!(reg & QSFP_HFI0_I2CDAT);
+}
+
+static int hfi1_getscl(void *data)
+{
+	struct hfi1_i2c_bus *bus = (struct hfi1_i2c_bus *)data;
+	u64 reg;
+	u32 target_in;
+
+	hfi1_setscl(data, 1);	/* clear OE so we do not pull line down */
+	udelay(2);		/* 1us pull up + 250ns hold */
+
+	target_in = i2c_in_csr(bus->num);
+	reg = read_csr(bus->controlling_dd, target_in);
+	return !!(reg & QSFP_HFI0_I2CCLK);
+}
 
 /*
- * QSFP support for hfi driver, using "Two Wire Serial Interface" driver
- * in twsi.c
+ * Allocate and initialize the given i2c bus number.
+ * Returns NULL on failure.
  */
-#define I2C_MAX_RETRY 4
+static struct hfi1_i2c_bus *init_i2c_bus(struct hfi1_devdata *dd,
+					 struct hfi1_asic_data *ad, int num)
+{
+	struct hfi1_i2c_bus *bus;
+	int ret;
+
+	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
+	if (!bus)
+		return NULL;
+
+	bus->controlling_dd = dd;
+	bus->num = num;	/* our bus number */
+
+	bus->algo.setsda = hfi1_setsda;
+	bus->algo.setscl = hfi1_setscl;
+	bus->algo.getsda = hfi1_getsda;
+	bus->algo.getscl = hfi1_getscl;
+	bus->algo.udelay = 5;
+	bus->algo.timeout = usecs_to_jiffies(50);
+	bus->algo.data = bus;
+
+	bus->adapter.owner = THIS_MODULE;
+	bus->adapter.algo_data = &bus->algo;
+	bus->adapter.dev.parent = &dd->pcidev->dev;
+	snprintf(bus->adapter.name, sizeof(bus->adapter.name),
+		 "hfi1_i2c%d", num);
+
+	ret = i2c_bit_add_bus(&bus->adapter);
+	if (ret) {
+		dd_dev_info(dd, "%s: unable to add i2c bus %d, err %d\n",
+			    __func__, num, ret);
+		kfree(bus);
+		return NULL;
+	}
+
+	return bus;
+}
 
 /*
- * Raw i2c write.  No set-up or lock checking.
+ * Initialize i2c buses.
+ * Return 0 on success, -errno on error.
  */
-static int __i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
-		       int offset, void *bp, int len)
+int set_up_i2c(struct hfi1_devdata *dd, struct hfi1_asic_data *ad)
 {
-	struct hfi1_devdata *dd = ppd->dd;
-	int ret, cnt;
-	u8 *buff = bp;
+	ad->i2c_bus0 = init_i2c_bus(dd, ad, 0);
+	ad->i2c_bus1 = init_i2c_bus(dd, ad, 1);
+	if (!ad->i2c_bus0 || !ad->i2c_bus1)
+		return -ENOMEM;
+	return 0;
+};
 
-	cnt = 0;
-	while (cnt < len) {
-		int wlen = len - cnt;
+static void clean_i2c_bus(struct hfi1_i2c_bus *bus)
+{
+	if (bus) {
+		i2c_del_adapter(&bus->adapter);
+		kfree(bus);
+	}
+}
 
-		ret = hfi1_twsi_blk_wr(dd, target, i2c_addr, offset,
-				       buff + cnt, wlen);
-		if (ret) {
-			/* hfi1_twsi_blk_wr() 1 for error, else 0 */
-			return -EIO;
-		}
-		offset += wlen;
-		cnt += wlen;
+void clean_up_i2c(struct hfi1_devdata *dd, struct hfi1_asic_data *ad)
+{
+	clean_i2c_bus(ad->i2c_bus0);
+	ad->i2c_bus0 = NULL;
+	clean_i2c_bus(ad->i2c_bus1);
+	ad->i2c_bus1 = NULL;
+}
+
+static int i2c_bus_write(struct hfi1_devdata *dd, struct hfi1_i2c_bus *i2c,
+			 u8 slave_addr, int offset, int offset_size,
+			 u8 *data, u16 len)
+{
+	int ret;
+	int num_msgs;
+	u8 offset_bytes[2];
+	struct i2c_msg msgs[2];
+
+	switch (offset_size) {
+	case 0:
+		num_msgs = 1;
+		msgs[0].addr = slave_addr;
+		msgs[0].flags = 0;
+		msgs[0].len = len;
+		msgs[0].buf = data;
+		break;
+	case 2:
+		offset_bytes[1] = (offset >> 8) & 0xff;
+		/* fall through */
+	case 1:
+		num_msgs = 2;
+		offset_bytes[0] = offset & 0xff;
+
+		msgs[0].addr = slave_addr;
+		msgs[0].flags = 0;
+		msgs[0].len = offset_size;
+		msgs[0].buf = offset_bytes;
+
+		msgs[1].addr = slave_addr;
+		msgs[1].flags = I2C_M_NOSTART,
+		msgs[1].len = len;
+		msgs[1].buf = data;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	i2c->controlling_dd = dd;
+	ret = i2c_transfer(&i2c->adapter, msgs, num_msgs);
+	if (ret != num_msgs) {
+		dd_dev_err(dd, "%s: bus %d, i2c slave 0x%x, offset 0x%x, len 0x%x; write failed, ret %d\n",
+			   __func__, i2c->num, slave_addr, offset, len, ret);
+		return ret < 0 ? ret : -EIO;
 	}
+	return 0;
+}
 
-	/* Must wait min 20us between qsfp i2c transactions */
-	udelay(20);
+static int i2c_bus_read(struct hfi1_devdata *dd, struct hfi1_i2c_bus *bus,
+			u8 slave_addr, int offset, int offset_size,
+			u8 *data, u16 len)
+{
+	int ret;
+	int num_msgs;
+	u8 offset_bytes[2];
+	struct i2c_msg msgs[2];
+
+	switch (offset_size) {
+	case 0:
+		num_msgs = 1;
+		msgs[0].addr = slave_addr;
+		msgs[0].flags = I2C_M_RD;
+		msgs[0].len = len;
+		msgs[0].buf = data;
+		break;
+	case 2:
+		offset_bytes[1] = (offset >> 8) & 0xff;
+		/* fall through */
+	case 1:
+		num_msgs = 2;
+		offset_bytes[0] = offset & 0xff;
+
+		msgs[0].addr = slave_addr;
+		msgs[0].flags = 0;
+		msgs[0].len = offset_size;
+		msgs[0].buf = offset_bytes;
+
+		msgs[1].addr = slave_addr;
+		msgs[1].flags = I2C_M_RD,
+		msgs[1].len = len;
+		msgs[1].buf = data;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	return cnt;
+	bus->controlling_dd = dd;
+	ret = i2c_transfer(&bus->adapter, msgs, num_msgs);
+	if (ret != num_msgs) {
+		dd_dev_err(dd, "%s: bus %d, i2c slave 0x%x, offset 0x%x, len 0x%x; read failed, ret %d\n",
+			   __func__, bus->num, slave_addr, offset, len, ret);
+		return ret < 0 ? ret : -EIO;
+	}
+	return 0;
+}
+
+/*
+ * Raw i2c write.  No set-up or lock checking.
+ *
+ * Return 0 on success, -errno on error.
+ */
+static int __i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
+		       int offset, void *bp, int len)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	struct hfi1_i2c_bus *bus;
+	u8 slave_addr;
+	int offset_size;
+
+	bus = target ? dd->asic_data->i2c_bus1 : dd->asic_data->i2c_bus0;
+	slave_addr = (i2c_addr & 0xff) >> 1; /* convert to 7-bit addr */
+	offset_size = (i2c_addr >> 8) & 0x3;
+	return i2c_bus_write(dd, bus, slave_addr, offset, offset_size, bp, len);
 }
 
 /*
  * Caller must hold the i2c chain resource.
+ *
+ * Return number of bytes written, or -errno.
  */
 int i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	      void *bp, int len)
@@ -99,63 +338,36 @@ int i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	if (!check_chip_resource(ppd->dd, i2c_target(target), __func__))
 		return -EACCES;
 
-	/* make sure the TWSI bus is in a sane state */
-	ret = hfi1_twsi_reset(ppd->dd, target);
-	if (ret) {
-		hfi1_dev_porterr(ppd->dd, ppd->port,
-				 "I2C chain %d write interface reset failed\n",
-				 target);
+	ret = __i2c_write(ppd, target, i2c_addr, offset, bp, len);
+	if (ret)
 		return ret;
-	}
 
-	return __i2c_write(ppd, target, i2c_addr, offset, bp, len);
+	return len;
 }
 
 /*
  * Raw i2c read.  No set-up or lock checking.
+ *
+ * Return 0 on success, -errno on error.
  */
 static int __i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
 		      int offset, void *bp, int len)
 {
 	struct hfi1_devdata *dd = ppd->dd;
-	int ret, cnt, pass = 0;
-	int orig_offset = offset;
-
-	cnt = 0;
-	while (cnt < len) {
-		int rlen = len - cnt;
-
-		ret = hfi1_twsi_blk_rd(dd, target, i2c_addr, offset,
-				       bp + cnt, rlen);
-		/* Some QSFP's fail first try. Retry as experiment */
-		if (ret && cnt == 0 && ++pass < I2C_MAX_RETRY)
-			continue;
-		if (ret) {
-			/* hfi1_twsi_blk_rd() 1 for error, else 0 */
-			ret = -EIO;
-			goto exit;
-		}
-		offset += rlen;
-		cnt += rlen;
-	}
-
-	ret = cnt;
-
-exit:
-	if (ret < 0) {
-		hfi1_dev_porterr(dd, ppd->port,
-				 "I2C chain %d read failed, addr 0x%x, offset 0x%x, len %d\n",
-				 target, i2c_addr, orig_offset, len);
-	}
-
-	/* Must wait min 20us between qsfp i2c transactions */
-	udelay(20);
-
-	return ret;
+	struct hfi1_i2c_bus *bus;
+	u8 slave_addr;
+	int offset_size;
+
+	bus = target ? dd->asic_data->i2c_bus1 : dd->asic_data->i2c_bus0;
+	slave_addr = (i2c_addr & 0xff) >> 1; /* convert to 7-bit addr */
+	offset_size = (i2c_addr >> 8) & 0x3;
+	return i2c_bus_read(dd, bus, slave_addr, offset, offset_size, bp, len);
 }
 
 /*
  * Caller must hold the i2c chain resource.
+ *
+ * Return number of bytes read, or -errno.
  */
 int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	     void *bp, int len)
@@ -165,16 +377,11 @@ int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	if (!check_chip_resource(ppd->dd, i2c_target(target), __func__))
 		return -EACCES;
 
-	/* make sure the TWSI bus is in a sane state */
-	ret = hfi1_twsi_reset(ppd->dd, target);
-	if (ret) {
-		hfi1_dev_porterr(ppd->dd, ppd->port,
-				 "I2C chain %d read interface reset failed\n",
-				 target);
+	ret = __i2c_read(ppd, target, i2c_addr, offset, bp, len);
+	if (ret)
 		return ret;
-	}
 
-	return __i2c_read(ppd, target, i2c_addr, offset, bp, len);
+	return len;
 }
 
 /*
@@ -182,6 +389,8 @@ int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
  * by writing @addr = ((256 * n) + m)
  *
  * Caller must hold the i2c chain resource.
+ *
+ * Return number of bytes written or -errno.
  */
 int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	       int len)
@@ -189,21 +398,12 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	int count = 0;
 	int offset;
 	int nwrite;
-	int ret;
+	int ret = 0;
 	u8 page;
 
 	if (!check_chip_resource(ppd->dd, i2c_target(target), __func__))
 		return -EACCES;
 
-	/* make sure the TWSI bus is in a sane state */
-	ret = hfi1_twsi_reset(ppd->dd, target);
-	if (ret) {
-		hfi1_dev_porterr(ppd->dd, ppd->port,
-				 "QSFP chain %d write interface reset failed\n",
-				 target);
-		return ret;
-	}
-
 	while (count < len) {
 		/*
 		 * Set the qsfp page based on a zero-based address
@@ -213,11 +413,12 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 
 		ret = __i2c_write(ppd, target, QSFP_DEV | QSFP_OFFSET_SIZE,
 				  QSFP_PAGE_SELECT_BYTE_OFFS, &page, 1);
-		if (ret != 1) {
+		/* QSFPs require a 5-10msec delay after write operations */
+		mdelay(5);
+		if (ret) {
 			hfi1_dev_porterr(ppd->dd, ppd->port,
 					 "QSFP chain %d can't write QSFP_PAGE_SELECT_BYTE: %d\n",
 					 target, ret);
-			ret = -EIO;
 			break;
 		}
 
@@ -229,11 +430,13 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 
 		ret = __i2c_write(ppd, target, QSFP_DEV | QSFP_OFFSET_SIZE,
 				  offset, bp + count, nwrite);
-		if (ret <= 0)	/* stop on error or nothing written */
+		/* QSFPs require a 5-10msec delay after write operations */
+		mdelay(5);
+		if (ret)	/* stop on error */
 			break;
 
-		count += ret;
-		addr += ret;
+		count += nwrite;
+		addr += nwrite;
 	}
 
 	if (ret < 0)
@@ -266,6 +469,8 @@ int one_qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
  * by reading @addr = ((256 * n) + m)
  *
  * Caller must hold the i2c chain resource.
+ *
+ * Return the number of bytes read or -errno.
  */
 int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	      int len)
@@ -273,21 +478,12 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	int count = 0;
 	int offset;
 	int nread;
-	int ret;
+	int ret = 0;
 	u8 page;
 
 	if (!check_chip_resource(ppd->dd, i2c_target(target), __func__))
 		return -EACCES;
 
-	/* make sure the TWSI bus is in a sane state */
-	ret = hfi1_twsi_reset(ppd->dd, target);
-	if (ret) {
-		hfi1_dev_porterr(ppd->dd, ppd->port,
-				 "QSFP chain %d read interface reset failed\n",
-				 target);
-		return ret;
-	}
-
 	while (count < len) {
 		/*
 		 * Set the qsfp page based on a zero-based address
@@ -296,11 +492,12 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		page = (u8)(addr / QSFP_PAGESIZE);
 		ret = __i2c_write(ppd, target, QSFP_DEV | QSFP_OFFSET_SIZE,
 				  QSFP_PAGE_SELECT_BYTE_OFFS, &page, 1);
-		if (ret != 1) {
+		/* QSFPs require a 5-10msec delay after write operations */
+		mdelay(5);
+		if (ret) {
 			hfi1_dev_porterr(ppd->dd, ppd->port,
 					 "QSFP chain %d can't write QSFP_PAGE_SELECT_BYTE: %d\n",
 					 target, ret);
-			ret = -EIO;
 			break;
 		}
 
@@ -310,15 +507,13 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		if (((addr % QSFP_RW_BOUNDARY) + nread) > QSFP_RW_BOUNDARY)
 			nread = QSFP_RW_BOUNDARY - (addr % QSFP_RW_BOUNDARY);
 
-		/* QSFPs require a 5-10msec delay after write operations */
-		mdelay(5);
 		ret = __i2c_read(ppd, target, QSFP_DEV | QSFP_OFFSET_SIZE,
 				 offset, bp + count, nread);
-		if (ret <= 0)	/* stop on error or nothing read */
+		if (ret)	/* stop on error */
 			break;
 
-		count += ret;
-		addr += ret;
+		count += nread;
+		addr += nread;
 	}
 
 	if (ret < 0)
diff --git a/drivers/infiniband/hw/hfi1/qsfp.h b/drivers/infiniband/hw/hfi1/qsfp.h
index dadc66c..69275eb 100644
--- a/drivers/infiniband/hw/hfi1/qsfp.h
+++ b/drivers/infiniband/hw/hfi1/qsfp.h
@@ -238,3 +238,6 @@ int one_qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		   int len);
 int one_qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		  int len);
+struct hfi1_asic_data;
+int set_up_i2c(struct hfi1_devdata *dd, struct hfi1_asic_data *ad);
+void clean_up_i2c(struct hfi1_devdata *dd, struct hfi1_asic_data *ad);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
