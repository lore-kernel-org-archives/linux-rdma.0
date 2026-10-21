Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792541950;
	b=ka9AQPLrxfPnzhopWHi5sxo9YZlekFHtGs7X+UusdwSXLx+ReLa/pjTn2HSMqlfkOB4V
	 sE6OU5Y/jobHI93FP/fxdU8lZzAj4DNH65JCNgbLjfFudIptsP+gQiu6z8gtt0Rta12Sg
	 rKJg2w55JceJbwvp8VCUtffNftyVhlzZzzqoEtIxWgKi0LMS60HyrlJhASiLgTw7eY3MW
	 7Srb5GzlUOgrRXTa9QJ+swKf+aHqbgbkgHWRk9jUB9wx0RMFJQCvlc9xWExsj/j3qMnyz
	 cgIy+oJSR4XjBpu1mkXf8BRh7ylWUH9+L9RH+IdLgEzndmvO7K5c9PRwOIwet5+nQUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792541950;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pGpt2LwanaD/GvAPAwxQMXFrIwRoaq29ij9OLsypfIA=;
	b=5mTOBvM2Tc2ZnS2aRdLSW1eTAnUt1iHfjpihm5+JxzyEPYQuoQzgCi4Pq0XDobUhM2Vc
	 sSQVuQzal0A94XW2PKTLdLDxGNymG0Sbkn98k5bLDqAsYtTQJXurQ/EqHL90A794DCEkJ
	 LM7Hgq1myPVKnNZezdXsUawNLU67Nrj+zh+VKjOGoSTOhUYbvFlCkOlK0NYwZ+qNjnKgD
	 QZvWMqn5hgs+fNSi+oicPNxbmEp+v025JWbHeA1l9Wp+HwOXTAxrftcmoJKAikP8jYR4v
	 J+JhQrenNmDi6duSedrPL2LWbAxwzSnpDleH0tVgXsco5lquuotH0Vx6qimAydimW8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=rwm4RFYp;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5427606A31B
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 00:19:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5427606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=rwm4RFYp
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e608cd460eso948325ad.3
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 17:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792541949; x=1793146749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pGpt2LwanaD/GvAPAwxQMXFrIwRoaq29ij9OLsypfIA=;
        b=rwm4RFYpNrxxNFadM20VP9dugTFB/pKWcqFPDJ6jKpxvXplFBEBgL7YdROhayPDA30
         oUm5oYuQbU+pm7FaqUP3PS3y2Hl/oHLsgd534f8rmWt6eZpNVqpR2liacwWck4icdyV5
         n4P+Q+k7KNXXph61Be/vH0lVEtHdLnakdQSwtfW+zFtv2TUnlzDX7kc5X207Y9I/uRq3
         yBNzIdoPk6m+dfbXYev74NWO2D4ftmwc34B3ebXekzX7SR2fbURuZJEEnj2midQW/gXG
         j/I92ZUpjEefAMGLjZC8McSN41sY70B8HxdC6KD9mIf8ZWJDXoFVPVTs7stqJnPul5Ye
         LAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792541949; x=1793146749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pGpt2LwanaD/GvAPAwxQMXFrIwRoaq29ij9OLsypfIA=;
        b=tZLe5UiZ7mhniYCiK+odBvFbVOvaIGpa1dz2g1wcxniYf6NN4JLpzMkXWeHa0NcMT9
         PqXM23WxmT09sESHy75r3gOWDE/p8wGK0v3t6L3CaDo3lVjJPubzuahqF3cbUTzSNXEJ
         360SJ0z1Yp9nspACFDfrOb3AUNbMPd/J6sPPUXMwYyjJJW5UPihIm1fC1Ok0hA5vfqYi
         I7TXWB/avWtwek0IV1ElZiQCbmp6Wj1hbtxjAPINyWNEK1pT85EBVND/RHINnm3T1zrZ
         PT/m/7dHnFQhp2BILLXjYW2ThqhafEToC8D0wfZszIqP+eeuO2Xk5yf/DyTRg2Jwg8/q
         0QrQ==
X-Forwarded-Encrypted: i=1; AKwUvBy/xGnrUBbwfj5h33VAItOFIrHBLAsj3Kuoi/7dbIzLXhRs8T3MFjFOjEn3ep9fnjpcXsSclG79wtCf@vger.kernel.org
X-Gm-Message-State: AFq9FYIXXWtCZKEhSwGpSbEOxIOkClBBNbgq9ZC6enrznt7oZIH+bJ11
	HU8bYZdXnBULC9yiPvVcr96NvNsdhrxpIoWs642pCjjjoETuwaVx6EyZa1Bl7k3VvPXXQGHx1t4
	IHi/r
