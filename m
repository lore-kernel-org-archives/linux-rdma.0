Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001481;
	b=BD0EufwvQIa2znqj3hUf9ONwAAQ+M7fRpCKZgnrSEUn51nyrYXhZO/C5FWai2z/xIkKW
	 eumrslzbdlJzm59cDxLzsRYBLJW+dtVnHjYO6vFfe0PrGMexlvCfrQzryBapuQxZd+j/b
	 vSAXqWBB0+ZcGywio4eDFrArp0uP0GPFj7oX6sUVfoY9coSVZYJtgs3MDWUK1mpCn9rnT
	 ArMfj+rBLLqk+uo8rmywcqyOTUXJ2LgfFUV1p48J0d3gdTno5OYXD6mB3HzxFnU9V/HnB
	 lPLgkSxZ/I6rSkwLCFB2H9cj6nACiXWAuYWAUt2kK+1uXUMWLEYsn4a1OQXLtuh8mIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001481;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=3bKETn2tfT+VfzHpVzyvlFK7iO6ILBCK0F6DzWCM8Rc=;
	b=zxOrhBTgpf5Mw0n56vHIEAjANOJ85QhByJQ6zu1bK43WwQqV2LfjBsCtWDEUm/2H+UHI
	 SNcSR2DEzjNPJVqnGDMA/9R1kpnTjOmX6c6z1FYvhz3/LW/WxaeZoWqy0wE0HWa/WK8by
	 u6TdkWobSwmmKiQZvv5dlgvwZJq8umZLVTbwYGxtlPshh5Um1JiZp342oVFqIvGtoc+GT
	 tD7Onp/JASgAVBJgt4sMttI1+AVnLxvEalGx14XS86GlEG+RKyoHMnzlevbOeTbU4o9uW
	 7ock13OiGoyQ6gbleSiHbicT2IVVdGrIzUi35KQAeaCFDIOXTfNxlUHKYKcFRinkNlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b="Zb/w6mgL";
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4C6606A331
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:31:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D4C6606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Zb/w6mgL
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261118113112epoutp01453314e574f64216e285c0110b94905f~pIFRIxI1b1340313403epoutp01S
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:31:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261118113112epoutp01453314e574f64216e285c0110b94905f~pIFRIxI1b1340313403epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795001472;
	bh=3bKETn2tfT+VfzHpVzyvlFK7iO6ILBCK0F6DzWCM8Rc=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Zb/w6mgLGo+l81rmhCdgEFNx4/tKjOxwPE/VFDT4CF3G0EnA9S0pRyWTDLkN0s1YX
	 tPUSM7WoZhR21C7XYQ1CSipxB2LP69pZa/bPt86hx7knkrn8IVMpqCGM4sh4/Mh2jD
	 QAvqsxhiVsQVRfDQA6IGJUltGjO9cODPXa2BHlCc=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20261118113112epcas5p165b10951a7c61e1233a0d7a04fe7de40~pIFQsdVpR0773307733epcas5p1r;
	Wed, 18 Nov 2026 11:31:12 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jTzv334Dgz6B9mD; Wed, 18 Nov
	2026 11:31:11 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20261118103434epcas5p4ddef3806fafdb60f309fe882e354881c~pHT0IHpTs1275112751epcas5p4e;
	Wed, 18 Nov 2026 10:34:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261118103432epsmtip222a7237d25cab0527f14e37decda0c44~pHTycbO4V0208902089epsmtip20;
	Wed, 18 Nov 2026 10:34:32 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	jgg@ziepe.ca, leon@kernel.org, asml.silence@gmail.com
Cc: nj.shetty@samsung.com, joshi.k@samsung.com, anuj1072538@gmail.com,
	linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [RFC 0/4] nvme-rdma: dma-buf backed I/O
Date: Wed, 18 Nov 2026 16:03:23 +0530
Message-Id: <20261118103327.1788667-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
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
X-CMS-MailID: 20261118103434epcas5p4ddef3806fafdb60f309fe882e354881c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261118103434epcas5p4ddef3806fafdb60f309fe882e354881c
References: <CGME20261118103434epcas5p4ddef3806fafdb60f309fe882e354881c@epcas5p4.samsung.com>

Hi all,

This series adds dma-buf support for NVMe over Fabrics using RDMA.

Patch 1 moves the NVMe dma-buf I/O context handling from nvme-pci to
nvme-core.

Patch 2 lets transports create and provide the dma-buf attachment.

Patch 3 adds an RDMA helper for attaching a dma-buf to the device used
for DMA.

Patch 4 adds dma-buf backed I/O support to nvme-rdma.

The series has been lightly tested with the liburing rw-dmabuf test
over NVMe/RDMA using Mellanox ConnectX-3 Pro adapters.

Anuj Gupta (1):
  RDMA/core: Add ib_dma_buf_dynamic_attach()

Nitesh Shetty (3):
  nvme: move dma-buf I/O context handling to nvme-core
  nvme: let transports provide the dma-buf attachment
  nvme-rdma: support dma-buf backed requests

 drivers/infiniband/core/verbs.c              |  28 +++
 drivers/nvme/host/Makefile                   |   2 +-
 drivers/nvme/host/{pci-dmabuf.c => dmabuf.c} |  93 ++++++++--
 drivers/nvme/host/{pci-dmabuf.h => dmabuf.h} |  46 ++++-
 drivers/nvme/host/pci.c                      |  14 +-
 drivers/nvme/host/rdma.c                     | 182 ++++++++++++++++++-
 include/rdma/ib_verbs.h                      |   7 +
 7 files changed, 334 insertions(+), 38 deletions(-)
 rename drivers/nvme/host/{pci-dmabuf.c => dmabuf.c} (58%)
 rename drivers/nvme/host/{pci-dmabuf.h => dmabuf.h} (51%)

-- 
2.25.1

