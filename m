Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8EC3E7179;
	Tue, 10 Mar 2026 10:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773138243; cv=none; b=E5jSE0YTW1Mxh7OfifjwCnLF9vk9gtjJOPTdHOR6RoIiOt4LPC2v7U6CYSTcTfSPFWp74CNyCE/X6pSkIESxP59sS3OEae3efuU5IsCfwIFgVmaL44Ullr8mS7jet4WPgPU2Lg13OgTIIMOrfKw23Azlda//1yEaLHTVH/HVvrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773138243; c=relaxed/simple;
	bh=kwFXB5h+26+wKhRTkDbqUEIzNw81Buq2D4DfKRRJ/zA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pJKy33ZQGdNoJkP4ljPzUQjXtjJT6cqDwB9asnH4IesYmFz9CHSNPR4Gj/xS9ftgbscOXFas53izqP7r+5xjkRsQNBNcCn4FC+XuhAgYt8Ep1A8OeeHCb0QEryNRegPeeAvHG2ESdA9pH6RJ7UH2StUFii0Zny0OOG6h8nlWjb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KsIWpvXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KsIWpvXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5931EC19423;
	Tue, 10 Mar 2026 10:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773138242;
	bh=kwFXB5h+26+wKhRTkDbqUEIzNw81Buq2D4DfKRRJ/zA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=KsIWpvXXvBKVy3wOI5ri0g8qzzODqahpvyBYb+SteatGZksG9naW11F0Mrqhjyfp6
	 Cv8wDvt/4XDxJJmZw3m17F8XEpc7wUYbYDhkJ3tK29cgcJ44+4rfuFe9wVQgQvLy16
	 f4nsN+uFTwxxsdvg9Dqa6pNqqM6981/FdDHqu+mlQCp9reHTfOF4qEX6JoA74LaSAR
	 kLpXYM0U8ieOu6Kx5KOBo1cWjjEbekT2M1OEf3PZuueoRqMClPYTpWr3yzITAnRHTY
	 jpt0xWRiZ1uczO3Kmfg8aLHC8onO1W2jN7C/V3RkhN7M6qHqqG1PaIZuFYkUpstlO0
	 DfFyBoylc8g9Q==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, 
 linux-hardening@vger.kernel.org, gustavoars@kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <20260308201419.5260-1-rosenp@gmail.com>
References: <20260308201419.5260-1-rosenp@gmail.com>
Subject: Re: [PATCH] RDMA/ocrdma: kzalloc_objs to kzalloc_flex
Message-Id: <177313823979.1685265.900674781014280960.b4-ty@kernel.org>
Date: Tue, 10 Mar 2026 06:23:59 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 08 Mar 2026 13:14:19 -0700, Rosen Penev wrote:
> Simplify allocation by eliminating one. No longer need to kfree pages
> separately.

Applied, thanks!

[1/1] RDMA/ocrdma: kzalloc_objs to kzalloc_flex
      https://git.kernel.org/rdma/rdma/c/353b3bbdb2c43f

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

