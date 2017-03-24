From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 15/28] ibnbd: add shared library functions
Date: Fri, 24 Mar 2017 11:45:30 +0100
Message-ID: <1490352343-20075-16-git-send-email-jinpu.wangl@profitbricks.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490352343-20075-1-git-send-email-jinpu.wangl-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, mail-99BIx50xQYGELgA04lAiVw@public.gmane.org, Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/block/ibnbd_lib/ibnbd-proto.c | 244 ++++++++++++++++++++++++++++++++++
 drivers/block/ibnbd_lib/ibnbd.c       | 108 +++++++++++++++
 2 files changed, 352 insertions(+)
 create mode 100644 drivers/block/ibnbd_lib/ibnbd-proto.c
 create mode 100644 drivers/block/ibnbd_lib/ibnbd.c

diff --git a/drivers/block/ibnbd_lib/ibnbd-proto.c b/drivers/block/ibnbd_lib/ibnbd-proto.c
new file mode 100644
index 0000000..c6d83f2
--- /dev/null
+++ b/drivers/block/ibnbd_lib/ibnbd-proto.c
@@ -0,0 +1,244 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler < mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>
+ *          Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *   	    Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ * 	    Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *   	    Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Milind Dumbare <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+#include "../ibnbd_inc/ibnbd-proto.h"
+#include "../ibnbd_inc/log.h"
+
+static int ibnbd_validate_msg_sess_info(const struct ibnbd_msg_sess_info *msg,
+					size_t len)
+{
+	if (unlikely(len != sizeof(*msg))) {
+		ERR_NP("Sess info message with unexpected length received"
+		       " %lu instead of %lu\n", len, sizeof(*msg));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+ibnbd_validate_msg_sess_info_rsp(const struct ibnbd_msg_sess_info_rsp *msg,
+				 size_t len)
+{
+	if (unlikely(len != sizeof(*msg))) {
+		ERR_NP("Sess info message with unexpected length received"
+		       " %lu instead of %lu\n", len, sizeof(*msg));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ibnbd_validate_msg_open_resp(const struct ibnbd_msg_open_rsp *msg,
+					size_t len)
+{
+	if (unlikely(msg->result))
+		return 0;
+
+	if (unlikely(len != sizeof(*msg))) {
+		ERR_NP("Open Response msg received with unexpected length"
+		       " %zuB instead of %luB\n", len, sizeof(*msg));
+		return -EINVAL;
+	}
+
+	if (unlikely(!msg->logical_block_size)) {
+		ERR_NP("Open Resp msg received with unexpected with"
+		       " invalid logical_block_size value %d\n",
+		       msg->logical_block_size);
+		return -EINVAL;
+	}
+
+	if (unlikely(!msg->physical_block_size)) {
+		ERR_NP("Open Resp msg received with invalid"
+		       " physical_block_size value %d\n",
+		       msg->physical_block_size);
+		return -EINVAL;
+	}
+
+	if (unlikely(!msg->max_hw_sectors)) {
+		ERR_NP("Open Resp msg received with invalid"
+		       " max_hw_sectors value %d\n", msg->max_hw_sectors);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ibnbd_validate_msg_revalidate(const struct ibnbd_msg_revalidate *msg,
+					 size_t len)
+{
+	if (unlikely(len != sizeof(*msg))) {
+		ERR_NP("Device resize message with unexpected length received"
+		       " %lu instead of %lu\n", len, sizeof(*msg));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ibnbd_validate_msg_open(const struct ibnbd_msg_open *msg,
+				   size_t len)
+{
+	if (len != sizeof(*msg)) {
+		ERR_NP("Open msg received with unexpected length"
+		       " %zuB instead of %luB\n", len, sizeof(*msg));
+		return -EINVAL;
+	}
+	if (msg->dev_name[strnlen(msg->dev_name, NAME_MAX)] != '\0') {
+		ERR_NP("Open msg received with invalid dev_name value,"
+		       " null terminator missing\n");
+		return -EINVAL;
+	}
+
+	if (unlikely(msg->access_mode != IBNBD_ACCESS_RO &&
+		     msg->access_mode != IBNBD_ACCESS_RW &&
+		     msg->access_mode != IBNBD_ACCESS_MIGRATION)) {
+		ERR_NP("Open msg received with invalid access_mode value %d\n",
+		       msg->access_mode);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ibnbd_validate_msg_close(const struct ibnbd_msg_close *msg, size_t
+				    len)
+{
+	if (unlikely(len != sizeof(*msg))) {
+		ERR_NP("Close msg received with unexpected length %lu instead"
+		       " of %lu\n", len, sizeof(*msg));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ibnbd_validate_msg_close_rsp(const struct ibnbd_msg_close_rsp *msg,
+					size_t len)
+{
+	if (unlikely(len != sizeof(*msg))) {
+		ERR_NP("Close_rsp msg received with unexpected length %lu"
+		       " instead of %lu\n", len, sizeof(*msg));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int ibnbd_validate_message(const void *data, size_t len)
+{
+	const struct ibnbd_msg_hdr *hdr = data;
+
+	switch (hdr->type) {
+	case IBNBD_MSG_SESS_INFO: {
+		const struct ibnbd_msg_sess_info *msg = data;
+
+		return ibnbd_validate_msg_sess_info(msg, len);
+	}
+	case IBNBD_MSG_SESS_INFO_RSP: {
+		const struct ibnbd_msg_sess_info_rsp *msg = data;
+
+		return ibnbd_validate_msg_sess_info_rsp(msg, len);
+	}
+	case IBNBD_MSG_OPEN_RSP: {
+		const struct ibnbd_msg_open_rsp *msg = data;
+
+		return ibnbd_validate_msg_open_resp(msg, len);
+	}
+	case IBNBD_MSG_REVAL: {
+		const struct ibnbd_msg_revalidate *msg = data;
+
+		return ibnbd_validate_msg_revalidate(msg, len);
+	}
+	case IBNBD_MSG_OPEN: {
+		const struct ibnbd_msg_open *msg = data;
+
+		return ibnbd_validate_msg_open(msg, len);
+	}
+	case IBNBD_MSG_CLOSE: {
+		const struct ibnbd_msg_close *msg = data;
+
+		return ibnbd_validate_msg_close(msg, len);
+	}
+	case IBNBD_MSG_CLOSE_RSP: {
+		const struct ibnbd_msg_close_rsp *msg = data;
+
+		return ibnbd_validate_msg_close_rsp(msg, len);
+	}
+	default:
+		ERR_NP("Ignoring received message with unknown type %d\n",
+		       hdr->type);
+		return -EINVAL;
+	}
+}
+
+const char *ibnbd_io_mode_str(enum ibnbd_io_mode mode)
+{
+	switch (mode) {
+	case IBNBD_FILEIO:
+		return "fileio";
+	case IBNBD_BLOCKIO:
+		return "blockio";
+	case IBNBD_AUTOIO:
+		return "autoio";
+	default:
+		return "unknown";
+	}
+}
+
+const char *ibnbd_access_mode_str(enum ibnbd_access_mode mode)
+{
+	switch (mode) {
+	case IBNBD_ACCESS_RO:
+		return "ro";
+	case IBNBD_ACCESS_RW:
+		return "rw";
+	case IBNBD_ACCESS_MIGRATION:
+		return "migration";
+	default:
+		return "unknown";
+	}
+}
diff --git a/drivers/block/ibnbd_lib/ibnbd.c b/drivers/block/ibnbd_lib/ibnbd.c
new file mode 100644
index 0000000..1ba4777
--- /dev/null
+++ b/drivers/block/ibnbd_lib/ibnbd.c
@@ -0,0 +1,108 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler < mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>
+ *          Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *   	    Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ * 	    Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *   	    Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Milind Dumbare <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+#include <linux/ctype.h>
+#include "../ibnbd_inc/ibnbd.h"
+#include "../ibnbd_inc/ibnbd-proto.h"
+
+u32 ibnbd_io_flags_to_bi_rw(u32 flags)
+{
+	u32 result = 0;
+
+	if (flags == 0)
+		return result;
+
+	if (flags & IBNBD_RW_REQ_WRITE)
+		result |= WRITE;
+
+	if (flags & IBNBD_RW_REQ_SYNC)
+		result |= REQ_SYNC;
+
+	if (flags & IBNBD_RW_REQ_DISCARD)
+		result |= REQ_OP_DISCARD;
+
+	if (flags & IBNBD_RW_REQ_SECURE)
+		result |= REQ_OP_SECURE_ERASE;
+
+	if (flags & IBNBD_RW_REQ_WRITE_SAME)
+		result |= REQ_OP_WRITE_SAME;
+
+	if (flags & IBNBD_RW_REQ_FUA)
+		result |= REQ_FUA;
+
+	if (flags & IBNBD_RW_REQ_FLUSH)
+		result |= REQ_OP_FLUSH | REQ_PREFLUSH;
+
+	return result;
+}
+
+u32 rq_cmd_to_ibnbd_io_flags(struct request *rq)
+{
+	u32 result = 0;
+
+	if (req_op(rq) == REQ_OP_WRITE)
+		result |= IBNBD_RW_REQ_WRITE;
+
+	if (rq_is_sync(rq))
+		result |= IBNBD_RW_REQ_SYNC;
+
+	if (req_op(rq) == REQ_OP_DISCARD)
+		result |= IBNBD_RW_REQ_DISCARD;
+
+	if (req_op(rq) == REQ_OP_SECURE_ERASE)
+		result |= IBNBD_RW_REQ_SECURE;
+
+	if (req_op(rq) == REQ_OP_WRITE_SAME)
+		result |= IBNBD_RW_REQ_WRITE_SAME;
+
+	if (rq->cmd_flags & REQ_FUA)
+		result |= IBNBD_RW_REQ_FUA;
+
+	if (req_op(rq) == REQ_OP_FLUSH)
+		result |= IBNBD_RW_REQ_FLUSH;
+
+	return result;
+}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
