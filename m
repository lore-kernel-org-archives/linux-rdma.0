Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739CC40DFC1;
	Mon, 30 Mar 2026 17:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774891122; cv=none; b=anf6V0CF0Hsco6BdfiNfM3mbAyKZjsK4nPsWUPWtamuguLx7NQt9uUqIhVSTdYbQZxRzYhBGgP78OGZ+8yizcRw6gi2bPrttmiPLmcE/zga7TZi5Q80BYcDE0dOg2Vm+52P5QPLusbi4eiCiTKmFRGkqXBUQmMeV5YWNa4fGQ8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774891122; c=relaxed/simple;
	bh=ndQto9udr35L7Pv25t6GhkNkta5ASsee84f+b99axKQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GBqbc3gyy/858A6WPMi9wMohchcMMHcq+32meMn0nB3VwOuRaY3fVRQW2QAVDjWyjHSt0e1w/rbW/a5WrD8LxCGhFy8El7HMOIEDQLVTHYtj9sLma4z373os1ONL87jH2WRQfdsg9P3zQdUokQeMb/23PMP0i7Itczi4gRkkOzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+HLw9v6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+HLw9v6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80557C4CEF7;
	Mon, 30 Mar 2026 17:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774891122;
	bh=ndQto9udr35L7Pv25t6GhkNkta5ASsee84f+b99axKQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=U+HLw9v66obNAq5+e+s0SWUDUpqGufH3ACQeeCh/Hu5RT1awvoY3eSusvyYo2tbYV
	 QDjCZY97v876wNZ+/xw9exfYyrGeVsamQWTxnY2h9xv4gpQbL/F78ZrEhMF5kgb+Gf
	 Sbl9bhzsoJ0+GorFY99319XxEMsvQ5j/4xuyc+iDrHyiPc6BoLpIZCf8GcmiaWCZTu
	 nGK8uAKCIVIjxpjpJLDpCT6MwnL6TWqXDYR3ZmRogS7xNJEXGrN1JuRGtVjUQ9bbbY
	 CTIhlu35ZQ9TlJ7Fp6vA+zli/FItG2HA0P6f9zOF5LttSSz//GJQGhNKzMZ5pG7Tn5
	 S4yiF3xUlXq1w==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook <kees@kernel.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-hardening@vger.kernel.org
In-Reply-To: <20260327030124.8385-1-rosenp@gmail.com>
References: <20260327030124.8385-1-rosenp@gmail.com>
Subject: Re: [PATCH] RDMA/core: use kzalloc_flex
Message-Id: <177489111890.3854404.9407326250267964747.b4-ty@kernel.org>
Date: Mon, 30 Mar 2026 13:18:38 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 26 Mar 2026 20:01:24 -0700, Rosen Penev wrote:
> Simplifies allocations by using a flexible array member in this struct.
> 
> Add __counted_by to get extra runtime analysis.

Applied, thanks!

[1/1] RDMA/core: use kzalloc_flex
      https://git.kernel.org/rdma/rdma/c/55893530ad19bf

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

