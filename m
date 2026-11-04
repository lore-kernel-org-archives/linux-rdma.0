Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793803333;
	b=BhbxZbYd0mzE5RjVTBpuaCcFEIhlxlBT0tytt+LdqhfzI3j4XEGk1nBiwo7Y22H+Ziqf
	 8taUaoCFnRgA0Y7aOcDtlb+XU3gJKnOTiOOWus48h7Bxt3akWj4iDu4anystoCCBHj56K
	 YmKNMew6FNMZS7SkSdOCiWczgAfr+ezOvaNKkJ1PRdZBlFkKv3hX4ZqO075yJTl9Ipvlo
	 451qLeTDHLSb0JYGrfkg0yA5fUSJVwE70cZKFNO4EFc1ckGCvFqT3/ff5RxubKp5l8qQE
	 QiK0wfWkfN/HP1M2iT0wgTUMTUGCdWi8fjDjZlWqzqjHjdFvCxDmPwDOJilEl/RU2hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793803333;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=K34Cwj8AS79jGdo99cPDdFkLRcE0lhSys0V8hNbTUNA=;
	b=obryLJwei+aM4RLI7sIYLAkAxL3V38PeMxxB6/cq3XHh/LMpozpoREMzM0Cjc8yqbST2
	 +1UvaLPVZ1m3eK/trSoNddIYok6tbgECDU8cPgg9emk+4tSuapplyUsAmvIyVPuGQmC/C
	 YutWD8uDsFiaOs3tDGyt+blMJp2v4DtQrWBDlOVR42EIbRo0wsuoxTb6dDgsUjLd4R1x9
	 sUnFkZsr8G9n8mFA701IP9GEIXrb2YHzp+nPCjpYjjgfKVt9WMz1r6qrHy3i2luFWaKMQ
	 1d6jy+45earB8An5bFeYpeKjNX6NWcdlpBmaw4BAjLLfW1kxfiiHhiz181lZ84OgFVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=XO+tm+VQ;
	arc=none smtp.remote-ip=209.85.222.225
