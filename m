Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168012;
	b=yfXNquoIe2zvEKRjpJNVecuYwByX5TJA7RZsPQ4quK1RFM2D3GNXYTleAN317DtiJoaq
	 qDWiSkEJ4BP0jSOcCLQ6AvbcAz6Rjxk5b1AT8kIetThYnhwd7gbNoTrYl2HUGR4kesIGv
	 46RDmjuAw2g8bg+67qzS4PnchVH36k2B/aUw60yfIoH3/N1BxjAfhEtn/EovH5duyLuI0
	 TGdZR1fMgHN+AxJSab6UuhvB5BrIEhYX0XkSSR8qy2iCwnzwtcO/ZNJMJ4zyUAa405m+O
	 O34qMGKsSjALJFi6ulHPDu++eSw09pnGfjvOI23JzYhxrxR/C9r1xR/uXbbBtqukrLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168012;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=aiooZ+ZYh1m/lK0QXir+fF4LrfWKHrZnSmJKjOKFPFY=;
	b=qQx+/hrMhT9VlRgCdDTo4NGtRHygHLW2uE/2+GxG+5HDgkkYewX3jR/Y3CV5fPnUTGiL
	 Cz8THkC0NCmsxAXUQ7bqfRGSkA4HDd1h+Plyqg1ZyWMfP1+Z/hmLsLbRe5aJUHNOsfSwh
	 G28ZukuDilBtuhIpj6uHMk8oriRqQBOjVOegdmI81Kjky4oGekDUwuLR0U2imCroqXCO4
	 NDjAFq/GQ0RWezH+C84Oxx0g36vc0UpPHXE12r1QrP+E/NQegNG1gq3n7XNBw2arta3YN
	 uBZHM5NHSMdZQHF1MNtL7SuIHp27YW9f6Y36wzej+gtoNWM6ZUGYDs0zsD6d4wmFobw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="AMM/lhtS";
	arc=none smtp.remote-ip=209.85.222.98
