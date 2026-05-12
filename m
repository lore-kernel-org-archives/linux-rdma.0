Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3963839B1;
	Tue, 12 May 2026 10:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778583555; cv=none; b=UsOim06KaGgHlhDButYACvJ3Tq7QkH+lXh4EOuCJ/QVx9DaZ15WmpqfKZRpLEIpFgOTFJqCPRoyKrdY8WYtU3/PKgzGTA53fmxBbu4VYzBi9em4MfHK77BaF/sn5IeoVZXNwAgFLIXuY8lsIq9sG2/Hryym4t8Wf4RHvMr2n4PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778583555; c=relaxed/simple;
	bh=tO2Y2OF2rv/G9gRkrgKdxw/Nw3Hb1oN8LbISA3cFwYQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gK2KEgevUyorPV9k7dV50Nc8212MO9dJ35iXvDi0Dkr9KiLaEsmsuj3KonNF6wTyajb3yHnzR2a+2TKr0pIEfTZnRvQFtXau1hxUwCPHrYi/GO7mjme/PkGNAWA+Gy7oVTZjxO5zNjpN3VOrw4U/C6a+kfti0gckrNra35M5FjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hM1eD9Yh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hM1eD9Yh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47615C2BCB0;
	Tue, 12 May 2026 10:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778583554;
	bh=tO2Y2OF2rv/G9gRkrgKdxw/Nw3Hb1oN8LbISA3cFwYQ=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=hM1eD9Yh2iQAz2JExlHxSHBEePYOQY3JpT2/T/ryvRgaPWbqH8bP2VITUDo7ng25a
	 PBY4C4s66Y3G/kpwqDBvYRzDHtPzRB/CUpBEXMqVJhTUqcYT65vvrJKclFOs4jod2k
	 xw6RA2A2mgWPw6Oswj5Rcpg5VQzdHP61DEbWtz8M9DcBx9/EgQrB4JKGMcs4XCcjwp
	 1d7dP3jO74KweeSvwqiaAbOv8kFRC0nj2aEUVMBOPDkfuznf1+zGMY0PPv1cX+lVcP
	 L2hlHA/RuCdGSWU4u1dy8u2rRb0Dp9/W1mdeoXbsYoLHpXPbuKvxHr0ELdIJjB97rV
	 ce9gghQEyy0Lg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Rohit Chavan <roheetchavan@gmail.com>
In-Reply-To: <20260505100550.1810139-1-roheetchavan@gmail.com>
References: <20260505100550.1810139-1-roheetchavan@gmail.com>
Subject: Re: [PATCH] RDMA/mlx5: Use max() macro for bfreg calculation
Message-Id: <177858355179.2288083.241983764313287039.b4-ty@kernel.org>
Date: Tue, 12 May 2026 06:59:11 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 05 May 2026 15:35:49 +0530, Rohit Chavan wrote:
> Simplify the calculation of medium blue flame registers by using the
> max() macro instead of open-coded ternary logic. This improves
> readability and aligns with the subsystem's preference for using
> standard kernel helpers.

Applied, thanks!

[1/1] RDMA/mlx5: Use max() macro for bfreg calculation
      https://git.kernel.org/rdma/rdma/c/4d957f6055768d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

