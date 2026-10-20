Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792511929;
	b=FXEGVYeRVQVdhXTCqLGAMwHTv8y7kCliKGNCh/BSFCJjNiZppYJVo4MqUwd1AkFw/zxJ
	 B1gkZ1IJLMBQKpBa2KstjwLbRNGEvJ22T6mUUWrDip+FNSHvsylyeYEKwHimjAuiizgRl
	 zV0jyhq5oCJVdLfMYVwmN8bi29HkvbSnO4BBfRw0g5bwt2RH7e0a8gBKGmnGyHu0++YP3
	 cixSl0TsKg8/ckuWLkU8EIxRes7GDEfFpY14mBAn8RjzyXqloaW5JtU1Z77wJYAMuL+4r
	 B3A/D6HW05T3RBkrF6opZhDHXCk6LyS8Fe4wYPg/weBP7iYMUarX19fga3iEJy/qGpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792511929;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jwwf/y9hgPD/4iYQyhF41CmYL12LaotsH+U0E6c+Hyg=;
	b=yDGUNyG+lmvDWbns6Ki+OUwPhMBNnlZVk3pe6Z35XHLt6ccVd1RUlhsVkOrprryFK/42
	 FdEksuY/fF1JhErt79frN8350/fXWuW6nSo4eKQ7MCR33sY2pfg3+Pajt3PGgt1Qua8ti
	 Lz0OZLGY/3iECP9wgYzB8ZOBIK509N9O+UJeMnX8R5KCkbkVuAndpTzkqvfwd87fi2ewe
	 eD85JseoPFVACLaHQq53rOwUwpu0U5LOdtdj9dZBSynBhcTcGqG2umeNTLYG/KFPcwo+L
	 fES9jm1JmOX5Y/rBZo38No6TiabnS35DpqIj1Ujx379buEa1WOIMbBkcs2IQTQJyB/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=HU3O1tnW;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B172B606A319
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 15:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B172B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=HU3O1tnW
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3a706146559so2541058a91.2
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 08:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792511927; x=1793116727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jwwf/y9hgPD/4iYQyhF41CmYL12LaotsH+U0E6c+Hyg=;
        b=HU3O1tnWPWO0LvoQtSJ3ZKkWeXOCTbJMcHGP+wkdJsOfsnYSbhOAjrrPfSF2xfEzWL
         q8lts82HfrmWhrS+oMkcMAscqmxYgCs31qm5m8Cx8VrGgSlKsQ8Hv4N8mnMgN1jqk4Bz
         wtrlTam43pFz+0SCXZjybODCbNi/zs/YGzUhUUEu5gMBOBXIhTZRH/T+UyGgNbVpD9cf
         dcDsXN6DFvk9fohwvRGYrYuA418hOnp/1wkdFCpzR0MV42bQIcoK0dnHtMiV4vCOxXf5
         0c2Sip16E4QD6vZqmehZZSz6nFWzBHw8AYOAvtEWAIUy0ZHxB1vyouivBlbkPvKOjGoG
         C8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792511927; x=1793116727;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jwwf/y9hgPD/4iYQyhF41CmYL12LaotsH+U0E6c+Hyg=;
        b=jw6Il0ZdnatDHzsGAo8yGWZNJArLuFB72u1zdtfVkaWShMNJK7ygMS02EHy3r6ZyCC
         Kjlvp34mLG+yfhfMrYnXdRN9NBQLrt0i0BXK19ZNinJk6+eZXfMECzTXchZ1llovFQXa
         PAXRY2QI88vbn5bXWL0x/YFC/uf8iOATkMpfqxurZBmytLQkbybzFZch8IJ9EL0PNpDy
         pIYbFdRmA8U7LrrJhLGQ22/Y5ik2ricQNnQ+OIPprWyC4SeAlQx7Ls2Gxt9gh8KBXnRG
         0FsyOWyS5ap7yknx5eG4UkKjUpXPjmj3PT6PxpQm1xLY2PTlQUHViBx3CmomrrHfBOp3
         8W5w==
