Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C7835837C
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 16:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737221; cv=none; b=piTfjEv+Jn8ZXEOnk6rbgUMQ9bdm0ngrdyEmJjyLiYV9h/VuBx4lcoqwXxdoa7raDwx83fd3JRSOoBS+aQ3/b6TFy8qXj7vJhb7HUKIJz4KGQmTf1PfSk7l2a/+P2dC2qvlNLrpMscQ9wLAyWZSe2wOhJeovuY0IqQuBtdZBaCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737221; c=relaxed/simple;
	bh=6IpaZhQCFn6EJCrgxjmtGlMJ25L3/kvYC7+EP8Sjy2Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tZj5fV3XfdOJUSTGf2lAmSRH/EpstEm8NKc8/Khn321jvkO7lF51IgQit8mcZrBidf8cYeHggeh3mmjLNQsHTr4CMDobjgu3/+OdK9MtRrnYlIzelSCqu5FYaHePOLLgjbXfmRDYdllfpEK5HLvwMfyNvzobW2gyhGOnsiSoJKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3DC1F000E9;
	Wed, 22 Jul 2026 16:20:18 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: leon@kernel.org, jgg@ziepe.ca, 
 Selvin Xavier <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
 kalesh-anakkur.purayil@broadcom.com, sriharsha.basavapatna@broadcom.com, 
 alhouseenyousef@gmail.com
In-Reply-To: <20260721115440.24021-1-selvin.xavier@broadcom.com>
References: <20260721115440.24021-1-selvin.xavier@broadcom.com>
Subject: Re: (subset) [PATCH for-next v4 0/4] RDMA/bnxt_re: Update the
 toggle page handling of CQ and SRQ
Message-Id: <178473721613.2912179.10168706512064876559.b4-ty@nvidia.com>
Date: Wed, 22 Jul 2026 12:20:16 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 21 Jul 2026 04:54:36 -0700, Selvin Xavier wrote:
> Based on the suggestion from Jason (
> https://patchwork.kernel.org/project/linux-rdma/patch/20260615224751.232802-5-selvin.xavier@broadcom.com/)
> , adding the uverb object to retrieve the CQ an SRQ structures while getting the
> toggle mem. To work with older rdma-core, retain the existing code with
> modification.
> The rdma-core pull request is here: https://github.com/linux-rdma/rdma-core/pull/1761
> Please review and apply the series.
> Thanks,
> Selvin Xavier
> 
> [...]

Applied, thanks!

[4/4] RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap
      https://git.kernel.org/rdma/rdma/c/85fddc66959716

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

