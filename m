Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559236;
	b=XCIVvXFo9GxW7qs8oIsdftEbkH7uRHFMDLKcz2frSRMJSpF8LeAFGqkDdjAWV5I4Y00V
	 j9CVKzzEFEyTDE8zkbwl46qbxxxQGimhN0T1Bmi1TS9jFjisoH1+ZCf2e1AFLnoMY0Zh+
	 F7ysmx2C0QsZDzt0KkPq8V67DfTj2H5z7dK6llb7RP6/aDtreSwUC+4j4d+fmkRLuyouE
	 A/b+w8M7vkOY9x57oed0YWhUcShy98d6tCryIyF4wZ9oZVz/fjskHZxavZ7oQ04/QEYyr
	 XpWTqhBwrPLcS31ZbrMBI+cBwpkZl4/JqQom5b5D1fp2rTs1YPdt1yDE9Kuya0DKNzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559236;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BBnWWtBKdgI2TAwNesV0oCYOVTkjWDyFP80ZcpwkwoA=;
	b=ApQOQELCOxV2QvQABD8bboooXgMung26WDZA5XLwNCmIeQ+rwbOaTRsAeCauR72EplrL
	 pnEDcm3lU8HOTXANzDPRGdzgchSjv4rtBc+ez/hc2zuaV+8DLhtigtCrtALwYXQ0TjNRp
	 PhTchXuMHXLxAYdB1WiVI5bVAzVzGFYKa9HyMRSaAF8KFUdK6h6CetF3rX2yOeuQaA9iL
	 YcbekZ9TiPvdGj9eImB/AjhRpXZOtlChTLjDQCh2feYwjgMfBOc9j0QBhOpJq9/SW7+r3
	 MrFRGNsmWg3sdnLqgsu5NTg39cfEP1QNoeQctgNFPFQUWzTVdg8Dl/XOGMejGep6FCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="gV4GU//8";
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284DA606A888
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 08:40:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 284DA606A888
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gV4GU//8
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso259658a12.3
        for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 00:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559234; x=1795164034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BBnWWtBKdgI2TAwNesV0oCYOVTkjWDyFP80ZcpwkwoA=;
        b=gV4GU//8b5UXX3fB1poHfcWwaF8yDwgTfBZ4FxVwCSyE/RGh9w7pN/L5D3TScLNDi/
         2Hj1ADK0phlUcLRUVdPQusQbLg1Xp7NyLGLcWQSxKZIaPr8x/OlUnwChIPoPIYSYCMXO
         atg6k6g1mVkciyLuzJEAg9vUaqGj0+Zg2TvFqWVw4hkbfVOTKHHwBeNG15jcsimGwakG
         yNuxR2g5R1lScr84PeUGpjCWwF1rNWq44FVyeKuZp+A3puhg8VWswtnqHZwRa1Ur0z9Q
         T1TzaiGy2U/3HBaK2ZwVhrT8EyOR5WWO/si+Pq73UfiBk/6+dJwzYqw59ZR+ZDsyMXC3
         G47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559234; x=1795164034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BBnWWtBKdgI2TAwNesV0oCYOVTkjWDyFP80ZcpwkwoA=;
        b=lRDpR5EUwnqcwgL59NuLtEb5a/na5iuuJ77hmMjdlaVPGk7XmRmAiMuUA8VdyDfcb4
         6iukPwSt6z8sUsQYu1S0WUcrXSetx7laSZxpcmR9OIlE3CqkI9kS0kYSzugBldSCaZaz
         B1a4i4QRWANsEQboemXCmglGGfpi43RMotKQZfObbfj8Iyua8L6g5eeDVynOl1nWczcD
         2mWyEjw5JeBtvHk15CmNBqbcNM9Z6uGAY28X+Up69jEJuh5fXhQxa1PQzRBc9Yk1MqZC
         7xaYOJmAXkeHNaY0TD1sme7IwEav8WP0v5JcJPgZzeHGhVq9j5jwyHso1uvP+iZIiR5d
         PpBA==
X-Forwarded-Encrypted: i=1; AL+hErEWEXk4DaOum97oljoeJqFTqRdFvUgEKoMd27kpA+oJ/OrX+ChOLta7zaTTqxpvBW8QQgIYoNboxs51@vger.kernel.org
X-Gm-Message-State: APuU4Z+G/TrSiEIE/+kYyACFvCyPeVtIjB+TlTlwbnRgVUpa972Zh+lh
	3HjYNTyrVfxuzr7aHNcO1sa8578Rn16d+a1paYTMeFdgNdOaoLYifzz/
