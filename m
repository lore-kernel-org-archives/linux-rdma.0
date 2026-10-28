Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168009;
	b=1DmebGNLBa5roJO/unzGWRtSjRfX52DNqFhiXKVZf55k0EsT2QFij2HMN+dU3ZcJH9ku
	 Kh/GAzxbZ0Ry+3Feh0+x9KdHbiQOQ3p8NXSuJ7b15a2Wq3VlPG1Cy+KU4CjIJtRp0Nd8E
	 SZef4DBLdn4XAgitpiapMyYJz4f0KUKbHq9uJRknQMnsQgxNbe1Ib3P6TRkJlEfYXlvDB
	 acirGFl0IrJyqhJdv7i1rGYuQc5i01KM7t5MIqiFMynlty4smxCzhUgkU99dqoiEnGOjW
	 jMnpLfKvnhwuDm1f6Ctp1qAyPn0RdOcg2LHX8oR/ephrPusDDW4b7ZZdY8iP01miz6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168009;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=xYIiK5ZXRF7pK6Ro8izazwBOsNaYTbsQwxGS7I8jAvs=;
	b=SR3zi2PqmoFjYvJGnCG4uRNQPFrC0BkXWfy9/wez0a6c/OMn0G3KmNnTBCxRovr6rA5O
	 wXXjP9OEtINHu2s/H6cBy9Qe50ipYSI5Wbvk7NY6QACZ9cqvCvrWiqmQgVpyTMmBCP8pC
	 gpegzAxchaLcSrwg9UBtCGhp/lnoTfxszaTIRnYsjtZj9Af3sj4e//X4ENP280IzY1kWE
	 KApnhCwtooe9YTQce1reQueUKmrCGUQD6QVv5ME/bcjyLhm913Q2rolI3cGIdrItMpY6l
	 QnbOcNEPGmt4bRXWf93dG64fUy1OhsWFbPTEQBfZ86hSj7pm2DF34DMcayS2aOluCrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=caGizmQz;
	arc=none smtp.remote-ip=209.85.222.228
