Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1603B4314B9;
	Wed,  8 Jul 2026 10:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783507650; cv=none; b=WIIE2m45AQqjaZKU2DxNTkjIkLwQVXdHrUqCUuFVRxDUhEvUxOuHuM97PI6CKYxgu/Zw1nXcUwLl2iO4qQjCxCcqm7Um2JpqcsKeUjX91CD5uryC9sTBMMX5oYHTRaE+5iHk5747uS57SFqigjIEx767HM83QZZJdf7931/go9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783507650; c=relaxed/simple;
	bh=7yKVIYO0sym8JpqRykhr+ZeaAW0TeH43gvNWQHkJFiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qC5DlEAEuqqUXAGFa/UnxaGguO5RFYhTMlAwl/APqpl9n+Ke6ZLMbRBdTCZfPBSIdKZLrFQnTRathxNRZpSyII41UBYKxy7ZRwx8yb5RaseF2bZpE8SPzL/94Y8xX46nwMfwghEPdJ3z+GpvQpQW5XxxbT8HBIUwIw3DijYSc/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXfb4qVo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXfb4qVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5C51F00A3E;
	Wed,  8 Jul 2026 10:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783507633;
	bh=oVw5RDalWrGELSovQDuuwdmhOXIH7dzvFlWaqGkZI8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXfb4qVozjRzW47J6ZhqbstN77AsQ/3rTFo9ox118gehErmSveqP8nNIxSOswMXCg
	 PFAhIAKqoGwPayKf4UQh3s22sCqEqS9iowqUmQDP32RMLgJ/nzgKbRuiKIEDWOwTQ+
	 7MIe/A5FzHKvcp/G8uENnIG1/lGR2MCCQ1bq5Yz161cLgmyqAV3pHD+SXZSvZbLAFp
	 hmmq0Kal0idcdIWIRHcDskYRpHZOJP1Cjt752Rd8ebdU8zVS+GrE6r/W9eX3KsvHQc
	 IvRSxhI/y8gTNAo51MF2sqvdfOGiM4D3D0VRmHK2+hvnGWGUW1JA29LmgSPMbvaQwh
	 ic8qtA2BIK4XQ==
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
Subject: [PATCH rdma-next 07/13] RDMA/hfi1: Free RX data on late probe failure
Date: Wed,  8 Jul 2026 13:45:45 +0300
Message-ID: <20260708-clean-init-one-hfi1-v1-7-b9e9641268a5@nvidia.com>
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

hfi1_init_dd() allocates the shared AIP/VNIC RX support before returning.
If hfi1_init() or hfi1_register_ib_device() later fails, init_one() tears
down the device data without calling hfi1_free_rx(). This leaks netdev_rx
and its dummy netdev.

Free the RX support after IB unregistration and before postinit_cleanup(),
as done on normal device removal.

Fixes: 4730f4a6c6b2 ("IB/hfi1: Activate the dummy netdev")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/hfi1/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 076ea9527b6e..79e253ac61f3 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1675,6 +1675,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			hfi1_device_remove(dd);
 		if (!ret)
 			hfi1_unregister_ib_device(dd);
+		hfi1_free_rx(dd);
 		postinit_cleanup(dd);
 		if (initfail)
 			ret = initfail;

-- 
2.54.0

