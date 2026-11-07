Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.111.35.241
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794044035;
	b=q/NMI65QjpkHtR98z1Zt33e4cFOm06NO39c0epIWCdCucrwPeDDX8PfIQ1v5ERK5I9ZB
	 h5g56sHM2vU0DuFwhEt8qXe07ZPF/zeA1hLWanS7NV2RENs608XwDR4z4VxefvSaTPgmh
	 lHg+Skaea0uDH+9YlH7VLcaWB2lDBYYy1IrbXsHdU/HtmTwhe2l+AfrFZbUxtvIAJMamT
	 AmpKwTlMzJTKkrS1GCy1A7L4VH5k0Ll8lfM4FGVgIlTrNmuRUej8u97RlCpUc75KpkfBK
	 kL+VcCtMrzNNcNjGavQ2SFAdJZhE4OZwkvnbSXR58yQToo9PMd4da7SmUSSpOxvxT4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794044035;
	h=DMARC-Filter:X-Originating-IP:Received:DKIM-Signature:X-Session-ID:
	 X-Originating-IP:X-Works-Send-Opt:X-Works-Smtp-Source:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=q/hSD6kpvWyJ8ZE/GhfkG18vM384HWYsfLoUPdHyOSU=;
	b=Az8AsYu30FSkCLKn+CfoqdUthDn34aM7EvQVDvMxJv4qb33oUqM3F1QYn/DA6g68X0Gh
	 wPEYeUmcGPY+uVyBNsgOmXM0mqt39vnW172KeNW8/P30z9tyzutaEH2/b6luz5LnZSfgf
	 54tBLFa7AZCh2R8Zw0KcwKFfmQHj5cbyhpna2afmgUjs0mD4dN0yzNgF/k2E3FxTwBpBX
	 pI5zr3pEeaypvr15iDCKPBjlBUIfNYaheAJSn/0FBT+8+KJmpiKIhirsTgqI2fUI1qvfs
	 hKmtGun4/WMRLM4LDPVpb0muPfoucsycUfb5qc1al8t5aneOsOIYNP4XD6sUmZDfYaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=naver.com;
	spf=pass smtp.mailfrom=naver.com;
	dkim=pass header.d=naver.com header.i=@naver.com header.a=rsa-sha256 header.s=s20171208 header.b=gCMVVh4Z;
	arc=none smtp.remote-ip=114.111.35.241
Received: from cvsmtppost32.nm.naver.com (cvsmtppost32.nm.naver.com [114.111.35.241])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DA3606A326
	for <linux-rdma@vger.kernel.org>; Sat,  7 Nov 2026 09:33:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4DA3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=naver.com header.i=@naver.com header.a=rsa-sha256 header.s=s20171208 header.b=gCMVVh4Z
Received: from nv1m-hmac-real-33 ([10.174.201.121])
  by cvsmtppost32.nm.naver.com with ESMTP id iTk7alABTXmOMMw7kV7EAA
  for <linux-rdma@vger.kernel.org>;
  Sat, 07 Nov 2026 09:33:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1794044026; bh=NjE90ula/xBWummYGYpT9JaUR8EqcRxgiMLz7xGCSa4=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=gCMVVh4ZcHHtdatLjYJqQWJUUN9FKJc6YWwbFcHsypbjVxNJTRDqmrxbXWGuJpsFU
	 RAzO/yelRBeAo+2m665Tw47c+jNMciNKga5zeKGSU18cEtGNbeJwBbmilN+jGS7a2h
	 Ch6eQGUPsR9bPiEoFQS9OyH/r+xmQ6O1K20nnuNvPUk5IakEQplwNaF+mZ915HdxhZ
	 63jnJF77jLc8R5iQ/heQhfGxnOi1LqQgDTrocXv2uR9TdbBqynd4o3/whKLvbDb5yd
	 UiNi8YSai9wiHqAAS1TwNk2Mf5cgWXz3uo94tuRuJGZhAw64rsf0zUFBOV+5STPwUT
	 Z6io0sNFqHbig==
X-Session-ID: L22dwugbQQyoXiM0o518-Q
X-Works-Send-Opt: OlewpzGdjHmdKHFOMr39Ko3YKHmqjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: rZYwKAtlFqJZ+HmrKoMw+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp009.nm.naver.com with ESMTP id L22dwugbQQyoXiM0o518-Q
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Sat, 07 Nov 2026 09:33:46 -0000
From: Sung Byeongchan <tjdqudcks0424@naver.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Subject: [PATCH] RDMA/iwcm: restrict MAPINFO to administrators
Date: Sat,  7 Nov 2026 18:33:38 +0900
Message-ID: <20261107093338.618394-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
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


RDMA_NL_IWPM_MAPINFO announces the userspace iWARP port mapper and asks
the kernel to send its live mapping table. Its callback registration does
not request an administrative permission check, so an ordinary local
NETLINK_RDMA sender can use the public mapper name and ABI version to
replace the global daemon portid.

With a production SIW mapping present, an unprivileged claimant received
the complete local and mapped sockaddr records in three of three fresh
KASAN boots. A second independent unprivileged socket could repeat the
claim. Wrong-name and old-version controls were rejected.

Set RDMA_NL_ADMIN_PERM on only the MAPINFO callback. The common RDMA
netlink receiver then requires CAP_NET_ADMIN before the callback changes
the daemon identity or serializes the mapping table.

The fixed kernel rejected the valid unprivileged request with -EPERM and
zero records in three of three matched boots. Legitimate root mapper
registration, live SIW mapping, daemon recovery, mapping removal and
post-remove cleanup all passed their baseline and fixed controls.

The demonstrated impact is disclosure of local iWARP endpoint metadata
and displacement of the trusted mapper identity. Uninitialized memory,
controlled read or write, RCE and LPE were not demonstrated.

Fixes: b493d91d333e ("iwcm: common code for port mapper")
Assisted-by: OpenAI Codex

Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
---
 drivers/infiniband/core/iwcm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 4b05867dad895..8a3b5aa2dc5f7 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -86,7 +86,10 @@ static struct rdma_nl_cbs iwcm_nl_cb_table[RDMA_NL_IWPM_NUM_OPS] = {
 	[RDMA_NL_IWPM_QUERY_MAPPING] = {.dump = iwpm_add_and_query_mapping_cb},
 	[RDMA_NL_IWPM_REMOTE_INFO] = {.dump = iwpm_remote_info_cb},
 	[RDMA_NL_IWPM_HANDLE_ERR] = {.dump = iwpm_mapping_error_cb},
-	[RDMA_NL_IWPM_MAPINFO] = {.dump = iwpm_mapping_info_cb},
+	[RDMA_NL_IWPM_MAPINFO] = {
+		.dump = iwpm_mapping_info_cb,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
 	[RDMA_NL_IWPM_MAPINFO_NUM] = {.dump = iwpm_ack_mapping_info_cb},
 	[RDMA_NL_IWPM_HELLO] = {.dump = iwpm_hello_cb}
 };

base-commit: d48723711bae9b8cdc56719c448ba42fef28cbee
-- 
2.43.0