Received: from mail-qk1-f225.google.com (mail-qk1-f225.google.com [209.85.222.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6AC606A338
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 14:42:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE6AC606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=XO+tm+VQ
Received: by mail-qk1-f225.google.com with SMTP id af79cd13be357-93f1ca4132bso75955085a.0
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 06:42:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793803332; x=1794408132;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=K34Cwj8AS79jGdo99cPDdFkLRcE0lhSys0V8hNbTUNA=;
        b=J1X9GHo8JJKSFNkUDXNYJEMBri+v/lQLK4NV9LX3Xy6cCCP+P6EH2d29+/l3C2n8n6
         57ngk/xDODvsSTeCgj3GXY3GYt0LoQxdyoJ0M95hcAvcDDsrCRCgWUGTmMJNfn6lBPrF
         xz9acOCE27KCEUHinHJDehSH9LCVSabILyrx+OuXmue1iVL2Bm8QH8aQrjlidOVJYtVj
         +B3Z5AETnvzTni2JOvSB4GiLksvIf6tJO9z/7lB+CBku9MZNf51Wv8qdcYTX7e0lrs6+
         kyK28hW9l53kaL3lXKWEkz67AmZVqSS7QsXsN2PtQboWG5eB+vXOiJx4E1VtinSKR4Ax
         2KLg==
X-Gm-Message-State: APuU4Z+XSduYxS47ww3+GHljgZ/Kl9qEIzsIDm0bkwBjvn17Wi9948+F
	VgfEtk7ywGsknyeRY9+dY819SiauOqZX/HBPHXQNXFa77qgw2nQXqb6v6Of4pDXJi8ui35qCwZK
	xAoD2mfl3ReVNt8okFCEpAqBG02507FDrNbw4UYYnn/e1vgjxvTQFcXoPJ/BosDqlplub5KZzpJ
	/Lab518JUwB7zMShR/bi0w0UQCoKmwaD3Czg0dggY3dfOvfVOaT/EaMN+mMy4IE/OaA7IR686Q0
	IDPhSMRNbWBtjSDyg==
X-Gm-Gg: AYBFou0+kn0eC0zh9lghovm3gYueB8o4Vw7XXzsb4zk40ErPTlW4yYK55MCd8knHRdf
	82k3dQYlQKe90ynSCyQieVqZRN0zficiSqU/BEU100Ous9cTwAKzsxK5s+7TXEH2C1ZX7H+LFAr
	uU5Ge7QQ7GIWNx0f/ysy6RRKoEuluGNvVANTFLx061uo+jVDC4dxljRHfbXGHS9Tykko+blp/gO
	Yb1Wxwkp1D/D4Mt48Ov5RWl7NFcUoeDcUtwULxJaNE5xFTpBrzPJeIQkRHfYTt76ZE8Y8o1tww9
	x3eThF8T/3hqOGIr66y5k13gdjmDURalWNJ8N4HE/lTBwboWveHGPqlVRxYv98nmsvObVxiQzGQ
	PFxazq3H375BBcUnJeoihWIi6ZgqsZa76pKxmWx9w+IQ+AmFuByAeTJL0vRLTvrkQnyH2CCwv1i
	mgSlHIlFXpiZiusbJchy0IOmhgTPQC9ZaLMn5s
X-Received: by 2002:a05:620a:258f:b0:93f:3163:3e5c with SMTP id af79cd13be357-9442178e69fmr2616408385a.81.1793803331673;
        Wed, 04 Nov 2026 06:42:11 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-91e7e7b3733sm345886d6.23.2026.11.04.06.42.11
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 06:42:11 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1aa0fb7f157so1339844c88.0
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 06:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793803330; x=1794408130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=K34Cwj8AS79jGdo99cPDdFkLRcE0lhSys0V8hNbTUNA=;
        b=XO+tm+VQcHqMKlvQmWUlD0DIhNB/2lRpdpyM+V/oIiqbJ4YmtAXSi9Koi92PDO+hyV
         AcrWjjQ//TDOi407CehY2ADBfPHGlcLwoO5G5HCv8pUb9TvymXRTroadaZdNVgNL2Fkk
         8WDNRghko3qsGzqjpJM3fYHoSaGA8Myl1fPCE=
X-Received: by 2002:a05:701b:4248:20b0:191:3c:aae7 with SMTP id a92af1059eb24-1ac5c64cb0emr25533757c88.26.1793803330100;
        Wed, 04 Nov 2026 06:42:10 -0800 (PST)
X-Received: by 2002:a05:701b:4248:20b0:191:3c:aae7 with SMTP id a92af1059eb24-1ac5c64cb0emr25533721c88.26.1793803329355;
        Wed, 04 Nov 2026 06:42:09 -0800 (PST)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38d3754sm10753968eec.14.2026.11.04.06.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 06:42:08 -0800 (PST)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next] RDMA/uverbs: Zero the QP attrs in ib_uverbs_query_qp
Date: Wed,  4 Nov 2026 12:02:44 -0800
Message-Id: <20261104200244.52979-1-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
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

ib_uverbs_query_qp() allocates qp_attr and qp_init_attr without zeroing
and copies fields such as alt_ah_attr, path_mig_state and sq_draining
to userspace. Drivers are not required to set every field in their
query_qp() callback, so uninitialized kernel heap memory can leak.

Allocate both structures zeroed.

Fixes: 7ccc9a24e012 ("IB/uverbs: Support for query QP from userspace")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index aca7c6ab55cd..54da98431f40 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1668,8 +1668,8 @@ static int ib_uverbs_query_qp(struct uverbs_attr_bundle *attrs)
 	if (ret)
 		return ret;
 
-	attr = kmalloc_obj(*attr);
-	init_attr = kmalloc_obj(*init_attr);
+	attr = kzalloc_obj(*attr);
+	init_attr = kzalloc_obj(*init_attr);
 	if (!attr || !init_attr) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.39.3

