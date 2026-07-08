Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B34F42315F;
	Wed,  8 Jul 2026 10:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783507614; cv=none; b=Yyasr8/NHhSleM6/cXmH4NJ7tUhqHp5FBefquGTh5ywuBARx0iSp5iWzilCmYh6k2nKGGOI445UplHZpLKV6KaW0ijUENVrghsLDU619QMJhalemHnKxrTl3d31OW7Km9XRfSVTHj2Ju0CUrK3l/nNgHK9Bav2YhIm0skjc4Jag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783507614; c=relaxed/simple;
	bh=UgZh/xhC8ZXSiplTDKl2R5rvMrBRnwjmcrZSK0vJr8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iexu+fFF0aWIH3bvAl5iNqL3JERf/01x5Joh5QbUBY/PaF6wvGdUPYjTxFRXtewDAGT2bC2o2B/PJCzpWe4dFJfSWy2I+IQdOBpuPlUNu1WklikG85cH3ftqP4PLzGc0mEbRHGxSdEXsOJpUaoy8uMa/BZLJE175GzXcAYLPj90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hX6nKUwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hX6nKUwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F42F1F00A3D;
	Wed,  8 Jul 2026 10:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783507594;
	bh=ZrlrqBUisThbU1dySuYB6HHuTmBSqBv48+vTm1KXQHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hX6nKUwawTeQW3TjwnnDtoDVIrfhiribugE0imA+Y+GsqDYE/LL2Yo6ThNcO83UVO
	 0trTfgOOSn68TohMm6kwWXLjZaPz10PW4t2UOgmfgUK8y9Q2Ifw8oYkhDiavCqWR78
	 YAwknB6rvSY4oUqt3hqrw70YlwKFqieDyUZQtK80cb42nvavdWy1fnJ5zFJvRqhi8J
	 t8Iu162l9I0vu6IFeNSWX6oiYqwXDpf7nLZtebIDeV4hSczgTMmFsgl+EglV6Q8nCi
	 FMnWkoCezQkWnCr80klFr+bHY4nxDxfm71xVDGW8yD/qlKTMnSKSvoFvxqda0Mdf0s
	 V8t3BhEE4f9ug==
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
Subject: [PATCH rdma-next 01/13] RDMA/rvt: Return NULL after port allocation failure
Date: Wed,  8 Jul 2026 13:45:39 +0300
Message-ID: <20260708-clean-init-one-hfi1-v1-1-b9e9641268a5@nvidia.com>
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

rvt_alloc_device() deallocates the IB device when its port array cannot
be allocated but then returns the pointer to the released allocation.
Callers treat any non-NULL value as valid and dereference it, resulting
in a use-after-free.

Return NULL immediately after deallocation so callers can propagate the
allocation failure.

Fixes: ff6acd69518e ("IB/rdmavt: Add device structure allocation")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/sw/rdmavt/vt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 5fa3a1f33326..f37d6d64adb9 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -55,8 +55,10 @@ struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
 		return rdi;
 
 	rdi->ports = kzalloc_objs(*rdi->ports, nports);
-	if (!rdi->ports)
+	if (!rdi->ports) {
 		ib_dealloc_device(&rdi->ibdev);
+		return NULL;
+	}
 
 	return rdi;
 }

-- 
2.54.0

