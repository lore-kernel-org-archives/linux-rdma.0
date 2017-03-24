From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH 14/28] ibnbd: add headers shared by ibnbd_client and ibnbd_server
Date: Fri, 24 Mar 2017 11:45:29 +0100
Message-ID: <1490352343-20075-15-git-send-email-jinpu.wangl@profitbricks.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: dledford@redhat.com, axboe@kernel.dk, hch@lst.de, mail@fholler.de, Milind.dumbare@gmail.com, yun.wang@profitbricks.com, Jack Wang <jinpu.wang@profitbricks.com>, Kleber Souza <kleber.souza@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Roman Pen <roman.penyaev@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

From: Jack Wang <jinpu.wang@profitbricks.com>

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
Signed-off-by: Kleber Souza <kleber.souza@profitbricks.com>
Signed-off-by: Danil Kipnis <danil.kipnis@profitbricks.com>
Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
---
 drivers/block/ibnbd_inc/ibnbd-proto.h | 273 ++++++++++++++++++++++++++++++++++
 drivers/block/ibnbd_inc/ibnbd.h       |  55 +++++++
 drivers/block/ibnbd_inc/log.h         |  68 +++++++++
 3 files changed, 396 insertions(+)
 create mode 100644 drivers/block/ibnbd_inc/ibnbd-proto.h
 create mode 100644 drivers/block/ibnbd_inc/ibnbd.h
 create mode 100644 drivers/block/ibnbd_inc/log.h

