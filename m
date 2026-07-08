Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932BF42CB02;
	Wed,  8 Jul 2026 10:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783507620; cv=none; b=kcCj6/N2XFs2bhQLfYWMxEKC2NDmVe33HiDW2+DwHSw29+7F/xwH+6ZfTjOp4GUgL295ItTQ73+KEGJIzMv28bpvBfHxVU+egs51e/Fim13xnLKaMrNgH0gbqP4ESnNDmCBSbz5npS2Wb/P0qD0iR3JhSJbVYPCcR630KWqkMLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783507620; c=relaxed/simple;
	bh=Nmtmz/UTYq609gzyssxxNyxB0LdgD93NKduw6h/foFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YSYoeO9yBo3spA647gqx/rcmullHrXm/0Q2BbG0fP0fgVjYbGDd5uttv2dFeTYACK2aBbxDqXCjqfNwJ5AeMwGHbIrzFt+MZRWIS4PoQwOvTkn2ksn3ZbScyjIz39vdCWbL/Hzs3mbQQpE1+SOoXizItVhsyqIRwj1pL69XBSvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OI/xtbV6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OI/xtbV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666701F000E9;
	Wed,  8 Jul 2026 10:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783507600;
	bh=w8uEFnXz3AgSxJ6opXvHWTD4sjYofGOXvknWnksXT3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OI/xtbV6PhIg6Do8IlcRYizQbeyCy0yvM7fJ32XIAFyIMG9/hu8ccWyj2wSf1fz11
	 ncWSEUq7dmTJAkN+96X1TnLmDZ9tehIHxALnubs1E1j7CpH4Or1jqHCZZsupoYRsRd
	 jpQcIBndY0o4DR02kX0gK70k83/1YO1bX4m5+eEy2O//Txoh9yq3wMcmo+TeXKBDCl
	 eDgVAhtu7oF6Ue2doX67LHKC0gJlVRNX2y2krXeATJT4Hs9KSLJYU9Omz5WFe4ZF7h
	 JbekSVmlUrOmcfGoE6bUSNGHWHRU24yddNLhRXpazYsinPlN26pPeHPVu4vQhRdNGn
	 eas1PoIOjoSkg==
From: Leon Romanovsky <leon@kernel.org>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Ira Weiny <iweiny@kernel.org>,
	Doug Ledford <dledford@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Sadanand Warrier <sadanand.warrier@intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Dean Luick <dean.luick@intel.com>,
	Sebastian Sanchez <sebastian.sanchez@intel.com>,
	Jubin John <jubin.john@intel.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH rdma-next 03/13] RDMA/hfi1: Remove redundant PCI device ID validation
Date: Wed,  8 Jul 2026 13:45:41 +0300
Message-ID: <20260708-clean-init-one-hfi1-v1-3-b9e9641268a5@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260708-clean-init-one-hfi1-v1-0-b9e9641268a5@nvidia.com>
References: <20260708-clean-init-one-hfi1-v1-0-b9e9641268a5@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

The PCI core calls init_one() only after pci_match_device() has selected
an ID. For normal probing, hfi1_pci_tbl already restricts matches to the
two supported Intel device IDs. Dynamic IDs and driver_override are
explicit requests to attempt binding, so the probe should not second-guess
the PCI core's decision.

Remove the redundant check.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/hfi1/init.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 3a408399f9ab..7c0383657ad0 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1571,15 +1571,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* First, lock the non-writable module parameters */
 	HFI1_CAP_LOCK();
 
-	/* Validate dev ids */
-	if (!(ent->device == PCI_DEVICE_ID_INTEL0 ||
-	      ent->device == PCI_DEVICE_ID_INTEL1)) {
-		dev_err(&pdev->dev, "Failing on unknown Intel deviceid 0x%x\n",
-			ent->device);
-		ret = -ENODEV;
-		goto bail;
-	}
-
 	/* Allocate the dd so we can get to work */
 	dd = hfi1_alloc_devdata(pdev, NUM_IB_PORTS *
 				sizeof(struct hfi1_pportdata));

-- 
2.54.0