X-Gm-Gg: AYBFou06hrJhtdK6zpymYOmHs4P+2lKXxrrXnRbRuVAVTuh5yZ8a2hpuZtSZWz9B8wu
	DHefEx5m3gDI0zRYUVQCg8hZXyyRE9jn0e/LlUSL3SJk6HGsMutb9h0nLJX6+0RDrX60Dx9+h73
	KBPI4juUZhwRLcSoUkottRS6i746c4UlT8DqM+xjis2RH+IX8k3zhEG0JcFuQu24/0lwiRRsU/d
	Ea93OCkI4DLyvGWo9jaRGXCJIUyKVNtK1+ljYa9egX4oVm/PM8Xcp+O2X2UyYAyyJ6or1BwfRxs
	ZTGqYl7b7oOI9j8jVEbp0dsxuGqe3sxJ359tefUucplpFiMQKJN4cWBDEpc2LDDZbimyf539Ddd
	wG2xwkHBJUewGtVsaRd4HT64B89wgpxElA+sSocT1CDPNLZd9k8iSz1UxbNwDFm1CvcjuNkDho1
	YjV1W9/SNxoeHeVBBgLBauljvzTclb2RcJdUR5aB2ZBUGSiGAzeAEIIlC9CeOIJBDVUvbx1Iuih
	sFVcFvBtOj5MF8tpf7g
X-Received: by 2002:a17:902:d2c1:b0:2e9:ca71:45f4 with SMTP id d9443c01a7336-2ea43c5ff3amr2928735ad.33.1792541948589;
        Tue, 20 Oct 2026 17:19:08 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e416:85ef:f22:6c5d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b4729b2sm3952655ad.53.2026.10.20.17.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 17:19:07 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2] RDMA/srpt: bound the indirect descriptor table and widen the counters
Date: Wed, 21 Oct 2026 09:18:53 +0900
Message-ID: <20261021001854.2343027-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

srpt_get_desc_tbl() bounds the number of indirect data buffer descriptors
by the two counts the initiator put in the SRP_CMD, and both are u8, so it
admits an nbufs of up to 510:

	if (nbufs >
	    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
		...
		return -EINVAL;
	}

Nothing checks that the header and those nbufs entries are inside the
information unit that was received.  srpt_alloc_rw_ctxs() walks
idb->desc_list for nbufs entries ending at

	sizeof(struct srp_cmd) + (srp_cmd->add_cdb_len & ~3) +
	sizeof(struct srp_indirect_buf) +
	nbufs * sizeof(struct srp_direct_buf)

which is 8480 bytes for an add_cdb_len of 252 and an nbufs of 510, past
recv_ioctx->byte_len and, at the default srp_max_req_size of 8276, past
the req_buf_cache object.  An add_cdb_len of 52 already suffices.  The
immediate data branch of this same function bounds its length against
srp_max_req_size and against recv_ioctx->byte_len, so bring the indirect
branch in line.

The count also outruns the counters that track the contexts, which are u8,
so at 256 descriptors n_rw_ctx wraps to zero and srpt_release_cmd() skips
the free:

	if (ioctx->n_rw_ctx) {
		srpt_free_rw_ctxs(ch, ioctx);
		ioctx->n_rw_ctx = 0;
	}

Such a command leaks every scatterlist target_alloc_sgl() allocated, every
registration rdma_rw_ctx_init() set up, and the rw_ctxs array, whose
kfree() sits inside srpt_free_rw_ctxs().  ioctx is a ring entry the next
command on the same tag overwrites, so the array pointer is lost too.  A
count between 257 and 510 leaks 256 contexts and frees the remainder.

Both changes are needed: a 510 entry table fits a default 8276 byte IU
when add_cdb_len is zero, so the new bound accepts it and the counters
still have to hold it, and widening the counters does nothing about a
table reaching past the IU.

Check the header against byte_len before reading the table length, and the
table after the existing count guard has bounded nbufs at 510.  The bound
is the number of descriptors the remaining bytes hold, so there is no
multiplication to overflow and a negative byte_len is refused.  Widen both
counters to int, which suits every user: the loops that walk the contexts
backwards use an int index and stop at -1, the sq_wr_avail accounting
passes the value to atomic_add() and atomic_sub_return(), and the three
places that print it use %d.