Received: from mail-ua1-f98.google.com (mail-ua1-f98.google.com [209.85.222.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3F9606A322
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:13:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E3F9606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=AMM/lhtS
Received: by mail-ua1-f98.google.com with SMTP id a1e0cc1a2514c-98301b325c4so191954241.1
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168011; x=1793772811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aiooZ+ZYh1m/lK0QXir+fF4LrfWKHrZnSmJKjOKFPFY=;
        b=JTCguJcQZlIZ4TbHaGbSboUb7QAKzuMo1nb6FwdiedlahdaZdC8JNAAQz2ZWi1EGLa
         Jilvsmd1xvKZvmrHCJB6dakcPHhS7BugVPMg823oGlyHTX4Qu/T+Jo14yEpMHjik0BHn
         wfrVhXLwhC4qBo4k6vg2TWicVrRjWHpjey+qDpDDBveVBQjq6nxwiVqInD7LzuFCRmYs
         cA9s2uXobO9y+OvcHmdjN9tIMxQRfO7J1uZjRCTFnR7X4mBUwUlpmgHl7u7PkimRj6Uh
         aYo8bdNWBM0Nl/QWJuAv2Q5n1RurFRlJke0gH2uUfZPq3kvZmw7Exy1eenRpOQTqoF9G
         7aNA==
X-Gm-Message-State: AFq9FYLRqwKvu/J9ep9Z6C4PnVFi7JWLg51C1kF5Yp31uyh00nIKxWuy
	4u2mpThSzpX4GSAkqhtkiykFQ2kkqp2mgJOsPDpIHBWOh6oJBlTE/ARF17v2WeWi3opSYMx+d/m
	TTB4IW1rOlFlDJgL6M+EC7O8ROpcu274bcPsMQfF+BqKcwKkUQQh5QZusRcq48lJrTikkyjMpsO
	xXoXiMfSD1RI4xjTNqwWfDZ79MYXjm/LvdrIHs+1vRNZ0CITRYRX7SXZ9SIv2JREqgenJFp8vim
	Q4/6/JwJN3XvFc3Cg==
X-Gm-Gg: AYBFou3InLzrmcuzs7ULgI9DNIp/LdhIOrsq0t0vGCLhXtPVPdDVfmasCR0MWNS27y1
	HU6hkiV8g6mPtKACPEbMLb31UdQC+u4e91j9xCqDbu/Ird7OoccsCc8V2Hr28jOKW6XBZkcwKgG
	ylnBqtZgjbRWzsUy9s47YxXBcZZhTkfy0vLLjL7wshaAWht2raycdAdyUgCHTjNde95I8tUkAYK
	cyqK/UmLCy8eHAOUD4rEu7IVxcn3Xi/lc84PKYJb3/mDWDASPt3HC0jboJ8vmB2CjJgHrAdl9kM
	PLwBRm19y2N6Lul7ctpRAqP+l1V/CsDDVBeCKINaD1VbTyp8MbLV1YM8ZpHUxRlN3utLsgLgvNY
	QG4qhdYP0YqdjcPHV3leu+hbi5wRjVxoOs/+Fa+m5imyjnCNdkbYqLfe0MfqD4rMmp6HAO4RlRa
	ZFGtF31B+p5sFJafTrpp05vYID3VXTdWVdzaWH
X-Received: by 2002:a05:6102:2c81:b0:7c1:5862:a97c with SMTP id ada2fe7eead31-7d03a66d992mr562079137.37.1793168010788;
        Tue, 27 Oct 2026 23:13:30 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-23.dlp.protect.broadcom.com. [144.49.247.23])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-991259c2946sm43242241.6.2026.10.27.23.13.30
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 23:13:30 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-89f84753b43so543032b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793168009; x=1793772809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aiooZ+ZYh1m/lK0QXir+fF4LrfWKHrZnSmJKjOKFPFY=;
        b=AMM/lhtS93sK1ZFt0JFm1QHKtVnAA+v9WYv9WtGUKG6clvBIlcRBJLyq8eo+S2VtrQ
         q2eeD89zKNtnGMM8p0pBEkNMYaqqdM5ioshSMuyZ8IKfgyCAylOql6AdxdMqqoEU/zt3
         3d4EfEz8Hf/dqPoYvp2ytxhtTj5VJ4btF+xIE=
X-Received: by 2002:a05:6a00:a207:b0:886:5938:cddb with SMTP id d2e1a72fcca58-8a6e6ef8569mr974286b3a.20.1793168009658;
        Tue, 27 Oct 2026 23:13:29 -0700 (PDT)
X-Received: by 2002:a05:6a00:a207:b0:886:5938:cddb with SMTP id d2e1a72fcca58-8a6e6ef8569mr974278b3a.20.1793168009174;
        Tue, 27 Oct 2026 23:13:29 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a75cf8fab6sm171717b3a.13.2026.10.27.23.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:13:28 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 3/7] RDMA/bnxt_re: Do not treat CQ error notification as a command completion
Date: Wed, 28 Oct 2026 04:34:00 -0700
Message-Id: <20261028113404.33289-4-selvin.xavier@broadcom.com>
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

creq_cq_error_notification has the same type as creq_qp_event, and its
cq_err_reason (1-6) sits where creq_qp_event carries the cookie. With
no case for the event in bnxt_qplib_process_qp_event(), it is handled
as a completion for cookie 1-6 and can corrupt an outstanding command.

Handle the event explicitly and do not touch crsqe_tbl. The event is
intentionally not reported to the stack for now; that will be handled
in a later series.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 167626246800..da6c7779ff87 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -647,6 +647,7 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 				       struct creq_qp_event *qp_event,
 				       u32 *num_wait)
 {
+	struct creq_cq_error_notification *cq_err_event;
 	struct creq_qp_error_notification *err_event;
 	struct bnxt_qplib_hwq *hwq = &rcfw->cmdq.hwq;
 	struct bnxt_qplib_crsqe *crsqe;
@@ -661,6 +662,13 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 	pdev = rcfw->pdev;
 	print_hex_dump_bytes("event: ", DUMP_PREFIX_OFFSET, qp_event, sizeof(*qp_event));
 	switch (qp_event->event) {
+	case CREQ_QP_EVENT_EVENT_CQ_ERROR_NOTIFICATION:
+		cq_err_event = (struct creq_cq_error_notification *)qp_event;
+		dev_dbg(&pdev->dev,
+			"Received CQ error notification cqid 0x%x, reason 0x%x\n",
+			le32_to_cpu(cq_err_event->xid),
+			cq_err_event->cq_err_reason);
+		break;
 	case CREQ_QP_EVENT_EVENT_QP_ERROR_NOTIFICATION:
 		err_event = (struct creq_qp_error_notification *)qp_event;
 		qp_id = le32_to_cpu(err_event->xid);
-- 
2.39.3

