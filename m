Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD38D264617
	for <linux-rdma@vger.kernel.org>; Tue, 24 Mar 2026 23:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774396321; cv=none; b=F0futVSINc2Mup1FeE9Kc6JCNZpEQKqC8vnMBSzc9e/TUY8NVLUgbzpJueg1DggkmQR8UFbCTI8VpYtrBvXq3/ktsGTIxNkIkGd/PRTBdgXqLKzQfUPYWLcHZRTg4NjJ9DXw7s0ypg/Ua0HEUp2ovsJ4KjKrFHXUxAYIx1sjXlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774396321; c=relaxed/simple;
	bh=O5GME2cuVxChwrcJ1TC22wMeIZDwNl2gWemTSjB0vcc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mDUgK7FXtGNAKcsOBiyj6zVubWSYdFtrg77ipM2SmP+UCdGnSX7/c4M0a3ySx4MjlUJipVritji5qGdQxJ9jzZt0iOfyNwn+exy3AuE9zXn+60oKceyw9i8dODP7sk6uNS6vGPFioxyJG+ISdgFYIT/Y/xwJcGLc6Atuv3fr+q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=CdOCU4Nn; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="CdOCU4Nn"
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62OM01v63068308
	for <linux-rdma@vger.kernel.org>; Tue, 24 Mar 2026 16:51:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=GTcNfaIvTV9CCY4TmT
	n6enDItgoZyUnkmTMnvSeTAAU=; b=CdOCU4NndSVgN7zKgckJpgtavyWE3HGGBo
	w0ZNInhRdhfx+BxwqlhVlGDGV4taks4QDuIJG5B5A+TVmUmih4moBce6gRIXlZ9R
	nlH9QI+MQOc0sEbqFwRMi78q6Jcm8EBjfWkMgojEMU4v4knh7rmzpDMOFuTYMM9I
	twBFxtrnbnnCymOojZFLr3UrKRg3mkhv4OTXwdFfcxJICeogrS5eANvzgjjMQkIK
	+q6K0fkL1zMPFCYURkJLNPtbHygVneLNgy7NjiP7l//Pdeo6bjqVxQ8YHTvLizIE
	6f+ZI5WJeroXRgpfiYSwBrWxyM6aZkfBjWmCXPKGF6TuYUXjuuzA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4d3ngbbe7h-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 24 Mar 2026 16:51:59 -0700 (PDT)
Received: from twshared22445.03.snb1.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Tue, 24 Mar 2026 23:51:52 +0000
Received: by devbig259.ftw1.facebook.com (Postfix, from userid 664516)
	id B181C1D7CEBE; Tue, 24 Mar 2026 16:46:15 -0700 (PDT)
From: Zhiping Zhang <zhipingz@meta.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Bjorn
 Helgaas <bhelgaas@google.com>, <linux-rdma@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <netdev@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, Keith Busch <kbusch@kernel.org>,
        Yochai
 Cohen <yochai@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>
CC: Bjorn Helgaas <helgaas@kernel.org>, Zhiping Zhang <zhipingz@meta.com>
Subject: [RFC v2 0/2] Retrieve tph from dmabuf for PCIe P2P memory access
Date: Tue, 24 Mar 2026 16:46:01 -0700
Message-ID: <20260324234615.3731237-1-zhipingz@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDE4NCBTYWx0ZWRfX/SQ+OFPfpY8y
 xetAGrHSDmbfYoUEf6wyPYJhjPcFilCbv+y5iyzvEPe+whj1xdRb+Qmh4rnHebH+HBkSVCLbM7q
 Aj1f1H2MKMRGLd/m4n3H0IOgQFxmnw2OeH73zUQ8FVNkEgWXF/fEGJV9lFBiRKRJhs9L7PRS+2J
 AocCWL6VitcTJPKkq0OYOnHY46+NxvyfLJADWsaOO/bW+qDeMVLMKJ8NZfP+aHcyJ7T3tg9Bg6z
 7MkW32kjWv2ICeuI59prfzMrZxMbZoW9G2LZV34OnLZEW4zHCIlNDsMDOKLoVWtdER6PbfL/1yG
 VszP02DOBW6VO+q/2gywXbW0wcL4tFpdWPSKbpVhDO8voSQtLMfysYJjgIv/T+1Iar15DKmQrFc
 kQUUzg++TjhuJIg02ekHcLekn8l0LLY34rVcCJnMX2Mebbfj/44s2Ef43OZhwEe1CwuJv4ELePj
 Qhaa8Uk+bJbAr73mdXA==
X-Proofpoint-ORIG-GUID: CeXpSFuYOtSNt45kLAxqsKzSs2-gPELY
X-Proofpoint-GUID: CeXpSFuYOtSNt45kLAxqsKzSs2-gPELY
X-Authority-Analysis: v=2.4 cv=J86nLQnS c=1 sm=1 tr=0 ts=69c3239f cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=U_y8lYiYyhHBU5rMqhb2:22 a=zJhtDeQ-gK41YlDc0VgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_04,2026-03-24_01,2025-10-01_01

Currently, the steering tag can be used for a CPU on the motherboard; the
ACPI check is in place to query and obtain the supported tph settings. He=
re
we intend to use the tph info to improve RDMA NIC memory access on a vfio=
-based
accelerator device via PCIe peer-to-peer. When an application registers a
RDMA memory region with DMABUF for the RDMA NIC to access the device memo=
ry,
the tph info of the memory region can be retrieved and used to set the
steering tag / process hint (ph). Additional instructions or hints can be
passed to the GPU or accelerator device for advanced memory operations,
such as, read cache selection.

Note this RFC is for the discussion on the direction and is not intended =
to be
a complete implementation. If no objection, we will convert it to a Patch=
 set.

Changes v1 -> v2:
- Encode steering tag and ph in vfio_device_feature_dma_buf flags field
  instead of adding new uapi struct fields, to preserve ABI compatibility
- Fix subject prefixes: "Vfio:" -> "vfio:", "RMDA MLX5:" -> "RDMA/mlx5:"
- Fix raw steering tag vs st_index mismatch: get_tph() now returns a raw
  steering tag, and the mlx5 consumer converts it to an st_index via the
  new mlx5_st_alloc_index_by_tag() API
- Fix @tph doc typo to @steering_tag in dma-buf.h
- Remove unused variable, fix parameter alignment, fix trailing semicolon

Zhiping Zhang (2):
  vfio: add callback to get tph info for dmabuf
  RDMA/mlx5: get tph for p2p access when registering dmabuf mr

 drivers/infiniband/hw/mlx5/mr.c               | 34 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lib/st.c  | 23 +++++++++----
 drivers/vfio/pci/vfio_pci_dmabuf.c            | 26 ++++++++++++--
 include/linux/dma-buf.h                       | 30 ++++++++++++++++
 include/linux/mlx5/driver.h                   |  7 ++++
 include/uapi/linux/vfio.h                     |  9 +++--
 6 files changed, 118 insertions(+), 11 deletions(-)

--
2.52.0