diff --git a/drivers/block/ibnbd_inc/ibnbd-proto.h b/drivers/block/ibnbd_inc/ibnbd-proto.h
new file mode 100644
index 0000000..4838177
--- /dev/null
+++ b/drivers/block/ibnbd_inc/ibnbd-proto.h
@@ -0,0 +1,273 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler < mail@fholler.de>
+ *          Jack Wang <jinpu.wang@profitbricks.com>
+ *   	    Kleber Souza <kleber.souza@profitbricks.com>
+ * 	    Danil Kipnis <danil.kipnis@profitbricks.com>
+ *   	    Roman Pen <roman.penyaev@profitbricks.com>
+ *          Milind Dumbare <Milind.dumbare@gmail.com>
+ *
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#ifndef __IBNBD_PROTO_H
+#define __IBNBD_PROTO_H
+#include <linux/limits.h>
+#include "ibnbd.h"
+
+#define IBNBD_VERSION 1
+
+#define GCC_DIAGNOSTIC_AWARE ((__GNUC__ > 6))
+#if GCC_DIAGNOSTIC_AWARE
+#pragma GCC diagnostic push
+#pragma GCC diagnostic warning "-Wpadded"
+#endif
+
+/**
+ * enum ibnbd_msg_types - IBNBD message types
+ * @IBNBD_MSG_SESS_INFO:	initial session info from client to server
+ * @IBNBD_MSG_SESS_INFO_RSP:	initial session info from server to client
+ * @IBNBD_MSG_OPEN:		open connection to ibnbd server instance
+ * @IBNBD_MSG_OPEN_RSP:		response to an @IBNBD_MSG_OPEN
+ * @IBNBD_MSG_READ:		request block device read operation
+ * @IBNBD_MSG_WRITE:		request block device write operation
+ * @IBNBD_MSG_REVAL:		notify client about changed device size
+ *
+ * Note: DO NOT REORDER THE MEMBERS OF THIS ENUM!
+ * If necessary, add new members after the last one.
+ */
+enum ibnbd_msg_type {
+	__IBNBD_MSG_MIN,
+	IBNBD_MSG_SESS_INFO,
+	IBNBD_MSG_SESS_INFO_RSP,
+	IBNBD_MSG_OPEN,
+	IBNBD_MSG_OPEN_RSP,
+	IBNBD_MSG_IO,
+	IBNBD_MSG_CLOSE,
+	IBNBD_MSG_CLOSE_RSP,
+	IBNBD_MSG_REVAL,
+	__IBNBD_MSG_MAX
+};
+
+/**
+ * struct ibnbd_msg_hdr - header of IBNBD messages
+ * @type:	Message type, valid values see: enum ibnbd_msg_types
+ */
+struct ibnbd_msg_hdr {
+	u16		type;
+	u16		__padding;
+};
+
+enum ibnbd_access_mode {
+	IBNBD_ACCESS_RO,
+	IBNBD_ACCESS_RW,
+	IBNBD_ACCESS_MIGRATION,
+};
+
+#define _IBNBD_FILEIO  0
+#define _IBNBD_BLOCKIO 1
+#define _IBNBD_AUTOIO  2
+
+enum ibnbd_io_mode {
+	IBNBD_FILEIO = _IBNBD_FILEIO,
+	IBNBD_BLOCKIO = _IBNBD_BLOCKIO,
+	IBNBD_AUTOIO = _IBNBD_AUTOIO,
+};
+
+/**
+ * struct ibnbd_msg_sess_info - initial session info from client to server
+ * @hdr:		message header
+ * @ver:		IBNBD protocol version
+ *
+ * Note: DO NOT CHANGE THE ORDER OF THE MEMBERS BEFORE 'ver'
+ */
+struct ibnbd_msg_sess_info {
+	struct ibnbd_msg_hdr hdr;
+
+	u8		ver;
+	u8		reserved[31];
+};
+
+/**
+ * struct ibnbd_msg_sess_info_rsp - initial session info from server to client
+ * @hdr:		message header
+ * @ver:		IBNBD protocol version
+ *
+ * Note: DO NOT CHANGE THE ORDER OF THE MEMBERS BEFORE 'ver'
+ */
+struct ibnbd_msg_sess_info_rsp {
+	struct ibnbd_msg_hdr hdr;
+
+	u8		ver;
+	u8		reserved[31];
+};
+
+/**
+ * struct ibnbd_msg_open - request to open a remote device.
+ * @hdr:		message header
+ * @clt_device_id:	device_id on client side to identify the device
+ * @access_mode:	the mode to open remote device, valid values see:
+ *			enum ibnbd_access_mode
+ * @io_mode:		Open volume on server as block device or as file
+ * @device_name:	device path on remote side
+ */
+struct ibnbd_msg_open {
+	struct ibnbd_msg_hdr hdr;
+	u32		clt_device_id;
+	u8		access_mode;
+	u8		io_mode;
+	s8		dev_name[NAME_MAX];
+	u8		__padding[3];
+};
+
+/**
+ * struct ibnbd_msg_close - request to close a remote device.
+ * @hdr:	message header
+ * @device_id:	device_id on server side to identify the device
+ */
+struct ibnbd_msg_close {
+	struct ibnbd_msg_hdr hdr;
+	u32		device_id;
+};
+
+/**
+ * struct ibnbd_msg_close_rsp - response to a close device message.
+ * @hdr:	message header
+ * @clt_device_id:	device_id on client side
+ */
+struct ibnbd_msg_close_rsp {
+	struct ibnbd_msg_hdr hdr;
+	u32		clt_device_id;
+};
+
+/**
+ * struct ibnbd_msg_open_rsp - response message to IBNBD_MSG_OPEN
+ * @hdr:		message header
+ * @result:		0 on success or negative error code on failure
+ * @clt_device_id:	device_id on client side
+ * @device_id:		device_id on server side to identify the device
+ * @queue_flags:	queue_flags of the device on server side
+ * @max_hw_sectors:	max hardware sectors in the usual 512b unit
+ * @max_write_same_sectors: max sectors for WRITE SAME in the 512b unit
+ * @max_discard_sectors: max. sectors that can be discarded at once
+ * @discard_zeroes_data: discarded areas are overwritten with 0?
+ * @discard_granularity: size of the internal discard allocation unit
+ * @discard_alignment: offset from internal allocation assignment
+ * @physical_block_size: physical block size device supports
+ * @logical_block_size: logical block size device supports
+ * @max_segments:	max segments hardware support in one transfer
+ * @nsectors:		number of sectors
+ * @secure_discard:	supports secure discard
+ * @rotation:		is a rotational disc?
+ * @io_mode:		io_mode device is opened.
+ */
+struct ibnbd_msg_open_rsp {
+	struct ibnbd_msg_hdr	hdr;
+	s32			result;
+	u32			clt_device_id;
+	u32			device_id;
+	u32			max_hw_sectors;
+	u32			max_write_same_sectors;
+	u32			max_discard_sectors;
+	u32			discard_zeroes_data;
+	u32			discard_granularity;
+	u32			discard_alignment;
+	u16			physical_block_size;
+	u16			logical_block_size;
+	u16			max_segments;
+	u16			secure_discard;
+	u64			nsectors;
+	u8			rotational;
+	u8			io_mode;
+	u8			__padding[6];
+};
+
+/**
+ * enum ibnbd_io_flags - IBNBD request types from rq_flag_bits
+ * @IBNBD_RW_REQ_WRITE:	bit not set = read, bit set = write
+ * @IBNBD_RW_REQ_SYNC:	request is sync
+ * @IBNBD_RW_REQ_DISCARD: request to discard sectors
+ * @IBNBD_RW_REQ_SECURE: secure discard request
+ * @IBNBD_RW_REQ_WRITE_SAME: write same block many times
+ */
+enum ibnbd_io_flags {
+	IBNBD_RW_REQ_WRITE		= 1 << 1,
+	IBNBD_RW_REQ_SYNC		= 1 << 2,
+	IBNBD_RW_REQ_DISCARD		= 1 << 3,
+	IBNBD_RW_REQ_SECURE		= 1 << 4,
+	IBNBD_RW_REQ_WRITE_SAME		= 1 << 5,
+	IBNBD_RW_REQ_FUA		= 1 << 6,
+	IBNBD_RW_REQ_FLUSH		= 1 << 7
+};
+
+/**
+ * struct ibnbd_msg_revalidate - notify client about new device size
+ * @hdr:		message header
+ * @clt_device_id:	device_id on client side
+ * @nsectors:		number of sectors
+ */
+struct ibnbd_msg_revalidate {
+	struct ibnbd_msg_hdr	hdr;
+	u32			clt_device_id;
+	u64			nsectors;
+};
+
+/**
+ * struct ibnbd_msg_io - message for I/O read/write
+ * @hdr:	message header
+ * @device_id:	device_id on server side to find the right device
+ * @sector:	bi_sector attribute from struct bio
+ * @rw:		bitmask, valid values are defined in enum ibnbd_io_flags
+ * @bi_size:   number of bytes for I/O read/write
+ */
+struct ibnbd_msg_io {
+	struct ibnbd_msg_hdr hdr;
+	u32		device_id;
+	u64		sector;
+	u32		rw;
+	u32		bi_size;
+};
+
+#if GCC_DIAGNOSTIC_AWARE
+#pragma GCC diagnostic pop
+#endif
+
+int ibnbd_validate_message(const void *data, size_t len);
+const char *ibnbd_io_mode_str(enum ibnbd_io_mode mode);
+const char *ibnbd_access_mode_str(enum ibnbd_access_mode mode);
+
+#endif /* __IBNBD_PROTO_H */
diff --git a/drivers/block/ibnbd_inc/ibnbd.h b/drivers/block/ibnbd_inc/ibnbd.h
new file mode 100644
index 0000000..4b691dc
--- /dev/null
+++ b/drivers/block/ibnbd_inc/ibnbd.h
@@ -0,0 +1,55 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler < mail@fholler.de>
+ *          Jack Wang <jinpu.wang@profitbricks.com>
+ *   	    Kleber Souza <kleber.souza@profitbricks.com>
+ * 	    Danil Kipnis <danil.kipnis@profitbricks.com>
+ *   	    Roman Pen <roman.penyaev@profitbricks.com>
+ *          Milind Dumbare <Milind.dumbare@gmail.com>
+ *
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#ifndef __IBNBD_H
+#define __IBNBD_H
+#include <linux/types.h>
+#include <linux/blkdev.h>
+
+
+u32 rq_cmd_to_ibnbd_io_flags(struct request *rq);
+u32 ibnbd_io_flags_to_bi_rw(u32 flags);
+#endif
diff --git a/drivers/block/ibnbd_inc/log.h b/drivers/block/ibnbd_inc/log.h
new file mode 100644
index 0000000..9048bff
--- /dev/null
+++ b/drivers/block/ibnbd_inc/log.h
@@ -0,0 +1,68 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler < mail@fholler.de>
+ *          Jack Wang <jinpu.wang@profitbricks.com>
+ *   	    Kleber Souza <kleber.souza@profitbricks.com>
+ * 	    Danil Kipnis <danil.kipnis@profitbricks.com>
+ *   	    Roman Pen <roman.penyaev@profitbricks.com>
+ *          Milind Dumbare <Milind.dumbare@gmail.com>
+ *
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#ifndef __IBNBD_LOG_H__
+#define __IBNBD_LOG_H__
+
+#define ERR_NP(fmt, ...) pr_err("ibnbd L%d ERR: " fmt, \
+				__LINE__, ##__VA_ARGS__)
+#define ERR_NP_RL(fmt, ...) pr_err_ratelimited("ibnbd L%d ERR: " fmt, \
+				__LINE__, ##__VA_ARGS__)
+
+#define WRN_NP(fmt, ...) pr_warn("ibnbd L%d WARN: " fmt, \
+				__LINE__, ##__VA_ARGS__)
+#define WRN_NP_RL(fmt, ...) pr_warn_ratelimited("ibnbd L%d WARN: " fmt,\
+				__LINE__, ##__VA_ARGS__)
+
+#define INFO_NP(fmt, ...)  pr_info("ibnbd: " fmt, ##__VA_ARGS__)
+#define INFO_NP_RL(fmt, ...) pr_info_ratelimited("ibnbd: " fmt, ##__VA_ARGS__)
+
+#define DEB(fmt, ...) pr_debug("ibnbd L%d " fmt, __LINE__, ##__VA_ARGS__)
+
+#define ibnbd_prefix(dev) ((dev->sess->hostname[0] != '\0') ? \
+			    dev->sess->hostname : dev->sess->str_addr)
+
+#endif /*__IBNBD_LOG_H__*/
-- 
2.7.4
