Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A3941F36F;
	Thu,  6 Aug 2026 08:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006145; cv=none; b=hik/sSqbHWwB8JStNvXaUbtlJk8q5aSlqlCrPEq07WGYu677jonEYQosGtUszydQWnn2qpjdlTE4FQGM61plGWx3TcyV0mQbQP7h/7qsPqjJhQ9pktmL6zhhQ0a5dxDaJ4Ti9EOAuXYPWdJ5w72AT02eOPu4nONUVPyhu6FnhtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006145; c=relaxed/simple;
	bh=EpCNwdppOSpyY8LMfPm8ebcmKnqafnDnSanNOI2oTeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HZve143TH59FgQgSkfFM7xFLyEYLZu59mbJcfbZYIhQhylHgNA2R/QlhYfY8NDe0kRpvrbnzgfvv2C+CHyH2wK67WlBgZ8EIrV/iz5TV+sYKimMy+RGmciC4cS/GfOSwM0QaDcFxGVIve4uNtWYXRcB55vfeofzBGtNaG3UMKD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OxS7rb48; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OxS7rb48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6591F00A3A;
	Thu,  6 Aug 2026 08:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786006144;
	bh=eEKJBMVUo0M31QUt7ficnexwo5+u+yy+kUoocn0io4o=;
	h=From:To:Cc:Subject:Date;
	b=OxS7rb48C7hgBIhA4ncY53I/JGFcZeSPcxft8yy+wFnnmepUbw2AifD4lfmvdOdOD
	 0NFh9K0ed9fRweKFL3WNOR7ltZUG/Uev2DJYRl0n48/+0KnP5t1U4b7/F/hoQ3jOaj
	 Gh6ANIoz274UoWmVOs+IU3d4zc9NlXyZMXEnh5xKip2XfF/aTuLE6NliD5zW2w4p6q
	 GPT2bcFrFOMDPoIgWWNedNs3peqTRoSgLybTmXPnJ4e4Z9lfYP24AX2MXNfCBunJuV
	 Ed1YTzKnPY5medKWWJ5iw4RRg7Mcvydut37RQE+blDeEcAhFyEMYIoBUu8xsaFLVqC
	 nCIlQysTOqk4Q==
From: Leon Romanovsky <leon@kernel.org>
To: Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/erdma: restrict the driver to little-endian systems
Date: Thu,  6 Aug 2026 11:48:56 +0300
Message-ID: <20260806-missing-endianness-conversion-for-64-v1-1-896327c1aff1@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260806-missing-endianness-conversion-for-64-f0af69246071
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

The eRDMA device interface requires explicit byte ordering, but several
DMA-visible values that should be little-endian remain native-endian.
Command request payloads are copied verbatim, data-path SQE headers are
written without cpu_to_le64(), and kernel doorbell records are assigned
plain u64 values. The command completion path also reads a little-endian
SQE header without conversion.

These paths are byte-swapped on big-endian kernels and can break command
processing during probe. Since complete big-endian support requires
converting every device-visible structure, depend on !CPU_BIG_ENDIAN.

Fixes: ca7fd6cff3b8 ("RDMA/erdma: Add driver to kernel build environment")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
RDMA/erdma: restrict the driver to little-endian systems
---
 drivers/infiniband/hw/erdma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/Kconfig b/drivers/infiniband/hw/erdma/Kconfig
index 267fc1f3c42a..745e5551773f 100644
--- a/drivers/infiniband/hw/erdma/Kconfig
+++ b/drivers/infiniband/hw/erdma/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config INFINIBAND_ERDMA
 	tristate "Alibaba Elastic RDMA Adapter (ERDMA) support"
-	depends on PCI_MSI && 64BIT
+	depends on PCI_MSI && 64BIT && !CPU_BIG_ENDIAN
 	depends on INFINIBAND_ADDR_TRANS
 	depends on INFINIBAND_USER_ACCESS
 	help

---
base-commit: 961ac0f0c5e414abdd6b33fae84b311d9fde0bd0
change-id: 20260806-missing-endianness-conversion-for-64-f0af69246071

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