Received: from mail-qk1-f228.google.com (mail-qk1-f228.google.com [209.85.222.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B780606A31D
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:13:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B780606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=caGizmQz
Received: by mail-qk1-f228.google.com with SMTP id af79cd13be357-93f2049ea7aso35463885a.2
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168008; x=1793772808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xYIiK5ZXRF7pK6Ro8izazwBOsNaYTbsQwxGS7I8jAvs=;
        b=n4ZiQuSrpV5b2p4y2Ljbv2h5HtpHCpj+HeFzmvr4vWXRf0cVUhBuaTXR9ZPTttPAaV
         QYsH30H7eSkYcIP2/nZNi9EjwMZu070dKap34gTPTe8g8OYASBTNXprD1gZfijnB6mnY
         b8rIgAVf4jJIHtlVj4/TPsACUCNP5WZ6phQn5FL6FYo3w5KV/QUA7wpXrPdCaPa11cw6
         WWOzw64E3q7EpYIEdX25vJhd4QnKxpOs0wA+RUHM/SDqr8EUf+eGz1TOsu153KrDjrRY
         gUmvrHops7pUciXFg486oYCNamBsQzZNJQvVGFMIxjW+IIdbXQ/VumUPzW6MDUyB6TbR
         rUTQ==
X-Gm-Message-State: AFq9FYK8LJKbwZdJnR7kMGD2mKAiuWReJmNZT4y7jNMY+fL3ym4kMWQm
	NJe7TbXsib9OmDeSBQcG8pcX3oDw5GvV/yajZnOtMrESCVJF8aNCMUGW8vVGQVfhPrpSoces3f6
	moYaokyUWmNffaOb78/NHuEhjfoVjuIA5OalYxO02FEKkVTdeU0iQ/+fgTzSz89UjItzAwXBoxU
	UtUdI8hCK+W1HDQlBuBfKgVdMFOWwfYq/trjXFFLkfZLwx5kXMIMCWNczxDZYb5hpygbrjLYO29
	risagctZyPRZwZrSA==
X-Gm-Gg: AYBFou1uhN4V2KI42AMWWjRSOB4Eft78TsTaZsx4wr/PE54BeCV+mr3b1d8ZaTKs9Vj
	9vBCgy/mf8zhD8/pn3O0xKzYzgign04Jh2rMJ1flJazbiI78BWIS1a/nr0q93vmOLvU2MDDtABh
	ZfhM924LRXLxz671brT4qHSdUv2URkII7mReAWEVTvss8HeHPfAoFeXdOTkNGUmyrDpg6g1ynsz
	RRVMzsf8b+gK+7UFIjxxW9RJNkbxOEK/pd0J4OcEdXV+uXkqKHvqrtkIareGC6SEyYlKcMOrKlj
	uN01GpCttzWchh081v8FzCqhQWL15gFJXNtESBKXp+PvcIa8VyreD0HVHnRbIMMDa/y3l5a1yP3
	lSlrZIw3fv9hfKBn6SG8CyMBaKe8vYW+XhtudL08m2HP3u8vZehZXP8zQLa3O3p1mdIwa0kypgr
	qjDLhB3MBEgphrNDKUoV3nRExxxStXqwys1lU6
X-Received: by 2002:a05:620a:2629:b0:93e:c12c:9b77 with SMTP id af79cd13be357-94408d68de4mr169866585a.82.1793168008183;
        Tue, 27 Oct 2026 23:13:28 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-23.dlp.protect.broadcom.com. [144.49.247.23])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-940f0677243sm175912885a.9.2026.10.27.23.13.27
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 23:13:28 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-88c768886a6so516981b3a.2
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793168007; x=1793772807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xYIiK5ZXRF7pK6Ro8izazwBOsNaYTbsQwxGS7I8jAvs=;
        b=caGizmQzn0DEyn3iUL+czo9Iaf0WPldowxe57YKnsoWOlzaY6XCUhSyVn9M13/ZRQ+
         iHqS2AdaYep4f2wCOEEarb2oZaIHzGrJq3hHTF4RFJ394AtBQ6Lz4XXdMRUp7sgtdbB3
         F9RW9kz7MPCWcJCxHeag5HJ5ryNAkWX+cfaoU=
X-Received: by 2002:a05:6a00:92a1:b0:869:9298:ba50 with SMTP id d2e1a72fcca58-8a6e1b55086mr1217807b3a.0.1793168006912;
        Tue, 27 Oct 2026 23:13:26 -0700 (PDT)
X-Received: by 2002:a05:6a00:92a1:b0:869:9298:ba50 with SMTP id d2e1a72fcca58-8a6e1b55086mr1217790b3a.0.1793168006425;
        Tue, 27 Oct 2026 23:13:26 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a75cf8fab6sm171717b3a.13.2026.10.27.23.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:13:25 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 2/7] RDMA/bnxt_re: Honor a completion that races with a wait timeout
Date: Wed, 28 Oct 2026 04:33:59 -0700
Message-Id: <20261028113404.33289-3-selvin.xavier@broadcom.com>
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

If the wait helper gives up (timeout or firmware stall) and the CREQ
tasklet processes the command before the waiter takes hwq->lock, the
response is already copied into the caller's buffer and is_in_used is
clear. The waiter still returns -ETIMEDOUT and may set
FIRMWARE_STALL_DETECTED, and for CREATE_AH the handler skips
destroy_timedout_ah() because the waiter was alive, so the AH leaks in
firmware.

Under the lock, if the slot no longer holds this command's response
buffer, a completion was delivered. Use its status instead of failing.

To keep that check valid, never reuse a cookie slot that is still in
use: __send_message() returns -EAGAIN and __send_message_no_waiter()
drops the internal command.

A slot stays in use only while its completion is outstanding. If that
completion never arrives, the cause is a PCI error or firmware still
processing the command, so there is no point in posting more commands.
Continuing to return -EAGAIN until firmware completes the command in
order is intended; otherwise recovery is initiated.

