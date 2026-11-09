Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794255217;
	b=M23iiyGsaeztdCtqGA1ghKRu4lOdAoJbLqmyyvwWJJmBwTdR7mSDkOnmlHb0DBCqG2z6
	 fLt7H7d++oBwRS25SYcuafTqpLuORdEgs7bCOxUUiYZXE8WmQOPEbUMjXk5/fmJzUsTEy
	 uwYrv3eE7hmMkRYO25yn1gx29Oqkr66Mn344W9hn2CMr3dDeCOg49klEx0V++yMf67QX/
	 yw1CBfLW7fcs1FNx7WYgTULER3PHMMHr/lPQUe0S6D59X+CAmlvW/q+aHEdoBXcfXTKAq
	 D6F2IajudG5IExchhZOZlXNPkL7diRYdsMWrCvqo4SN5Y5MrV2up/m+ZK+G5WHvIxqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794255217;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uEUhc0o+zUeX7PEeAhsV85l+vCP5t8Vwwg/hq9Oboac=;
	b=4lcfv2bve8kZHJykKMFpRhncjlJcCe6gmH/GYMhm5S29rVWXixeDoWZoybzbazFR35+Q
	 Mb2+t0+EFA4pOmSEwCDL5bUyAwjC7I1MPkfKkHsoEyiv5I/06caO2jHMDWnkDWfa9U/pR
	 L23IHqvbzzSfucVoSYuXBr758JZW2IF2AInaf8JmTmp3chxVRjPoCAmouJAJOdKhQUezh
	 ZW3K1LwTIfQHNsdqXN//ybrPRdvbcsMfrD12cYewdgds+hDz3fq7f8nUC1wiRKaKOt8Tm
	 Q8VpIKm8bo/sunXbwsxbmWi/RddiS2/viu1/NECEiBqHnIuoigygdkP6AGhqFK/WGGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Eg/ug+vY";
	arc=none smtp.remote-ip=74.125.225.130
Received: from mail-wm2-f2.google.com (mail-wm2-f2.google.com [74.125.225.130])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2FE606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 20:13:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA2FE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Eg/ug+vY
Received: by mail-wm2-f2.google.com with SMTP id 5b1f17b1804b1-4a21339d376so662675e9.1
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 12:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794255215; x=1794860015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uEUhc0o+zUeX7PEeAhsV85l+vCP5t8Vwwg/hq9Oboac=;
        b=Eg/ug+vYD0D0AgnIWS1dNzLSRWyESktrtjplWdOPjXBJgMBMUIubipYZmoDoauUwvz
         /dZGsc6EkttNs5bk+GFenZxxOQN+H7M6Wl5RBI1b9qEIRIFKL+rgwqOlDbgERFKahL/9
         G5dez3qdZ3nGiGMgrM4QY8QQkB9mWgS8nvPMEQSHZj9MsIpqX7roNjOe5JtIyM5ZzRi5
         k6oCSCEo2RxEony4RPbRrLfThs+geglFdhqQA+8d/tTr0USjaaGBoQfVwcI2I/PR4pY9
         AnrBnsqAYUJmk9xcQAiH3zwEPQEZA8ardfjSoJhiO8tSLEiTCIoBC5h8C9aIeRpP0hbF
         mYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794255215; x=1794860015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uEUhc0o+zUeX7PEeAhsV85l+vCP5t8Vwwg/hq9Oboac=;
        b=GGf1lcNgKzj75FH5qS5SpnUoKdIlmVXetQJgqxw1j4pRNabuAh73pv4R4onrNLjh4E
         +RoC/fN4RR+6LGN46TAlZ6TxeFNvOcyxIadmL7SFqXwKcM8tggy9VvMoGZv84z5Kq0u6
         +0NTnWRxepkt5TeuOYq1tDv7EJkERoX2gCZldfzq99aUbYdOxoHEDIKG8I8K5Hx6UUkO
         MQg/4n9O3umAu64/FVSlECDnrj1X6BlVU8HxCRYqROZgcMNMK4BbcuWW69WbAMP0p+q8
         3R9GZ5048pT5s1MrECOxgK2N0ySHcA/OTEdIXZQc/LkMoViTmToq8qaSTjolm9NmtWWC
         AgOA==
