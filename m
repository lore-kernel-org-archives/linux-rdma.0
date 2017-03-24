From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH 03/28] ibtrs_lib: add common functions shared by client and server
Date: Fri, 24 Mar 2017 11:45:18 +0100
Message-ID: <1490352343-20075-4-git-send-email-jinpu.wangl@profitbricks.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: dledford@redhat.com, axboe@kernel.dk, hch@lst.de, mail@fholler.de, Milind.dumbare@gmail.com, yun.wang@profitbricks.com, Jack Wang <jinpu.wang@profitbricks.com>, Kleber Souza <kleber.souza@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Roman Pen <roman.penyaev@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

From: Jack Wang <jinpu.wang@profitbricks.com>

These files define functions used by both client and server, eg
validate protocol message, heartbeat helpers, etc.

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
Signed-off-by: Kleber Souza <kleber.souza@profitbricks.com>
Signed-off-by: Danil Kipnis <danil.kipnis@profitbricks.com>
Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
---
 drivers/infiniband/ulp/ibtrs_lib/common.c      | 104 +++++++
 drivers/infiniband/ulp/ibtrs_lib/heartbeat.c   | 112 +++++++
 drivers/infiniband/ulp/ibtrs_lib/ibtrs-proto.c | 248 +++++++++++++++
 drivers/infiniband/ulp/ibtrs_lib/ibtrs.c       | 412 +++++++++++++++++++++++++
 drivers/infiniband/ulp/ibtrs_lib/iu.c          | 113 +++++++
 5 files changed, 989 insertions(+)
 create mode 100644 drivers/infiniband/ulp/ibtrs_lib/common.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_lib/heartbeat.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_lib/ibtrs-proto.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_lib/ibtrs.c
 create mode 100644 drivers/infiniband/ulp/ibtrs_lib/iu.c

