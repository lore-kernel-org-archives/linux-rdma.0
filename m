Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5933747F3C0;
	Wed, 23 Sep 2026 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168722; cv=none; b=b01xqFWrFMdX6P9PxABGdKpDAIE/ZRg5KeqpDBzcS9fcukvFIx0TjI+etomY+G+OeNgqkKnqCJ3oi/Mf2MHSeCr1ZrVHpLr9tlx54+Qw5qtntWF33lqFHzWPY2sBXvz0fQoxOa/zUKDgnP+eFHHGBhy9452EYRtwS5HS6xOJRzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168722; c=relaxed/simple;
	bh=IfZ3++Ala8i9MKBME+qBpDS65W4FSS3sOo9VXM6+uFI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IiuRJLh/95LiXcHs/JIqBnphBpMRepXMVqDqV/KNOVHN8gQ90DSPOQ1ssKnNV4SKGP9mYDUaJsf1RRT3U10EP7GolxqDZw7WQ36koBkyZntB/koQucBnZtjIumb5RvPasQZIf/Q41cOr8rKbDY5ir/LTVjzJuRozUmxEGB9B3vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=op76lwDY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="op76lwDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F111F000FF;
	Wed, 23 Sep 2026 13:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790168720;
	bh=GzpNsFO2GDCBmu+yrHExxQQQEd/D4ol2Bp7U+w3FvRs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=op76lwDYBbBb+1MWJ2n6ETkdVkC+aTLZ0DCKbPCLpo3AxZy8fDTKawZgAY6mLFRXr
	 BpcOzjbdS8U1ZMYj1yTIzS/I7+Ln6WWYMN4O48aHLVDhuJW7IoNUTicephoyENO04q
	 NkhkmLLxgc4vBgjRdZpqMhcgRIhDD6s6vEQkzZVm2HTO4XYxDvLEwxRxpiEygqMmZ7
	 f+MsUUrOjLTxjeCnf+CjTTkHrA9YLAbBQtpXpcR29bqTR2usVPfcAdAwtOfurJnJPA
	 rWjeW90oWzRYAqfvev99TWL5Si4z0LNwWInxXRxpzqIrC5aMwmAtwOAabBsjnwVp94
	 QaKBcQ4zamuCg==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Serhat Kumral <serhatkumral1@gmail.com>
Cc: shiraz.saleem@intel.com, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260918110428.36586-1-serhatkumral1@gmail.com>
References: <20260918110428.36586-1-serhatkumral1@gmail.com>
Subject: Re: [PATCH] RDMA/irdma: Free IRQ when CEQ vector mapping fails
Message-Id: <179016871798.3414676.5264199046634538106.b4-ty@kernel.org>
Date: Wed, 23 Sep 2026 09:05:17 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 18 Sep 2026 14:04:28 +0300, Serhat Kumral wrote:
> irdma_cfg_ceq_vector() registers an IRQ handler before requesting the
> CEQ-to-vector mapping through the virtual channel. If the mapping
> fails, the function returns without releasing the IRQ resources.
> The caller destroys the CEQ, leaving the IRQ handler registered
> and potentially referencing freed memory.
> 
> Call irdma_destroy_irq() on mapping failure to release
> the IRQ resources and drain the associated tasklet
> before the caller destroys the CEQ. Use the same dev_id
> passed to request_irq(), accounting for CEQ0 sharing
> its interrupt vector with the AEQ.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Free IRQ when CEQ vector mapping fails
      https://git.kernel.org/rdma/rdma/c/df1d75774b1284

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