X-Forwarded-Encrypted: i=1; AL+hErGhQNhdAatEiftXxQBpxoksqDBLjhuipsrq3oCviXyMDQWvph315YnCU6/mUH1VEx7K4ZVB3svL9Ka2@vger.kernel.org
X-Gm-Message-State: APuU4Z/5l2zp6xAD//zBBwV7BXNOdhUd14ZxS/SFpuyFSBz7aiy/Ct+Z
	qYS1Lydb6Y2s6LQBM66tX3vEPTIixLD5wdud+MY7huHHoGTtPp3UVVBr
X-Gm-Gg: AYBFou1MrHAJtR4rqZ5g3YsHYlwziC/cnVCUC1G8em7v4xIqPQdnHDNoBx5pzAnuGBL
	RUfVbWsoLQbuXvhfSqrcM3pX//tChNZu3P4cTPijWTsdaqk9jdKU20FJ0wwV3zU6m7bvoweadDH
	BHoC/EfELttSPFsWKGUNcccuusrQawC5iRhlSbDOB3ZnxZH/gxzLLEU7xAba8wsGuOB8hIqbap3
	ADtV6jyGTzqWA25Ow9HeP7t1mPxPFjT8pybq3kXkeZJSmPszD4tadiMwYL0Jp+CiTyUb49bEl9S
	vDtdAVCCjDlXUHk7E0R0ephSxK/cvwpCWxWbHK8ZiPd4fvYWG4QcNSXn+x1enL10cI7B4f9UcxR
	kWYb+aXIPI5FsERdmAGcNuFFVNfX6S3WUsqQBYHUipHfcXwkTxv4Z11LpQ7uM25DYGH7vK/NxOU
	Ta4U69PJyWLzLYM8OcojHYbNJihgIIxSL80QAC3iNLrJV5po4EcevvFVY60yJo5HVxtYLqmBrLl
	X9sXSb9EKC4iLoOLjqO22ECDfEDoz/mEb+X+iazaHKQP/bRt+WEPrtIJh93qGQ2fcsdq9Lz5WKD
	kMC3V9nnBDl0nWNduG/oqSByPmT7kcDek3xO42V9ZaL3xA==
X-Received: by 2002:a05:600c:8b2a:b0:4a0:20b4:ba93 with SMTP id 5b1f17b1804b1-4ba02351468mr5057055e9.16.1794255214985;
        Mon, 09 Nov 2026 12:13:34 -0800 (PST)
Received: from serhat-ubuntu.home ([212.253.195.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba01fe63e6sm18441715e9.7.2026.11.09.12.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 12:13:34 -0800 (PST)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Ira Weiny <iweiny@kernel.org>,
	Doug Ledford <dledford@redhat.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] IB/rdmavt: Call check_modify_qp after validating QP attributes
Date: Mon,  9 Nov 2026 23:13:02 +0300
Message-ID: <20261109201302.14531-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
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

rvt_modify_qp() calls the driver's check_modify_qp() hook before it
validates the address handle attributes with rvt_check_ah().

hfi1_check_modify_qp() uses the user-supplied SL in ah_to_sc() to index
ibp->sl_to_sc[32]. The SL is a u8 that is bounds-checked only in
hfi1_check_ah(), which runs later so an SL >= 32 causes an possible
out-of-bounds read.

Move the check_modify_qp() call after all generic attribute checks.

Fixes: e85ec33d820e ("IB/rdmavt: add modify queue pair driver helpers")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
found by smatch:
- drivers/infiniband/hw/hfi1/verbs.c:1474 ah_to_sc() error: buffer overflow 'ibp->sl_to_sc' 32 <= 255 user_rl='0-255'
--This fix relies on the SL bounds check added by commit 0dbfaa9f2813

 drivers/infiniband/sw/rdmavt/qp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 3602b9ff2196..abd33f42c888 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1422,10 +1422,6 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				attr_mask))
 		goto inval;
 
-	if (rdi->driver_f.check_modify_qp &&
-	    rdi->driver_f.check_modify_qp(qp, attr, attr_mask, udata))
-		goto inval;
-
 	if (attr_mask & IB_QP_AV) {
 		if (opa_ah) {
 			if (rdma_ah_get_dlid(&attr->ah_attr) >=
@@ -1521,6 +1517,10 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		if (attr->max_dest_rd_atomic > rdi->dparms.max_rdma_atomic)
 			goto inval;
 
+	if (rdi->driver_f.check_modify_qp &&
+	    rdi->driver_f.check_modify_qp(qp, attr, attr_mask, udata))
+		goto inval;
+
 	switch (new_state) {
 	case IB_QPS_RESET:
 		if (qp->state != IB_QPS_RESET)
-- 
2.53.0

