Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264DB4CCDDD;
	Thu, 10 Sep 2026 15:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789053361; cv=none; b=DfIjD41Gn69yndVEa2266BYobyFX5Zc129rrzU4NhUgEXI1MLXcqqNVz2a6WUkl7wP58Ommo9g1oKXqkDT8JB8Ov/FLZlNabcah2PdL3KPtOjlFT6ID+P/oo6z8C/1m/GvtX04cNPp6NSZ2KWNN48eiPlaN9xf0JqBOBmnTOQMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789053361; c=relaxed/simple;
	bh=Llx7OXwXz9E6PzJsHJa4BIKtenImRD9pReN2hvcAF4M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bS8fbm7t875oKNzmrRKtUOlMh84XQ7nJMWOyg3eezlAW68d5+xkAB700FQIBrc6mQBdbkQ0hqesF1Fdf/fffUUFFtK9QdVOTHO2T+/AfmNqLT6ftsKeVkyc1t+xzVeOxKctVDbYpntRgM6rWLxgbpG/1jrTQiNqflLpgK55BgSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FvFlHbjY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvFlHbjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790DF1F000FF;
	Thu, 10 Sep 2026 15:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789053355;
	bh=+cooRaiJn8SBRvN7gCCaIPOlBpE7d5a6lvwi2Hd5tUM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=FvFlHbjY4CHCIHAcF0hOq5AhjZrqZglX1mQKPoKAh1eoKBkygp12O7ke3vLGD29RR
	 X7n1nAHRZNqnrN0BITqPE/4tiayu+utuv4eXmc6pxh7okhnuelrevxt5nyB523zEtY
	 OSlStN8h3iFvglEfselX5qqtVJfv1k04RfM8aRbGmZYXOGUpNHbfItQyA/GFW51iGk
	 8ctOtJMhNh9c+VJeA163HpemObGLUOfaPDLgu5y6XDU0MVWmYEGeAllf2+XkTWq7tA
	 0dC6drui24ots8tjLQyASIyYbBi6CAksxP9HaMjFAeGaOdPIaaeDX/+dgV13erwwoo
	 kDdb06fWJkQxg==
From: Leon Romanovsky <leon@kernel.org>
To: bernard.metzler@linux.dev, 
 =?utf-8?q?J=C3=A9r=C3=A9my_Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
In-Reply-To: <20260908085520.1746329-1-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260908085520.1746329-1-Jeremy.Jean@oss.cyber.gouv.fr>
Subject: Re: [PATCH] RDMA/siw: Bound fragmented header copies by the
 remaining length
Message-Id: <178905335219.346872.13841177617054824107.b4-ty@kernel.org>
Date: Thu, 10 Sep 2026 11:15:52 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 08 Sep 2026 08:55:20 +0000, Jérémy Jean wrote:
> siw_get_hdr() can receive an extended DDP/RDMAP header across more than
> one TCP callback. The first callback may receive most of the header,
> while the next one still limits the copy to hdrlen - MIN_DDP_HDR instead
> of the number of missing bytes. This makes the destination move past the
> end of the header and overwrite the receive state, including
> fpdu_part_rcvd. A later callback can then use a negative fpdu_part_rcvd
> value as a copy offset, which creates an OOB write.
> 
> [...]

Applied, thanks!

[1/1] RDMA/siw: Bound fragmented header copies by the remaining length
      https://git.kernel.org/rdma/rdma/c/9ff797e516dbc1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

