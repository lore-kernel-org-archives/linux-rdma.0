Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BEA4399F3
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 10:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801212; cv=none; b=qp2Lo4aceiHokjleth8DEbu8hZyObhXhZ2IDUDdtNMobhQ3UyGqzrOJAlN22dA4meaUlfog9Wojmag/nvn576abHuGm9sDFSr145gHqWGFKRrt0y8mi/y26VU95/7iLAdyUBS1x9oob1lHT4o3+fI267cVEM5PYg1AQm4X8yakI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801212; c=relaxed/simple;
	bh=EX6dIxoaDkFKpG3Ub8lxOZjpzcOj7LOYvzg/Fjm/BwY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Tzq5jQQ/MSprvJingWlKKPFw1nvjdUBUIefD0R0eqqOxg3FCtQJvHsk4yRJRwOXrpoZkf3cHfYjPaN2tE6psqXuzyMW+9L6IkikrBYTXuXHJIA05eX070QrzVyn3n4L1fmpknw64qYQH7g+nSSAOi22qxN0LObGRRsypTW5SLBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TBMa+1NH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TBMa+1NH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C76B1F00A3D;
	Thu, 23 Jul 2026 10:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784801210;
	bh=tMuGoovxoTK9HAhzIGf9gwJuY/g5E6GJi+rOPpjX8iA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TBMa+1NHCkkRA9U1WOgcD9PVNeT2WuRcznBNOQG+tzVfCxcp12TyVj2lW9+ooSKlY
	 nF3xEq4SgDinY8HXyPKc5k2ng0B8+SIEYqGb7MPKK3HiDbXfUdcMmFx/JwNCOA7OU7
	 Bt7RUQRxR2BE6yVMH8jHVkH4pbuiPxBZ9d7CB0Usxa13mrV7nYJkNq2FF1F2BHYCn8
	 OmuC40V9P/igPP136X3eI89TqjICBzKiQt4JH9t2d4VURgYcV7oNCb6ANaZgTQObzV
	 tdoFGaa/c0NtkrVtftIPFBSaS/USqMCKSue4oZfzi7mlFcWApOv11/hRoSvRyjiOgP
	 vRzQcbd3xA+dA==
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>, 
 Dmitry Antipov <dmantipov@yandex.ru>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
In-Reply-To: <20260723071845.568718-1-dmantipov@yandex.ru>
References: <20260723071845.568718-1-dmantipov@yandex.ru>
Subject: Re: [PATCH] RDMA/ocrdma: accept boolean value in
 ocrdma_dbgfs_ops_write()
Message-Id: <178480118756.3409014.326778239896391067.b4-ty@kernel.org>
Date: Thu, 23 Jul 2026 06:06:27 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 23 Jul 2026 10:18:45 +0300, Dmitry Antipov wrote:
> Since reset is actually controlled by the boolean flag rather than
> long, switch to 'kstrtobool_from_user()' and use the latter for an
> overall simplification of 'ocrdma_dbgfs_ops_write()'.

Applied, thanks!

[1/1] RDMA/ocrdma: accept boolean value in ocrdma_dbgfs_ops_write()
      https://git.kernel.org/rdma/rdma/c/66fd61fe1aa717

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