diff --git a/drivers/infiniband/ulp/ibtrs_lib/common.c b/drivers/infiniband/ulp/ibtrs_lib/common.c
new file mode 100644
index 0000000..81affa7
--- /dev/null
+++ b/drivers/infiniband/ulp/ibtrs_lib/common.c
@@ -0,0 +1,104 @@
+/*
+ * InfiniBand Transport Layer
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
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <rdma/ibtrs.h>
+
+u64 timediff_cur_ms(u64 cur_ms)
+{
+	struct timespec cur = CURRENT_TIME;
+	struct timespec ts = ns_to_timespec(cur_ms * NSEC_PER_MSEC);
+
+	if (timespec_compare(&cur, &ts) < 0)
+		return timespec_to_ms(&ts) - timespec_to_ms(&cur);
+	else
+		return timespec_to_ms(&cur) - timespec_to_ms(&ts);
+}
+
+/*
+ * ibtrs_malloc() - allocate kernel or virtual memory
+ * @size: size to be allocated
+ *
+ * The pointer returned must be freed with kvfree()
+ */
+void *ibtrs_malloc(size_t size)
+{
+	void *p;
+
+	p = kmalloc(size, (GFP_KERNEL | __GFP_REPEAT));
+	if (p)
+		return p;
+
+	/* try allocating virtual memory */
+	p = vmalloc(size);
+	if (p)
+		return p;
+
+	return NULL;
+}
+
+/*
+ * ibtrs_zalloc() - allocate kernel or virtual memory
+ * @size: size to be allocated
+ *
+ * The pointer returned must be freed with kvfree()
+ */
+void *ibtrs_zalloc(size_t size)
+{
+	void *p;
+
+	p = kzalloc(size, GFP_KERNEL);
+	if (p)
+		return p;
+
+	/* try allocating virtual memory */
+	p = vzalloc(size);
+	if (p)
+		return p;
+
+	return NULL;
+}
diff --git a/drivers/infiniband/ulp/ibtrs_lib/heartbeat.c b/drivers/infiniband/ulp/ibtrs_lib/heartbeat.c
new file mode 100644
index 0000000..1575931
--- /dev/null
+++ b/drivers/infiniband/ulp/ibtrs_lib/heartbeat.c
@@ -0,0 +1,112 @@
+/*
+ * InfiniBand Transport Layer
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
+#include <rdma/ibtrs.h>
+#include <rdma/ibtrs_log.h>
+
+inline void ibtrs_heartbeat_set_send_ts(struct ibtrs_heartbeat *h)
+{
+	struct timespec ts = CURRENT_TIME;
+
+	atomic64_set(&h->send_ts_ms, timespec_to_ms(&ts));
+}
+
+inline void ibtrs_set_last_heartbeat(struct ibtrs_heartbeat *h)
+{
+	struct timespec ts = CURRENT_TIME;
+
+	atomic64_set(&h->recv_ts_ms, timespec_to_ms(&ts));
+}
+
+inline u64 ibtrs_heartbeat_send_ts_diff_ms(const struct ibtrs_heartbeat *h)
+{
+	return timediff_cur_ms(atomic64_read(&h->send_ts_ms));
+}
+
+inline u64 ibtrs_recv_ts_ms_diff_ms(const struct ibtrs_heartbeat *h)
+{
+	return timediff_cur_ms(atomic64_read(&h->recv_ts_ms));
+}
+
+void ibtrs_set_heartbeat_timeout(struct ibtrs_heartbeat *h, u32 timeout_ms)
+{
+	h->timeout_ms = timeout_ms;
+	h->warn_timeout_ms = (timeout_ms >> 1) + (timeout_ms >> 2);
+}
+
+void ibtrs_heartbeat_warn(const struct ibtrs_heartbeat *h)
+{
+	u64 diff = ibtrs_recv_ts_ms_diff_ms(h);
+
+	DEB("last heartbeat message from %s was received %lu, %llums"
+	    " ago\n", ibtrs_prefix(h), atomic64_read(&h->recv_ts_ms), diff);
+
+	if (diff >= h->warn_timeout_ms)
+		WRN(h, "Last Heartbeat message received %llums ago,"
+		       " timeout: %ums\n", diff, h->timeout_ms);
+}
+
+bool ibtrs_heartbeat_timeout_is_expired(const struct ibtrs_heartbeat *h)
+{
+	u64 diff;
+
+	if (h->timeout_ms == 0)
+		return false;
+
+	diff = ibtrs_recv_ts_ms_diff_ms(h);
+
+	DEB("last heartbeat message from %s received %lu, %llums ago\n",
+	    ibtrs_prefix(h), atomic64_read(&h->recv_ts_ms), diff);
+
+	if (diff >= h->timeout_ms) {
+		ERR(h, "Heartbeat timeout expired, no heartbeat received "
+		       "for %llums, timeout: %ums\n", diff,
+		       h->timeout_ms);
+		return true;
+	}
+
+	return false;
+}
diff --git a/drivers/infiniband/ulp/ibtrs_lib/ibtrs-proto.c b/drivers/infiniband/ulp/ibtrs_lib/ibtrs-proto.c
new file mode 100644
index 0000000..43ae8ec
--- /dev/null
+++ b/drivers/infiniband/ulp/ibtrs_lib/ibtrs-proto.c
@@ -0,0 +1,248 @@
+/*
+ * InfiniBand Transport Layer
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
+#include <linux/errno.h>
+#include <linux/printk.h>
+#include <rdma/ibtrs.h>
+#include <rdma/ibtrs_log.h>
+
+static int
+ibtrs_validate_msg_sess_open_resp(const struct ibtrs_msg_sess_open_resp *msg)
+{
+	static const int min_bufs = 1;
+
+	if (unlikely(msg->hdr.tsize !=
+				IBTRS_MSG_SESS_OPEN_RESP_LEN(msg->cnt))) {
+		ERR_NP("Session open resp msg received with unexpected length"
+		       " %dB instead of %luB\n", msg->hdr.tsize,
+		       IBTRS_MSG_SESS_OPEN_RESP_LEN(msg->cnt));
+
+		return -EINVAL;
+	}
+
+	if (msg->max_inflight_msg < min_bufs) {
+		ERR_NP("Sess Open msg received with invalid max_inflight_msg %d"
+		       " expected >= %d\n", msg->max_inflight_msg, min_bufs);
+		return -EINVAL;
+	}
+
+	if (unlikely(msg->cnt != msg->max_inflight_msg)) {
+		ERR_NP("Session open msg received with invalid cnt %d"
+		       " expected %d (queue_depth)\n", msg->cnt,
+		       msg->max_inflight_msg);
+		return -EINVAL;
+	}
+
+	if (msg->ver != IBTRS_VERSION) {
+		WRN_NP("Sess open resp version mismatch: client version %d,"
+		       " server version: %d\n", IBTRS_VERSION, msg->ver);
+	}
+
+	return 0;
+}
+
+static int
+ibtrs_validate_msg_user(const struct ibtrs_msg_user *msg)
+{
+	/* keep as place holder */
+	return 0;
+}
+
+static int
+ibtrs_validate_msg_rdma_write(const struct ibtrs_msg_rdma_write *msg,
+			      u16 queue_depth)
+{
+	if (unlikely(msg->hdr.tsize <= sizeof(*msg))) {
+		ERR_NP("RDMA-Write msg received with invalid length %d"
+		       " expected > %lu\n", msg->hdr.tsize, sizeof(*msg));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+ibtrs_validate_msg_req_rdma_write(const struct ibtrs_msg_req_rdma_write *msg,
+				  u16 queue_depth)
+{
+	if (unlikely(msg->hdr.tsize <= sizeof(*msg))) {
+		ERR_NP("Request-RDMA-Write msg request received with invalid"
+		       " length %d expected > %lu\n", msg->hdr.tsize,
+		       sizeof(*msg));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+ibtrs_validate_msg_con_open(const struct ibtrs_msg_con_open *msg)
+{
+	if (unlikely(msg->hdr.tsize != sizeof(*msg))) {
+		ERR_NP("Con Open msg received with invalid length: %d"
+		       " expected %lu\n", msg->hdr.tsize, sizeof(*msg));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+ibtrs_validate_msg_sess_open(const struct ibtrs_msg_sess_open *msg)
+{
+	if (msg->hdr.tsize != sizeof(*msg)) {
+		ERR_NP("Sess open msg received with invalid length: %d"
+		       " expected %lu\n", msg->hdr.tsize, sizeof(*msg));
+		return -EPROTONOSUPPORT;
+	}
+
+	if (msg->ver != IBTRS_VERSION) {
+		WRN_NP("Sess open msg version mismatch: client version %d,"
+		       " server version: %d\n", msg->ver, IBTRS_VERSION);
+	}
+
+	return 0;
+}
+
+static int ibtrs_validate_msg_sess_info(const struct ibtrs_msg_sess_info *msg)
+{
+	if (msg->hdr.tsize != sizeof(*msg)) {
+		ERR_NP("Error message received with invalid length: %d,"
+		       " expected %lu\n", msg->hdr.tsize, sizeof(*msg));
+		return -EPROTONOSUPPORT;
+	}
+
+	return 0;
+}
+
+static int ibtrs_validate_msg_error(const struct ibtrs_msg_error *msg)
+{
+	if (msg->hdr.tsize != sizeof(*msg)) {
+		ERR_NP("Error message received with invalid length: %d,"
+		       " expected %lu\n", msg->hdr.tsize, sizeof(*msg));
+		return -EPROTONOSUPPORT;
+	}
+
+	return 0;
+}
+
+int ibtrs_validate_message(u16 queue_depth, const void *data)
+{
+	const struct ibtrs_msg_hdr *hdr = data;
+
+	switch (hdr->type) {
+	case IBTRS_MSG_RDMA_WRITE: {
+		const struct ibtrs_msg_rdma_write *msg = data;
+
+		return ibtrs_validate_msg_rdma_write(msg, queue_depth);
+	}
+	case IBTRS_MSG_REQ_RDMA_WRITE: {
+		const struct ibtrs_msg_req_rdma_write *req = data;
+
+		return ibtrs_validate_msg_req_rdma_write(req, queue_depth);
+	}
+	case IBTRS_MSG_SESS_OPEN_RESP: {
+		const struct ibtrs_msg_sess_open_resp *msg = data;
+
+		return ibtrs_validate_msg_sess_open_resp(msg);
+	}
+	case IBTRS_MSG_SESS_INFO: {
+		const struct ibtrs_msg_sess_info *msg = data;
+
+		return ibtrs_validate_msg_sess_info(msg);
+	}
+	case IBTRS_MSG_USER: {
+		const struct ibtrs_msg_user *msg = data;
+
+		return ibtrs_validate_msg_user(msg);
+	}
+	case IBTRS_MSG_CON_OPEN: {
+		const struct ibtrs_msg_con_open *msg = data;
+
+		return ibtrs_validate_msg_con_open(msg);
+	}
+	case IBTRS_MSG_SESS_OPEN: {
+		const struct ibtrs_msg_sess_open *msg = data;
+
+		return ibtrs_validate_msg_sess_open(msg);
+	}
+	case IBTRS_MSG_ERROR: {
+		const struct ibtrs_msg_error *msg = data;
+
+		return ibtrs_validate_msg_error(msg);
+	}
+	default:
+		ERR_NP("Received IBTRS message with unknown type\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+void fill_ibtrs_msg_sess_open(struct ibtrs_msg_sess_open *msg, u8 con_cnt,
+			      const uuid_le *uuid)
+{
+	msg->hdr.type		= IBTRS_MSG_SESS_OPEN;
+	msg->hdr.tsize		= sizeof(*msg);
+	msg->ver		= IBTRS_VERSION;
+	msg->con_cnt		= con_cnt;
+
+	memcpy(msg->uuid, uuid->b, IBTRS_UUID_SIZE);
+}
+
+void fill_ibtrs_msg_con_open(struct ibtrs_msg_con_open *msg,
+			     const uuid_le *uuid)
+{
+	msg->hdr.type		= IBTRS_MSG_CON_OPEN;
+	msg->hdr.tsize		= sizeof(*msg);
+	memcpy(msg->uuid, uuid->b, IBTRS_UUID_SIZE);
+}
+
+void fill_ibtrs_msg_sess_info(struct ibtrs_msg_sess_info *msg,
+			      const char *hostname) {
+	msg->hdr.type		= IBTRS_MSG_SESS_INFO;
+	msg->hdr.tsize		= sizeof(*msg);
+	memcpy(msg->hostname, hostname, sizeof(msg->hostname));
+}
diff --git a/drivers/infiniband/ulp/ibtrs_lib/ibtrs.c b/drivers/infiniband/ulp/ibtrs_lib/ibtrs.c
new file mode 100644
index 0000000..2bebcd0
--- /dev/null
+++ b/drivers/infiniband/ulp/ibtrs_lib/ibtrs.c
@@ -0,0 +1,412 @@
+/*
+ * InfiniBand Transport Layer
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
+#include <rdma/ibtrs.h>
+#include <rdma/ibtrs_log.h>
+#include <rdma/ib.h>
+
+int ibtrs_write_empty_imm(struct ib_qp *qp, u32 imm_data,
+			  enum ib_send_flags flags)
+{
+	struct ib_send_wr wr, *bad_wr;
+
+	memset(&wr, 0, sizeof(wr));
+	wr.send_flags	= flags;
+	wr.opcode	= IB_WR_RDMA_WRITE_WITH_IMM;
+	wr.ex.imm_data	= cpu_to_be32(imm_data);
+
+	return ib_post_send(qp, &wr, &bad_wr);
+}
+
+int ibtrs_post_send(struct ib_qp *qp, struct ib_mr *mr, struct ibtrs_iu *iu,
+		    u32 size)
+{
+	struct ib_sge list;
+	struct ib_send_wr wr, *bad_wr;
+
+	if ((WARN_ON(size == 0)))
+		return -EINVAL;
+
+	list.addr   = iu->dma_addr;
+	list.length = size;
+	list.lkey   = mr->lkey;
+
+	memset(&wr, 0, sizeof(wr));
+	wr.next       = NULL;
+	wr.wr_id      = (uintptr_t)iu;
+	wr.sg_list    = &list;
+	wr.num_sge    = 1;
+	wr.opcode     = IB_WR_SEND;
+	wr.send_flags = IB_SEND_SIGNALED;
+
+	return ib_post_send(qp, &wr, &bad_wr);
+}
+
+static int post_rdma_write(struct ib_qp *qp, struct ib_sge *sge, size_t num_sge,
+			   u32 rkey, u64 rdma_addr, u64 wr_id, u32 imm_data,
+			   enum ib_wr_opcode opcode, enum ib_send_flags flags)
+{
+	struct ib_send_wr *bad_wr;
+	struct ib_rdma_wr wr;
+	int i;
+
+	wr.wr.next			= NULL;
+	wr.wr.wr_id		= wr_id;
+	wr.wr.sg_list		= sge;
+	wr.wr.num_sge		= num_sge;
+	wr.rkey		= rkey;
+	wr.remote_addr	= rdma_addr;
+	wr.wr.opcode		= opcode;
+	wr.wr.ex.imm_data		= cpu_to_be32(imm_data);
+	wr.wr.send_flags		= flags;
+
+	/* if one of the sges has 0 size,, the operation will fail with an
+	 * length error
+	 */
+	for (i = 0; i < num_sge; i++)
+		if (WARN_ON(sge[i].length == 0))
+			return -EINVAL;
+
+	return ib_post_send(qp, &wr.wr, &bad_wr);
+}
+
+inline int ib_post_rdma_write(struct ib_qp *qp, struct ib_sge *sge,
+			      unsigned int num_sge, u32 rkey, u64 rdma_addr,
+			      u64 wr_id)
+{
+	return post_rdma_write(qp, sge, num_sge, rkey, rdma_addr, wr_id,
+			       0, IB_WR_RDMA_WRITE, 0);
+}
+
+inline int ib_post_rdma_write_imm(struct ib_qp *qp, struct ib_sge *sge,
+				  unsigned int num_sge, u32 rkey, u64 rdma_addr,
+				  u64 wr_id, u32 imm_data,
+				  enum ib_send_flags flags)
+{
+	return post_rdma_write(qp, sge, num_sge, rkey, rdma_addr, wr_id,
+			       imm_data, IB_WR_RDMA_WRITE_WITH_IMM, flags);
+}
+
+int ib_get_max_wr_queue_size(struct ib_device *dev)
+{
+	struct ib_device_attr *attr = &dev->attrs;
+
+	return attr->max_qp_wr;
+}
+
+static const char *ib_event_str(enum ib_event_type ev)
+{
+	switch (ev) {
+	case IB_EVENT_CQ_ERR:
+		return "IB_EVENT_CQ_ERR";
+	case IB_EVENT_QP_FATAL:
+		return "IB_EVENT_QP_FATAIL";
+	case IB_EVENT_QP_REQ_ERR:
+		return "IB_EVENT_QP_REQ_ERR";
+	case IB_EVENT_QP_ACCESS_ERR:
+		return "IB_EVENT_QP_ACCESS_ERR";
+	case IB_EVENT_COMM_EST:
+		return "IB_EVENT_COMM_EST";
+	case IB_EVENT_SQ_DRAINED:
+		return "IB_EVENT_SQ_DRAINED";
+	case IB_EVENT_PATH_MIG:
+		return "IB_EVENT_PATH_MIG";
+	case IB_EVENT_PATH_MIG_ERR:
+		return "IB_EVENT_PATH_MIG_ERR";
+	case IB_EVENT_DEVICE_FATAL:
+		return "IB_EVENT_DEVICE_FATAL";
+	case IB_EVENT_PORT_ACTIVE:
+		return "IB_EVENT_PORT_ACTIVE";
+	case IB_EVENT_PORT_ERR:
+		return "IB_EVENT_PORT_ERR";
+	case IB_EVENT_LID_CHANGE:
+		return "IB_EVENT_LID_CHANGE";
+	case IB_EVENT_PKEY_CHANGE:
+		return "IB_EVENT_PKEY_CHANGE";
+	case IB_EVENT_SM_CHANGE:
+		return "IB_EVENT_SM_CHANGE";
+	case IB_EVENT_SRQ_ERR:
+		return "IB_EVENT_SRQ_ERR";
+	case IB_EVENT_SRQ_LIMIT_REACHED:
+		return "IB_EVENT_SRQ_LIMIT_REACHED";
+	case IB_EVENT_QP_LAST_WQE_REACHED:
+		return "IB_EVENT_QP_LAST_WQE_REACHED";
+	case IB_EVENT_CLIENT_REREGISTER:
+		return "IB_EVENT_CLIENT_REREGISTER";
+	case IB_EVENT_GID_CHANGE:
+		return "IB_EVENT_GID_CHANGE";
+	default:
+		return "Unknown IB event";
+	}
+};
+
+static void ib_event_handler(struct ib_event_handler *h, struct ib_event *ev)
+{
+	switch (ev->event) {
+	case IB_EVENT_DEVICE_FATAL:
+	case IB_EVENT_PORT_ERR:
+		WRN_NP("Received IB event %s (%d) on device %s port %d\n",
+		       ib_event_str(ev->event), ev->event,
+		       ev->device->name, ev->element.port_num);
+		break;
+	default:
+		INFO_NP("Received IB event %s (%d) on device %s port %d\n",
+			ib_event_str(ev->event), ev->event,
+			ev->device->name, ev->element.port_num);
+		break;
+	}
+}
+
+static void qp_event_handler(struct ib_event *ev, void *ctx)
+{
+	struct ib_con *con = ctx;
+
+	switch (ev->event) {
+	case IB_EVENT_COMM_EST:
+		INFO(con, "QP event %s (%d) received\n",
+		     ib_event_str(ev->event), ev->event);
+		rdma_notify(con->cm_id, IB_EVENT_COMM_EST);
+		break;
+	default:
+		INFO(con, "Unhandled QP event %s (%d) received\n",
+		     ib_event_str(ev->event), ev->event);
+		break;
+	}
+}
+
+static void cq_event_handler(struct ib_event *ev, void *ctx)
+{
+	INFO_NP("CQ event %s (%d)\n", ib_event_str(ev->event), ev->event);
+}
+
+int ib_session_init(struct ib_device *dev, struct ib_session *s)
+{
+	int err;
+
+	s->pd = ib_alloc_pd(dev, IB_PD_UNSAFE_GLOBAL_RKEY);
+	if (IS_ERR(s->pd)) {
+		ERR_NP("Allocating protection domain failed, errno: %ld\n",
+		       PTR_ERR(s->pd));
+		return PTR_ERR(s->pd);
+	}
+	s->mr = s->pd->__internal_mr;
+	INIT_IB_EVENT_HANDLER(&s->event_handler, dev, ib_event_handler);
+	err = ib_register_event_handler(&s->event_handler);
+	if (err) {
+		ERR_NP("Registering IB event handler failed, errno: %d\n",
+		       err);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	ib_dealloc_pd(s->pd);
+	s->pd = NULL;
+	s->mr = NULL;
+
+	return err;
+}
+
+static int init_cq(struct ib_con *con, struct rdma_cm_id *cm_id,
+		   ib_comp_handler comp_handler, void *ctx, int cq_vector,
+		   u16 cq_size)
+{
+	struct ib_cq_init_attr cq_attr = {};
+
+	cq_attr.cqe = cq_size * 2 + 1;
+	cq_attr.comp_vector = cq_vector;
+
+	con->cq = ib_create_cq(cm_id->device, comp_handler, cq_event_handler,
+			       ctx, &cq_attr);/*1 for beacon*/
+	if (IS_ERR(con->cq)) {
+		ERR(con, "Creating completion queue failed, errno: %ld\n",
+		    PTR_ERR(con->cq));
+		return PTR_ERR(con->cq);
+	}
+
+	return 0;
+}
+
+inline int ibtrs_request_cq_notifications(struct ib_con *con)
+{
+	return ib_req_notify_cq(con->cq, IB_CQ_NEXT_COMP |
+				IB_CQ_REPORT_MISSED_EVENTS);
+}
+
+void ib_con_destroy(struct ib_con *con)
+{
+	int err;
+
+	err = ib_destroy_qp(con->qp);
+	if (err)
+		ERR(con, "Destroying QP failed, errno: %d\n",
+		    err);
+
+	err = ib_destroy_cq(con->cq);
+	if (err)
+		ERR(con, "Destroying CQ failed, errno: %d\n",
+		    err);
+}
+
+static int create_qp(struct ib_con *con, struct rdma_cm_id *cm_id,
+		     struct ib_pd *pd, u16 wr_queue_size, u32 max_send_sge)
+{
+	struct ib_qp_init_attr init_attr = {NULL};
+	int ret;
+
+	init_attr.cap.max_send_wr = wr_queue_size + 1;/*1 more for beacon*/
+	init_attr.cap.max_recv_wr = wr_queue_size;
+	init_attr.cap.max_recv_sge = 2;
+	init_attr.event_handler = qp_event_handler;
+	init_attr.qp_context = con;
+	init_attr.cap.max_send_sge = max_send_sge;
+
+	init_attr.qp_type = IB_QPT_RC;
+	init_attr.send_cq = con->cq;
+	init_attr.recv_cq = con->cq;
+	init_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
+
+	ret = rdma_create_qp(cm_id, pd, &init_attr);
+	if (ret) {
+		ERR(con, "Creating QP failed, errno: %d\n", ret);
+		return ret;
+	}
+
+	con->qp = cm_id->qp;
+	return ret;
+}
+
+int post_beacon(struct ib_con *con)
+{
+	struct ib_send_wr *bad_wr;
+
+	return ib_post_send(con->qp, &con->beacon, &bad_wr);
+}
+
+int ib_con_init(struct ib_con *con, struct rdma_cm_id *cm_id,
+		u32 max_send_sge,
+		ib_comp_handler comp_handler, void *ctx, int cq_vector,
+		u16 cq_size, u16 wr_queue_size, struct ib_session *session)
+{
+	int err, ret;
+
+	err = init_cq(con, cm_id, comp_handler, ctx,
+		      cq_vector, cq_size);
+	if (err)
+		return err;
+
+	err = create_qp(con, cm_id, session->pd, wr_queue_size, max_send_sge);
+	if (err) {
+		ret = ib_destroy_cq(con->cq);
+		if (ret)
+			ERR(con, "Destroying CQ failed, errno: %d\n",
+			    ret);
+		return err;
+	}
+	con->beacon.wr_id = (uintptr_t)&con->beacon;
+	con->beacon.opcode = IB_WR_SEND;
+	con->cm_id = cm_id;
+
+	return 0;
+}
+
+void ib_session_destroy(struct ib_session *session)
+{
+	if (session->pd) {
+		ib_dealloc_pd(session->pd);
+		session->pd = NULL;
+	}
+
+	ib_unregister_event_handler(&session->event_handler);
+}
+
+int ibtrs_addr_to_str(const struct sockaddr_storage *addr, char *buf,
+		      size_t len)
+{
+	switch (addr->ss_family) {
+	case AF_IB:
+		return scnprintf(buf, len, "gid:%pI6",
+				 &((struct sockaddr_ib *)
+				   addr)->sib_addr.sib_raw);
+	case AF_INET:
+		return scnprintf(buf, len, "ip:%pI4",
+				 &((struct sockaddr_in *)addr)->sin_addr);
+	case AF_INET6:
+		/* workaround for ip4 client addr being set to INET6 family.
+		 * This should fix it:
+		 * yotamke@mellanox.com: [PATCH for-next] RDMA/CMA: Mark
+		 * IPv4 addresses correctly when the listener is IPv6]
+		 * http://permalink.gmane.org/gmane.linux.drivers.rdma/22395
+		 *
+		 * The first byte of ip6 address can't be 0. If it is, assume
+		 * structure addr actually contains ip4 address.
+		 */
+		if (!((struct sockaddr_in6 *)addr)->sin6_addr.s6_addr[0]) {
+			return scnprintf(buf, len, "ip:%pI4",
+					 &((struct sockaddr_in *)
+					   addr)->sin_addr);
+		}
+		/* end of workaround*/
+		return scnprintf(buf, len, "ip:%pI6c",
+				 &((struct sockaddr_in6 *)addr)->sin6_addr);
+	default:
+		ERR_NP("Invalid address family\n");
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL(ibtrs_addr_to_str);
+
+int ibtrs_heartbeat_timeout_validate(int timeout)
+{
+	if (timeout && timeout < MIN_HEARTBEAT_TIMEOUT_MS) {
+		WRN_NP("Heartbeat timeout: %d is invalid, must be 0 "
+		       "or >= %d ms\n", timeout, MIN_HEARTBEAT_TIMEOUT_MS);
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/drivers/infiniband/ulp/ibtrs_lib/iu.c b/drivers/infiniband/ulp/ibtrs_lib/iu.c
new file mode 100644
index 0000000..f9102b3
--- /dev/null
+++ b/drivers/infiniband/ulp/ibtrs_lib/iu.c
@@ -0,0 +1,113 @@
+/*
+ * InfiniBand Transport Layer
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
+#include <linux/slab.h>
+#include <rdma/ibtrs.h>
+
+/*
+ * Return an IU  to the free pool
+ */
+inline void ibtrs_iu_put(struct list_head *head, struct ibtrs_iu *iu)
+{
+	list_add(&iu->list, head);
+}
+
+/*
+ * Get an IU from the free pool, need lock to protect list
+ */
+struct ibtrs_iu *ibtrs_iu_get(struct list_head *head)
+{
+	struct ibtrs_iu *iu;
+
+	if (list_empty(head))
+		return NULL;
+
+	iu = list_first_entry(head, struct ibtrs_iu, list);
+	list_del(&iu->list);
+	return iu;
+}
+
+struct ibtrs_iu *ibtrs_iu_alloc(u32 tag, size_t size, gfp_t gfp_mask,
+				struct ib_device *dma_dev,
+				enum dma_data_direction direction, bool is_msg)
+{
+	struct ibtrs_iu *iu;
+
+	iu = kmalloc(sizeof(*iu), gfp_mask);
+	if (!iu)
+		return NULL;
+
+	iu->buf = kzalloc(size, gfp_mask);
+	if (!iu->buf)
+		goto err1;
+
+	iu->dma_addr = ib_dma_map_single(dma_dev, iu->buf, size, direction);
+	if (ib_dma_mapping_error(dma_dev, iu->dma_addr))
+		goto err2;
+
+	iu->size      = size;
+	iu->direction = direction;
+	iu->tag       = tag;
+	iu->is_msg     = is_msg;
+	return iu;
+
+err2:
+	kfree(iu->buf);
+err1:
+	kfree(iu);
+	return NULL;
+}
+
+void ibtrs_iu_free(struct ibtrs_iu *iu, enum dma_data_direction dir,
+		   struct ib_device *ib_dev)
+{
+	if (WARN_ON(!iu))
+		return;
+
+	ib_dma_unmap_single(ib_dev, iu->dma_addr, iu->size, dir);
+	kfree(iu->buf);
+	kfree(iu);
+}
-- 
2.7.4
