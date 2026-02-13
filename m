Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2153375AE;
	Fri, 13 Feb 2026 10:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770980347; cv=none; b=DhY8nrwkZiB9etwarnk2JljI6kAkc8o5bMrNeSZYNK/Mr7PC1q6q9L2kx3GpW8H7Ffb8yVOg8DAhzHAh5VX4Zy2i+0TSZdGR8D4RRLvYXrakR5QaR2ZDtIiEajOGQN+u4ds/I1Ubk/X3ZKdzh4h7CgQBNyunXd0+IPI6PLTKqHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770980347; c=relaxed/simple;
	bh=Q1DCh8dQ1KaQLj3VPpwNYcjh0I8nlT+pOmgUCPDsk1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6mPAvIWTBb7z6k2c8hWpB1r2nNm/D1BYhwW7oqsD2M7aMowvVBNncwmjZpUnSv68YGJMfpvE7k4Dun7vS6Y+1DT1d4ULyQYY5l1krZD2fTzCC2m3jRW/IS4UJOxaRVmHpc3w69N7pgEnqR1dmRWRH+ZebcmBVZV9jva/GbgREA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cHLgrs38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHLgrs38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB99C116C6;
	Fri, 13 Feb 2026 10:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770980346;
	bh=Q1DCh8dQ1KaQLj3VPpwNYcjh0I8nlT+pOmgUCPDsk1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHLgrs38oixAD3ic9buWodMVj07v8CwmVWlUK9xzVRuUPIpYvwMMeqQDl5CgzgAmG
	 3ibdWoHX0zaGiBKDD5umv+vV4dXytxow6NugqIPLha24Ii8jdUL0kl2tXIbHlBfXCm
	 X7IxmuH5AGtKECjBkV8RaPhN6b5hrEj/2t+AwxKYLKu8vciX848vKp3idF3WPBMz9U
	 8xa0oCUFXoP+idAYuDwbSdKE5ZjQbv3IwqCV0lvRrze4vJ2euQkf1Rj1hzD4CeIdKP
	 WG1MPYlMEOiUNjtuPxCZ8hxTn6LoUji8BzMN/sAPYvAC/Nk9FBnvvviOpULTNcQu5F
	 7B7AONF+e7u/w==
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
Subject: [PATCH rdma-next 04/50] RDMA/core: Promote UMEM to a core component
Date: Fri, 13 Feb 2026 12:57:40 +0200
Message-ID: <20260213-refactor-umem-v1-4-f3be85847922@nvidia.com>
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

To manage UMEM objects at the core level and reuse the existing
ib_destroy_cq*() flow, move the UMEM files to be built together with
ib_core. Attempting to call ib_umem_release() from verbs.c currently
results in the following error:

    depmod: ERROR: Cycle detected: ib_core -> ib_uverbs -> ib_core
    depmod: ERROR: Found 2 modules in dependency cycles!
    verbs.c:(.text+0x250c): undefined reference to `ib_umem_release'

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 48922e0ede56..ada9877d02df 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -16,6 +16,8 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
 
 ib_core-$(CONFIG_SECURITY_INFINIBAND) += security.o
 ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
+ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o umem_dmabuf.o
+ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o
 
 ib_cm-y :=			cm.o cm_trace.o
 
@@ -42,5 +44,3 @@ ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
 				uverbs_std_types_wq.o \
 				uverbs_std_types_qp.o \
 				ucaps.o
-ib_uverbs-$(CONFIG_INFINIBAND_USER_MEM) += umem.o umem_dmabuf.o
-ib_uverbs-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o

-- 
2.52.0

