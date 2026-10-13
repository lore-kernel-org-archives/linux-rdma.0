Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DB33905F0
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 08:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791881024; cv=none; b=IfmNAbGB3C1l7izNgDunPwLeUOC7ChahLL0sdpYc45VYNzGsu5SYYPn9d91EYbIMbSrHvwHse8LMEp20/lKo1U2HHCkRbiHyc3VvRyVBIgb6FyJyuUulQwDCPsqGlZOp9KQAP6AYslLtXUxIGNkZg8v9B1INQIF9AckPkxjd/BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791881024; c=relaxed/simple;
	bh=y3zAet3U8FrmV1lJqcbnornyQ8pV+g7xGYWQH5sgZrc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kHG75h5IX9p8iJOU7i1UQUXai8bhfznNuYMBmg/KQkxCj5fkBJdtHba4/IrpTksKX2HsKN0LDf4bZPkrX+m79ARXH/4EDcgcbX6IJ7S05lnVAc2MStEtfzvJEePjvWQgy+SibLhIMCvBn3R5hrWtN8dLO6tj/kthBeb4hsq5Gqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hDg5s/1P; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hDg5s/1P"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3ab4178ee33so1345573a91.3
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 01:43:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791881023; x=1792485823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g9PvXdE5NldSkOE6MkjPWmqacMJ3HF25zbrjrKzhj+c=;
        b=Ha29ry9MiuQuHnb2STaaWNMOXTg8i3xi0wPIWsm/lzyP6odgcGLbSL/mN4bb90lfb1
         1MqmONvjMDYC0wTMWutYA2eGOLPjKyR/h7uKmgprJUZwShKR4Uc7USUAd+p4zypkbFRR
         dimQF+mbn5Vee/AiZMZluQ3x+8v0F3FxoeLXZxsRAV8D0h38sb39LkL1DMDXuMu4YIKl
         ecR+UospLv2OyguAF4hniZcErcBJUQ1Bz0v8/ZRgViNTY8CQ8sHbM3DctwWhRgEjD9sb
         2KacOmLBUs2NRxZVm3tR4vKe421LZYw98UjHL5RWAtZ4LrdVGYgW6uwifPgedtNL6JrD
         T86Q==
X-Gm-Message-State: AFq9FYLcXba1yamyLXwwDquhG7WWAPQ0tdSCcOMF2aQYYEVB99PzWyJK
	SnYRVAxYS/K0HH9KGMuZHnsXuL16N+fuSDV/LLZJDiyCvuwq/8jGCThkb611Ouas65xVQW/tPRy
	3L5AIyee2G5L37m0H2rbXZmQKtEeENU7fnbqn7XORVjL6yH5OZBccZcCWuNSr9RLwkZ8XZJLrC/
	7MqS0+ltlCm0mRTsPFQKNw6vwnqfhajKnWoK79jUiF6eEE7R2CjMK7N4PoVY6BgI2bvzP104Tpj
	CTDB8gixzNVneOeLA==
X-Gm-Gg: AYBFou2QiaBHH6bFT3gbV9Gmvn7Gs0aVYyK7o3DRTxPZGpwKrciMoALVQVzZ4USYEJp
	E3c9NUr6K5XYHR8OaCS14touq2CfaECdiQf3HJ30LJBZU8gIWQRWipsYj71wZNuMOsqpVfqpmCC
	N1G6CdeKZj4Oh7wYbaa1pPGNns8XnpPKEEvN3Bad2vldsPGZmtjUplB4jyWrmMgBN2VfYKJ5pKo
	SUPHaSI3oYZfYBboci4LizAiqLrRwK/5lVOMjqSqsp9C4UQdgzEvimFnUXsYJIrIBVxrlzX9lcO
	k+Y0ubESHep7odq+5Kxau2mTN7+YI1KXQf3j4ccQ6Rk/VO/igZ/QXozTklsyX0VMQ95LAdxHKob
	JGtRQi7pfsueqjuAOvs9RMmGIHcDuaN4MorIvUNQVc3EgSgfWs/1aYDssGq3oaOowZifUu9iVCR
	pirY27yAkfKtNQSfxMFjLDT+TKwotz20HU8aF4KGg=
