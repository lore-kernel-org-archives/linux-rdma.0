Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168006;
	b=s0OMdpq5hPTQ/a/qRX5I6Tf1bhSk65lyMTO/UmQmyhcdc4dfwM75WLpTk+wAT5QEJrMP
	 +55ZomVaJ+oiLvJL/+AF92FnKID2x2gEmMOnZnTSCS2h0pFQrMKg441T/dyoXt2yGVgTZ
	 lRJawTq40GaV1qLv4FqT6TOoyZ2VyAfzRfVbXjy8h79uOt1jPlTPSAK9aVrg2aJvbARd0
	 wcE1h1xbUgHqqgvyEswCNuZcaZbkorFNDo4JNLhAN7009YP7BQZFh0lXRUgyOP+yCwBgc
	 4rIwOJrKA7CfW2PthKPxdfrfMzAYKdqm1J3ewb+oNNfVulfBvbvh/E69aiCzr23/dCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168006;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=dwW/aaZyKP6c8E6pqwqU1HuwGgTb3fA2eKNIwYo0OWE=;
	b=A83AgSo8ykLABjDOOIYbTyCmMCUN6F6PmRmTaf7hOlzpTotndfPFuho/Urttip1GNTpt
	 QVPT+li0K7efo2cx8Dg9KU3dDA5wkAifQVd7dr7h0XFiS4xluk7nzq3GFz9tD5I+shpEP
	 bL1MRQNXjW+8sGvXpL/5mXrIlmytck8YLQXp7kWq9V4EKaHVyVb6JqQ1TgJzDcbUrJF7z
	 T/n3F+8/tyBuvNXOiDlfqfDphk0H/oXRvNPd6TcfDHk4gIsCctDZu0pyrmdIxYQ1awBxF
	 rlEJP8J1VSVeiBP0Bhl1ayHVdYRMyKIKIYy7sJR2LozhphqJP9oM2iu/N4GFA+9tLkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FojfghBC;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFA5606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:13:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EFA5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FojfghBC
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3acb512a7a0so392546a91.1
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168005; x=1793772805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dwW/aaZyKP6c8E6pqwqU1HuwGgTb3fA2eKNIwYo0OWE=;
        b=IF7IvdIk7KXItaovkfvz9lfsHvj+EKaPgK3Rw0ndP85vHZJ7MxhhPpBg8Gfgum8m3/
         XdcbJBaRC/4bOer8KR7gk5lxp3hXNlua69aceXmQ+tO8VSNLJ7UTQHwbjDg5xNWjMHiB
         3mIlSVg7PWYwJmE6WYnNgA0QMv1NsvwxlXAlygMWwk+DHBtp0Z4vVPyRzdm3tOXx0E4Y
         +BWYjTI3WmcnM3zPBiMMiZhv27l1lzTfYn1mGfmH9Nfsy4mSpC8qxobUbbU/HcO0gEGb
         WcRRmY2xMpb3i+SBDbTEonLd4L39n8Di2MQJzgbwz8E3MU6zoUQZwN3chD8F9UdhCVAQ
         77ag==
X-Gm-Message-State: AFq9FYLMz4Y4JtrtsNYojMNq764O8o10M34aG1Dbxzd4/yOMtk7zH98s
	aAv4h0W+mkiQe9orgzWIZzjXURQotFVSaM3+TUpDdpWETIo60TKDYiLByjIwG+BQQVhev4uh1Kv
	ldViNcNRMhNOdLs29NTboPVp9pr8cA81qsYtkqF1FCXccc+0Hwmgc6gYx4m2Mvkicv6W7sZjpFg
	X+LR7lUlpVG+xkdSTglj6bf5frWI7UhTWLVjx/V8TeWiEsx8bvn37/Ps8jyaKu0iBZ3K+rTC7qV
	0V1vodFpBoozxNsKw==
X-Gm-Gg: AYBFou0YTeyJUpWuSpbJ8axn8UIbN0PZuX2B86f3kkiaXPreHo4+KzqbbRNhldsg7Zv
	c90Xc+U3tWu5f8vegtszILXkkI/FBV9iq3i4Vc7epIl+g5fK6IviUyRba5QYUUzlSqtd1oq4EP8
	fGsBjQVZ63oh5OgM2yE86ZIi0UYHOhgKljQnOy+OPWTWO9aQwc3cUnzlYeCXlThB5heINB7A57U
	GfKiovQGIJZTpdGMqs0UDocYDLIJflDBqvYStjWzzqtjvB0lRBK4B+u5RyPaP2sD3+F1WbUJG1Z
	u7vTU/xNijnZwCMwa8h3wsdt38NsdbeQKmi2zDHotq6TZuQ97lMUrMfzwNHxf8LdDtmeSake35y
	6ygj/bfRuqmSrkwq+ZahNI1DxgdhwgmlK/4REiId1xHdgORbGPbTtS72i3Snfl2HoH1q9F3YDI7
	jnJgxmqaDq12agtB34a6Q+nIsIXS3QRfZCXr8g
