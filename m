Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF9D457E7F;
	Tue, 29 Sep 2026 19:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790708756; cv=none; b=muibc2FF9BO07ZIPhvkXr6Wqkq61smdvdYVGHs5PUKFKlJa20LUhB6IASvGoJxImRa10Xn+4O3RGYs+kmHww+Wmv6v5Z/RQoMe3LrvM5lqL9MOsKcXLq9lYKJAlpx+ox/ktmiRJ2uCfZdUvzRKa3oeJK6TgJgtayomV6nrcr47s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790708756; c=relaxed/simple;
	bh=cdhdK6Wqqf16iHG320qyeWFtctYtsAwo/xlgZm67xKg=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=P4BgScX/wAUtWpP9DrZfZU7MVFC/M+fey/jTs9JRPKFdSRtYSarRBeVUqQjg8eXPEAsAfJitvZb8B9PH5mp0wU4dYh8JbUgZ7p6UUN2RfzoMZnOmeYd/VPkYPJdqIQXoScImjagt+4Z+LPCTrF12Y66+Rg4ZcNJrgRuYJjkX+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QOtHAbHt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QOtHAbHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A444F1F000FF;
	Tue, 29 Sep 2026 19:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790708755;
	bh=kHVOXudtAUCt+DGnC0hgiDqVew8/7HltoL79ogwGx6w=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=QOtHAbHti8HgUdNyUZ/ppwA5T3CxQdnohGBOXHD92BjD+jyEP/FoSCvz78HLO2XjR
	 fEPn+FmDpLSCDsgokXO2w9D3fitNQC3CjnIRvXFWCRgFmCxIjiAqXVeHY/U89A7Snm
	 MxeGQSJBRqYIJzxYGgyQIidJwY5tWl/3ysl/OrX6TjayfQLe2AAA8z2O6YBD0auGPV
	 utCyMKLEs1raiETSvds3/5ckwHK5HejiBrjernsjE4D9OaM5P/bzkHV0UfWgp7HtZ4
	 tzE8TR7c6vpFASExvksMffc0dJ5Xhm9wKrNTpHF+bQR5ju9wxie1fMgOaOukCpV71W
	 A59Wm8202uHRw==
From: Leon Romanovsky <leon@kernel.org>
To: Potnuri Bharat Teja <bharat@chelsio.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, "David S. Miller" <davem@davemloft.net>, 
 Steve Wise <larrystevenwise@gmail.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Jiale Yao <yaojiale02@163.com>
In-Reply-To: <20260926112611.3214382-1-yaojiale02@163.com>
References: <20260926112611.3214382-1-yaojiale02@163.com>
Subject: Re: [PATCH] RDMA/cxgb4: Do not allow userspace to write the status
 page
Message-Id: <179070875254.3980457.816097222979925728.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 15:05:52 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 26 Sep 2026 19:26:11 +0800, Jiale Yao wrote:
> The device status page is shared by all userspace contexts and contains
> db_off, which the driver updates to control doorbell flow. The rdma-core
> provider maps it with PROT_READ, but c4iw_mmap() passes the requested page
> protection through when handling CXGB4_MMAP_CONTIG.
> 
> A process can therefore request PROT_WRITE directly or later upgrade a
> read-only mapping with mprotect() because VM_MAYWRITE remains set. This
> lets userspace alter device-wide flow-control state seen by the kernel and
> other contexts.
> 
> [...]

Applied, thanks!

[1/1] RDMA/cxgb4: Do not allow userspace to write the status page
      https://git.kernel.org/rdma/rdma/c/1c5335a6902639

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

