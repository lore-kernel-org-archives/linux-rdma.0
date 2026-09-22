Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9390349CC1
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 00:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038313; cv=none; b=oQoLuMlw0D2TzwYmKd7fzuiZ3jZmPuUwvrjLtjprNVg3RfqnNHhqPmN7g2IhJND3mMGaFH8p31gNG14ZzJjdDyNLrU2IjSHfdMcK5Ymm6kvZsdE37hCA+sd9k5W4qQC8FhVmcO0a0LtNPHcxHAgVjOuZakFnEtkFNyVLHiMHIg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038313; c=relaxed/simple;
	bh=Y3s5fiaL624QJtUSpB6iv6LdFrBTDQx1qdW2g5j+o7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MGC28PUcN0uXp1xEKT8OflsBF+bwzCH9X0TKqzXpwPHg2baggywvIX5UbuRHUI/wB53zFGrrbJrJAmrysH+f39ylbpl2rqqMovjl+3m28pfD1uOVMkax9MCwJaQm/Z8m5PQT6ph58YB27tNf3EmlZj0qCq+ARHyKAqegxLsRf4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=IZtgIwzV; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IZtgIwzV"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2d560775ca2so9568225ad.1
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790038311; x=1790643111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2sGBJnIXdtd6urImKsoe3r+p0EFdjm9uxVf4TMGOKoQ=;
        b=zOnBzdtu/pewRoZdi7GonNyU5+5ccW22nunKynV2QrZ2ipRbd/lSV/a3oQRhfVbTcL
         aVLkSuixowlrhN/xNpCYymbOHOxrROkitpFSmh5FzIzi9RjbSVpMwI+hwkgiM6rI2bEj
         524hTuOmPN+Ek1Ykj6BJexR90ELTpnfOJi3f9De6t0vy33rzRp76Qm1Qvr5ufjbalydQ
         lPzH5stKoBhKBwsmAfahFWph7OmnZ87xPxV+f5UhVth5kA7XHk2ibm+bxx76Knvbbuf9
         LHZQ2f082IKyh1pJVTLo06kcsAkkT55k1nxHDdZwlK2uopvqk7WEmqEgv/NamBMrAkgL
         KqGQ==
X-Gm-Message-State: AFuF++nd/8+i9xhEPPxDCriEqZktPrbw0VnSYaXVtgVP3IEccm0zgpyh
	845LkabSx8B9h3BbZl1/e5Ojd64EeQCJNAKtbXjrhr3mCWOV8C50beSPDojOEk+rSLEKbraRu8S
	BnjhPNw5UjoK5bGIBACP+Mi19e+l6a6BWQeoUtYDDlCoZoLdxG1YjCWS8j16vV5Ll9kb1CxlvoT
	rNEXlm/bQXNrljSsqmdEHHNC7Rs6MK++l6hpVlRYWnZoE9Mo54Xiq8uF79fvUWoZ2nTGyjFZIfx
	IhcTZOjQF6yKlaXvA==
X-Gm-Gg: AYBFou0nnfWPL6eSYQgnT82jVwYTsqb2PsKKnBTqif63swCu1yW1vs31qVKAq1uvOVG
	Pspx4pZIAE1GxU+xMT4MWC3PBV2JI70S8GCvLOMrF2KMwiefbFDF7hGfWJ+g5K/nT2Qg4X83JK0
	t/Cnnl07H9xbEThVuaRQbB2VGmqYAOVXijLcB2wG9nqs7I9k4/AP1ljI0tn66xtVUnEYP/ZQYf4
	ilKowxUWsHbgQhk3d7b13hiqxcVipzdA89fnUltnU91aZcvk3RZiB2ZdWtS8lxy62rj8XjYSVOb
	uaX0kMsuqcka8g7QmeSuvDS5yLDbTY5jkB35WkwuemlT/+XAW5PI4BXgsM+uij4Cd36iNnVtrLx
	G3BjI83ynFQI/g97wgNx8KXVZ9xWlaATjF6nH/bk30Yekn3lzZxMoFXISXfg5ZEZ8IYUEiRNzrG
	fJwzppdsHzOfqS9jicY9AfEscCcUYpnHsX9T+p
X-Received: by 2002:a17:90b:4ac7:b0:39e:6c6a:4b6a with SMTP id 98e67ed59e1d1-39e6c6a5812mr10960502a91.52.1790038311077;
        Mon, 21 Sep 2026 17:51:51 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a06bc2a76asm301351a91.8.2026.09.21.17.51.50
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2026 17:51:51 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2dd188e16a2so39703635ad.2
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790038309; x=1790643109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2sGBJnIXdtd6urImKsoe3r+p0EFdjm9uxVf4TMGOKoQ=;
        b=IZtgIwzVLQsaa1xde7aUAp3dMYABvxtURtCkhBzZxnPBic9yFrIOfrQMzCVwTLMrSb
         bDRUClhHC1Pmz7+L0kahxdBnHh63SYLUJ3BDjWL2PWMBdbxXLDsKgKgVI75AjDH0fQpa
         dG8FwSqOPQDbn10GmDDX5cJz5k7LpHFCSFz1Y=
X-Received: by 2002:a17:903:298e:b0:2dd:c100:4b7d with SMTP id d9443c01a7336-2ddc1005fa7mr121357545ad.52.1790038308855;
        Mon, 21 Sep 2026 17:51:48 -0700 (PDT)
X-Received: by 2002:a17:903:298e:b0:2dd:c100:4b7d with SMTP id d9443c01a7336-2ddc1005fa7mr121357365ad.52.1790038308410;
        Mon, 21 Sep 2026 17:51:48 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e61340e56sm804218eec.30.2026.09.21.17.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 17:51:47 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v3 4/8] RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
Date: Mon, 21 Sep 2026 23:12:26 -0700
Message-Id: <20260922061230.7909-5-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260922061230.7909-1-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

wqe is declared once above the WR loop and never zeroed, so
wqe.flags holds indeterminate stack contents on the first WR and the
previous WR's stale value thereafter. This propagates straight into
the hardware-visible srqe->flags in bnxt_qplib_post_srq_recv().

Most values of the wqe struct is set except flags. So initialize
flags also.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index f81490fab0d1..22583d2d361d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2397,6 +2397,7 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
 	spin_lock_irqsave(&srq->lock, flags);
 	while (wr) {
 		/* Transcribe each ib_recv_wr to qplib_swqe */
+		wqe.flags = 0;
 		wqe.num_sge = wr->num_sge;
 		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
-- 
2.39.3

