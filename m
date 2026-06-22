Received: from mail-vs1-f99.google.com (mail-vs1-f99.google.com [209.85.217.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FDC33ADB3
	for <linux-rdma@vger.kernel.org>; Mon, 22 Jun 2026 04:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782103387; cv=none; b=hB8C9OZ/1kbj9JrkhE2bhVXofBfv6Dx4ZqwQ0U3pMECOQWax/i5at2kMgwUbtSA7uynk2jYwmtfMLBPonudBWgJ+Dw9Dfo2LU+OPMypsIh3OdYOe0Gr9MTxuvYeatFBY6XF24GopJ3yMPXXwp13tPrX2alud/mWjpG+yiTjs1MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782103387; c=relaxed/simple;
	bh=NOmEkPAabqEl/hTtKevDI8otWBSzBWN5lOLEzzBB9l8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kRWbgLf7c6Ji4YlDeUSpyl6Xzq2V1AmATfSE7mMZwEUZQ3mweX/9hgDR23hST3bYkB8FKo8Vm4mvEBdESSFnEpKoYot9Au+Rpd+I8Hmp5gMHFHSG4UO+EtfmbHNkdN9vuNfb2k1j5SG/wrL2dzBQUNAWzyvNIgS0qIODDV6kuNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=G3mWnW8w; arc=none smtp.client-ip=209.85.217.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="G3mWnW8w"
Received: by mail-vs1-f99.google.com with SMTP id ada2fe7eead31-7296b2650c6so2499232137.0
        for <linux-rdma@vger.kernel.org>; Sun, 21 Jun 2026 21:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782103385; x=1782708185;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JFvRW+L4BXTea2SQK7k9k1HRWpYHuoScrbvaZ+lFrVk=;
        b=ELmLfVhw7lf6XvLmNsRDi04PI/jfHFhk9I6/okXBfi234JOblJVwJy9xiDuLxkiKPT
         5St+wEG+UYjGE5Q4nywyM1b1GhZ2jb0B4zLXkjZ7Ymv7dcHs0wlVJuIqO/D3eR4sqsF9
         oX3QY6ItKB3tLG8POTP+8TFJfWaJC64Q50K0c5Nhcw1YYye8hwrxTMnyRlGnLYUcNaQR
         bLWFfTikKuviZuvstej1ev2WnriBK/FMnMH+XPMI5FQJTmsLBsFjU+U9ht1Qx9GZw+8q
         NqRtlxkRCUOdcuj8qZxcoxO84Xeg39yS+xsCRk6rP+OmHNFtrE0OjbQS8IeOxlDXRZpq
         vaHg==
X-Gm-Message-State: AOJu0YxMpQaMr2XYiGjGfFEG9oOawE1sk/+Nkn/irylwmxB80qIWXo9Y
	KSLJQX0a4xnQPmDoAN0gTlzgmgnUtektIm60gmPdkFGLxS8kf+h3XvHoOO75FRKLuMJvlYFhjrI
	tHUODNcpBANC9xb2LFTH4roMZYz2fPVI1bxhuX0U+AZwDZmkzR856yF0a9Zr9iT+dZ6hhkRePRk
	YefINhxXEVKZkTGshF87DL3uKISPsgrr1r1EZOs+XCjuAjNTGI1fkvIWnrpRh6VTzoKfCr8jVpv
	gvmBlrbSgxlBQ2+4g==
X-Gm-Gg: AfdE7cnOqahzBpKWK9Da5eKKFV5s7jcUQoSsZ7eQVxYvpXgA7NbfH5SpXqjM1IAXrO2
	FVK89l8J2QPfbdVSfX6XeRnXPAsSqxl99LAPB1UVJmlf4Nl0gFOFNX0oQXIZZktMAd/OdgFQto9
	vciy873tn0Yf/OZJyj4HY5tre3hAtrQPDB9mTNn7XEDB5rYwUQMRF0+oAviISyStsTToS2zbb7g
	PmMVohvPQDkWrh/cCzlz8wk1/DbgOBI9IuJyazwCemObrD7MToXdhmLz7bdpTVfLX2iOV1BfhRi
	DMw4DJBgjpJB8QFFu/u4EghLutJvPfEB2iLZVxlT8r+RizQPH4viBRe32nb8MH+1WecDVtW72Be
	PYyTiJ6sXwIif1SPI0JYLKvhVICrRiSGbLhvAL/86CCJH51gpGESbQAUdO1Wk7HgSwLztwRc9zs
	pWaB0H/X/dGYqbhxDLxqQLRNd7tLRuLszL1EVI5U9rOuOgdeQv5Q==
X-Received: by 2002:a05:6102:e0e:b0:720:7dd1:5c8c with SMTP id ada2fe7eead31-72a1d205a20mr7288148137.6.1782103384869;
        Sun, 21 Jun 2026 21:43:04 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-72ba1d809c4sm539989137.7.2026.06.21.21.43.04
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jun 2026 21:43:04 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2c6a20348ceso46881655ad.1
        for <linux-rdma@vger.kernel.org>; Sun, 21 Jun 2026 21:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1782103384; x=1782708184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JFvRW+L4BXTea2SQK7k9k1HRWpYHuoScrbvaZ+lFrVk=;
        b=G3mWnW8w3WDfyatlH1xqkN4LOM3ECewTt3SL1n8fR3MnJMR00z8kAxTo3qK9s1PV6k
         xHge6DbLF6eRhPVQebZlKSCjQjd/P38uTCrz6L82sDr66XKmyMkDJ3+S4GQatA2ZKayF
         Wba1AILsV+j1yqRVVTPbN/CFcWgFUnX/4dNNs=
X-Received: by 2002:a17:902:ccc7:b0:2b4:59bf:5728 with SMTP id d9443c01a7336-2c718f862e4mr126921865ad.25.1782103383854;
        Sun, 21 Jun 2026 21:43:03 -0700 (PDT)
X-Received: by 2002:a17:902:ccc7:b0:2b4:59bf:5728 with SMTP id d9443c01a7336-2c718f862e4mr126921605ad.25.1782103383385;
        Sun, 21 Jun 2026 21:43:03 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7439f901bsm60607475ad.44.2026.06.21.21.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 21:43:02 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	sriharsha.basavapatna@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next 0/2] RDMA/bnxt_re: Update the toggle page handling of CQ and SRQ
Date: Mon, 22 Jun 2026 03:05:26 -0700
Message-Id: <20260622100528.132463-1-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Based on the suggestion from Jason (
https://patchwork.kernel.org/project/linux-rdma/patch/20260615224751.232802-5-selvin.xavier@broadcom.com/)
, adding the uverb object to retrieve the CQ an SRQ structures while getting the
toggle mem. To work with older rdma-core, retain the existing code with
modification.

The rdma-core pull request is here: https://github.com/linux-rdma/rdma-core/pull/1761

Please review and apply the series.

Thanks,
Selvin Xavier

Selvin Xavier (2):
  RDMA/bnxt_re: Replace per-device hash tables with per-context XArray
  RDMA/bnxt_re: Add uverbs object handle path for CQ/SRQ toggle page

 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |   6 --
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |  58 ++++++++---
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |   5 +-
 drivers/infiniband/hw/bnxt_re/main.c     |   5 -
 drivers/infiniband/hw/bnxt_re/uapi.c     | 124 +++++++++++------------
 include/uapi/rdma/bnxt_re-abi.h          |   4 +
 6 files changed, 112 insertions(+), 90 deletions(-)

-- 
2.39.3

