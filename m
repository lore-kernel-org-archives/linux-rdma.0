Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780253BFE44
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 17:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716774; cv=none; b=ZpnTtukxASj5DECNH9K6/D7zFh03PtVI7KUNYEOfnU4Si2ffW2V0pHuVyJI/oJdfVuex9uWV9VCHurrglr39+yj4+MPb82n7TmA5j8zY5ejDXRiNTrMXWoLmlfZ11smEeVYN6LYSNoW4MfJBuozetSFf0CxWaUX2NGPQVk3cO78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716774; c=relaxed/simple;
	bh=uDLNxhbJgkz0/NSwy7S9jmNTyJ0BMSFl8QEG5JPhLbM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d2ZXj1CjNapau4BT79sRIYQrsfswwAUdyyg415dIC3s7oHZN6cLMeSOAt43gSxAoesyhYDobThUlUZ5FbB2EFtG4MtD1ZM80E2etcW1R6D/0wPw6wzcCj8lGNNyK6A0P9Ts2dr/+E96nkgYPiROLrq8am+rVM+cDvKQSNDxkt7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KeOlfc+K; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KeOlfc+K"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2d94c868ea5so28219465ad.3
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716772; x=1789321572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aF2YYLviQC7k0gOePiuYzdYi8in7fV8VgUF3QZqs4ww=;
        b=YkREvtSJ8IrSZSE8CB1hQS2lTcLBdNzETOQVocpNkSMaPFrqE81wI8SIGP9Af3WVzb
         wLWGv/9+2eqiJbxBCIyBislzaA9zlup8wnBaWQRJjF1wQerPvr5YBFSk/P7j6IHIC7EK
         +6zZ1/1dZbor1YXHUpMrRaTJwOUp8hXH9OmmoFDB+WlyhYlQ0buh+dgZ2MA/ayDWCWtp
         csQMwkYYJlqMHIlJRWs1azxLxtRgp3cKBrwZmLBxNCbJxsptp/c5nLUZldwpXFE2KbOE
         qzAPFpZg13k1dEcup4iTIZww3sYwphUzdVCuaodDUvcv2c/+yg0bnUwV5iwgbDvVL0KM
         HxmQ==
X-Gm-Message-State: AFuF++ksE9oU/U6Vlanxx/drlSfIO7TcgEFm0rYLu/v245uOruy8Tcck
	dvAwBMa7JD5itT+knoBCtNsA9pmtFSloIVgPW2iSiJRgOttgfqWb3P0FfS/1JMnFE+vblo2Ojk+
	I+FMQW3OO9mdhOl7H5L12kHj/pX9wMZRA+ot+0/uwgkmUrdYK4ZSNSdbDaLQUG9hIQrFWIIHL3j
	q3iDHuQZ9YZvWqek74vMIMgnElZz3ep5BrbAhLVSYSes4lf/IWhUg2ZQjSUbwdlyPddAdxPHB1Q
	U3h8r4g53O8DxJBDg==
X-Gm-Gg: AYBFou2lfx5DWBh5UpZ84PmhtKJz/Ar9dxze4PmwMXvpVTfvtcQMWDnLXymIyCnBboN
	usRjJaRmWh8br0P2sAzIHPvBDGf4RdzpDi9J4hJzwIorzlaaGQM9m1ByOAQS5nnIvha5W0ioT02
	o04ZMGOtG/37Fw33Z5XTrMi8cosEEtJLFKwc6LgoIBjMuaXMBAA2B1R5CzWu9Pkx3hzH9938SXm
	K5+IwIhh3krt9L+64mZRYOLarLnO8Ko73Z0dzbvuyS1cQU7wWtOlzwCIDb0O2wtazkPd8sRH1GQ
	zQribqs+SJJGhiXwspj3LuHPLMvGhrmIv++iyriHr960E2umv415wXrdn11kVAGXL/gxZyg8+EV
	4Kc0RC4Br52g0NLv1hDwlHqwzvSgz46sXq1V24faa36tbzJot5q6jP6YUJ9515VhruhjpW2XYNm
	6d0whxZcxciMubwYtazp98s8jngDlvISK6ldEnP2c=
