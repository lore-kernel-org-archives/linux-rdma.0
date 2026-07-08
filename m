Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B8842F6F9;
	Wed,  8 Jul 2026 10:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783507612; cv=none; b=YRvT2BPqs1zgIXLj3lSnuBdbacskz26KI5Ue4kwAEej1SP8xuKnPoY9X5AjXG6vEUXqELWgnLTCYGrDotkVmdKlEulkUb6RD0eP5SzU+Rd8D4pVqgZgMUB14GF1NkFxnYV+Ghpduq1buCXn5oZAxZPSl0Sq8vhI2UUqVXkpn4oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783507612; c=relaxed/simple;
	bh=DuSD1O90tw7ehV47XZMLeukliYvvTMe3va9DrUhipRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tLaIQtMTazZmAS5KvBZuhsGtjh0i6HLxhyZMzm4UiCtVPCyr1Tz1VsSQ8CW3pkqLeQXcIlGGOUXcB+6fQTdSNilGsHNJNcnScjaM5Mg/WPhBjLuJM67ZWQKwHg33wJXZPNSDSUxyseEjoU2XtDAJB8SNYlRaRWQuT0T3Ufmj5ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NOF74wRw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NOF74wRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A52C1F00A3A;
	Wed,  8 Jul 2026 10:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783507605;
	bh=ML/TbO4YSOqW5hl7rFndxG03jdWTecqLMNOh7BIxx1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NOF74wRwR+PGXeIUY2QJR/EfvBBjtSY8d7VUGWmJbepdAqAHRMwH5uT1XRUsq+nA8
	 iV6GgbYG0U4pue3+sPoiBbkjfv8iWCiPT/uJTVZo6vI5xEe66K70ZsBq6vmeLLNW1x
	 w3H27yUAElqdQmZr2IWDfggtKlcaKFhtDvt45I1At6V1q/wH38RMh9iKT4Epwdh9NS
	 B4S2ZivKvi3zIE3EjSOlfSCm/eW6zOg0U5OsMlmfwiCKvYqlC62ucRYESV3nscBFRC
	 1DY6OYf5Vtg3KeQIF2Ors7PCg1EXSCxKi/a8ybV5+CVGyDyqFhMXnt1cYM3c3jcf0o
	 t9ztaWQpjwUCg==
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
Subject: [PATCH rdma-next 05/13] RDMA/hfi1: Drop device data from hfi1_validate_rcvhdrcnt()
Date: Wed,  8 Jul 2026 13:45:43 +0300
Message-ID: <20260708-clean-init-one-hfi1-v1-5-b9e9641268a5@nvidia.com>
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

hfi1_validate_rcvhdrcnt() only needs hfi1_devdata to identify the adapter
in error messages. Requiring the full device data prevents module parameter
validation from running before hfi1_devdata is allocated.

Pass pci_dev instead and use dev_err(), allowing validation to move earlier
without losing the PCI BDF needed on multi-device systems. Use %u for the
unsigned count while changing the messages.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/hfi1/chip.c | 17 +++++++++--------
 drivers/infiniband/hw/hfi1/chip.h |  2 +-
 drivers/infiniband/hw/hfi1/init.c |  2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 44c524e45396..a41dd67c50bf 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -11929,26 +11929,27 @@ u8 encode_rcv_header_entry_size(u8 size)
 
 /**
  * hfi1_validate_rcvhdrcnt - validate hdrcnt
- * @dd: the device data
+ * @pdev: the PCI device
  * @thecnt: the header count
  */
-int hfi1_validate_rcvhdrcnt(struct hfi1_devdata *dd, uint thecnt)
+int hfi1_validate_rcvhdrcnt(struct pci_dev *pdev, uint thecnt)
 {
 	if (thecnt <= HFI1_MIN_HDRQ_EGRBUF_CNT) {
-		dd_dev_err(dd, "Receive header queue count too small\n");
+		dev_err(&pdev->dev, "Receive header queue count too small\n");
 		return -EINVAL;
 	}
 
 	if (thecnt > HFI1_MAX_HDRQ_EGRBUF_CNT) {
-		dd_dev_err(dd,
-			   "Receive header queue count cannot be greater than %u\n",
-			   HFI1_MAX_HDRQ_EGRBUF_CNT);
+		dev_err(&pdev->dev,
+			"Receive header queue count cannot be greater than %u\n",
+			HFI1_MAX_HDRQ_EGRBUF_CNT);
 		return -EINVAL;
 	}
 
 	if (thecnt % HDRQ_INCREMENT) {
-		dd_dev_err(dd, "Receive header queue count %d must be divisible by %lu\n",
-			   thecnt, HDRQ_INCREMENT);
+		dev_err(&pdev->dev,
+			"Receive header queue count %u must be divisible by %lu\n",
+			thecnt, HDRQ_INCREMENT);
 		return -EINVAL;
 	}
 
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 56e03d486ace..bc1c9e1c3172 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -660,7 +660,7 @@ static inline u32 chip_rcv_array_count(struct hfi1_devdata *dd)
 }
 
 u8 encode_rcv_header_entry_size(u8 size);
-int hfi1_validate_rcvhdrcnt(struct hfi1_devdata *dd, uint thecnt);
+int hfi1_validate_rcvhdrcnt(struct pci_dev *pdev, uint thecnt);
 void set_hdrq_regs(struct hfi1_devdata *dd, u8 ctxt, u8 entsize, u16 hdrcnt);
 
 u64 create_pbc(struct hfi1_pportdata *ppd, u64 flags, int srate_mbs, u32 vl,
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index a37a875736f7..fd91a4b4812d 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1580,7 +1580,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Validate some global module parameters */
-	ret = hfi1_validate_rcvhdrcnt(dd, rcvhdrcnt);
+	ret = hfi1_validate_rcvhdrcnt(pdev, rcvhdrcnt);
 	if (ret)
 		goto bail;
 

-- 
2.54.0