X-Received: by 2002:a17:90b:384a:b0:3ab:4f1:4f6c with SMTP id 98e67ed59e1d1-3ab3a90a038mr9206685a91.14.1791881022815;
        Tue, 13 Oct 2026 01:43:42 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ab369147b5sm6656448a91.0.2026.10.13.01.43.42
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2026 01:43:42 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33713e5e6daso4294964eec.0
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 01:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791881021; x=1792485821; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g9PvXdE5NldSkOE6MkjPWmqacMJ3HF25zbrjrKzhj+c=;
        b=hDg5s/1P0idn3T8ppbmq6AWa0va+9WGnzdn/0iSBA6Sd6rm5rqA7VSMe7O/8YD3KaE
         s2xUBz/N7mZyIJJA5XYSSSlg5TiMt+FHZW+AwEk5Y4JPQuEohkS+HESqmIcWiwJ8EcSk
         /HY95xb0iMhQNeA70+FCfQf3rfR+I6Crn6U/Y=
X-Received: by 2002:a05:701b:2717:b0:16d:dd5c:4261 with SMTP id a92af1059eb24-16ddd5c42a5mr15515691c88.46.1791881021009;
        Tue, 13 Oct 2026 01:43:41 -0700 (PDT)
X-Received: by 2002:a05:701b:2717:b0:16d:dd5c:4261 with SMTP id a92af1059eb24-16ddd5c42a5mr15515663c88.46.1791881020339;
        Tue, 13 Oct 2026 01:43:40 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1698de65af7sm40209556c88.0.2026.10.13.01.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 01:43:39 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 2/2] RDMA/bnxt_re: Unpublish QP table before freeing it
Date: Tue, 13 Oct 2026 07:04:27 -0700
Message-Id: <20261013140427.256612-3-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261013140427.256612-1-selvin.xavier@broadcom.com>
References: <20261013140427.256612-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

bnxt_re_dev_uninit() frees the QP table before the RCFW channel is
disabled, so the CREQ tasklet can still look up rcfw->qp_tbl while it
is being freed.

Clear rcfw->qp_tbl under tbl_lock before freeing it, and have the QP
error notification handler bail out if the table is gone.

Fixes: 82f1f575aa13 ("RDMA/bnxt_re: Fix allocation of QP table")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  4 ++++
 drivers/infiniband/hw/bnxt_re/qplib_res.c  | 10 +++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 9ee0d500436c..34d8aa12265d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -638,6 +638,10 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 		err_event = (struct creq_qp_error_notification *)qp_event;
 		qp_id = le32_to_cpu(err_event->xid);
 		spin_lock(&rcfw->tbl_lock);
+		if (!rcfw->qp_tbl) {
+			spin_unlock(&rcfw->tbl_lock);
+			break;
+		}
 		tbl_indx = map_qp_id_to_tbl_indx(qp_id, rcfw);
 		qp = rcfw->qp_tbl[tbl_indx].qp_handle;
 		if (!qp) {
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 086cf9fe3920..3faaec28201e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -909,7 +909,15 @@ int bnxt_qplib_init_res(struct bnxt_qplib_res *res)
 
 void bnxt_qplib_free_res(struct bnxt_qplib_res *res)
 {
-	kvfree(res->rcfw->qp_tbl);
+	struct bnxt_qplib_rcfw *rcfw = res->rcfw;
+	struct bnxt_qplib_qp_node *qp_tbl;
+
+	/* The CREQ tasklet may still be running; unpublish the table first */
+	spin_lock_bh(&rcfw->tbl_lock);
+	qp_tbl = rcfw->qp_tbl;
+	rcfw->qp_tbl = NULL;
+	spin_unlock_bh(&rcfw->tbl_lock);
+	kvfree(qp_tbl);
 	bnxt_qplib_free_sgid_tbl(res, &res->sgid_tbl);
 	bnxt_qplib_free_pd_tbl(&res->pd_tbl);
 	bnxt_qplib_free_dpi_tbl(res, &res->dpi_tbl);
-- 
2.39.3

