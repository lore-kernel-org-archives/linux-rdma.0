Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794288578;
	b=mNQ7X8QGfRB1BaoK1KyLoqgm3C355PaLZ8pXQw+8eUb7pDHJ3u0ZqaIVpzWcOZB18TS+
	 cn7X48kjsB5p3NFmPbczWHdlrhy9Rnx0CE+cqJZ7hiKHX4Al3lQwPDm5M8BQ61d28qj4W
	 kbi/1LaH8nplGDEI4lGJMIovoMsgv0S8gQuuN5rXMMrktRBoPOY+1ZVoE4b0muY4hb9D8
	 HeOO+nfCthfde7N89PJy0Vl0WvWCimXXyl/LkVQArLYfCQEnn+itFMyDgHkCFsO/fXN6E
	 h0mdCLsGUjm5WfeTV05NGUhfYjm6R8n5xQ0ilZo/evcprNMMVVSCk1rt90hlV/GhyPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794288578;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p2T/Tnq0wrJazsgzibf7bEuis2IKzeDcfBGA8lydX14=;
	b=XVXNSVYkhC+/hCCnd7VRR3eejPDKfq6ZUzdJM4OfNejWZ2BEuZsgQPrAHTAtt0dvctnt
	 e0T4Nm2ZiBqpZY+cSvY52tIUZsFuzi+P/PDo5/tFegB76eq0ZBvw6DJzch+kV0yGK7YAY
	 cff5CN0JhqxbCqlfIKUNJ1HjdKBVBWb9FVKw4Uwo5TBLeI2DhNF2tYvnnPG1dKjL3E9Oj
	 43bJETXz5aRdPVN88MHJSrxTBsuL7VnBoxX4iacXMtF0M38yAFG0dvTmG6WfQJ3iCtVp1
	 3494tZHp/doePVZ/Rd24wUaNaWj2iBIE6aBQ9pemEGZ7JDVJIvTBswnTxbY1DdgRWZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GvIrSLnm;
	arc=none smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB0A606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 05:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AB0A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GvIrSLnm
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a0673d9bd2so971906b3a.3
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 21:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794288576; x=1794893376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p2T/Tnq0wrJazsgzibf7bEuis2IKzeDcfBGA8lydX14=;
        b=GvIrSLnmuwFnsNPBX/JyOUrvoXMsCql0KosPD5ppgPaPqcc6R5CxsHsikD9OU2PMvP
         ZZdJwsdIW5Ow1aVXIJeDuHZKA03ifzweRfP2uL+MFNias2IwYZH+M0HUrL3b5JA6S8hU
         saio/qh6Vi5j69eII53NZXVIVuUKXV+xSco+gMpvToX16L0Kv+CsX/IJzYXZfoRxlfQy
         uS6BRZk+ouZVMvp4AB8n/eqkjK6Ok73T3aCSRrVdzMFps6tMHJxu62NNRyMZk83w0EqP
         nsk6eydxgvE2TZhX7WmV0/DM7HH8v3hYvd2T8ongfOHOfCiko2RJZCr3KUQDcM8GUM1q
         tzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794288576; x=1794893376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p2T/Tnq0wrJazsgzibf7bEuis2IKzeDcfBGA8lydX14=;
        b=lX0gSX+s8YwZRGzXOSXbr43OzEae8FK+Fl/U3UQKRbmINBbsa+Qba9sW1iE3mLoTOx
         eU2t1L7yiZDXZB0PWETc/a3JKRpIgFcfPNhszSXaHxeZQS7VjfMjRhxGO9u49nkHxEoN
         B3M5YMvhYyc6dsLQEwqv0YW9bfkAuTV9Ss1sHf9CgHqBj4BEjFZkI0DhninD8INdxJIi
         vz9zKZkCsYoZrLAqw9kpsypbOVXWD++ro/UlGHYpXBrJbhTlNHVX5kHzNaBegGek0xhb
         XNYIhQmS0tgH/D0GCYsynQUjcvm5mricDbyqB2a3A6EoAu+uj2jinIP6cKv5PpOTgGKr
         j/Ww==
X-Forwarded-Encrypted: i=1; AL+hErEgHtlEnld0tdWOkzF1dvsLDHqyhTtF9w0+Adr9Nvbuuq4QZNai88zpbcrA1XJuVm4Z/9WfrQ0NpWlw@vger.kernel.org
X-Gm-Message-State: APuU4Z+WB8fCSRMAiqPfh9bO8duzL242p17gWt7XdIotJ+eDLYFPEQGD
	WLBGao6lN8CCeaG5dEZpnpJVnuzlpFME7D1BnelNBZ2+tl0SDCyo1fmY
