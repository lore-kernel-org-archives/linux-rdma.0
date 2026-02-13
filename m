Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00E5354AF1;
	Fri, 13 Feb 2026 10:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770980357; cv=none; b=XflSNcBNDMEYEAtZd/crhie17cN2hfd7oukJQC5j5mciN2uCfywqRkZblrYm0YC6Arq+4VcOkJqeEQCnn06Xi3V/M1rzyUolsQ0IRJ5C1AfikYvkF0z2td+9KSnrvPyVIgGpYzy3A6i+DnPU9V3x5JpvTKjtDjPLwHfr8UUFpwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770980357; c=relaxed/simple;
	bh=Nw1nfs0JxfKQuNIGR98010MtHYruPmZR1Tu88LU5ocY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8MaEREziBn2YzMqRhFXRS1jZWpFh6Q8EPEHwCS7+hf4rHpGP/HqBl3NN5xZXXE57NC13wu30fDU8zExkvwnF034DR98+rgjJ+QchUTqRwr8VvEzAhIEn2nD+kcI8KWAIItvylTsePO6MbsaLn8iKMjx3hwhLXfntzbUk2jpoz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XvWniCXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XvWniCXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4550C2BC87;
	Fri, 13 Feb 2026 10:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770980354;
	bh=Nw1nfs0JxfKQuNIGR98010MtHYruPmZR1Tu88LU5ocY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvWniCXsC1Tq/J6MQwYtCaxC2AOUAJdOs6Ix8vqCzkTSm2jUt3oBI5PDXxyqvYK6+
	 RAGzFK4TBxPELdB5/FXe+cSOFypCg7PgMuviEYhJKpyitAKKKRbQXJy9zsXXoKWRFB
	 SM+qAPmalJMA7rcPeTq5gmlew1U7XibLHunEvCch4R+b4GW2Qtwp8+6YBQwuSNDalu
	 13jCv6KhdfOGLWQjcUiV0/XzAz0RbWEvfGmyBhohLjcjg/64j7fs+SPRwposScXlcH
	 pUksLU6STRFsfQR4V3H2bl9TuoaKExA1OXstK8/PlWvSMxd69MyV0S12J0v+rtWcb0
	 /Vb8va1tQe9SA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Christian Benvenuti <benve@cisco.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org
Subject: [PATCH rdma-next 02/50] RDMA/umem: Allow including ib_umem header from any location
Date: Fri, 13 Feb 2026 12:57:38 +0200
Message-ID: <20260213-refactor-umem-v1-2-f3be85847922@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213-refactor-umem-v1-0-f3be85847922@nvidia.com>
References: <20260213-refactor-umem-v1-0-f3be85847922@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-47773
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Including ib_umem.h currently triggers circular dependency errors.
These issues can be resolved by removing the include of ib_verbs.h,
which was only needed to resolve the struct ib_device pointer.

>> depmod: ERROR: Cycle detected: ib_core -> ib_uverbs -> ib_core
>> depmod: ERROR: Found 2 modules in dependency cycles!
  make[3]: *** [scripts/Makefile.modinst:132: depmod] Error 1
  make[3]: Target '__modinst' not remade because of errors.
  make[2]: *** [Makefile:1960: modules_install] Error 2
  make[1]: *** [Makefile:248: __sub-make] Error 2
  make[1]: Target 'modules_install' not remade because of errors.
  make: *** [Makefile:248: __sub-make] Error 2
  make: Target 'modules_install' not remade because of errors.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/rdma/ib_umem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index ce47688dd003..084a1d9a66f3 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -10,8 +10,8 @@
 #include <linux/list.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
-#include <rdma/ib_verbs.h>
 
+struct ib_device;
 struct ib_ucontext;
 struct ib_umem_odp;
 struct dma_buf_attach_ops;

-- 
2.52.0

