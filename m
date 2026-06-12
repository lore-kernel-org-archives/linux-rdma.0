Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50823A8723
	for <linux-rdma@vger.kernel.org>; Fri, 12 Jun 2026 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781267208; cv=none; b=ejCeuUoEfFicnguPeTkouu98MGnM4ULgBt5lZLS3/pbQwN+diK3xkxpVnBSflbE2annQr7UMlwfo2PMNG+O0qbrMVnnwBpdwM2XnHgoEY5noFkeq4nJhnU+B5XRs39H2vDDHK8UJh55x0tEuyJAjalM71CrK+gUyI9xlOU5sSJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781267208; c=relaxed/simple;
	bh=c9+uibl38zu47Fzs8FaOr1SX/4oAzbEJlxCfnlYFDMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NlHWdSjXIrx/wXVX3uML/ByfySYsU1y4zy9zKNIBdk2yuTBm0DpPSOo84iCSR047483EZ9rejnwGtcLnxmNJUFTV7w7d/SH5ZM52825fL9Ug/pqVWnXSn4UVPQEYilMgBgKOfQhf3MTPyCoGs7V/z58NZiiF2sJ/gjE76XAZo80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=VDIBa2Y5; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=pfAFOWl4; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="VDIBa2Y5";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="pfAFOWl4"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4gcJfQ4C4tz9t5H;
	Fri, 12 Jun 2026 14:26:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1781267198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lL6EfkpFkYCqwvOdw8ZwNQUZozI+SoVsFwTExAbcEbU=;
	b=VDIBa2Y5p/E5V9eJuaptjbbas8H7eVv83zpeRSyMenP2bSjN9eP5DCJ1QrHbqFLfbNtufU
	LLK9SFjKDb/RAirntLXeYcpxexPVDx6kPWU8g3cHpLsGseVBPzGM8uDUdJsbzqOgVpeXQg
	JErjZwhIWUCJD9rYWMv9R76PURBRnMlj7nTvClAEaC9tNlFi9fN8tPURuQzgYwu1pixwWJ
	Bj2WtT+nj6ZIqIB2Eozrc2iLl3QOWyfTNU0fCEUKEcM3F/wMEEYiaSoAD+E2gtQjdtjPl0
	IGyfwgljwqUfqWhJ2k6Asdg99QY87u27VfhuF5YOftdyH44y/WOteWgZ0PAGrA==
Authentication-Results: outgoing_mbo_mout;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=pfAFOWl4;
	spf=pass (outgoing_mbo_mout: domain of manuelebner@mailbox.org designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1781267197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lL6EfkpFkYCqwvOdw8ZwNQUZozI+SoVsFwTExAbcEbU=;
	b=pfAFOWl4xH06z1Z+I0P0xPPmbPEpP0JxYDPysfpdl6dDyexd67M11es/Uyh91r+416EWNm
	GFM8xZZWBw3fbZKPg00SIDarxKnDfpb0vpiOnB6wSe5R4wwpejwWIRYQxmh/OAV8SEwDzc
	P0dUXmtGyXiYHmDkwrfQa5lxwCPjo5i1TULmbUC6H9VGJhu7r6pfA2UO+rvkNzqxkj8huq
	5JydlPyuXhwSvjc2Jk2Uxp38Oletllnim2loDNJJJvjLTatfmvA4OxGlWBtLa5FRSRL8Yx
	ti/EdkA6xN1P5QyTP1eliimfckyYKPRmzWDlgSQilGbC/oa8Smp4sqJExjjy6w==
To: Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org
Cc: Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH] ABI: sysfs-class-infiniband: minor cleanup
Date: Fri, 12 Jun 2026 14:26:12 +0200
Message-ID: <20260612122611.183127-2-manuelebner@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: wzduj7dtdi6gz39g1wsa5nwpk3fucucc
X-MBO-RS-ID: 6952ea2f14c9caa9033
X-Rspamd-Queue-Id: 4gcJfQ4C4tz9t5H

Close parenthesis with ')'.
Add '-': 64-bit counter.

Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
---
 Documentation/ABI/stable/sysfs-class-infiniband | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-infiniband b/Documentation/ABI/stable/sysfs-class-infiniband
index 694f23a03a28..7ba116103429 100644
--- a/Documentation/ABI/stable/sysfs-class-infiniband
+++ b/Documentation/ABI/stable/sysfs-class-infiniband
@@ -148,17 +148,17 @@ Description:
 		**Data info**:
 
 		port_xmit_data: (RO) Total number of data octets, divided by 4
-		(lanes), transmitted on all VLs. This is 64 bit counter
+		(lanes), transmitted on all VLs. This is a 64-bit counter
 
 		port_rcv_data: (RO) Total number of data octets, divided by 4
-		(lanes), received on all VLs. This is 64 bit counter.
+		(lanes), received on all VLs. This is a 64-bit counter.
 
 		port_xmit_packets: (RO) Total number of packets transmitted on
 		all VLs from this port. This may include packets with errors.
-		This is 64 bit counter.
+		This is a 64-bit counter.
 
 		port_rcv_packets: (RO) Total number of packets (this may include
-		packets containing Errors. This is 64 bit counter.
+		packets containing Errors). This is a 64-bit counter.
 
 		link_downed: (RO) Total number of times the Port Training state
 		machine has failed the link error recovery process and downed
-- 
2.54.0

