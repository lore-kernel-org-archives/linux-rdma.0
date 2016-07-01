From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 12/18] IB/hfi1: Remove TWSI references
Date: Fri, 01 Jul 2016 16:01:50 -0700
Message-ID: <20160701230149.20160.7941.stgit@scvm10.sc.intel.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove the TWSI code.  The driver now uses the kernel's built-in
i2c bit bus module.

Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/Makefile |    2 
 drivers/infiniband/hw/hfi1/chip.c   |   31 --
 drivers/infiniband/hw/hfi1/chip.h   |    2 
 drivers/infiniband/hw/hfi1/twsi.c   |  489 -----------------------------------
 drivers/infiniband/hw/hfi1/twsi.h   |   65 -----
 5 files changed, 1 insertions(+), 588 deletions(-)
 delete mode 100644 drivers/infiniband/hw/hfi1/twsi.c
 delete mode 100644 drivers/infiniband/hw/hfi1/twsi.h

diff --git a/drivers/infiniband/hw/hfi1/Makefile b/drivers/infiniband/hw/hfi1/Makefile
index 9b5382c..0cf97a0 100644
--- a/drivers/infiniband/hw/hfi1/Makefile
+++ b/drivers/infiniband/hw/hfi1/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
 hfi1-y := affinity.o chip.o device.o driver.o efivar.o \
 	eprom.o file_ops.o firmware.o \
 	init.o intr.o mad.o mmu_rb.o pcie.o pio.o pio_copy.o platform.o \
-	qp.o qsfp.o rc.o ruc.o sdma.o sysfs.o trace.o twsi.o \
+	qp.o qsfp.o rc.o ruc.o sdma.o sysfs.o trace.o \
 	uc.o ud.o user_exp_rcv.o user_pages.o user_sdma.o verbs.o \
 	verbs_txreq.o
 hfi1-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 22bfe0e..40d485b 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -12349,37 +12349,6 @@ u8 hfi1_ibphys_portstate(struct hfi1_pportdata *ppd)
 	return ib_pstate;
 }
 
-/*
- * Read/modify/write ASIC_QSFP register bits as selected by mask
- * data: 0 or 1 in the positions depending on what needs to be written
- * dir: 0 for read, 1 for write
- * mask: select by setting
- *      I2CCLK  (bit 0)
- *      I2CDATA (bit 1)
- */
-u64 hfi1_gpio_mod(struct hfi1_devdata *dd, u32 target, u32 data, u32 dir,
-		  u32 mask)
-{
-	u64 qsfp_oe, target_oe;
-
-	target_oe = target ? ASIC_QSFP2_OE : ASIC_QSFP1_OE;
-	if (mask) {
-		/* We are writing register bits, so lock access */
-		dir &= mask;
-		data &= mask;
-
-		qsfp_oe = read_csr(dd, target_oe);
-		qsfp_oe = (qsfp_oe & ~(u64)mask) | (u64)dir;
-		write_csr(dd, target_oe, qsfp_oe);
-	}
-	/* We are exclusively reading bits here, but it is unlikely
-	 * we'll get valid data when we set the direction of the pin
-	 * in the same call, so read should call this function again
-	 * to get valid data
-	 */
-	return read_csr(dd, target ? ASIC_QSFP2_IN : ASIC_QSFP1_IN);
-}
-
 #define CLEAR_STATIC_RATE_CONTROL_SMASK(r) \
 (r &= ~SEND_CTXT_CHECK_ENABLE_DISALLOW_PBC_STATIC_RATE_CONTROL_SMASK)
 
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 66a3279..d0a4ddb 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -1338,8 +1338,6 @@ struct hfi1_message_header *hfi1_get_msgheader(
 				struct hfi1_devdata *dd, __le32 *rhf_addr);
 int hfi1_get_base_kinfo(struct hfi1_ctxtdata *rcd,
 			struct hfi1_ctxt_info *kinfo);
-u64 hfi1_gpio_mod(struct hfi1_devdata *dd, u32 target, u32 data, u32 dir,
-		  u32 mask);
 int hfi1_init_ctxt(struct send_context *sc);
 void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
 		  u32 type, unsigned long pa, u16 order);
