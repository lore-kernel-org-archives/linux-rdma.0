Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3912236212C;
	Wed, 18 Mar 2026 10:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773828543; cv=none; b=DwYtkJIh+C8y5Y8iXlraLC5VwpyrIX+GrxwV1AkD8EPO/5Cv/o2HrWWCuHU5Lo+2x70vzQeHXX7zyAq8xvr0C4CSzljkzkfUm4UxdemPJBMWy1pesLn+w2zXwIhuug6fxGkGJnQTDF9x3nADshbiGU1ssRPxOsGCdLupeVQVPqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773828543; c=relaxed/simple;
	bh=ZcPeKHOriConcezBIZjdOIpLmhSndWu0Hg9ShPgEfrE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lJ24L3xYvWEfhfEkLj70vLqSrzYtpv9avPiLcsFIQ4LPcC0mHu6rm45FicjLG3a3/nU/hsPnYWoyDvzOfpywcptH3SHHDcAzwskkS6QyHliU1pfxNEhzPKMAFl2wSQwwAus3QbY7nzZOrIMUkWtm6hbpiGUXeAIL4xkXveoTjHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWyMqaWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWyMqaWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8655C19421;
	Wed, 18 Mar 2026 10:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773828542;
	bh=ZcPeKHOriConcezBIZjdOIpLmhSndWu0Hg9ShPgEfrE=;
	h=From:To:Cc:Subject:Date:From;
	b=MWyMqaWQ98R7K3PSKBqESvSJqE3vwyZzuevbcRA0bG+P7+pTqPHtjSJ038RIlzLM6
	 xJAIMApwnP4hMGDrzKdXcaBIC+xWu4Yx0p0rJ7KOq46XFgUHZlWVadUPYzpD24TZi3
	 KU54D4clQod4Yw+XCObK6AIkLG/nVvq/KlPt83tYrT8Geft0j8hmOCDloWftfrvoIC
	 DDlgeHn7k/JtxS5hjj4gO10mJY4YAfzC7ELHDt2zvX4wpVHA2bBAYMcOzwdKRY2AYC
	 biSaDlINNDQY1TV/sdRLSKEqI0067pBegUnBl1/gvIEIASRJKzqlWkEJ3VbmxIw567
	 IDJGh5g5y0TFQ==
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 0/4] RDMA/bnxt_re: Miscellaneous cleanups
Date: Wed, 18 Mar 2026 12:08:49 +0200
Message-ID: <20260318-bnxt_re-cq-v1-0-381cb1b5e625@nvidia.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260317-bnxt_re-cq-320a01ce90d8
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

Perform general cleanup following the recently added CQ creation logic.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (4):
      RDMA/bnxt_re: Simplify bnxt_re_init_depth() callers and implementation
      RDMA/bnxt_re: Remove unnecessary checks in kernel CQ creation path
      RDMA/bnxt_re: Replace kcalloc() with kzalloc_objs()
      RDMA/bnxt_re: Clean up uverbs CQ creation path

 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 124 ++++++++++++-------------------
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |   9 ++-
 2 files changed, 53 insertions(+), 80 deletions(-)
---
base-commit: 5122be2a19aa0fc512ea689fd1064f7e05b45d17
change-id: 20260317-bnxt_re-cq-320a01ce90d8

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

