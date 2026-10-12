Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE5A4D7D46
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791830488; cv=none; b=lj7XdbpAb2v/8X6yVab2JNGHVp5pwIlZoPCamygE3SSoUEK5CpAFhL8fTD0cydpW65aJBF52sSDjdRQnxgQ4c6FCCJ2sgUjSEdPf8l/xXhcY9kp9t9QU5DAuSJsOrqlz3shmNu8RkYRmZR40QNoAzEcKhd1Xnblg4N+aFXwrIy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791830488; c=relaxed/simple;
	bh=CP5M2dNp6vy33mrSyJMFz/g5afMVKcxI97inwKhfhzA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kp/flEqHlcQmJDBxN0sLIimWsXyI+ThXOWGbPH8sMAj/kmSPKj7f9sbJB2yzf6eJ5tHyTXilGn2qQkqNRVzYmDsbB6S8fIBYXh54ab37rOVTOyw4FXcMhr9pjuYkW2Ss6ZYh0BHn/cTrpIDje6jamSh+kSToiib8Npi5hTaq6fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aQiyvNkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQiyvNkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D96A1F0089B;
	Mon, 12 Oct 2026 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791830485;
	bh=0bX3pWj6uxNRorAEXZmlKkLwP0XC+/51NjVFCqjQpT0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=aQiyvNkZrqT4qIf+oSu++6xXdZh5/xhq4sfGxJUHV/g5Y1Ah6UHZCgcNvbfGMGXxy
	 JzbKs2QCGNzBEOhpgs9oSW90BE0ndEbG1HosutlDzsean0hssiNYLt0N4vgh/Kus2w
	 8XJcw/iZ8bmIMfSkN60Hy7Qd1zukHE30bGhcKkix6hhW36EjZ7/6ybteTvceT6/hDq
	 dcaU2VKOo8i/v54rTQlymaOenDefAUNRwCN4qlgMHpjpZSkL3ts6zCQwwwsUjVuxzC
	 M8gS6218AxVCz68DGQBUYvmRIAErBP4rZaF4BeP+wZKwU9mIvHBWryaVOR/g8u5iyB
	 tGGH8KMDhE/2w==
From: Leon Romanovsky <leon@kernel.org>
To: Bernard Metzler <bernard.metzler@linux.dev>, 
 Haitam Lazaar <haitam@lazaarsec.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma <linux-rdma@vger.kernel.org>
In-Reply-To: <1a12ad1d83f.19cd98924357428.7073029566232810804@lazaarsec.com>
References: <1a12ad1d83f.19cd98924357428.7073029566232810804@lazaarsec.com>
Subject: Re: [PATCH v3 for-rc] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for
 read responses
Message-Id: <179183048228.1683418.3661711247940249935.b4-ty@kernel.org>
Date: Mon, 12 Oct 2026 14:41:22 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 11 Oct 2026 11:55:57 +0000, Haitam Lazaar wrote:
> When generating an RDMA READ response (SIW_OP_READ_RESPONSE),
> siw_check_sgl_tx() unconditionally passes 0 as the required permission
> mask:
> 
>     /* Reference memory to be tx'd w/o checking access for LOCAL_READ */
>     rv = siw_check_sgl_tx(qp->pd, wqe, 0);
> 
> [...]

Applied, thanks!

[1/1] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read responses
      https://git.kernel.org/rdma/rdma/c/39d3758108bb0e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

