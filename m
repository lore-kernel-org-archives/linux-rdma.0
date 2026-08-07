Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD263A382B
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 19:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044589; cv=none; b=JqZwRcv9iOFv4XSEC4rnqUELJUhznS4kyBg0kYh5+PodolqJ6rImntENU5o0WqPLb4rsrkuEVqIjMAITKbV7svfaa5X6svrBtLBd6694badXgddfyolSqFOSPzsZXutCBeEMGMiD2X1OslzI7LhN3G7djT2T4G11SRq8jYO5khM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044589; c=relaxed/simple;
	bh=PzXxKrnY0IUYEVQ/qgw9l+roN/WgFaPB1sCYbymB3ao=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xzm8s1Wxhhmz9GXkn/wvQacKRwVbVOUVBRxTE8UjmrnZerO/yP43x4j7pYh05CDUvChoszPaUSMqzRKzqMCZasYWHJ+oDr3GpDpX4FM6J6fxSyRTCDl+StQhdnkGBeqoU9oeriPo8YqjVs/qdpnsFfxguH3epfjgGMdhRXuQao8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=VSrgv3he; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VSrgv3he"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-84a4d8fd6ecso3169694b3a.1
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 12:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786044587; x=1786649387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FZc3fPv429QC7MwRe//s7CLGTEIAm+SrduOJa8Oq84g=;
        b=cO7KdHrthlWCakXLL/yOzuSyeWYaGje6NThdia+49e1AGjRQ90SJ7W/1oc5gEwT6q5
         //C/eZIplEpTqX6pghq72TXVIEn0tvShXYXl2xloX4FEJoieAk91BhqSaAIvlgtzekuf
         vAecgO+clp4sOZYkr77RKk8y2GZ0slM4mLeXm+zT1Fqx6H4EQX0aJXJJqfBcq2V7sC/8
         nt3kpaHwfXZArvyGCwZ7nPSIguG/cXb2KtKvQGkMyRh0yF0RUI7tXNkGS25c4/IWl5ae
         QcQ+Fu1Bz/CKzm/xrm+8HiEvjQvH5weMq3HuGWkrg7ajpdcYI2LKSCkDjIrvfT5eimLa
         N4hA==
X-Gm-Message-State: AOJu0YzmBzqctcxsViwxAXNt1frxLyNGTX5A3GXFwCUM+yj+M5tMqH8g
	wCJS2Q2XJd8YX9u+CP/HnU4dnGplAQGOjA5sBIsmCINzsUmnIbs+WKembwpPlCggkSMIO/qlQJT
	dwJ0MIPD5J+4YS58SW+ERKU9iCXh0St8RoLOMbxGyfToGksXjNsly/3t5mfs0pIo1QjDn5CMeHI
	uPM4pfCng9xTvDoqexzMZtzqZwNyUbmBpM9dVqI5FzOQSIbNUGlt9G+rQRQPyAxA5zZWXdjvtEf
	vuZtZi7rq17HIBq2w==
X-Gm-Gg: AR+sD11tybXLxui9lbGg9/Nb7T4NdS5876JDt5M0deDzBcUsTYsy7RjYbv065OqrrUR
	fCshhFHg7dk34dtYLVIx9zRs27qHD6HLEXeKSMAL8j9EPeKBSt6JkR79ZA3zVO1G/uhglOrl9NF
	NglFpcSfZpwgrqAskoeSPpjlEpKkUpQEnQTiW6Vt1TKkvAAEIqCrjlM+cJSUZrumHEeH/GW91gr
	YCK7keCiHcn0lex5lq83bUzxl/WNNVL9USVCCqBbtqunsQtjFm70+Y7pKp9svNc/7mRb8gQCXxl
	2sKimidEY7PQLf9BZppZWTwW4oVIfMBOYX4fybDneI8eBzEvuzXEH/pL7gu6RGMthFlOLixHALR
	/mB6habxfjvz3OQQH9iUbrfiz7KTMXEKn0wZ7TO3QNSM6I9NSOOJ7p4krqQIj5zbI8fWexuuiLs
	/lE1RuF/xMGVmkBzoDga8WfkBKF+isOSyaiw==
X-Received: by 2002:a05:6a00:983:b0:842:3a3b:d6e7 with SMTP id d2e1a72fcca58-84f2e052333mr17311383b3a.23.1786044587227;
        Thu, 06 Aug 2026 12:29:47 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-0.dlp.protect.broadcom.com. [144.49.247.0])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cbe70913b6dsm1607658a12.8.2026.08.06.12.29.46
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Aug 2026 12:29:47 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb835525b13so2964796a12.1
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 12:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786044585; x=1786649385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FZc3fPv429QC7MwRe//s7CLGTEIAm+SrduOJa8Oq84g=;
        b=VSrgv3he7yyVoI4B/0wM9bBzhMKaHr+z1DBExgng9BBZcadxc109sBsYz1pD+uKlAK
         KpQGXSjeqJZTfO1Bak9xBsS+7md2w9fhkybgq0jlHccaQu11u2nixlqt26jlc51ClFjA
         IU940nN1KxQJ7lZFU7CDDO+o13VjK/J23MvNw=
X-Received: by 2002:a05:6a20:9392:b0:3c3:a140:9380 with SMTP id adf61e73a8af0-3cb85e469d1mr18895828637.16.1786044585458;
        Thu, 06 Aug 2026 12:29:45 -0700 (PDT)
X-Received: by 2002:a05:6a20:9392:b0:3c3:a140:9380 with SMTP id adf61e73a8af0-3cb85e469d1mr18895785637.16.1786044584982;
        Thu, 06 Aug 2026 12:29:44 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158644a195sm28484575eec.13.2026.08.06.12.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 12:29:44 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	saravanan.vajravel@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next 0/4] DMA/bnxt_re: Add support for larger page sizes for queue memory
Date: Thu,  6 Aug 2026 17:51:34 -0700
Message-Id: <20260807005138.771669-1-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series adds support for using page sizes larger than 4K for the
CQ and QP queue memory. Removes some of the untested page sizes reported
for MR and add support for few page sizes for QP/CQ memories.

Please review and apply

Thanks,
Selvin Xavier


Selvin Xavier (4):
  RDMA/bnxt_re: Update the page sizes supported for MR
  RDMA/bnxt_re: Prepare infrastructure for larger pages for Queue memory
  RDMA/bnxt_re: Add support for larger PBL pages for CQ
  RDMA/bnxt_re: Add support for larger PBL pages for QP

 drivers/infiniband/hw/bnxt_re/bnxt_re.h   |  1 -
 drivers/infiniband/hw/bnxt_re/ib_verbs.c  | 54 ++++++++++++++++++++---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c  | 30 ++++++++++---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 21 +++++++++
 drivers/infiniband/hw/bnxt_re/qplib_res.h | 35 ++++++++++++++-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c  |  5 +++
 drivers/infiniband/hw/bnxt_re/qplib_sp.h  |  3 ++
 drivers/infiniband/hw/bnxt_re/roce_hsi.h  | 42 ++++++++++++++++--
 8 files changed, 171 insertions(+), 20 deletions(-)

-- 
2.39.3

