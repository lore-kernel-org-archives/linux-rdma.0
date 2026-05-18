Received: from mail-yx1-f98.google.com (mail-yx1-f98.google.com [74.125.224.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8EA48124B
	for <linux-rdma@vger.kernel.org>; Mon, 18 May 2026 15:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779119218; cv=none; b=iF/QaQ8dDALdYF/9A5wGnPlaKfu3J1NxXwECQirgAhQ/FxSdU6CAXqsXJNQtr1FYXQLcFX/K6QCpBijGmE/LRgNRZaxKrnsAuhExNDdPSB90OonAJDIqZ5iV3gTU3UbtnQrAkSi4QjlDG0ZrDqpSZ6GQZFHUqASsxZQKuyfh6nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779119218; c=relaxed/simple;
	bh=wbSax1j94TarfeVhh/jq34XlMBNSZPOosjFjDbIpGz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPSs4+Vmswzft8209Qj8JrhvPw1IC3U6tP+DTZBYSX2UPT072aANZfbIk2qqCUaprL2TEBHGn9t1RNWERXwlryFx6pVe23R2nw33udfgtLxaHd2dSrHK6DiQRqhri8hQbXWPJf8lOWEzXRIYn+LqQY+QhuTEXkX0vntynThBfGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bTYCTxqG; arc=none smtp.client-ip=74.125.224.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bTYCTxqG"
Received: by mail-yx1-f98.google.com with SMTP id 956f58d0204a3-651c5d525f6so2488328d50.3
        for <linux-rdma@vger.kernel.org>; Mon, 18 May 2026 08:46:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779119209; x=1779724009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DpRHlvXpRGKmnpzQ8sKj2I6KDfX3CD9sv1ZBiRR4tdc=;
        b=me9gdZ5J7QwULIepfaT6wgvv3buKyPCnyjKudLMU04gwEpe6O0VnsH0PNQ3/63xcjw
         T2eHbxnwWs66OmV6jE7gcfItGjoh90JdfYCZ9/6bR/xOiBRKntK3QoC9Y+KY6xedZ7Oa
         m6KvW934LNtirXhePWPyPacjhEK/szu7ZKqN5BxMq70ffIHlboUIcMb22XKdBDc0cQbC
         fgCMNJG+Jow/xeQTS1d8wOZln23em+wTuNlw6y21+Zq1XoblikFvl4GUm0Cy8//tyvea
         F4RR+RkV9BSPNu/13Sjjqc8D99T7vHmecjNc3f8Z5m2xfER9VLEiBG+/5NGD25TiWsGW
         qkaA==
X-Gm-Message-State: AOJu0YzCBT7fZhpc8B95PaS+eVQBI9wMVJ+BF1r6ccStbi/7EQqj3EeI
	d8skt3hHK/CgLu5sUsYplQbS/0xvCDJqxWqusZGynrL5nd/F+UlhdCgYQyDlVAf5w9ajHlx24EU
	ej73cREYwHlp/7euuEVSath1vhxUQiAt3ltTF7NofZ6Jl6FqDeB5QKXE5AeqjIIfkbs4N96+mpY
	hEymCJLVHzROGSjy8Kh7yScT0YFOFEzDoxhw8heuiWhwG+xljoyF9v4ArdC9ygYYCWUlAUmHb2y
	sy5E/KCurLwS0Uol9BmIK2cMC2w
X-Gm-Gg: Acq92OEIAgHitxQOhnYfRSHyHmzJ6TgX8/7zNVLuzD3An7xhTX1voTEaIlrdp+fyKK8
	oIya5IVpY+DN5zCYGYPmzk1YA4Uf3C33uZS20BrZv04yg8TAhSMMdjwltGP7eVmn3APx3fIj8QR
	4qGdlQvjhtBLJL1+RzOOQzGDo9J1oAtYY3+DuZSCDnV/LFA7PllWlK8aLpYr/iUinE9piHsckdk
	cGKuvVdLtSuyk7pZjAP5tKIvudaUZ98dUp+RuHTnsHBaX67Fa/162QkGL5MaGE4qwcqQFVL7Maq
	J0l/wXJfU6q1HlnFvP5nRQ1fQ7A3gjWOsWO1qOonaoimi0lhr1q/zoIVrH8II/qDm/173jf1ysS
	Pd6I0uO9VkzOUKvOPno+McJjN9FfoLtU4BQRhWIBdTJ8wNVi0eZVsNcoR9pjQnlz72tFtZuP8qU
	+DthtC26yj5e+SNm3Mh2vz2jtoPXX7JcIxTBJWc8TNdfAc4ZyM/isKubH8zrpJniPQlgSh8RI=
X-Received: by 2002:a53:c04c:0:20b0:656:30a1:70e2 with SMTP id 956f58d0204a3-65e22686cbbmr12680763d50.6.1779119208670;
        Mon, 18 May 2026 08:46:48 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-101.dlp.protect.broadcom.com. [144.49.247.101])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-65e0dadbf82sm1093203d50.20.2026.05.18.08.46.48
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2026 08:46:48 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b458add85aso26529615ad.2
        for <linux-rdma@vger.kernel.org>; Mon, 18 May 2026 08:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1779119207; x=1779724007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DpRHlvXpRGKmnpzQ8sKj2I6KDfX3CD9sv1ZBiRR4tdc=;
        b=bTYCTxqG8snH/7HD9vk/nYYahapi8QrHnb8xXAvBKXM9x+BjPql28TblWR2vGp9qeu
         2ocgldguQ/3x8FNi7Duf21xibR4of0dwJyJdsZ60gABEYg5WYnT4UCCx2FX1VK5dxJ75
         DytdH1roPDoeWXIyyq01BnW3nJIQHQ4i2GB68=
X-Received: by 2002:a17:903:24c:b0:2bd:eeb6:ff2e with SMTP id d9443c01a7336-2bdeeb70291mr34972075ad.21.1779119207390;
        Mon, 18 May 2026 08:46:47 -0700 (PDT)
X-Received: by 2002:a17:903:24c:b0:2bd:eeb6:ff2e with SMTP id d9443c01a7336-2bdeeb70291mr34971785ad.21.1779119206914;
        Mon, 18 May 2026 08:46:46 -0700 (PDT)
Received: from dhcp-10-123-156-119.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d2360e8sm163954285ad.82.2026.05.18.08.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 08:46:46 -0700 (PDT)
From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: [PATCH rdma-next v6 3/9] RDMA/bnxt_re: Update sq depth for app allocated QPs
Date: Mon, 18 May 2026 21:07:15 +0530
Message-ID: <20260518153721.183749-4-sriharsha.basavapatna@broadcom.com>
X-Mailer: git-send-email 2.51.2.636.ga99f379adf
In-Reply-To: <20260518153721.183749-1-sriharsha.basavapatna@broadcom.com>
References: <20260518153721.183749-1-sriharsha.basavapatna@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

For app allocated QPs, there's no need to reserve extra slots.
The application accounts for this while allocating the SQ.

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index c67179160654..fd1ea053d563 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1541,7 +1541,8 @@ static void bnxt_re_adjust_gsi_rq_attr(struct bnxt_re_qp *qp)
 static int bnxt_re_init_sq_attr(struct bnxt_re_qp *qp,
 				struct ib_qp_init_attr *init_attr,
 				struct bnxt_re_ucontext *uctx,
-				struct bnxt_re_qp_req *ureq)
+				struct bnxt_re_qp_req *ureq,
+				bool fixed_que_attr)
 {
 	struct bnxt_qplib_dev_attr *dev_attr;
 	struct bnxt_qplib_qp *qplqp;
@@ -1582,13 +1583,18 @@ static int bnxt_re_init_sq_attr(struct bnxt_re_qp *qp,
 			sq->max_sw_wqe = sq->max_wqe;
 
 	}
-	sq->q_full_delta = diff + 1;
-	/*
-	 * Reserving one slot for Phantom WQE. Application can
-	 * post one extra entry in this case. But allowing this to avoid
-	 * unexpected Queue full condition
-	 */
-	qplqp->sq.q_full_delta -= 1;
+	if (!fixed_que_attr) {
+		sq->q_full_delta = diff + 1;
+		/*
+		 * Reserving one slot for Phantom WQE. Application can
+		 * post one extra entry in this case. But allowing this to avoid
+		 * unexpected Queue full condition
+		 */
+		qplqp->sq.q_full_delta -= 1;
+	} else {
+		sq->q_full_delta = 0;
+	}
+
 	qplqp->sq.sg_info.pgsize = PAGE_SIZE;
 	qplqp->sq.sg_info.pgshft = PAGE_SHIFT;
 
@@ -1737,7 +1743,7 @@ static int bnxt_re_init_qp_attr(struct bnxt_re_qp *qp, struct bnxt_re_pd *pd,
 		bnxt_re_adjust_gsi_rq_attr(qp);
 
 	/* Setup SQ */
-	rc = bnxt_re_init_sq_attr(qp, init_attr, uctx, ureq);
+	rc = bnxt_re_init_sq_attr(qp, init_attr, uctx, ureq, fixed_que_attr);
 	if (rc)
 		return rc;
 	if (init_attr->qp_type == IB_QPT_GSI)
-- 
2.51.2.636.ga99f379adf

