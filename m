Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794380098;
	b=PdAqfzFQ1EbxrGzN7FX/ybFCFRqQksOlcKSiJz9s/ZqFQii+9qmyD4Di5wq/Z/sdLQpf
	 yck7Y1BYjExn8qw1BRTNN8mT3Idtyg5tamyg0NCrI7bYTuIGOH9DPZPjXtOfdoHeI559p
	 Cpvlf4vSDicKRZGohJw/0uqfeEOo4OA+E0GnBhTMda67C6yiNooN4quceDjs5qGgj5Q9x
	 DpR5SEXqTrTn5Gt1pM+3h3qX58RO8Pmdur+zZVlLHCAkOTJuzcfk3bqy4NdI7aoNmfdBi
	 A1zmVmErqUQAR9Bdkv4QIMIXXEj14ROHSh6CRWZeS3gxSXrrCfn++R6AxLeAgLIn7XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794380098;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9y/PRy7+nn0Am7DVlgAQyn6v6XmW7DI9L6qaUnk45TM=;
	b=dW+mfTbWQTPqm1bcuQRlZ8mZp9aujwHTRyhkCnxIZubmdiGTAHgZx4v3zZx+5msYl4Sf
	 PLmTMFmWzVf2Ur0RBM4xPyi5uI+bdrjdWhbKxk/BqWH44BlBhjndDSos+7ngOaNdyXrFx
	 slT7iB+Ak/r68O8vhK338yBYKSDR0etMgeHg+1yMO5suqc9xeXFjaag9Ujgqjj8x7TGJq
	 DZK8WAdTbOefipyVea4D43rg2Y/jZyM/xcBEv2++u/NobTp0YxK8wjSTmOl4xrdpiRuKk
	 aUl9wN6cvrVdhvs7lajFyp4JT/7BDGE5RUZ2H28zRdZTKByxRgOe6YPcYS6AQZ6wr5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pMPFvo7P;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1195606A321
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 06:54:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1195606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pMPFvo7P
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a4c72951b8so1837361b3a.3
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 22:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794380097; x=1794984897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9y/PRy7+nn0Am7DVlgAQyn6v6XmW7DI9L6qaUnk45TM=;
        b=pMPFvo7P3DmNjP5NkVj88J213VQKJx7Gb2XXkRFafbr2ySO4cnJeyOb6PUh/XtyvoN
         V4S/goQYN1pINF8Mp3g4sRCn925yc0TUAAHhRz8Rdr+sTC027Fd+zkyKrZlUGmkZC4vo
         ZlJ6ui1PQeBsg1jVF5P5HAPIxsV8g3YX4qRjQJ3JH8NPdT+wzMTG2H3ZcJ89l+DQyI7B
         s0rwsvIYyY7A9Ko5dsKcHLiu0G+hnNuJ2G1GCXwwQTtQ2e1e3+KZDw2Jyuommhn+1t/N
         h9Ey8ohG8gybCPAUqtTJgjhKicCD1JWPUFdUXJGioBEt1yUvkgc3c8lYNF000OdxEaxr
         GrVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794380097; x=1794984897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9y/PRy7+nn0Am7DVlgAQyn6v6XmW7DI9L6qaUnk45TM=;
        b=E4/xPeK+qdHDsaQAV+RIBsYMP2HtqAu7b8acGMHeujXNcbQKyabNhqlCQ+xEuqIHjF
         GvHXonewxgbYXbxcNNxAp8f4EnFFirGB51pTK0Gu4ifLP2v/sonchC1F9EwAQJZWcI0I
         mFf7jcZJo1oCjAFS6nad7Ht/i0kmkZVkhIgd46BWEjri0/KsgvfXOz+EtFcHRx4NM0eZ
         sbs75xOJ33PNn/bRrxs/60fAGO0jzGcY2x2+t72FHtJOjpSiTZYWAPjP4NG3DSVma7lF
         Cvuf+P1bbhEDQnq2KmsLhfxWVpgKKkufskzY8fGCOCdZK5DzG2GGRCbZU2X/3TK9O1vR
         W2Tw==