X-Gm-Gg: AYBFou3RbB97LSSQlOTd5je3H4sonYi2msblIEY+bydJDwxxaoylt4o4S9fBPqLyAr/
	BvTj0CnUfFXQdnWoqM2JwCxUwf5S0uS6tRuB/Z6jbUb9Xp+lzWlgi/VXnY3lZPa+47DgORDMT5r
	hQ1gsqynCsdeQxGwZQZ3pbc5dKoWCtXTu/CvKgOudq0D5Eu275PWAt7Glz/d1zC/1F9FHIRZe+Q
	nkfQyacjqQSQ0YZhZ0uKabTrzBR2gIEoCem3WnlWkG7HlxfO9qlmrFvF0HGx+Cui+4u9nO/iWlW
	UIhfHqJRN64nyjzZCMVm0wkxPKHL0NRWiUAb5o47eWzuUTv+SFcBAlWjhtToveBlLyQiSdrJEYU
	uS95KVyUoBdACRo4A5jr0FSPMsDCPF3l+mSnKgw44N2UI0KEOfBOjUHr8oOYO6ta65SKEtVDNzK
	Cv7izjqYWvAMEuOWGErwd9RwTy6rRl3qdPFoWCRg7qANihMWAYuTwX8Zf95mbW84RMIjAg2+Gpu
	JE6Sk+GchY4is3MNwgyU1PVhDmB8h2bpkSLmfJ52fpv4qPFCw6oHHw6VSk92lLDLnhqpSDQGqpt
	9GYVFHBcGl7FFOFbi6eBdZRK79N3gl5jTkiTGyUuBA==
X-Received: by 2002:a05:6a21:1f82:b0:3e2:6f6b:467f with SMTP id adf61e73a8af0-3f18eeaa3dbmr1587066637.33.1794288576305;
        Mon, 09 Nov 2026 21:29:36 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67adcfsm402224a12.8.2026.11.09.21.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:29:35 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v2] RDMA/srpt: Limit read data transfers to the command length
Date: Tue, 10 Nov 2026 13:28:26 +0800
Message-ID: <20261110052827.963143-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261110030809.913063-2-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com>
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

SRPT builds RDMA contexts from the initiator's buffer descriptors before
parsing the CDB. The resulting RDMA WRITE requests can exceed
cmd->data_length after target core shortens the command or when an
indirect descriptor's buffers exceed its advertised total length.
A backend such as rd_mcp fills only cmd->data_length bytes, leaving an
uninitialized tail that is still transferred to the initiator.

A remote initiator with access to the LUN can therefore read
uninitialized target kernel memory beyond the requested SCSI data,
potentially exposing sensitive data left from previous uses of those
pages.

Limit the data SGEs in every read response to cmd->data_length without
depending on SCF_UNDERFLOW_BIT. Keep MR operations and WR accounting
unchanged by retaining excess RDMA WRITEs as zero-length requests.
Clear sg_list when num_sge becomes zero so that providers such as irdma
do not program a non-zero first fragment from the original SGE list.

The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
system.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Cc: stable@vger.kernel.org
Signed-off-by: liuyong <pkfxxxing@gmail.com>
---

Changes in v2 (addressing the two issues reported by sashiko-bot):
- Limit every read response to cmd->data_length without relying on
  SCF_UNDERFLOW_BIT.
- Clear sg_list when num_sge is zero to avoid stale fragments on irdma.

This revision has been compiled and verified to fix the reported issue.

 drivers/infiniband/ulp/srpt/ib_srpt.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad..9257c6beb 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2907,12 +2907,32 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	if (ioctx->cmd.data_direction == DMA_FROM_DEVICE &&
 	    ioctx->cmd.data_length &&
 	    !ioctx->queue_status_only) {
+		struct ib_send_wr *wr;
+		u32 data_len = cmd->data_length;
+
 		for (i = ioctx->n_rw_ctx - 1; i >= 0; i--) {
 			struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
 
 			first_wr = rdma_rw_ctx_wrs(&ctx->rw, ch->qp,
 					ch->sport->port, NULL, first_wr);
 		}
+
+		/* Do not expose uninitialized data beyond cmd->data_length. */
+		for (wr = first_wr; wr != &send_wr; wr = wr->next) {
+			int j;
+
+			if (wr->opcode != IB_WR_RDMA_WRITE)
+				continue;
+			for (j = 0; j < wr->num_sge && data_len; j++) {
+				struct ib_sge *sge = &wr->sg_list[j];
+
+				sge->length = min(sge->length, data_len);
+				data_len -= sge->length;
+			}
+			wr->num_sge = j;
+			if (!j)
+				wr->sg_list = NULL;
+		}
 	}
 
 	if (state != SRPT_STATE_MGMT)