X-Forwarded-Encrypted: i=1; AKwUvByamMMdtRLpCQdjdbb+h5tDZvXbAHpEkDWf6e6S/ZrGOGqwd8vR1u2dw6/ua6qc6T4t+MT4LNM1nvun@vger.kernel.org
X-Gm-Message-State: AFq9FYJ04NHh2MNCNamSxViEX8Vrq07wUd/tW6Dzu7tTYYV/RB1pwkxl
	YjAeuNY4vW/VWCLOWDgRiWxQua2BmHAwQe1MQPVItaBaqr0SOaMtrogY3zCpbYtaC74=
X-Gm-Gg: AYBFou3gKrlCslUI7dCHOkAPUsnyAn5XzrLFz09H/T2dXFRtxRlQDVp1NFCEu3SzyOt
	g60LvNwbBI092S12XnQd1XIQjroGc4E9wiaDh0oZWHGdhYXHna5mCn+/iUz+zGiz3Jv+KHnKiwH
	Q6fRklcDLIQV5jog9bNooGu/xDZkAu6dNxn1edGZjoIDQt1J/69t9rfHnDURO+iNuBG4ujvKhV0
	qFWq+lLnsu32b886DcvB3qqOEZOKvjOC2S720W0fKBdPXR0dnPp5UTNdn3lwpdRRf2Q3S0xAq4O
	L8rCxwGVfiJ4stS0LXQU38XEXj+k6ZDPxuu2UZUWlttriKsIXicrIM6qhKEbZyMtj0xh6PpOU8C
	hlHOPOWMr022Xnrpnxvb+h3BDKoj0yNdfhw+SmKU2vrxmyqM3BbW/JesBScvwvGfXLYpeuBUpb3
	m0nmPiwgeHWJTJFJg15Xz0nIkhz9G0IdYFrW3BOEL/+hYPkYWki8ToqClU4bBdmhqQvKwjj51k/
	UKvTDQ9YtAriql4Aqpj
X-Received: by 2002:a17:90b:5743:b0:3a8:cc4f:3475 with SMTP id 98e67ed59e1d1-3acef60db08mr10119028a91.60.1792511925477;
        Tue, 20 Oct 2026 08:58:45 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e416:85ef:f22:6c5d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad813de463sm41188a91.13.2026.10.20.08.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 08:58:45 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH] RDMA/srpt: widen the RDMA context counters
Date: Wed, 21 Oct 2026 00:57:25 +0900
Message-ID: <20261020155725.2251969-1-yhlee@isslab.korea.ac.kr>
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

srpt_alloc_rw_ctxs() then builds that many contexts but counts them in
ioctx->n_rw_ctx and ioctx->n_rdma, which are u8.  At 256 descriptors
n_rw_ctx wraps to zero, and srpt_release_cmd() frees the contexts only
when it is nonzero:

	if (ioctx->n_rw_ctx) {
		srpt_free_rw_ctxs(ch, ioctx);
		ioctx->n_rw_ctx = 0;
	}

A command carrying 256 descriptors therefore leaks every scatterlist
target_alloc_sgl() allocated, every registration rdma_rw_ctx_init() set
up, and the rw_ctxs array as well, since the kfree() for it sits inside
srpt_free_rw_ctxs().  ioctx is a ring entry that the next command on the
same tag overwrites, so the array pointer is lost too.  The descriptor
payload sizes are the initiator's to choose and the command can be
repeated, so this grows without bound.  A count between 257 and 510 leaks
256 contexts and frees the remainder.

Widen both counters so they hold what the guard already admits, rather
than refusing counts the guard accepts.  int suits every existing user:
the two loops that walk the contexts backwards use an int index and stop
at -1, the sq_wr_avail accounting passes the value to atomic_add() and
atomic_sub_return(), which take an int, and the three places that print it
use %d.  The WARN_ON(ioctx->n_rdma <= 0) in srpt_rdma_read_done() becomes
a real signed test instead of a test for zero.  The error unwind path
walks by index and restores both counters, so it was never affected.

There is no splat to quote, because the result is a leak rather than an
access past an object.  A KUnit harness that is not part of this patch
calls srpt_get_desc_tbl() with a fabricated SRP_CMD and counts the
rdma_rw_ctx_init() and rdma_rw_ctx_destroy() calls.  With u8 counters, 256
descriptors build 256 contexts and destroy none, and 510 build 510 and
destroy 254.  With int counters, 1, 128, 255, 256 and 510 descriptors all
build and destroy the same number.

Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7197d95f2216b..b174d58ca98a3 100644
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

