Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793706647;
	b=3OZvAGk28+qLuYeHlOqWaULa2+aL6W9GZz+pGEXTcj/IKvow59igILQfP4i1WzuRmLpi
	 odxxDdmuV+whnPmOuu0M7jFiBObQ/Zgz6f1/8zOr1xHTrr+5XoIPF0T3BssH1ATj2+P+E
	 vp10baiKbHaIrZkX3On3CJeym7m/Nyf6h4P84mwhRpAmVvX+OUrJlx/ZQV6ydudkq8BN5
	 aPZwXStzh/JcsGG0I1z0OFruSIPd/JZxIruu/P851pU+GbVYMzLOnYu4EnNvQSK7tG3SY
	 r/za/C1fkEMmVDNzc5G2wJcu8FLH/lymeB8Dn/vZu2OfBR6GXc7PMqBTJ8zvLqVeIJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793706647;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=9bGsescVcCTMSoGoxEzsBVUuqwxJfWKZTtlOq3cqGT0=;
	b=01focG0Dk4FlCQYViQx8pBdFbjDuPdRd2v17NQBMgT2PB4Ton34Vy+xLTb1G6QaGffiu
	 DoysspUtCJ4Lt/fQhKYFdflSaWepMJu2LLHg2tXz38wfeFrhxv0/xCVK9piBcOgerAFpu
	 NKwShXx7jlMy/dZJeAaGJCb8OuWUrLGuBXtJ3CZ6lLua13C+US3FlKt+PXQRLq9oBIyu+
	 9HFd5L98O02Nzy/MaO5Bz50TJrLiquD00uZIpfGeyAcRXG4hCyCRHBGW1iSH+9zgkMYtg
	 aI7b5JJ9q44vaNU2UVoSUUtvGGmfz2JnimLDxMfXbbEqeKhZEdev1Ee4TWsFMmDxwIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=qfI0B5Uz;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4415C6082BEC;
	Tue,  3 Nov 2026 11:50:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4415C6082BEC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=qfI0B5Uz
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 5F18E20B7167; Tue,  3 Nov 2026 03:50:32 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5F18E20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793706632;
	bh=9bGsescVcCTMSoGoxEzsBVUuqwxJfWKZTtlOq3cqGT0=;
	h=From:To:Cc:Subject:Date:From;
	b=qfI0B5UzdcHHuZASIiJSfwdzjdunShRI56Emsb0OZzSnty9qvmBe59vvK35ZoiCf1
	 4E5161+nVm1RukiagMtzHDHv6iEOew60xgpP6F4bIEjcelgpztbK6jNiymHBGKm3ZT
	 g3b6zdnjftg43DSPEaziqNvqsuQYnco4GvScF5To=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	zhiyueqiu@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mana_ib: Enable RDMA devices on the CDX bus
Date: Tue,  3 Nov 2026 03:50:32 -0800
Message-ID: <20261103115032.736554-1-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
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

From: Zhiyue Qiu <zhiyueqiu@microsoft.com>

Enable MANA RDMA on CDX by depending on the shared GDMA core and matching
the CDX auxiliary devices.

Map non-PCI userspace doorbells with pgprot_device() to match the CDX
transport, and report the Microsoft vendor ID directly.

Signed-off-by: Zhiyue Qiu <zhiyueqiu@microsoft.com>
Co-developed-by: Konstantin Taranov <kotaranov@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
---
 drivers/infiniband/hw/mana/Kconfig  | 10 +++++-----
 drivers/infiniband/hw/mana/device.c |  2 ++
 drivers/infiniband/hw/mana/main.c   |  8 +++++---
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mana/Kconfig b/drivers/infiniband/hw/mana/Kconfig
index 546640657..6eae7fa91 100644
--- a/drivers/infiniband/hw/mana/Kconfig
+++ b/drivers/infiniband/hw/mana/Kconfig
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config MANA_INFINIBAND
 	tristate "Microsoft Azure Network Adapter support"
-	depends on NETDEVICES && ETHERNET && PCI && MICROSOFT_MANA
+	depends on NETDEVICES && ETHERNET && MICROSOFT_GDMA_CORE
 	help
 	  This driver provides low-level RDMA support for Microsoft Azure
-	  Network Adapter (MANA). MANA supports RDMA features that can be used
-	  for workloads (e.g. DPDK, MPI etc) that uses RDMA verbs to directly
-	  access hardware from user-mode processes in Microsoft Azure cloud
-	  environment.
+	  Network Adapter (MANA) on the PCI or CDX bus. MANA supports RDMA
+	  features that workloads such as DPDK and MPI can use to directly
+	  access hardware from user-mode processes in the Microsoft Azure
+	  cloud environment.
diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/mana/device.c
index 62c7803ca..33e474907 100644
--- a/drivers/infiniband/hw/mana/device.c
+++ b/drivers/infiniband/hw/mana/device.c
@@ -257,6 +257,8 @@ static void mana_ib_remove(struct auxiliary_device *adev)
 static const struct auxiliary_device_id mana_id_table[] = {
 	{ .name = "mana.rdma", },
 	{ .name = "mana.eth", },
+	{ .name = "mana_cdx.rdma", },
+	{ .name = "mana_cdx.eth", },
 	{},
 };
 
diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 858bbc325..c63ac20e7 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -572,7 +572,10 @@ int mana_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma)
 	pfn = (gc->phys_db_page_base +
 	       gc->db_page_size * mana_ucontext->doorbell) >>
 	      PAGE_SHIFT;
-	prot = pgprot_writecombine(vma->vm_page_prot);
+	if (dev_is_pci(gc->dev))
+		prot = pgprot_writecombine(vma->vm_page_prot);
+	else
+		prot = pgprot_device(vma->vm_page_prot);
 
 	ret = rdma_user_mmap_io(ibcontext, vma, pfn, PAGE_SIZE, prot,
 				NULL);
@@ -623,14 +626,13 @@ int mana_ib_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
 			 struct ib_udata *uhw)
 {
 	struct mana_ib_dev *dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
-	struct pci_dev *pdev = to_pci_dev(mdev_to_gc(dev)->dev);
 	int err;
 
 	err = ib_no_udata_io(uhw);
 	if (err)
 		return err;
 
-	props->vendor_id = pdev->vendor;
+	props->vendor_id = PCI_VENDOR_ID_MICROSOFT;
 	props->vendor_part_id = dev->gdma_dev->dev_id.type;
 	props->max_mr_size = MANA_IB_MAX_MR_SIZE;
 	props->page_size_cap = dev->adapter_caps.page_size_cap;

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

