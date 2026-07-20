Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1518B445AE0
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 17:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568214; cv=none; b=FxXUJzeXPLsqnH7l2XlMUoVmtxoVH6bYeFnJfXlGbsNykrcLl14FXrRUweEALXKxGkRdmkFxadqArJ5Gp8fb4jIVZq9nKx4ZzD+bJk4NuDddE0k2QLj3TVcd52nv5Y4cOuywxAvktG5OOo6fGmA5B/oKO7l/mQXLBK4vNtQwDRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568214; c=relaxed/simple;
	bh=zDM+9twRBKxInfPVZPob4moDrbBEMI9XxzYXWZNJ2ig=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aifVFgKUkaq2bE6jQhaFBY59LINykKauMNhKQ6+z3pH5en2YcvGTTaR5A3Ep8QReiN4NSyrv4ZRAY03zkz4rhwyl23afEHuzLz4pw3gLykHY/TgGGzaZqe0qPnFCV+UAdgvIItRCeYZivBa1Z0IS708XUn1dGnIus9M7TH22v5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Tl7Q9xad; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Tl7Q9xad"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66KHAdnN2476942
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 10:23:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=DTLEKDAFm5o1IDs3CH
	TtawTAzo4xpniHg617Q1VmLJg=; b=Tl7Q9xadHMpkxViS5d+CvQm9BElU+IlntQ
	S9ZU+HjsSnLfhgabFVop7CROnwpFK4ij9abRJX8yXC31ACM/XYvtjdwQd13kFrnT
	AFtDhFqiMtz6mzib1YdwwLPhHK5EDHgBcyQI68uCckmFc/VoLZh0SBlShkymQs4W
	hGCv/5GGvqEdHhhYwQ9Czq+qaNCd7mLIz2mzLQoaAKouMNf4EtizYMK7tJwHOFqU
	9czYn7mvG7BtKxrfVCFKKkZBYdJ2y6e9LU3ztSNrIZX4Q4ZDURZbKLkHT7GnpD3C
	d3nebUoVQmL1hB3iYOugEt0Hl6wyHvpQy0VtvjAhA/7sVbHbuqMg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fgu4dew2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 10:23:26 -0700 (PDT)
Received: from twshared9793.01.snb2.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 20 Jul 2026 17:23:25 +0000
Received: by devbig259.ftw1.facebook.com (Postfix, from userid 664516)
	id 99D3242B04105; Mon, 20 Jul 2026 10:23:07 -0700 (PDT)
From: Zhiping Zhang <zhipingz@meta.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Wei Huang <wei.huang2@amd.com>,
        <linux-pci@vger.kernel.org>
CC: Christian Konig <christian.koenig@amd.com>,
        Alex Williamson
	<alex@shazbot.org>, <linux-rdma@vger.kernel.org>,
        Zhiping Zhang
	<zhipingz@meta.com>
Subject: [PATCH v3] PCI/TPH: treat reserved 0b10 completer encoding as unsupported
Date: Mon, 20 Jul 2026 10:22:24 -0700
Message-ID: <20260720172304.117134-1-zhipingz@meta.com>
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
X-Proofpoint-GUID: WDpm8LDflQPXb_L1e_UkPmLrpMkB7w-y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDE5MiBTYWx0ZWRfX3dDC59cP/eTo
 Svjpq6xElM2Rin7TSXtzm2FLUkKQ4UfAWvIBNVSoIB4ZKOa4QZ0OBMKSabcLlsdNv3JHM4bUoDz
 qY4TyevcHOZFc8Y3oYOOv0OZ7MXzkCiGU13D3f+Tk1D+/tZs1EfR4/9168Blq+XVqG4PwolzvWn
 9gEJcWqYmYyuaQ8AVZYPPwyEn0GzOxn337K7qCis4ksELf6gt6+lIhnOOpOLkNV8YT0ywEzohAy
 qhw61zlUBQmEt3eXssqIe6BlKQPy7WrnEoo7AONO98uDrEFdiEnbpTVRgsDkcaIxzMGo4hDFzPV
 RjCMlv12Lw3wcv3+UUvGR4o5h4MjNQT4jfgy7u07cSF0a5fI4a/1eMYIULECcD5sIu7VAULqwYx
 vA8sw8j2+w913iBCLgsQuRShwxJ0PADASFLcBdTWjfFSSowaSI2r3PZSj84Im05o8qlH1j3b4xn
 GJMxXSeuUHwsICT9kSQ==
X-Proofpoint-ORIG-GUID: WDpm8LDflQPXb_L1e_UkPmLrpMkB7w-y
X-Authority-Analysis: v=2.4 cv=NOrlPU6g c=1 sm=1 tr=0 ts=6a5e598e cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VabnemYjAAAA:8 a=5iV6q52TU81yRMb5XQMA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDE5MiBTYWx0ZWRfX+H2Rmy7tzIzM
 RxBQoO3kdTnNNvltzl9wbqU8iIuFi7VSTxbRZZ8TSs6O6jmnG1tY8inxKc7mP5bCvmzT0mT72KE
 LWsrpqKQcVPQq1z9SHmJXecLLshXa7c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_04,2026-07-20_03,2025-10-01_01

get_rp_completer_type() returns the Root Port's "TPH Completer
Supported" field (bits 13:12 of Device Capabilities 2) verbatim. The
0b10 encoding is reserved, but pcie_enable_tph() feeds the raw value
into the requester type:

	pdev->tph_req_type =3D min(pdev->tph_req_type, rp_req_type);

and later writes tph_req_type to the TPH Requester Enable field, which
only defines 0b00 (disable), 0b01 (TPH only) and 0b11 (extended TPH).

No known hardware presents the reserved 0b10 in this field, so this is
defensive hardening rather than a fix for observed silicon: fold the
reserved encoding into "not supported" so only the three architected
values can ever reach the Requester Enable field.

Fixes: f69767a1ada3 ("PCI: Add TLP Processing Hints (TPH) support")
Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
---
 drivers/pci/tph.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
index 655ffd60e62f..5cbb381e2a02 100644
--- a/drivers/pci/tph.c
+++ b/drivers/pci/tph.c
@@ -200,6 +200,7 @@ EXPORT_SYMBOL(pcie_tph_get_st_table_size);
 static u8 get_rp_completer_type(struct pci_dev *pdev)
 {
 	struct pci_dev *rp;
+	u8 tph_comp;
 	u32 reg;
 	int ret;
=20
@@ -211,7 +212,15 @@ static u8 get_rp_completer_type(struct pci_dev *pdev=
)
 	if (ret)
 		return 0;
=20
-	return FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
+	/*
+	 * 0b10 is reserved; treat it as "not supported" so only the
+	 * architected encodings reach the Requester Enable field.
+	 */
+	tph_comp =3D FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
+	if (tph_comp =3D=3D PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY ||
+	    tph_comp =3D=3D PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH)
+		return tph_comp;
+	return PCI_EXP_DEVCAP2_TPH_COMP_NONE;
 }
=20
 /* Write tag to ST table - Return 0 if OK, otherwise -errno */
--=20
2.53.0-Meta