X-Received: by 2002:a17:90b:4c03:b0:398:cb56:e92 with SMTP id 98e67ed59e1d1-39b26130698mr26127777a91.11.1788716772520;
        Sun, 06 Sep 2026 10:46:12 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39ae62ac9adsm1529018a91.1.2026.09.06.10.46.12
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Sep 2026 10:46:12 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d52734fc41so50319285ad.1
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788716771; x=1789321571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aF2YYLviQC7k0gOePiuYzdYi8in7fV8VgUF3QZqs4ww=;
        b=KeOlfc+KM6xAcVpNC6gFNTSunrBiOiBt1y8QM0/Zw23HueRT51INd+E76nutrBrca+
         coN1fyCpNB/WJPATnuhvKnM6hdKjsf34TR8G20GwBI5vIyyxbQpWFHeKoW0QAsN6/tkU
         +CoeBFVcj5dMQQcP5CF1rE9MjOR+jDEKGi4Ek=
X-Received: by 2002:a17:903:2ca:b0:2d9:3850:2741 with SMTP id d9443c01a7336-2db12255f7bmr273546575ad.0.1788716770708;
        Sun, 06 Sep 2026 10:46:10 -0700 (PDT)
X-Received: by 2002:a17:903:2ca:b0:2d9:3850:2741 with SMTP id d9443c01a7336-2db12255f7bmr273546005ad.0.1788716770261;
        Sun, 06 Sep 2026 10:46:10 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3356dc5c04dsm11075108eec.8.2026.09.06.10.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 10:46:09 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 8/8] RDMA/bnxt_re: Check is_in_used before trusting RCFW completion
Date: Sun,  6 Sep 2026 16:07:00 -0700
Message-Id: <20260906230700.12233-9-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260906230700.12233-1-selvin.xavier@broadcom.com>
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Gate the crsqe->resp memcpy in bnxt_qplib_process_qp_event() on
is_in_used in addition to is_waiter_alive, since a late/duplicate
completion for an already-retired cookie could still write through a
stale resp pointer.

Also disarm the waiter and clear resp when a wait call bails out early
on ERR_DEVICE_DETACHED, and require is_in_used before re-triggering
__destroy_timedout_ah(), closing the same stale-cookie exposure
elsewhere in the completion path.

Fixes: 691eb7c6110f ("RDMA/bnxt_re: handle command completions after driver detect a timedout")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 9ee0d500436c..0339e55bea88 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -511,14 +511,16 @@ static int __bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 	else
 		rc = __poll_for_resp(rcfw, cookie);
 
-	if (rc) {
+	if (rc || test_bit(ERR_DEVICE_DETACHED, &rcfw->cmdq.flags)) {
 		spin_lock_bh(&rcfw->cmdq.hwq.lock);
 		crsqe = &rcfw->crsqe_tbl[cookie];
 		crsqe->is_waiter_alive = false;
+		crsqe->resp = NULL;
 		if (rc == -ENODEV)
 			set_bit(FIRMWARE_STALL_DETECTED, &rcfw->cmdq.flags);
 		spin_unlock_bh(&rcfw->cmdq.hwq.lock);
-		return -ETIMEDOUT;
+		if (rc)
+			return -ETIMEDOUT;
 	}
 
 	if (evnt->status) {
@@ -627,6 +629,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 	struct bnxt_qplib_qp *qp;
 	u16 cookie, blocked = 0;
 	bool is_waiter_alive;
+	bool is_in_used;
 	struct pci_dev *pdev;
 	u32 wait_cmds = 0;
 	int rc = 0;
@@ -682,7 +685,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 		if (crsqe->is_internal_cmd && !qp_event->status)
 			atomic_dec(&rcfw->timeout_send);
 
-		if (crsqe->is_waiter_alive) {
+		if (crsqe->is_waiter_alive && crsqe->is_in_used) {
 			if (crsqe->resp) {
 				memcpy(crsqe->resp, qp_event, sizeof(*qp_event));
 				/* Insert write memory barrier to ensure that
@@ -697,6 +700,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 
 		req_size = crsqe->req_size;
 		is_waiter_alive = crsqe->is_waiter_alive;
+		is_in_used = crsqe->is_in_used;
 
 		crsqe->req_size = 0;
 		if (!is_waiter_alive)
@@ -718,7 +722,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 		 * resource leak and relatively not critical +  unlikely
 		 * scenario. Current design is not to handle such case.
 		 */
-		if (!is_waiter_alive && !qp_event->status &&
+		if (is_in_used && !is_waiter_alive && !qp_event->status &&
 		    qp_event->event == CREQ_QP_EVENT_EVENT_CREATE_AH)
 			__destroy_timedout_ah(rcfw,
 					      (struct creq_create_ah_resp *)
-- 
2.39.3