X-Forwarded-Encrypted: i=1; AL+hErH1uXeutqCcKOO/ccv01j96trWRXn+04v1IJf887Nvx3DM6uE3NPCPttYcMY2o8HlLgm0I8ieKx9zIA@vger.kernel.org
X-Gm-Message-State: APuU4Z/NjxCR1x78Gfw9Ig7xz92se2wyMG8p5MzNN3azWd96ixkjZ8X0
	dcE14V8+EF4naUVnpuvLIPzz2O89+c3yxc+HnboTsvjnru3QdEnpQdxZ
X-Gm-Gg: AYBFou1TglR1qSIa6bLf+IppVrnyu3IBgqnPdcJwdWtKrIGfWiJ1uvkE+OFlvHhljPX
	s1gbMafdcAh5Mf5Rzugc+NCKkOUf2hGXdOjTb7xEfJ48F8MYPKmtPoev39fnaHI5rgFlLThDy8j
	GVVRToMXwfTsW0ru3Mp2xpnw46mJkoKp5Ei3tH9ZRF28sm0Ze47p0ngG3pIAuKuL9E+79FTb+ab
	mN268JCJm53Yg1tkL57VrpMUXPU/FheHCpvbxwo3aI8KavkP0SVYgmbP7/sOr63Vpc0Ra+LQK74
	ZBquy1LHt0J7lMBGkwO5/YOOXNnHzTo04dkRHx/JR/ZFNHnMfaoduRqYj4BTRbIMA2TdR9VCdIe
	j7BqeLi5M6CooEkPeFwwHRInV0mQvC52mCw3BdthnF7X+kvjXFZc0eL3f6Kqq2xNt3kIbV9ifY4
	AWT4yAel3TTf2sIoSkF4qNwFJbMoigZLbifynwfnGvO+cXCO1NiEGclz7q5H67bkeCGALWWMZj6
	4Fkk+eNZ3gjYE7hKFd7OlNdHjRV2u4WCQwZ+JxUSnW4tmDWc1TD9YPV2Eznyj6dkJCwSlHGbi1b
	sWM5vRZTyN6xLdWBEoEHVqcCkaaxFUeQ0OVQX4ODVkX2zdR7ed//aTB1Km0h0Qs=
X-Received: by 2002:a05:6a00:21cd:b0:892:e080:4edb with SMTP id d2e1a72fcca58-8bc1d9122a6mr1712975b3a.60.1794380097046;
        Tue, 10 Nov 2026 22:54:57 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baa7bf82b1sm1823362b3a.8.2026.11.10.22.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:54:56 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v3] RDMA/srpt: Prevent uninitialized read buffer disclosure
Date: Wed, 11 Nov 2026 14:53:40 +0800
Message-ID: <20261111065342.1282709-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261110052827.963143-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SRPT allocates read buffers and creates RDMA contexts from the
initiator's descriptors before parsing the CDB. When target core reduces
cmd->data_length, a backend such as rd_mcp fills only the shorter
length, but the prebuilt RDMA transfer still sends the full buffer. This
can disclose stale target kernel memory to a remote initiator with
access to the LUN.

Reject indirect descriptor tables whose direct descriptor lengths do not
sum to the advertised total before allocating RDMA contexts. Also
initialize commands rejected during descriptor parsing so the BUSY
response path has valid callbacks and a command reference.

Save the original buffer length and zero any read tail beyond
cmd->data_length before posting the existing RDMA transfers. Synchronize
each mapped SG list for device access after zeroing.

The issue was discovered by Qihoo 360's Tulongfeng multi-agent system.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Cc: stable@vger.kernel.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: liuyong <pkfxxxing@gmail.com>
---
Developed against f66469d9905b39d2c260a15d7d6db450f4db67c1 (7.4-rc1).

 drivers/infiniband/ulp/srpt/ib_srpt.c | 41 +++++++++++++++++++++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 ++
 2 files changed, 43 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad8..0bef01e20c 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -41,6 +41,7 @@
 #include <linux/kthread.h>
 #include <linux/string.h>
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
 #include <linux/atomic.h>
 #include <linux/inet.h>
 #include <rdma/ib_cache.h>
