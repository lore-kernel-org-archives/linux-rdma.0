Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B7749B201
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 11:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789470994; cv=none; b=Qh+aTV+VoSR7mzqbFxIspb/BwGappJfUQPfugUOfYTgtZrYyxrTJcl277oK/VAFoOtPRLLz2Swsd91NRPvSKBS6nA0CsEXoHTPq6/oaN3dKBpETFbLchzAxEfHh0wPMuIliHT2vN+M/tQUvCyX/7hzqk6YCAOTJCLUCfpPDEQN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789470994; c=relaxed/simple;
	bh=yRgayEehfplI/nzGlBaCQkCibM+F0mM1emO3yMcI8H8=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bvwLaZEwY+d/OStGu16l+RRPTvrPxICAX4yve9ZxpmIewRa8VtKRl/xfMAzZnwtHdwagqvprrQ1zkRN/Pryvx9y0NejkV/XXIC2bbNoVM8GZidGAC+SJyffpPXUm1j5F80YBQl23xEsHOjXZgN4SPDB+3mvC2iRPzviraR1smSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gfdt8l+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfdt8l+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE821F00893;
	Tue, 15 Sep 2026 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789470993;
	bh=VO8QP/bwTO41dWFYu2QAwoLubLaZtl35r2Pe0rVMmfk=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=gfdt8l+yWbyVUX4EA4yzN91Ny38LhD1R/V1DC3202VmPyOIAK/tYlPaQ0ri+QOJAu
	 IODvUu4NS+gkblXIoxytXz1ZVcgDPV2qHkG2P9xpjrUtS9ME1sgT7qkPFshWDqG/F7
	 9gjQ4nQa01Rv+5ct8NvAZUkQc44bT6msNCl6P32nzi9zBm8G8ck0eOzdM/T1H1Q9xU
	 5uVUoLZt20AYLpUi971knpX3FWeI0DuZAL57QwhWKPLupoMqYlMHoid1V8fMlIQGN2
	 UMbwiPzxUSuUMQIYCwXJ5UZ0Cio12/EsKRnBXPgJaypkaNjdT3wOX+kytLVXvc/bAs
	 kE+2tYH9ZulPw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260914121253.2193-1-lirongqing@baidu.com>
References: <20260914121253.2193-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/mlx5: Print err code when create_qp fails
Message-Id: <178947099020.1230106.14053311297942379715.b4-ty@kernel.org>
Date: Tue, 15 Sep 2026 07:16:30 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 14 Sep 2026 20:12:53 +0800, lirongqing wrote:
> Add the actual error code to the "Create QP type %d failed" log
> line in create_qp(), so failures can be diagnosed from dmesg
> alone without guessing the underlying error.

Applied, thanks!

[1/1] RDMA/mlx5: Print err code when create_qp fails
      https://git.kernel.org/rdma/rdma/c/8d946772ce6b33

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

