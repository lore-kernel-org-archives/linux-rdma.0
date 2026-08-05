Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8232B3B6356
	for <linux-rdma@vger.kernel.org>; Wed,  5 Aug 2026 15:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785942048; cv=none; b=IQ0EO83KRxYAyqqqVOBsOQkMQXjmrKPaK4mGgtz+dvfblPVFMoK6h5c/sX6F1NYQ1Il0dkmhKU5JZ+yWAVhV7s7KbMhgCtM9NJHaBteymyVNCun532ibXrmF2qwoS5RUYJd50lEG96sSqOHSNvQpIV5+i+s0StQYtQUYYuCSKcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785942048; c=relaxed/simple;
	bh=aeAFRnKDWkuCy1iCZdYLszzYvjvbOvBGEIE0y95BMUI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EBrx/cBYoR/RZKTel0+g+LDaA1R52Mp+FmcyAkTAa6WSrgKF1rBEl71wJwX0tC82W+2nYGavsfn3+j8OFrupPm9DM7d78nkqXQF5U/XnKs7w3zVSFQuUcdTZRwZ6ZAfTNgMWmuwUXR2r2w0PPYKixqG4ma1Bpk3eBKNbO4WhLLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hrwVbN5p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hrwVbN5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E9F1F000E9;
	Wed,  5 Aug 2026 15:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785942045;
	bh=htrydqL49MOmkhv4g44vMe8zYius4v1wZkAqM+p5GfQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=hrwVbN5pLR7VWUC5m6PahjPZ1BwjJrHx7EZW93iV+kAb7oBw3e4vShKY98oibs6Ko
	 11vep1Ayev/C/FAJ+mvQFxdh97qprT5FU7dYRgKBiOHbJRuJpTvmiIecNae5ydW49K
	 lhkzqnssjOX7+k4E1zXZ8hFDigBYZ0/nyE/P8gKYvvrj4g30imVJhSI0IZ8ev5OMLb
	 mLqukGA0sdy4OrkL6qq8ghwB85vTHKDiD0TTmIZ4VVUt/du1IO28L0l84CBfiydL3L
	 bGzMI7nAbj0f4qwpTCveGWkDQY20aC+NXP6gQh/Qx7eeQFfJzRi2Vl5bfylpmMztdW
	 Y/5qkKVghaYSg==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Cheng Xu <chengyou@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
In-Reply-To: <20260730124357.12976-1-chengyou@linux.alibaba.com>
References: <20260730124357.12976-1-chengyou@linux.alibaba.com>
Subject: Re: [PATCH 1/2] RDMA/erdma: Hold CQ references when processing EQ
 events
Message-Id: <178594204272.4141286.8986915439047065650.b4-ty@kernel.org>
Date: Wed, 05 Aug 2026 11:00:42 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 30 Jul 2026 20:43:53 +0800, Cheng Xu wrote:
> EQ handlers look up CQs from dev->cq_xa and invoke CQ completion or
> error callbacks outside the xarray lock. erdma_destroy_cq() can erase the
> CQ from the xarray and free its queue buffer and doorbell record while a
> previously scheduled EQ handler is still using the CQ.
> 
> Add a CQ refcount and take a reference under the xarray lock with
> refcount_inc_not_zero(). Remove the CQ from the xarray before dropping
> the destroy-path reference, then wait for in-flight EQ users before
> releasing CQ resources.
> 
> [...]

Applied, thanks!

[1/2] RDMA/erdma: Hold CQ references when processing EQ events
      https://git.kernel.org/rdma/rdma/c/98df2aee1459ee
[2/2] RDMA/erdma: Hold QP references for AE and CM processing
      https://git.kernel.org/rdma/rdma/c/a52eeff32024f1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