@@ -1115,8 +1116,10 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 	} else if (((srp_cmd->buf_fmt & 0xf) == SRP_DATA_DESC_INDIRECT) ||
 		   ((srp_cmd->buf_fmt >> 4) == SRP_DATA_DESC_INDIRECT)) {
 		struct srp_indirect_buf *idb = srpt_get_desc_buf(srp_cmd);
+		u64 total_len = 0;
 		int nbufs = be32_to_cpu(idb->table_desc.len) /
 				sizeof(struct srp_direct_buf);
+		int i;
 
 		if (nbufs >
 		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
@@ -1128,6 +1131,11 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 			return -EINVAL;
 		}
 
+		for (i = 0; i < nbufs; i++)
+			total_len += be32_to_cpu(idb->desc_list[i].len);
+		if (total_len != be32_to_cpu(idb->len))
+			return -EINVAL;
+
 		*data_len = be32_to_cpu(idb->len);
 		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
 				sg, sg_cnt);
@@ -1304,6 +1312,7 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 	WARN_ON_ONCE(ioctx->recv_ioctx);
 	ioctx->n_rdma = 0;
 	ioctx->n_rw_ctx = 0;
+	ioctx->buf_len = 0;
 	ioctx->queue_status_only = false;
 	/*
 	 * transport_init_se_cmd() does not initialize all fields, so do it
@@ -1597,9 +1606,13 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 			pr_err("0x%llx: parsing SRP descriptor table failed.\n",
 			       srp_cmd->tag);
 		}
+		target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+				scsilun_to_int(&srp_cmd->lun), 0,
+				cmd->sam_task_attr, dir, 0);
 		goto busy;
 	}
 
+	send_ioctx->buf_len = data_len;
 	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
 			     scsilun_to_int(&srp_cmd->lun), data_len,
 			     cmd->sam_task_attr, dir, TARGET_SCF_ACK_KREF);
@@ -2866,6 +2879,31 @@ static u8 tcm_to_srp_tsk_mgmt_status(const int tcm_mgmt_status)
 	return SRP_TSK_MGMT_FAILED;
 }
 
+static void srpt_zero_read_tail(struct srpt_send_ioctx *ioctx)
+{
+	struct ib_device *dev = ioctx->ch->sport->sdev->device;
+	u32 data_len = ioctx->cmd.data_length;
+	int i;
+
+	for (i = 0; i < ioctx->n_rw_ctx; i++) {
+		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
+		struct scatterlist *sg;
+		unsigned int j;
+
+		for_each_sg(ctx->sg, sg, ctx->nents, j) {
+			u32 skip = min(data_len, sg->length);
+
+			data_len -= skip;
+			if (skip < sg->length)
+				sg_zero_buffer(sg, 1, sg->length - skip, skip);
+		}
+
+		if (!ib_uses_virt_dma(dev))
+			dma_sync_sg_for_device(dev->dma_device, ctx->sg,
+					       ctx->nents, DMA_TO_DEVICE);
+	}
+}
+
 /**
  * srpt_queue_response - transmit the response to a SCSI command
  * @cmd: SCSI target command.
@@ -2907,6 +2945,9 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	if (ioctx->cmd.data_direction == DMA_FROM_DEVICE &&
 	    ioctx->cmd.data_length &&
 	    !ioctx->queue_status_only) {
+		if (ioctx->buf_len > cmd->data_length)
+			srpt_zero_read_tail(ioctx);
+
 		for (i = ioctx->n_rw_ctx - 1; i >= 0; i--) {
 			struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 506c11b843..78bba74148 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -204,6 +204,7 @@ struct srpt_rw_ctx {
  * @rdma_cqe:    RDMA completion queue element.
  * @state:       I/O context state.
  * @cmd:         Target core command data structure.
+ * @buf_len:     Original SRP data buffer length.
  * @sense_data:  SCSI sense data.
  * @n_rdma:      Number of work requests needed to transfer this ioctx.
  * @n_rw_ctx:    Size of rw_ctxs array.
@@ -223,6 +224,7 @@ struct srpt_send_ioctx {
 	struct ib_cqe		rdma_cqe;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
+	u32			buf_len;
 	u8			n_rdma;
 	u8			n_rw_ctx;
 	bool			queue_status_only;
-- 
2.43.0

