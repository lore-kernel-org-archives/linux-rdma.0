Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AC437DE9D
	for <linux-rdma@vger.kernel.org>; Sun,  5 Jul 2026 14:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783260047; cv=none; b=rImMBC7zQRBDqHidjtG7Z7atLSzcmuCMxCPe13+QHpynX7YF7PAiv3+ZJMiMzwAaGd2Ayj79z4EukBkssmw50B5dxYrM07muRMiBTxMz6+itwPu0D3DIQwLLUce+blnWTPooYZbMevLICwscPw66nsZiE9WmMq49Mbvm+Ildvbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783260047; c=relaxed/simple;
	bh=88q0CT52rP5yiFsVvPXd65J7Rt6CNzCSkaSG6g7RZ0Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RgF/Ql0+JV6asJA80ErI1xL5+6Xbf5xIXnJaj579Am6e7almJbLc9P+T1YEmbmgjmtc0AROVy00zlJDk6SKLOmnHgwAhM8i+pLXIg5C2Eg+9pRAWgBqWGPAMt9wQ/1fgllbnjZvfxlY3JTvR41gqBkLixOlgJ4kpLfHA/3+hJEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZ0fMYCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZ0fMYCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33881F000E9;
	Sun,  5 Jul 2026 14:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783260046;
	bh=Ab02AgEenhGfM5mrwuZ3/PPut0V8eLAX6fHcwOw0NV0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=QZ0fMYCVbN5A6F8HCP1XS1NOV5d94CeQ/fTrrPSvBFvCZRhCFc3Ky++Mr1z9zHRWu
	 EENVL91v6RXobBZrmuBAnEPA+nhX+9P4CsTrW/e4/hbxRwh2mTRDVd4B59ozefTP9o
	 oF4BcOGx3sB/v+GW/Qqo7K1l/lL94/3s1kcNZV5BxyHC+J/8QFK46RNYe95rusoLRz
	 qYLCYP+BUHg6Ol+a1tLIHKTvg1KdrOKTqmN48gK/UA7vc3RMP8+t/3mPTux/d2bAaW
	 VEMNPoiskr5S0/XvS4301vpx/z5kUXwOfT5MCwqpBXHxb3F05/ryXgkYUtB9Zi8O6M
	 XJUPXjvfVPzJQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Or Gerlitz <ogerlitz@ddn.com>
Cc: Mark Zhang <markzhang@nvidia.com>, 
 Patrisious Haddad <phaddad@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20260617-fix-cma-ipoib-v1-1-03f869344304@ddn.com>
References: <20260617-fix-cma-ipoib-v1-1-03f869344304@ddn.com>
Subject: Re: [PATCH] RDMA/cma: Fix hardware address comparison length in
 netevent callback
Message-Id: <178299026931.607917.10072787718698047212.b4-ty@kernel.org>
Date: Thu, 02 Jul 2026 07:04:29 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 17 Jun 2026 14:21:05 +0300, Or Gerlitz wrote:
> The cited commit hardcoded the hardware address comparison len to ETH_ALEN.
> 
> This breaks IPoIB, which uses 20-byte addresses. By truncating the
> memcmp, the CMA may incorrectly assume the target address is
> unchanged and fails to abort the stalled connection.
> 
> Fix this by replacing ETH_ALEN with the dynamic neigh->dev->addr_len
> to correctly evaluate the full address regardless of the link layer.
> 
> [...]

Applied, thanks!

[1/1] RDMA/cma: Fix hardware address comparison length in netevent callback
      https://git.kernel.org/rdma/rdma/c/18313833e2c6de

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