An internal destroy_ah dropped for the same reason leaks the AH in
firmware; this is accepted and the comment in
bnxt_qplib_service_creq() is updated to say so.

Fixes: 691eb7c6110f ("RDMA/bnxt_re: handle command completions after driver detect a timedout")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 31 ++++++++++++++++++----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 707687a8f301..167626246800 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -223,7 +223,7 @@ static int __block_for_resp(struct bnxt_qplib_rcfw *rcfw, u16 cookie)
  * Current design of this function is -
  * user must hold the completion queue hwq->lock.
  * user must have used existing completion and free the resources.
- * this function will not check queue full condition.
+ * the command is dropped if the cookie slot is in use or the queue is full.
  * this function will explicitly set is_waiter_alive=false.
  * current use case is - send destroy_ah if create_ah is return
  * after waiter of create_ah is lost. It can be extended for other
@@ -245,9 +245,17 @@ static void __send_message_no_waiter(struct bnxt_qplib_rcfw *rcfw,
 	u8 *preq;
 
 	cookie = cmdq->seq_num & RCFW_MAX_COOKIE_VALUE;
-	__set_cmdq_base_cookie(msg->req, msg->req_sz, cpu_to_le16(cookie));
 	crsqe = &rcfw->crsqe_tbl[cookie];
 
+	if (crsqe->is_in_used ||
+	    bnxt_qplib_get_cmd_slots(msg->req) >= HWQ_FREE_SLOTS(hwq)) {
+		dev_warn_ratelimited(&rcfw->pdev->dev,
+				     "CMDQ cookie %#x busy or CMDQ full, dropping internal command\n",
+				     cookie);
+		return;
+	}
+	__set_cmdq_base_cookie(msg->req, msg->req_sz, cpu_to_le16(cookie));
+
 	/* Set cmd_size in terms of 16B slots in req. */
 	bsize = bnxt_qplib_set_cmd_slots(msg->req);
 	/* GET_CMD_SIZE would return number of slots in either case of tlv
@@ -314,6 +322,12 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw,
 		spin_unlock_bh(&hwq->lock);
 		return -EAGAIN;
 	}
+	if (crsqe->is_in_used) {
+		dev_info_ratelimited(&pdev->dev,
+				     "CMDQ cookie %#x still in use\n", cookie);
+		spin_unlock_bh(&hwq->lock);
+		return -EAGAIN;
+	}
 	if (msg->block)
 		cookie |= RCFW_CMD_IS_BLOCKING;
 	__set_cmdq_base_cookie(msg->req, msg->req_sz, cpu_to_le16(cookie));
@@ -520,6 +534,11 @@ static int __bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 		pending = true;
 		crsqe->is_waiter_alive = false;
 		crsqe->resp = NULL;
+	} else if (rc) {
+		/* The completion was processed after the wait gave up but
+		 * before the lock was taken. The response is valid.
+		 */
+		rc = 0;
 	}
 	if (rc == -ENODEV)
 		set_bit(FIRMWARE_STALL_DETECTED, &rcfw->cmdq.flags);
@@ -726,9 +745,11 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 		 * so let's destroy the same address vector since it is
 		 * no more used in stack. We don't care about completion
 		 * in __send_message_no_waiter.
-		 * If destroy_ah is failued by firmware, there will be AH
-		 * resource leak and relatively not critical +  unlikely
-		 * scenario. Current design is not to handle such case.
+		 * If destroy_ah is failed by firmware, or is dropped locally
+		 * because the cookie slot is in use or the CMDQ is full,
+		 * there will be AH resource leak and relatively not
+		 * critical + unlikely scenario. Current design is not to
+		 * handle such case.
 		 */
 		if (!is_waiter_alive && !qp_event->status &&
 		    qp_event->event == CREQ_QP_EVENT_EVENT_CREATE_AH)
-- 
2.39.3

