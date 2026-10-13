Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45E64CDA31
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 10:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791888784; cv=none; b=gq5trIWbVXleEhNb0iBY0xLdRTTwtFc9r1RBvzregqe7ZqVMQcMER6Rqy9EE/pc4UN1zVBHCym+bsxqDbBwjjxQ65N72nqHbOcsPF26QVwwiZ0cdPS43EVQahRkiCHkOXs5QHMaOHi9aET7FzxgeE3oIzM2hVVdxg8vBrNAKZa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791888784; c=relaxed/simple;
	bh=rLfTLGJeVsfaNrd/K4fePy7zF90sflbkQUVnjXaVg+4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hAMGbog8ArtTfogpAReqNAeGYfydm/bRHnB389+RWCe//JdCQg2xhRiLwOzkR5LlP9mAX8I6e930hoAuBZD4gBquhT9H0d/yEXSXDfAYMy5fcNakAuP7sPxJVAg6V2ycLpkLyyROggad65HMDWzihNyshUat9y8UZTwFmYOVUBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inrLj+oJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inrLj+oJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC9E1F000FF;
	Tue, 13 Oct 2026 10:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791888783;
	bh=B2cKiGFVsNzeY3N0LBd09AWiOcJowlpk9eZaWmLy0s8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=inrLj+oJiRPAyC0yK9oGgMQ1dD4USchyqotpBJUx9BBxTd+yN+1NOGKHpQijmnmo2
	 A1//+cdi+oTp0v0lbn1TtwRTM44ulLD5hYFz5thquj21a6QnhPioZUnOhFkuwnTEWM
	 Hrm+S6CUtJZ6keOWPhqHk79DRiSLN0t9h+c+8SvFvpIIm6t7iK3k7Hb93VCx0wBGQr
	 kqwOdd9eoCWV8oiYHrbwBocaJwzKJ6kPr4PHjPuI/z3U0NuZ8Vxa6LswQ51Sbs+bN2
	 RDLihUFLREpumOU8qsEbsnUx5V6VtF/hJBMHz23xBm6XBHvsIhwh2OqFY8ht14rFO5
	 p1osPtCJ0LzWA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yonatan Nachum <ynachum@amazon.com>
Cc: sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev, 
 Michael Margolin <mrgolin@amazon.com>, Tom Sela <tomsela@amazon.com>
In-Reply-To: <20261012165113.576899-1-ynachum@amazon.com>
References: <20261012165113.576899-1-ynachum@amazon.com>
Subject: Re: [PATCH for-rc v2] RDMA/efa: Fix race between admin command
 timeout and completion
Message-Id: <179188878048.2091840.5826055837403701421.b4-ty@kernel.org>
Date: Tue, 13 Oct 2026 06:53:00 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 12 Oct 2026 16:51:13 +0000, Yonatan Nachum wrote:
> An admin command that times out can race with the interrupt handler
> processing its completion, in two ways.
> 
> The timeout path releases the completion context without synchronizing
> against the handler. A handler that has already seen the command as
> submitted then copies the CQE into the caller's response buffer after
> the waiter returned and that buffer went out of scope.
> 
> [...]

Applied, thanks!

[1/1] RDMA/efa: Fix race between admin command timeout and completion
      https://git.kernel.org/rdma/rdma/c/2e0df4424434f2

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

