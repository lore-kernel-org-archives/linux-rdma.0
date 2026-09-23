Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A380B3CB560
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 10:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160812; cv=none; b=E56cj8z5nDHRISN+k+Wmhcse7mg+RwC8LrdKitozH4r9mbyeKdQFU7GDj80jCVAVyaIrE0ltP/PkZkqAIbCR86wMvPSDSaz55laaZ2wLVuoTenafw3M6EygxWsmiB/BvYBeXQnTzKSwTR8nYf3PiBrKNLt+k3ksubJVIY5mXV8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160812; c=relaxed/simple;
	bh=r+CzcAsNaV3i2ivYG29J2yOrkiOcY1U1urTaG7t1lnI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EbvtbFLwJVTaciJ01HX1yoHCMqQVP3Jf8xMc+Hpp8WZLMSKDTix2OtuNrDdy0UVjUJbjDvHJuOpTagCN4OM9aLI2r6OhmpXp9RxkbZNX0jVHjSEjn+g+51il7quh2sNx7Y0FUKM8yyjdmQkOteZLvHsgg9KGVmRX/ABEh7OxQWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmAcF+Dj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmAcF+Dj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE731F000FF;
	Wed, 23 Sep 2026 10:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790160797;
	bh=CbeddEj7muq5Xnh19DRiRXSGgukp5da9lkhsBiIGoK8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=RmAcF+DjuU28ugZNfmGl7zp7PkxXKtBj4I993iMO18KXSl7JZRSb1TwrLO/j2wWSx
	 wpkeUYSRZ3riEh5022uP2sV9FNb8FoNppnVYWs36x3KRsTbHQU4AQdlY+l9EI7Y8fE
	 A16otpZINzkpaSpjx12mLTCsbCc7K3+kekL0Nk/8cNEulBK+t5StF2RkkZ0cqT61oN
	 uhlI125EqZ0CnbDNI2C6dX4nc96Fi+gkIH1V/Q5mBz7enNm9A/5c8pjzag0lPiALuz
	 nyyOWdgatvdMjNOz1DWmt9uLsaI/HWW6yHH0VMR33PqQ0NUH1xmluomVX9qPxw//6v
	 YhVCuBuEPTwjw==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Cheng Xu <chengyou@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
In-Reply-To: <20260917120459.13286-1-chengyou@linux.alibaba.com>
References: <20260917120459.13286-1-chengyou@linux.alibaba.com>
Subject: Re: [PATCH for-next v4 0/5] RDMA/erdma: Support non-contiguous
 kernel queue buffers
Message-Id: <179016079524.3401433.4560223049599563885.b4-ty@kernel.org>
Date: Wed, 23 Sep 2026 06:53:15 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 17 Sep 2026 20:04:54 +0800, Cheng Xu wrote:
> This small patchset introduces support for non-contiguous kernel queue
> buffers. Kernel QP and CQ buffers currently use a single coherent DMA
> allocation, which can fail for large queues when memory is fragmented.
> To address this, we allocate page-sized coherent buffers and describe
> them with the existing MTT.
> 
> - #1 unwinds kernel QP initialization failures explicitly.
> - #2 adds support for non-contiguous kernel QP buffers.
> - #3 adds support for non-contiguous kernel CQ buffers.
> - #4 unifies userspace and kernel space queue buffer management.
> - #5 moves kernel QP helpers after the shared memory helpers.
> 
> [...]

Applied, thanks!

[1/5] RDMA/erdma: Unwind kernel QP initialization failures
      https://git.kernel.org/rdma/rdma/c/9a413ed37d54b3
[2/5] RDMA/erdma: Support non-contiguous kernel QP buffers
      https://git.kernel.org/rdma/rdma/c/97ff4e6cd8d87e
[3/5] RDMA/erdma: Support non-contiguous kernel CQ buffers
      https://git.kernel.org/rdma/rdma/c/717ba25e0904bf
[4/5] RDMA/erdma: Unify userspace and kernel queue buffer management
      https://git.kernel.org/rdma/rdma/c/30cc2244165041
[5/5] RDMA/erdma: Move kernel QP helpers after memory helpers
      https://git.kernel.org/rdma/rdma/c/337b40e287b7e9

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