X-Received: by 2002:a17:90b:3c0d:b0:3a7:ecab:c4c7 with SMTP id 98e67ed59e1d1-3ae581d6ca9mr1133549a91.34.1793168005537;
        Tue, 27 Oct 2026 23:13:25 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-23.dlp.protect.broadcom.com. [144.49.247.23])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ae5ab93b50sm836826a91.4.2026.10.27.23.13.25
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 23:13:25 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-89f71ac2e2fso612104b3a.3
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793168004; x=1793772804; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dwW/aaZyKP6c8E6pqwqU1HuwGgTb3fA2eKNIwYo0OWE=;
        b=FojfghBCWEmo9O8iWEewxILhpql06vM7JHJjJ1dFkHd2sgWvZUpPrkt9ykYhyDdi9+
         xDVIW1IqR1Hwf51kPRteUtC9tVlB+hkH5o4MqUpb5SyZYNYvH97j/o0uCqBQuoHUbbxJ
         TTkP48nnALUVMOxrPiZpfdlSqOFWOAkqR+e2c=
X-Received: by 2002:a05:6a21:4014:b0:3e2:aab8:4ec5 with SMTP id adf61e73a8af0-3e90244273dmr1069446637.66.1793168004028;
        Tue, 27 Oct 2026 23:13:24 -0700 (PDT)
X-Received: by 2002:a05:6a21:4014:b0:3e2:aab8:4ec5 with SMTP id adf61e73a8af0-3e90244273dmr1069435637.66.1793168003612;
        Tue, 27 Oct 2026 23:13:23 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a75cf8fab6sm171717b3a.13.2026.10.27.23.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:13:23 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 1/7] RDMA/bnxt_re: Clear stale RCFW resp pointer when wait ends
Date: Wed, 28 Oct 2026 04:33:58 -0700
Message-Id: <20261028113404.33289-2-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261028113404.33289-1-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

If the wait ends with ERR_DEVICE_DETACHED, bnxt_qplib_map_rc() returns 0
for destroy-type opcodes, so the caller sees a synthetic success without
a CREQ. is_waiter_alive and resp are left set, resp keeps pointing at
the caller's stack, and a late CREQ is copied into a dead frame.

After the wait, take hwq->lock and, if the slot still holds this
command's response buffer, clear is_waiter_alive and resp. This also
covers the timeout case, where it is only defensive since is_waiter_alive
was already cleared there. Return success without checking evnt->status
when the slot still holds the buffer, since no completion was processed.

Also reset the slot in the completion handler, in the same critical
section that clears is_in_used, so that a second CREQ for the same cookie
cannot be copied into the caller's buffer. With this, resp == evnt under
the lock means no completion was processed.

Clear crsqe->resp when __send_message_no_waiter() takes a slot as well, so
a stale waiter can never match an internal command's slot by its own
response buffer pointer.

Fixes: 3022cc151197 ("RDMA/bnxt_re: Avoid the command wait if firmware is inactive")
Fixes: 691eb7c6110f ("RDMA/bnxt_re: handle command completions after driver detect a timedout")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 26 ++++++++++++++--------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 34d8aa12265d..707687a8f301 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -255,6 +255,7 @@ static void __send_message_no_waiter(struct bnxt_qplib_rcfw *rcfw,
 	 */
 	crsqe->is_internal_cmd = true;
 	crsqe->is_waiter_alive = false;
+	crsqe->resp = NULL;
 	crsqe->is_in_used = true;
 	crsqe->req_size = __get_cmdq_base_cmd_size(msg->req, msg->req_sz);
 
@@ -487,6 +488,7 @@ static int __bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 {
 	struct creq_qp_event *evnt = (struct creq_qp_event *)msg->resp;
 	struct bnxt_qplib_crsqe *crsqe;
+	bool pending;
 	u16 cookie;
 	int rc;
 	u8 opcode;
@@ -511,15 +513,21 @@ static int __bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 	else
 		rc = __poll_for_resp(rcfw, cookie);
 
-	if (rc) {
-		spin_lock_bh(&rcfw->cmdq.hwq.lock);
-		crsqe = &rcfw->crsqe_tbl[cookie];
+	spin_lock_bh(&rcfw->cmdq.hwq.lock);
+	crsqe = &rcfw->crsqe_tbl[cookie];
+	pending = false;
+	if (crsqe->resp == evnt) {
+		pending = true;
 		crsqe->is_waiter_alive = false;
-		if (rc == -ENODEV)
-			set_bit(FIRMWARE_STALL_DETECTED, &rcfw->cmdq.flags);
-		spin_unlock_bh(&rcfw->cmdq.hwq.lock);
-		return -ETIMEDOUT;
+		crsqe->resp = NULL;
 	}
+	if (rc == -ENODEV)
+		set_bit(FIRMWARE_STALL_DETECTED, &rcfw->cmdq.flags);
+	spin_unlock_bh(&rcfw->cmdq.hwq.lock);
+	if (rc)
+		return -ETIMEDOUT;
+	if (pending)
+		return 0;
 
 	if (evnt->status) {
 		/* failed with status */
@@ -703,8 +711,8 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 		is_waiter_alive = crsqe->is_waiter_alive;
 
 		crsqe->req_size = 0;
-		if (!is_waiter_alive)
-			crsqe->resp = NULL;
+		crsqe->resp = NULL;
+		crsqe->is_waiter_alive = false;
 
 		crsqe->is_in_used = false;
 
-- 
2.39.3

