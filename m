Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C046E3E867A;
	Tue,  2 Jun 2026 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780409115; cv=none; b=e5LnN1VNE07q2utxSemABrnz6rwX5RAyoF8QcFmT6P5jHr6TfT8rz6Za++zREaxTYbE0NukEo0nug9zWdhji/iwpu72wOLRq1VWf0DvTo2XSPAelGb4V2bqDVArxhc3vBVntwnM8wne1O3IWFujuFqtDKx19jvZQcI+7PhXxqbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780409115; c=relaxed/simple;
	bh=MPJmrHyzu6Q4n7GstA06o8d60TkJhPuXCvlMGIU8yKM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hy0fipb3cUNP/TbC67RCo+pHDzNytQ8JcN9mdfTsGhOspqUXTKlOJNJAIXLXqzU6R3uW/hKc/iudwsOYA9UXQPdICQn5+Cnrdoxqy4p1Grjmp/E++lI3usDJDMEws2ZLUZhHBpQdiDMpdlREcuTSK7nHbkAApfDcin9RfpvR8VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B9dqDQoM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B9dqDQoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679661F00893;
	Tue,  2 Jun 2026 14:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780409114;
	bh=2/krVRc7nfC9A6ChR8uWLfYagg/geIPKiZr1Lzo9cUQ=;
	h=From:To:Cc:Subject:Date;
	b=B9dqDQoMxwB67FmFnBSdYa7bcZ9qIe4k6ZHnCsHhGztpX9zQim+J3K7vYlCTxCLM1
	 FY4U5Mwa6JLqmYcAFc7xFtmyrwB25RItgtvRgkYHjHe6J9agymaA0vDgHPX+lFOmSv
	 DrQ7opyYK1VrDmF2Ekp7koeroAi+6D+tw9mC3ZI1IxtPOceIvfw9AUI7aKg3Mqfasa
	 +Lp4cd9rV+WwsGKFcY+ADl6qPnnqVRi2KMnixcNA1g6q4tp9KD4Iz5UkMT1PodcWHF
	 vHqJkVzIvhBBi1KJTeCp4+eOyi+jR+xU5ouLyHc30X5w3DubDp+x1WOYlpZPmIc4YM
	 rrcDrADWND5JQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Doug Ledford <dledford@redhat.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Kees Cook <kees@kernel.org>,
	Dean Luick <dean.luick@cornelisnetworks.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] [v2] RDMA/hfi1, rdmavt: open-code rvt_set_ibdev_name()
Date: Tue,  2 Jun 2026 16:04:34 +0200
Message-Id: <20260602140453.3542427-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

clang warns about a function missing a printf attribute:

include/rdma/rdma_vt.h:457:47: error: diagnostic behavior may be improved by adding the 'format(printf, 2, 3)' attribute to the declaration of 'rvt_set_ibdev_name' [-Werror,-Wmissing-format-attribute]
  447 | static inline void rvt_set_ibdev_name(struct rvt_dev_info *rdi,
      | __attribute__((format(printf, 2, 3)))
  448 |                                       const char *fmt, const char *name,
  449 |                                       const int unit)

The helper was originally added as an abstraction for the hfi1 and
qib drivers needing the same thing, but now qib is gone, and hfi1
is the only remaining user of rdma_vt.

Avoid the warning and allow the compiler to check the format string by
open-coding the helper and directly assigning the device name.

Fixes: 5084c8ff21f2 ("IB/{rdmavt, hfi1, qib}: Self determine driver name")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: fix typo
    drop two other patches from the series that are no longer
    relevant, leaving only one patch
---
 drivers/infiniband/hw/hfi1/init.c | 13 ++++++++++++-
 include/rdma/rdma_vt.h            | 20 --------------------
 2 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 8b5a5b32b0fa..b7fd8b1fbbbd 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1206,6 +1206,7 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
 					       size_t extra)
 {
 	struct hfi1_devdata *dd;
+	struct ib_device *ibdev;
 	int ret, nports;
 
 	/* extra is * number of ports */
@@ -1227,7 +1228,17 @@ static struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev,
 			"Could not allocate unit ID: error %d\n", -ret);
 		goto bail;
 	}
-	rvt_set_ibdev_name(&dd->verbs_dev.rdi, "%s_%d", class_name(), dd->unit);
+
+	/*
+	 * FIXME: rvt and its users want to touch the ibdev before
+	 * registration and have things like the name work. We don't have the
+	 * infrastructure in the core to support this directly today, hack it
+	 * to work by setting the name manually here.
+	 */
+	ibdev = &dd->verbs_dev.rdi.ibdev;
+	dev_set_name(&ibdev->dev, "%s_%d", class_name(), dd->unit);
+	strscpy(ibdev->name, dev_name(&ibdev->dev), IB_DEVICE_NAME_MAX);
+
 	/*
 	 * If the BIOS does not have the NUMA node information set, select
 	 * NUMA 0 so we get consistent performance.
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 7d8de561f71b..7ffc83262a01 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -438,26 +438,6 @@ struct rvt_dev_info {
 	struct rvt_wss *wss;
 };
 
-/**
- * rvt_set_ibdev_name - Craft an IB device name from client info
- * @rdi: pointer to the client rvt_dev_info structure
- * @name: client specific name
- * @unit: client specific unit number.
- */
-static inline void rvt_set_ibdev_name(struct rvt_dev_info *rdi,
-				      const char *fmt, const char *name,
-				      const int unit)
-{
-	/*
-	 * FIXME: rvt and its users want to touch the ibdev before
-	 * registration and have things like the name work. We don't have the
-	 * infrastructure in the core to support this directly today, hack it
-	 * to work by setting the name manually here.
-	 */
-	dev_set_name(&rdi->ibdev.dev, fmt, name, unit);
-	strscpy(rdi->ibdev.name, dev_name(&rdi->ibdev.dev), IB_DEVICE_NAME_MAX);
-}
-
 /**
  * rvt_get_ibdev_name - return the IB name
  * @rdi: rdmavt device
-- 
2.39.5

