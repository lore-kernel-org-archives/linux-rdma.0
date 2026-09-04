Received: from outbound.baidu.com (mx21.baidu.com [220.181.3.85])
	by smtp.subspace.kernel.org (Postfix) with SMTP id A97A336B928;
	Fri,  4 Sep 2026 02:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.3.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788488703; cv=none; b=nxghf3VuYYffAetDB7UjXU5CJTqm40IZoa9IGW61PcENey0IiUw9a3giJNTG0Lfc2I4blAFJcmnpRpGa0t14EqFXd+ufxddk9BkY74Tg3alFxpIaf1uT84C5KBnoEdw5ZlBKwaHrw9q8geELlDWHdof5APpCTMowrOZ6Ohzwa/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788488703; c=relaxed/simple;
	bh=aRzs6URsRqJoay9AcceZR+z0rD0oKRKtCzLMQG/JRN4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fY7FLNLTFmD9brkCr3n1Gd/ElO01a94CLcyyYZOnfQ1s+qP9dnFlOsqaxjttfdkz2wsOoKKJHusKnihXdZCI/imPECrq13rqFLgm31SoGuxNcywQafT41iOPhi16O9CSPhHdXYOUKKVREonGJ3HHGSBwEpz0H/C9sFauOulhBgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=LToCPs1j; arc=none smtp.client-ip=220.181.3.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="LToCPs1j"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Li
 RongQing <lirongqing@baidu.com>, Yishai Hadas <yishaih@nvidia.com>, Edward
 Srouji <edwards@nvidia.com>, Sean Hefty <sean.hefty@intel.com>, Christian
 Koenig <christian.koenig@amd.com>, "Michael J . Ruhl"
	<michael.j.ruhl@intel.com>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] RDMA/uverbs: Set MR iova and length in ioctl reg paths
Date: Fri, 4 Sep 2026 10:24:41 +0800
Message-ID: <20260904022441.2200-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc3.internal.baidu.com (172.31.3.13) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1788488695;
	bh=bP+hP3XAQuZOHsiZg3PGbmlAlTTEKriYxx9/e5Bt5Vw=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=LToCPs1jfrNRFE+rfBbS0YPJ0Csz4lBWOpzoQ7mAUyZSbcf1B1TZ+ybWR+qaxcd5j
	 hAgqbyMg60HEkD2bTeD0dnzDjf5okS45WMPF3L9BDiM9Lkm9p6vIOAdqny1rlG8Um8
	 rLSbNs5LxE0IGI/Kh2lGyNsshgBs34wP9VpYqjkB+zQkRaP565CFlfIdP21gMfmV4N
	 VUT2gRsbyEdNQjEZkLjTuq2k6F7bM3FkmkRScCqDU2kfWcfRzFnNt1A+cy6nAQYnwT
	 hgUNCZzoS54Hx08E8u3aiDivU3LIOZdSZPJYLEJ3q1ExHUUsYlEcoCSbCPEAmD5CIX
	 PmvGrrEh2Cc6g==

From: Li RongQing <lirongqing@baidu.com>

UVERBS_METHOD_REG_MR and UVERBS_METHOD_REG_DMABUF_MR do not
initialize ib_mr->iova and ib_mr->length, unlike
ib_uverbs_reg_mr() which assigns both from the command.

Drivers that do not set these fields themselves are therefore left
with zero values. UVERBS_METHOD_QUERY_MR and RDMA netlink then report
zero iova and length. Some drivers also use these fields in their data
path; for example, rxe uses them for range validation in
mr_check_range(), causing accesses to MRs registered through these
ioctl paths to fail.

Drivers such as mlx5 that initialize the fields themselves are
unaffected.

Set iova and length in both ioctl handlers, matching the legacy
registration path.

Fixes: 5b2e45049dc0 ("IB/core: Add UVERBS_METHOD_REG_MR on the MR object")
Fixes: bfe0cc6eb249 ("RDMA/uverbs: Add uverbs command for dma-buf based MR registration")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/core/uverbs_std_types_mr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index 0c72f80..df02488 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -247,6 +247,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_DMABUF_MR)(
 	mr->pd = pd;
 	mr->type = IB_MR_TYPE_USER;
 	mr->uobject = uobj;
+	mr->iova = iova;
+	mr->length = length;
 	atomic_inc(&pd->usecnt);
 
 	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
@@ -374,6 +376,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_MR)(
 	mr->pd = pd;
 	mr->type = IB_MR_TYPE_USER;
 	mr->uobject = uobj;
+	mr->iova = iova;
+	mr->length = length;
 	atomic_inc(&pd->usecnt);
 	if (dmah) {
 		mr->dmah = dmah;
-- 
2.9.4

