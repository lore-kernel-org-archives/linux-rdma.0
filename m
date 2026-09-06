Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623DD3BD63B
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716751; cv=none; b=mbgO4+UAzJHnpuHG5nAkWffh30EbueQDUp53Fk22U+0qDYZZ6zY3UkirPdhgauhtlV6nC3ICDisoYtZSFUNUEdl9dOIQ8uCg8unm2bmeBN4ypWJzW8mb5fsKtToZNOCxBop7I5c6AWhpYzqCb5RCadmnSc/bScSjcqkV2qc/Fhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716751; c=relaxed/simple;
	bh=QVAf3HqEbX80F2AVAtyt77Z0rnVJ6USXNXmPeJeAiKc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t8vMEeuQSPD1O61ARhtmIUNSRlv+tWjS5Dm7DT/ZQ3d0NKMcS5Noz4fQXoEebiMgP+mwk2qNozOXLSoetcn9PqdBemiDOXKlRanTFknaWXpoNIT37vEJwv5iFJwgqRH8A3UUCd7DMkZT1OugJHuG5W18lFFpsqaF2s0j77of3/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=IteFB8Db; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IteFB8Db"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cc1c3d79b9bso1974779a12.3
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716748; x=1789321548;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=l3lNQaQZ7pDde/8aPBsjOQ3i1HbLl1yvpwUEYiCGz4s=;
        b=J4urMb7gV0vArXNHMOznUQA6gdvN4uIakUsr7uyghfN+5TKdRfLCKxTj/Ruj8Cc3co
         kjhIfD7C+uO+0r0tAQht6U42rOaiaul9vS8QQsxAXq+Fg33p/hFHhflyWwCT41qqbSAj
         vabOweHPnPbs/0w+KOzQ24+474keMFVzkoKAWREDSoo7REtgorFe2DWrD6DyVnziOWFW
         UzUlCOVpAAUSLa3FeQ/juI4RJsXx1gPdlmcXsnP13lRGKPrY8MpFwxcXf2SoH5N4MOid
         Vr28uLtbKzuN3HuDq3HA1Dg/DI62fGOmlXk5Trm6byGpy5TulZMLu/3nznHjgzkbkkg7
         QIAw==
X-Gm-Message-State: AFuF++nNjEsCl4lkuqGrNkcPLLrBRyOExlQE3jtuJpL+u38WNmJwFDcb
	4H0dO/tP4xs5dDKAGBQ77XkAqMh7QIamsYAZdTMO6fuJV1HQL/Q8sbnXpk0A6dLKuRS9aMakSQX
	Sjlts9cQbs9eU8Ys63nMCeX1Cy4mnmzIMMR8hyGRyORdSJ6BS6+loGCk5wJ/tuu8oKFXPJaYQrP
	Q7sEkCslKJy9Zby5E9sJTtlpkmV/pdiE7YaGcuegNKZUKPdnTPtF7HIvJvxuUSAZVDVdg4Nqy4W
	15dTjjRhytDB5N42A==
X-Gm-Gg: AYBFou0sIfoNgVxrqwBzqv5/ofDe2PvyGPju3fRX3yEiyHBS7YrJ9ViY4d/bijaaxTh
	S5KrtGUm4isBI1E1G1eT7H2m7tezxZE38nawGD5Y8SSz9vpxWZilSLXZKisnC7gCQxFowrlvapC
	SM5QZF2b2qTa2u3QZSUFO3voA/MnTPTEKfdD2rT5J7QvQWxYzHmcySRfMHIxYKA9uN3Niz3qQcC
	zRdPK6QqCYiIfsgjTngg4zD1aj4MH4A86N2Nfo7K8vwRm7P8pQqt21Bj+ld91OVttyWo8+7+kpV
	JueN6/YVzEZrHPiC0lo6qaRgoJlqWb8SriD2h1BFcTzOCwbNHHNFbdsRDMWm+2b8YtVD/RX5hpg
	y1HCXgVzIaMeIDWMCXqxaGvlE3yZF8oBmHn9nlMLsPKkwolFrUug9idzgJvDS2ItOpI1H1Eia6Z
	4o0etsvwSPFh8l4jln67OzNZDMuM8xlNpnBwD2z9A=
X-Received: by 2002:a17:90b:5705:b0:36d:9e0b:3801 with SMTP id 98e67ed59e1d1-39b2617ed3bmr31140460a91.8.1788716748294;
        Sun, 06 Sep 2026 10:45:48 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b551b44a8sm1822422a91.7.2026.09.06.10.45.47
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Sep 2026 10:45:48 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d02df2bf09so23711365ad.0
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788716746; x=1789321546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=l3lNQaQZ7pDde/8aPBsjOQ3i1HbLl1yvpwUEYiCGz4s=;
        b=IteFB8DbqJoEvZTb46jelHVU8mX+iLVFMITUC1PIvYWFJ3CIEXOIIHp3vt2Kl+wjbL
         OSSiqjpY25BoEvsFYy7ohdAfGaYnDYtaLrcuIThPXR8ParCHRKLCEVN80zSTpTsRCG25
         lqirDGlsJ4hc1uxf1dNgCgWx4YEZphwS71ijM=
X-Received: by 2002:a17:902:cf42:b0:2cf:afe8:b722 with SMTP id d9443c01a7336-2db125c3108mr299763535ad.11.1788716746262;
        Sun, 06 Sep 2026 10:45:46 -0700 (PDT)
X-Received: by 2002:a17:902:cf42:b0:2cf:afe8:b722 with SMTP id d9443c01a7336-2db125c3108mr299763295ad.11.1788716745794;
        Sun, 06 Sep 2026 10:45:45 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3356dc5c04dsm11075108eec.8.2026.09.06.10.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 10:45:45 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 0/8] RDMA/bnxt_re: Fix input validation and lifetime bugs
Date: Sun,  6 Sep 2026 16:06:52 -0700
Message-Id: <20260906230700.12233-1-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series fixes some of the bugs found while auditing bnxt_re's handling
of user-supplied values and object/device lifetimes.

Please review and apply the series.

Thanks,
Selvin Xavier

Selvin Xavier (8):
  RDMA/bnxt_re: Reject executable mappings of the DBR and toggle pages
  RDMA/bnxt_re: Detect wrong sge_len passed for inline
  RDMA/bnxt_re: Validate num_sge in bnxt_re_post_srq_recv()
  RDMA/bnxt_re: Validate SRQ max_sge at create time
  RDMA/bnxt_re: Fix rdev lifetime races in  suspend/resume/shutdown
  RDMA/bnxt_re: Fix the PD and DPI table size
  RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
  RDMA/bnxt_re: Check is_in_used before trusting RCFW completion

 drivers/infiniband/hw/bnxt_re/hw_counters.c |  6 ++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.c    | 28 ++++++++++++++----
 drivers/infiniband/hw/bnxt_re/main.c        | 32 ++++++++++++++++-----
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c  | 12 +++++---
 drivers/infiniband/hw/bnxt_re/qplib_res.c   |  9 +++---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c    |  2 +-
 6 files changed, 65 insertions(+), 24 deletions(-)

-- 
2.39.3