X-Gm-Gg: AYBFou0m5adsF7xvTgiAfippazGeyOGcoobphGM6k481ajtIgcCIOvC1o3ElAFQEMI9
	mGIGAUen0wX1zBWMgd3AHjzGowng5Q3BL2r+OdSiG5Pq1jszoSz638G2vNhaidzr/V86jXmjG9Y
	gRpzwS61TznRXJGEK9WbU5emnwrl6NijCm7/FSzUupuP9o+YFvsurt6dnkqAD3C3HHb7fmEMDyz
	CqxhO8zWs9ABd1pUe+1wiR95mK8ptmCybiWwpuyKE+r1klkwLpxrHhi4p17oE3jREnAAt1u73BK
	IyNz1iI84bpCdpWd8w4Tl/Z9/Q4gt3/YgMVaR8ycnQWvhhzPFAdAVoLpfyaB8b/zfa0desX2xb0
	Dhm34QelpVzMsphLnOtYHkwPNEWuiY3Xc6ZXklNqaK9lbmHX/e4joTra+qgow41OoGRPLbMj0pe
	Usl7LQGnGhg7P+6xrwDP0Jr0/pYuZ0e0mnQUcIZDsiwYUBRP0X+0rvK1yFx7Czigyf2OjPDLrWJ
	+FiunKCopYjLMvxLkHFjBTVuDyxGYizggXodI21Ydl/uJAHl04scCNj2QJhyxtnZzfNagmf3Xj4
	5ocomga5/TpCQDkT/sY7fjraHinjjyASvgN2prWWvA==
X-Received: by 2002:a17:90b:56cb:b0:3b0:a9de:9880 with SMTP id 98e67ed59e1d1-3b1b0a3c5e9mr1581124a91.33.1794559234473;
        Fri, 13 Nov 2026 00:40:34 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm1264855a91.1.2026.11.13.00.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:40:34 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v5 3/3] RDMA/srpt: Prevent uninitialized read buffer disclosure
Date: Fri, 13 Nov 2026 16:38:42 +0800
Message-ID: <20261113083848.1517595-4-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113083848.1517595-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com> <20261112094138.1390409-1-pkfxxxing@gmail.com> <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
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

SRPT allocates read buffers and creates RDMA contexts from the initiator's
descriptors before parsing the CDB. When target core shortens
cmd->data_length, a backend such as rd_mcp fills only the shorter length,
but the prebuilt RDMA transfer still sends the full buffer. This can
disclose stale target kernel memory to a remote initiator with access to
the LUN.

Reject indirect descriptor tables whose direct descriptor lengths do not
sum to the advertised total, and log the mismatch before allocating RDMA
contexts. Save the original buffer length and zero the tail beyond
cmd->data_length through the chained command scatterlist before posting
RDMA transfers. This applies to both data and control READ commands.

The issue was discovered by Qihoo 360's Tulongfeng multi-agent system.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Cc: stable@vger.kernel.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yong Liu <pkfxxxing@gmail.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 17 +++++++++++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 127f256c6e..fc530ddf48 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1115,8 +1115,10 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 	} else if (((srp_cmd->buf_fmt & 0xf) == SRP_DATA_DESC_INDIRECT) ||
 		   ((srp_cmd->buf_fmt >> 4) == SRP_DATA_DESC_INDIRECT)) {
 		struct srp_indirect_buf *idb = srpt_get_desc_buf(srp_cmd);
+		u64 total_len = 0;
 		int nbufs = be32_to_cpu(idb->table_desc.len) /
 				sizeof(struct srp_direct_buf);
+		int i;
 
 		if (nbufs >
 		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
@@ -1128,6 +1130,14 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 			return -EINVAL;
 		}
 
+		for (i = 0; i < nbufs; i++)
+			total_len += be32_to_cpu(idb->desc_list[i].len);
+		if (total_len != be32_to_cpu(idb->len)) {
+			pr_err("SRP descriptor lengths total %llu does not match advertised length %u\n",
+			       total_len, be32_to_cpu(idb->len));
+			return -EINVAL;
+		}
+
 		*data_len = be32_to_cpu(idb->len);
 		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
 				sg, sg_cnt);
@@ -1304,6 +1314,7 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 	WARN_ON_ONCE(ioctx->recv_ioctx);
 	ioctx->n_rdma = 0;
 	ioctx->n_rw_ctx = 0;
+	ioctx->buf_len = 0;
 	ioctx->queue_status_only = false;
 	/*
 	 * transport_init_se_cmd() does not initialize all fields, so do it
@@ -1607,6 +1618,7 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto busy;
 	}
 
+	send_ioctx->buf_len = data_len;
 	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
 			     scsilun_to_int(&srp_cmd->lun), data_len,
 			     cmd->sam_task_attr, dir, TARGET_SCF_ACK_KREF);
@@ -2914,6 +2926,11 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	if (ioctx->cmd.data_direction == DMA_FROM_DEVICE &&
 	    ioctx->cmd.data_length &&
 	    !ioctx->queue_status_only) {
+		if (ioctx->buf_len > cmd->data_length)
+			sg_zero_buffer(cmd->t_data_sg, cmd->t_data_nents,
+				       ioctx->buf_len - cmd->data_length,
+				       cmd->data_length);
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

