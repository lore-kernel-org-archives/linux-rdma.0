Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2C343A815
	for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 20:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784147071; cv=none; b=Gt47oNQ4vN/Iz9PropK28D22NPE1GcnLhZsRSmIumzw1VIhQVU7+G+oNH90uR4Ec4gcXc1T4nXdEQbb4eGX3I+jjujg6vQtJAOdtZrVy/SXD6ldOzx8005CN1a11BzYTyHlpVy7u7cXBYctkssHoU4zxmRQAtUOL/gr51Ngds0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784147071; c=relaxed/simple;
	bh=qXxZygeDGdb3Cs9hUiCNFUaBdU7ZPIfK3IGwww4NFHQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=obSMpJnMb46prDWEYo33quKMMrtxlrRRvztFKNb0leNrTXaLVeHY/Qn0kaEt9TOc90gNlyIRO6+loS37WJBU66RmsUwTbYD3StWKr7VGjTIjnanRwbIA1LGNpu6cAW2sNC9YNmfzKkq8Iq1QzSTZWZKJ0b1txgkyCshvE6yIYzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=MQtn3OOy; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="MQtn3OOy"
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66FHX2sb690345
	for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 13:24:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=SosxtXEwaaPBi9Pj+I
	05e19Wzb4ZSsibxfiyJFLTTpg=; b=MQtn3OOyL6+CkLkdzcRMOvjnVRP61i1iFh
	bHNMWVGeycjLbSnm4u0vbXWRGIdNwESOzoIaayChii9gwagQLD3l0A09AT25gnMw
	YBHZdq07k98DQFkYdSM6DRcFpFkwAfR46WPMIyWF396BDYus+XAilIszoryDqIqU
	4eMXTc0tBdKzJY+BGZ82NlSP2wwkkv0lI4jSZAThlyVJXPomqoe/mHwo0VGAz8gW
	llEcw8xNEkeBvfueQowfqGdjgTVD4lstlz2FOCDB8TSrSuVFA3+9A8uld60gapqD
	RjGLUb2Z9+W7Y90mdO6aBHC2V0m+DpK8eYf1teeNE9Gfp0etqcmA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fduqv7srk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 13:24:28 -0700 (PDT)
Received: from twshared19691.04.snb1.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Wed, 15 Jul 2026 20:24:28 +0000
Received: by devbig259.ftw1.facebook.com (Postfix, from userid 664516)
	id 8CC1A423A594F; Wed, 15 Jul 2026 13:24:10 -0700 (PDT)
From: Zhiping Zhang <zhipingz@meta.com>
To: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: Christian Konig <christian.koenig@amd.com>,
        Alex Williamson
	<alex@shazbot.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zhiping Zhang <zhipingz@meta.com>
Subject: [PATCH v2] PCI/TPH: fold reserved completer encoding in get_rp_completer_type()
Date: Wed, 15 Jul 2026 13:24:00 -0700
Message-ID: <20260715202409.3767494-1-zhipingz@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=LJFWhpW9 c=1 sm=1 tr=0 ts=6a57ec7c cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=4h92JMTCafKA-fb_NiOh:22 a=VabnemYjAAAA:8 a=10P_XigQlVKDyM0i7pYA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: embqAMgSWPWPR3OrulavmAfawi492Rgh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDIwMiBTYWx0ZWRfX+1utyJlhun05
 VUdHauCF3u2vyd0AsghnYjcTCfots1qo6Nm75op7zk4lYl+lN5nR5IsPWFyxFOI/IphnkmdXcmS
 spmMyB90sixOKTopbR6OwAu9yUE8aULXQfdynk+KEzYIjgn2LL2v1C8xOM+EE7TX6QxUs5zQIDY
 SSQRmzcvlZTV6vA/Hm2SOvNqAl+PE5dxA4sloBfgV5Mo3y0OSg9G5vPgg8W67uX+b7wLMhaFsjI
 2kT7QyuuryWHrPd1KRHUyMEDVpLlwc3Ii8CNf07ndTEEQ1kEP73BL2nRsQQH+5E25aH/xDm+IA3
 HJdUZX49MLFq3QZxaezpacQv+qT25HJ0tHzEOe8VgT1htWNcdun3iAnFdwwvco8Vmkg+sO6E0/k
 oVSGe70q+kI/rIibBzQC+RHIuaulGFthA8g1FD+dAe21XQK89n9mNxN8s8XbubjiU8UH50nMCuW
 4i1Lq8XyOxuiVVOCjRQ==
X-Proofpoint-ORIG-GUID: embqAMgSWPWPR3OrulavmAfawi492Rgh
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDIwMiBTYWx0ZWRfX5ow7Zep7hnPL
 wxxAf7ZlGZrpUAiNQiDVfMAMBKbn98KOZPghwql8RlWT77TT/2S8IGEm4zWbpdoAAeZ5uihzNE2
 TY0ozHneWS6DhhlV6iakNpsksfXFD/s=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_04,2026-07-15_02,2025-10-01_01

get_rp_completer_type() returns the Root Port's "TPH Completer
Supported" field (bits 13:12 of Device Capabilities 2) verbatim. The
0b10 encoding is reserved, but pcie_enable_tph() feeds the raw value
into the requester type:

	pdev->tph_req_type =3D min(pdev->tph_req_type, rp_req_type);

and later writes tph_req_type to the TPH Requester Enable field, which
only defines 0b00 (disable), 0b01 (TPH only) and 0b11 (extended TPH).
If a Root Port ever presents the reserved 0b10, that value could be
written back to hardware, risking undefined behavior.

Fold the reserved encoding into "not supported" so only the three
defined values can propagate.

Fixes: f69767a1ada3 ("PCI: Add TLP Processing Hints (TPH) support")
Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
---
 drivers/pci/tph.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
index 655ffd60e62f..ebe1aa5ba5eb 100644
--- a/drivers/pci/tph.c
+++ b/drivers/pci/tph.c
@@ -196,6 +196,21 @@ u16 pcie_tph_get_st_table_size(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pcie_tph_get_st_table_size);
=20
+/*
+ * Fold the reserved 0b10 "TPH Completer Supported" encoding into
+ * "not supported" so only the three defined values propagate.
+ */
+static u8 tph_completer_type_fold(u8 comp)
+{
+	switch (comp) {
+	case PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY:
+	case PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH:
+		return comp;
+	default:
+		return PCI_EXP_DEVCAP2_TPH_COMP_NONE;
+	}
+}
+
 /* Return device's Root Port completer capability */
 static u8 get_rp_completer_type(struct pci_dev *pdev)
 {
@@ -211,7 +226,8 @@ static u8 get_rp_completer_type(struct pci_dev *pdev)
 	if (ret)
 		return 0;
=20
-	return FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
+	return tph_completer_type_fold(FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK,
+						 reg));
 }
=20
 /* Write tag to ST table - Return 0 if OK, otherwise -errno */
--=20
2.53.0-Meta