diff --git a/drivers/infiniband/hw/hfi1/twsi.c b/drivers/infiniband/hw/hfi1/twsi.c
deleted file mode 100644
index e82e52a..0000000
--- a/drivers/infiniband/hw/hfi1/twsi.c
+++ /dev/null
@@ -1,489 +0,0 @@
-/*
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * BSD LICENSE
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  - Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  - Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  - Neither the name of Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- */
-
-#include <linux/delay.h>
-#include <linux/pci.h>
-#include <linux/vmalloc.h>
-
-#include "hfi.h"
-#include "twsi.h"
-
-/*
- * "Two Wire Serial Interface" support.
- *
- * Originally written for a not-quite-i2c serial eeprom, which is
- * still used on some supported boards. Later boards have added a
- * variety of other uses, most board-specific, so the bit-boffing
- * part has been split off to this file, while the other parts
- * have been moved to chip-specific files.
- *
- * We have also dropped all pretense of fully generic (e.g. pretend
- * we don't know whether '1' is the higher voltage) interface, as
- * the restrictions of the generic i2c interface (e.g. no access from
- * driver itself) make it unsuitable for this use.
- */
-
-#define READ_CMD 1
-#define WRITE_CMD 0
-
-/**
- * i2c_wait_for_writes - wait for a write
- * @dd: the hfi1_ib device
- *
- * We use this instead of udelay directly, so we can make sure
- * that previous register writes have been flushed all the way
- * to the chip.  Since we are delaying anyway, the cost doesn't
- * hurt, and makes the bit twiddling more regular
- */
-static void i2c_wait_for_writes(struct hfi1_devdata *dd, u32 target)
-{
-	/*
-	 * implicit read of EXTStatus is as good as explicit
-	 * read of scratch, if all we want to do is flush
-	 * writes.
-	 */
-	hfi1_gpio_mod(dd, target, 0, 0, 0);
-	rmb(); /* inlined, so prevent compiler reordering */
-}
-
-/*
- * QSFP modules are allowed to hold SCL low for 500uSec. Allow twice that
- * for "almost compliant" modules
- */
-#define SCL_WAIT_USEC 1000
-
-/* BUF_WAIT is time bus must be free between STOP or ACK and to next START.
- * Should be 20, but some chips need more.
- */
-#define TWSI_BUF_WAIT_USEC 60
-
-static void scl_out(struct hfi1_devdata *dd, u32 target, u8 bit)
-{
-	u32 mask;
-
-	udelay(1);
-
-	mask = QSFP_HFI0_I2CCLK;
-
-	/* SCL is meant to be bare-drain, so never set "OUT", just DIR */
-	hfi1_gpio_mod(dd, target, 0, bit ? 0 : mask, mask);
-
-	/*
-	 * Allow for slow slaves by simple
-	 * delay for falling edge, sampling on rise.
-	 */
-	if (!bit) {
-		udelay(2);
-	} else {
-		int rise_usec;
-
-		for (rise_usec = SCL_WAIT_USEC; rise_usec > 0; rise_usec -= 2) {
-			if (mask & hfi1_gpio_mod(dd, target, 0, 0, 0))
-				break;
-			udelay(2);
-		}
-		if (rise_usec <= 0)
-			dd_dev_err(dd, "SCL interface stuck low > %d uSec\n",
-				   SCL_WAIT_USEC);
-	}
-	i2c_wait_for_writes(dd, target);
-}
-
-static u8 scl_in(struct hfi1_devdata *dd, u32 target, int wait)
-{
-	u32 read_val, mask;
-
-	mask = QSFP_HFI0_I2CCLK;
-	/* SCL is meant to be bare-drain, so never set "OUT", just DIR */
-	hfi1_gpio_mod(dd, target, 0, 0, mask);
-	read_val = hfi1_gpio_mod(dd, target, 0, 0, 0);
-	if (wait)
-		i2c_wait_for_writes(dd, target);
-	return (read_val & mask) >> GPIO_SCL_NUM;
-}
-
-static void sda_out(struct hfi1_devdata *dd, u32 target, u8 bit)
-{
-	u32 mask;
-
-	mask = QSFP_HFI0_I2CDAT;
-
-	/* SDA is meant to be bare-drain, so never set "OUT", just DIR */
-	hfi1_gpio_mod(dd, target, 0, bit ? 0 : mask, mask);
-
-	i2c_wait_for_writes(dd, target);
-	udelay(2);
-}
-
-static u8 sda_in(struct hfi1_devdata *dd, u32 target, int wait)
-{
-	u32 read_val, mask;
-
-	mask = QSFP_HFI0_I2CDAT;
-	/* SDA is meant to be bare-drain, so never set "OUT", just DIR */
-	hfi1_gpio_mod(dd, target, 0, 0, mask);
-	read_val = hfi1_gpio_mod(dd, target, 0, 0, 0);
-	if (wait)
-		i2c_wait_for_writes(dd, target);
-	return (read_val & mask) >> GPIO_SDA_NUM;
-}
-
-/**
- * i2c_ackrcv - see if ack following write is true
- * @dd: the hfi1_ib device
- */
-static int i2c_ackrcv(struct hfi1_devdata *dd, u32 target)
-{
-	u8 ack_received;
-
-	/* AT ENTRY SCL = LOW */
-	/* change direction, ignore data */
-	ack_received = sda_in(dd, target, 1);
-	scl_out(dd, target, 1);
-	ack_received = sda_in(dd, target, 1) == 0;
-	scl_out(dd, target, 0);
-	return ack_received;
-}
-
-static void stop_cmd(struct hfi1_devdata *dd, u32 target);
-
-/**
- * rd_byte - read a byte, sending STOP on last, else ACK
- * @dd: the hfi1_ib device
- *
- * Returns byte shifted out of device
- */
-static int rd_byte(struct hfi1_devdata *dd, u32 target, int last)
-{
-	int bit_cntr, data;
-
-	data = 0;
-
-	for (bit_cntr = 7; bit_cntr >= 0; --bit_cntr) {
-		data <<= 1;
-		scl_out(dd, target, 1);
-		data |= sda_in(dd, target, 0);
-		scl_out(dd, target, 0);
-	}
-	if (last) {
-		scl_out(dd, target, 1);
-		stop_cmd(dd, target);
-	} else {
-		sda_out(dd, target, 0);
-		scl_out(dd, target, 1);
-		scl_out(dd, target, 0);
-		sda_out(dd, target, 1);
-	}
-	return data;
-}
-
-/**
- * wr_byte - write a byte, one bit at a time
- * @dd: the hfi1_ib device
- * @data: the byte to write
- *
- * Returns 0 if we got the following ack, otherwise 1
- */
-static int wr_byte(struct hfi1_devdata *dd, u32 target, u8 data)
-{
-	int bit_cntr;
-	u8 bit;
-
-	for (bit_cntr = 7; bit_cntr >= 0; bit_cntr--) {
-		bit = (data >> bit_cntr) & 1;
-		sda_out(dd, target, bit);
-		scl_out(dd, target, 1);
-		scl_out(dd, target, 0);
-	}
-	return (!i2c_ackrcv(dd, target)) ? 1 : 0;
-}
-
-/*
- * issue TWSI start sequence:
- * (both clock/data high, clock high, data low while clock is high)
- */
-static void start_seq(struct hfi1_devdata *dd, u32 target)
-{
-	sda_out(dd, target, 1);
-	scl_out(dd, target, 1);
-	sda_out(dd, target, 0);
-	udelay(1);
-	scl_out(dd, target, 0);
-}
-
-/**
- * stop_seq - transmit the stop sequence
- * @dd: the hfi1_ib device
- *
- * (both clock/data low, clock high, data high while clock is high)
- */
-static void stop_seq(struct hfi1_devdata *dd, u32 target)
-{
-	scl_out(dd, target, 0);
-	sda_out(dd, target, 0);
-	scl_out(dd, target, 1);
-	sda_out(dd, target, 1);
-}
-
-/**
- * stop_cmd - transmit the stop condition
- * @dd: the hfi1_ib device
- *
- * (both clock/data low, clock high, data high while clock is high)
- */
-static void stop_cmd(struct hfi1_devdata *dd, u32 target)
-{
-	stop_seq(dd, target);
-	udelay(TWSI_BUF_WAIT_USEC);
-}
-
-/**
- * hfi1_twsi_reset - reset I2C communication
- * @dd: the hfi1_ib device
- * returns 0 if ok, -EIO on error
- */
-int hfi1_twsi_reset(struct hfi1_devdata *dd, u32 target)
-{
-	int clock_cycles_left = 9;
-	u32 mask;
-
-	/* Both SCL and SDA should be high. If not, there
-	 * is something wrong.
-	 */
-	mask = QSFP_HFI0_I2CCLK | QSFP_HFI0_I2CDAT;
-
-	/*
-	 * Force pins to desired innocuous state.
-	 * This is the default power-on state with out=0 and dir=0,
-	 * So tri-stated and should be floating high (barring HW problems)
-	 */
-	hfi1_gpio_mod(dd, target, 0, 0, mask);
-
-	/* Check if SCL is low, if it is low then we have a slave device
-	 * misbehaving and there is not much we can do.
-	 */
-	if (!scl_in(dd, target, 0))
-		return -EIO;
-
-	/* Check if SDA is low, if it is low then we have to clock SDA
-	 * up to 9 times for the device to release the bus
-	 */
-	while (clock_cycles_left--) {
-		if (sda_in(dd, target, 0))
-			return 0;
-		scl_out(dd, target, 0);
-		scl_out(dd, target, 1);
-	}
-
-	return -EIO;
-}
-
-#define HFI1_TWSI_START 0x100
-#define HFI1_TWSI_STOP 0x200
-
-/* Write byte to TWSI, optionally prefixed with START or suffixed with
- * STOP.
- * returns 0 if OK (ACK received), else != 0
- */
-static int twsi_wr(struct hfi1_devdata *dd, u32 target, int data, int flags)
-{
-	int ret = 1;
-
-	if (flags & HFI1_TWSI_START)
-		start_seq(dd, target);
-
-	/* Leaves SCL low (from i2c_ackrcv()) */
-	ret = wr_byte(dd, target, data);
-
-	if (flags & HFI1_TWSI_STOP)
-		stop_cmd(dd, target);
-	return ret;
-}
-
-/* Added functionality for IBA7220-based cards */
-#define HFI1_TEMP_DEV 0x98
-
-/*
- * hfi1_twsi_blk_rd
- * General interface for data transfer from twsi devices.
- * One vestige of its former role is that it recognizes a device
- * HFI1_TWSI_NO_DEV and does the correct operation for the legacy part,
- * which responded to all TWSI device codes, interpreting them as
- * address within device. On all other devices found on board handled by
- * this driver, the device is followed by a N-byte "address" which selects
- * the "register" or "offset" within the device from which data should
- * be read.
- */
-int hfi1_twsi_blk_rd(struct hfi1_devdata *dd, u32 target, int dev, int addr,
-		     void *buffer, int len)
-{
-	u8 *bp = buffer;
-	int ret = 1;
-	int i;
-	int offset_size;
-
-	/* obtain the offset size, strip it from the device address */
-	offset_size = (dev >> 8) & 0xff;
-	dev &= 0xff;
-
-	/* allow at most a 2 byte offset */
-	if (offset_size > 2)
-		goto bail;
-
-	if (dev == HFI1_TWSI_NO_DEV) {
-		/* legacy not-really-I2C */
-		addr = (addr << 1) | READ_CMD;
-		ret = twsi_wr(dd, target, addr, HFI1_TWSI_START);
-	} else {
-		/* Actual I2C */
-		if (offset_size) {
-			ret = twsi_wr(dd, target,
-				      dev | WRITE_CMD, HFI1_TWSI_START);
-			if (ret) {
-				stop_cmd(dd, target);
-				goto bail;
-			}
-
-			for (i = 0; i < offset_size; i++) {
-				ret = twsi_wr(dd, target,
-					      (addr >> (i * 8)) & 0xff, 0);
-				udelay(TWSI_BUF_WAIT_USEC);
-				if (ret) {
-					dd_dev_err(dd, "Failed to write byte %d of offset 0x%04X\n",
-						   i, addr);
-					goto bail;
-				}
-			}
-		}
-		ret = twsi_wr(dd, target, dev | READ_CMD, HFI1_TWSI_START);
-	}
-	if (ret) {
-		stop_cmd(dd, target);
-		goto bail;
-	}
-
-	/*
-	 * block devices keeps clocking data out as long as we ack,
-	 * automatically incrementing the address. Some have "pages"
-	 * whose boundaries will not be crossed, but the handling
-	 * of these is left to the caller, who is in a better
-	 * position to know.
-	 */
-	while (len-- > 0) {
-		/*
-		 * Get and store data, sending ACK if length remaining,
-		 * else STOP
-		 */
-		*bp++ = rd_byte(dd, target, !len);
-	}
-
-	ret = 0;
-
-bail:
-	return ret;
-}
-
-/*
- * hfi1_twsi_blk_wr
- * General interface for data transfer to twsi devices.
- * One vestige of its former role is that it recognizes a device
- * HFI1_TWSI_NO_DEV and does the correct operation for the legacy part,
- * which responded to all TWSI device codes, interpreting them as
- * address within device. On all other devices found on board handled by
- * this driver, the device is followed by a N-byte "address" which selects
- * the "register" or "offset" within the device to which data should
- * be written.
- */
-int hfi1_twsi_blk_wr(struct hfi1_devdata *dd, u32 target, int dev, int addr,
-		     const void *buffer, int len)
-{
-	const u8 *bp = buffer;
-	int ret = 1;
-	int i;
-	int offset_size;
-
-	/* obtain the offset size, strip it from the device address */
-	offset_size = (dev >> 8) & 0xff;
-	dev &= 0xff;
-
-	/* allow at most a 2 byte offset */
-	if (offset_size > 2)
-		goto bail;
-
-	if (dev == HFI1_TWSI_NO_DEV) {
-		if (twsi_wr(dd, target, (addr << 1) | WRITE_CMD,
-			    HFI1_TWSI_START)) {
-			goto failed_write;
-		}
-	} else {
-		/* Real I2C */
-		if (twsi_wr(dd, target, dev | WRITE_CMD, HFI1_TWSI_START))
-			goto failed_write;
-	}
-
-	for (i = 0; i < offset_size; i++) {
-		ret = twsi_wr(dd, target, (addr >> (i * 8)) & 0xff, 0);
-		udelay(TWSI_BUF_WAIT_USEC);
-		if (ret) {
-			dd_dev_err(dd, "Failed to write byte %d of offset 0x%04X\n",
-				   i, addr);
-			goto bail;
-		}
-	}
-
-	for (i = 0; i < len; i++)
-		if (twsi_wr(dd, target, *bp++, 0))
-			goto failed_write;
-
-	ret = 0;
-
-failed_write:
-	stop_cmd(dd, target);
-
-bail:
-	return ret;
-}
diff --git a/drivers/infiniband/hw/hfi1/twsi.h b/drivers/infiniband/hw/hfi1/twsi.h
deleted file mode 100644
index 5b8a5b5..0000000
--- a/drivers/infiniband/hw/hfi1/twsi.h
+++ /dev/null
@@ -1,65 +0,0 @@
-#ifndef _TWSI_H
-#define _TWSI_H
-/*
- * Copyright(c) 2015, 2016 Intel Corporation.
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * BSD LICENSE
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  - Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  - Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  - Neither the name of Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- */
-
-#define HFI1_TWSI_NO_DEV 0xFF
-
-struct hfi1_devdata;
-
-/* Bit position of SDA/SCL pins in ASIC_QSFP* registers  */
-#define  GPIO_SDA_NUM 1
-#define  GPIO_SCL_NUM 0
-
-/* these functions must be called with qsfp_lock held */
-int hfi1_twsi_reset(struct hfi1_devdata *dd, u32 target);
-int hfi1_twsi_blk_rd(struct hfi1_devdata *dd, u32 target, int dev, int addr,
-		     void *buffer, int len);
-int hfi1_twsi_blk_wr(struct hfi1_devdata *dd, u32 target, int dev, int addr,
-		     const void *buffer, int len);
-
-#endif /* _TWSI_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
