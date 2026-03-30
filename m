Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157F13B5840;
	Mon, 30 Mar 2026 10:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774866857; cv=none; b=qhP+mDSvia5lcY1MwDLi5WZWVtxk4QRIEgPQ/nkplX8Uf7B16SDPYVifwF/vn/1z7XtQ+mf/otgry2YDW++GPNjG09nCMTsDj3TDN65XLSWoqUq31QdZF0tQXglbyKRsO3wqCKifcGSx5ko3wgh1YoZJKter19p4FxuqZ4TnToQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774866857; c=relaxed/simple;
	bh=sLEC/t54ohP5GpB79TBB7Jg6jk+rDwNg8TUVbkY6P1g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=PsFXRjooclDLCFvAoNCkPJTKu300qPAwCIKLkxwuskn5Fpw170rClCnln5w9n/ipFVNomXq4PbhQXKmHnaYWbcAhXH/rWKTUqKP4B1euFfwr4Re0D0icw7ZInQnsqKJZdcysIkccL5qLHUmW8pq3HYUW61HkUtSqkwQXodMoZL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EoesIubE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EoesIubE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4328DC4CEF7;
	Mon, 30 Mar 2026 10:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774866856;
	bh=sLEC/t54ohP5GpB79TBB7Jg6jk+rDwNg8TUVbkY6P1g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=EoesIubErzTJI0fwv29cuCP7OdiWXEmoaXWU7ne3KZ6pIy00gycbvxBkF/yrrGs1w
	 mY1JLcVZen+XbLm4iFnlcSImqsETSbqSQxb5Q2CQZteaJkR6d3iJic+UMdrXzakuT6
	 LIxfaYg7ae6y4OSXHRtwq7xFSDmcdJ7/bHsdqrh8/m0l8842kKkIUkN8Jp6gEnNJDJ
	 ZPxUekfXKcZIWdREHU3MVdIiZ5wrLiJFKuXsTWgqwgIH88Yk0Buk2eFV5Xhe0BL4AQ
	 RiKswwX7t/ARPFUYIW/ziRoY0uhIzXH2n/dSoBjg45JiDY48HWYPxx+tDJOkbKonFM
	 w5vDEgnywA+0Q==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Michael Guralnik <michaelgur@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260323-umem-dma-attrs-v1-1-d6890f2e6a1e@nvidia.com>
References: <20260323-umem-dma-attrs-v1-1-d6890f2e6a1e@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/umem: Use consistent DMA attributes
 when unmapping entries
Message-Id: <177486685365.3787384.18151233008605317373.b4-ty@kernel.org>
Date: Mon, 30 Mar 2026 06:34:13 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 23 Mar 2026 22:10:18 +0200, Leon Romanovsky wrote:
> The DMA API expects that mapping and unmapping use the same DMA
> attributes. The RDMA umem code did not meet this requirement, so fix
> the mismatch.

Applied, thanks!

[1/1] RDMA/umem: Use consistent DMA attributes when unmapping entries
      (no commit info)

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