The KUnit harness below is not part of this patch.  It calls
srpt_get_desc_tbl() with a fabricated SRP_CMD in a buffer from a
kmem_cache shaped like req_buf_cache, and stubs only rdma_rw_ctx_init()
and rdma_rw_ctx_destroy(), the two helpers that need a live QP.  An
add_cdb_len of 252 with an nbufs of 510 gives

  BUG: KASAN: slab-out-of-bounds in srpt_alloc_rw_ctxs+0x6ee/0x950
  Read of size 4 at addr 000000006318205c by task kunit_try_catch/33

  CPU: 0 UID: 0 PID: 33 Comm: kunit_try_catch Tainted: G                 N  7.3.0-dirty #7 VOLUNTARY
  Tainted: [N]=TEST
  Call Trace:
   [<600a43cf>] ? dump_stack_lvl+0x5e/0x7a
   [<600450d2>] ? _printk+0x0/0xd7
   [<60051cce>] ? print_report+0x14b/0x517
   [<6039355e>] ? alloc_pages_node_noprof+0xae/0x120
   [<600450d2>] ? _printk+0x0/0xd7
   [<60a5d70e>] ? srpt_alloc_rw_ctxs+0x6ee/0x950
   [<603c78eb>] ? kasan_report+0x11b/0x160
   [<60a5d70e>] ? srpt_alloc_rw_ctxs+0x6ee/0x950
   [<60a5d70e>] ? srpt_alloc_rw_ctxs+0x6ee/0x950
   [<6008fdc9>] ? srpt_test_run.constprop.0.cold+0x177/0xd8f
   [<60a5fd30>] ? srpt_test_run.constprop.0+0x0/0xea0
    [ ... ]
   [<6072718c>] ? kunit_try_run_case+0x1bc/0x310
   [<60726fd0>] ? kunit_try_run_case+0x0/0x310
   [<6072d250>] ? kunit_generic_run_threadfn_adapter+0x0/0x100
   [<6072d2cc>] ? kunit_generic_run_threadfn_adapter+0x7c/0x100
   [<6014750e>] ? kthread+0x36e/0x560
   [<601471a0>] ? kthread+0x0/0x560
   [<600a90de>] ? new_thread_handler+0xce/0x130
  The buggy address belongs to the object at 0000000063180000
   which belongs to the cache srpt-kunit-iu of size 8276
  The buggy address is located 8 bytes to the right of
   allocated 8276-byte region [0000000063180000, 0000000063182054)

  Memory state around the buggy address:
   0000000063181f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   0000000063181f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >0000000063182000: 00 00 00 00 00 00 00 00 00 00 04 fc fc fc fc fc
                                                      ^
   0000000063182080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

With 256 descriptors inside the IU there is no splat, because that case is
a leak rather than an access past an object: the harness counts 256
rdma_rw_ctx_init() calls and no rdma_rw_ctx_destroy() call.  After this
patch both shapes are refused, and 1, 128, 255, 256 and 510 descriptors
that fit the IU are accepted with every context freed again.

Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v2: also bound the indirect descriptor walk against recv_ioctx->byte_len,
as raised in review; widen the counters as in v1.
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 21 +++++++++++++++++++--
 drivers/infiniband/ulp/srpt/ib_srpt.h |  4 ++--
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7197d95f2216b..5a12581286194 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -959,7 +959,7 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 	struct srpt_rdma_ch *ch = ioctx->ch;
 	struct scatterlist *prev = NULL;
 	unsigned prev_nents;
-	u8 n_rdma, n_rw_ctx;
+	int n_rdma, n_rw_ctx;
 	int ret, i;
 
 	if (nbufs == 1) {
@@ -1115,7 +1115,16 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 	} else if (((srp_cmd->buf_fmt & 0xf) == SRP_DATA_DESC_INDIRECT) ||
 		   ((srp_cmd->buf_fmt >> 4) == SRP_DATA_DESC_INDIRECT)) {
 		struct srp_indirect_buf *idb = srpt_get_desc_buf(srp_cmd);
-		int nbufs = be32_to_cpu(idb->table_desc.len) /
+		int desc_off = (u8 *)idb - (u8 *)srp_cmd;
+		int nbufs, room;
+
+		if (desc_off > recv_ioctx->byte_len - (int)sizeof(*idb)) {
+			pr_err("received SRP_CMD with a truncated indirect descriptor header (%d + %zu > %d)\n",
+			       desc_off, sizeof(*idb), recv_ioctx->byte_len);
+			return -EINVAL;
+		}
+
+		nbufs = be32_to_cpu(idb->table_desc.len) /
 				sizeof(struct srp_direct_buf);
 
 		if (nbufs >
@@ -1128,6 +1137,14 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 			return -EINVAL;
 		}
 
+		room = (recv_ioctx->byte_len - desc_off - (int)sizeof(*idb)) /
+			(int)sizeof(struct srp_direct_buf);
+		if (nbufs > room) {
+			pr_err("received SRP_CMD with %d descriptors but room for %d in the IU\n",
+			       nbufs, room);
+			return -EINVAL;
+		}
+
 		*data_len = be32_to_cpu(idb->len);
 		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
 				sg, sg_cnt);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 4c46b301eea18..1dce9bcb490f0 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -223,8 +223,8 @@ struct srpt_send_ioctx {
 	struct ib_cqe		rdma_cqe;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
-	u8			n_rdma;
-	u8			n_rw_ctx;
+	int			n_rdma;
+	int			n_rw_ctx;
 	bool			queue_status_only;
 	u8			sense_data[TRANSPORT_SENSE_BUFFER];
 };

base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.43.0

