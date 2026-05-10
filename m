Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8743A1CF8
	for <linux-rdma@vger.kernel.org>; Sun, 10 May 2026 15:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778428512; cv=none; b=FBC/v3WZDgib0QgyinowVWeeEpl+8vSE1UN5FiUtfpB2KlArLm9W2w4U3P6xo1Gk6tTxP6DM2YwMBFj9eoCjmr/twaoKbzUl246Bb5UKZMT4PiiXMu+uYGxaBFWyKqXEjTA6OWWjf0rapSvwqPq4ZP3f2sGtiBFm7erjzkwlwKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778428512; c=relaxed/simple;
	bh=hLeMTDDXIlirmObX4HXle+nkgJFIuu3DCbM3rIDaNzA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=VgDUR/Q66c3yN3bMfcAD5778aPLBV78LDwIPHq/IC0o5hh5xXEjs7sP1tY1beEt/F7rW+OEmaZ9VCvpZ3DOBXuATxbZNndekPzsW3b4mZRIX4ktN0WtLkVcITdF0P0IyFkk1keOCON7dpldi6lzAJYqTZ7q4UjmL0QNr4Wf0Aic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndf68iBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndf68iBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460F5C2BCB8;
	Sun, 10 May 2026 15:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778428510;
	bh=hLeMTDDXIlirmObX4HXle+nkgJFIuu3DCbM3rIDaNzA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=ndf68iBhnLMiV9CDDhGpEt//m+9yLXYjukJ97ERK+BLWk4nj5C5PtC1f+TL213q8x
	 kjeSeTem0PV/ACjCBIA8D+5rZwjqtzoOjBkE7pelyZdjHIZYI3G8fjf20i4xSphUed
	 VlBsRMB2+HftMoqeoxWPFjAcer5+lGmGXCL3EcvT6Pjul7B2Urg+kcZ5FWV6ke1m/u
	 cCrw30wHOKp/+iqBgS6fAIxhv4wHWV8TM/8EiV/cngj77o55faNGaTvwvrwIvzHRCa
	 Vf7/Bg4p6q6wXZCxZ9Edkeeew1gbULRy6DDGaCb/ctyC3X1cFoWh05ZalrszSlKA9S
	 RwH41TRhiMlfg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Chenguang Zhao <zhaochenguang@kylinos.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260410074046.2044595-1-zhaochenguang@kylinos.cn>
References: <20260410074046.2044595-1-zhaochenguang@kylinos.cn>
Subject: Re: [PATCH] RDMA/mlx5: use QP port when decoding responder CQEs
Message-Id: <177842850773.2062437.7010172559893275656.b4-ty@kernel.org>
Date: Sun, 10 May 2026 11:55:07 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 10 Apr 2026 15:40:46 +0800, Chenguang Zhao wrote:
> The responder CQE path determines the link layer via
> rdma_port_get_link_layer(). Use qp->port instead of
> hardcoding port 1, which can mis-decode completions on
> multi-port devices.

Applied, thanks!

[1/1] RDMA/mlx5: use QP port when decoding responder CQEs
      https://git.kernel.org/rdma/rdma/c/1a1ead4b27d3b5

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

