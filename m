Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088F03D2FE6;
	Thu, 16 Jul 2026 08:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191374; cv=none; b=nYPOClfuS7KARbbHmV8r8uY+qL1bulusta4OPDXsNJGlUqfemj81f3dDSHZNGf3XcOI/QPnPE0VQ5ZL/rrQuC55zjj0xJrFSx5BmcgUgs8I5KpTfAQB/RF9u5ODmtSg7RcakvgkyFqRDtw3xE2frRLTNlQchuh0nVt3rQ8dp/vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191374; c=relaxed/simple;
	bh=mO1ugmJMOIgDvwuoGXBqJLesL2L2+cfgVEU6JNPjrdI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hFpUT4OA1TqqH2tWWsF2lCiqFSzwZ2Z2FZk2mn2nHDEvhB1Y1Mv1H5pMHl8tH8kc/b+5lrldd4oN3JAgskTWVgq6JuV9luD9+iNmK2VO0kksFQhfr54ZMV1F8C10rV22bpLz/a6iluOjd9bDhtAiRRKGzE3eu9KIkUKdBX2B/k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gp/cyVJb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gp/cyVJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E23C1F000E9;
	Thu, 16 Jul 2026 08:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784191372;
	bh=EMzqKP1/SRJEhxF2BAlQCy7KtBfz5+Lgc/jGjP09H4o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=gp/cyVJb6uafhQ5PogxpH9DaFweHMk1XVCgjhNbh3ebRMrK0GjJ6NaCKbz5Ssd7az
	 h8QaFAGzlwtVP+52L1z07E9ywedlDw2MmKWu+1yLJa0mp2tUFliizJLQuFEIsINhmv
	 xE885Goo1gS4TVOdEJplM2MhC/EexKPCBfUgVTFjqK+9/5YL7EvrWIpakkSuoG5pNH
	 TV1Yj5+Vq9OKNTcLcFuSBMz9djRp44lkEc26g0JF1gdaR2Hy15JjttZ8MR4KUdP5xP
	 1oJJMl3uGWVVeBYxVEtAc9bFadlAf+cBrEmBrAouokfDf8eR7IjDUQdUBwhhEcsSDK
	 SK5AIcW0ICnGQ==
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jacob Moroni <jmoroni@google.com>, 
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260714-fix-destroy-no-udata-v2-1-734fdcf667d5@kernel.org>
References: <20260714-fix-destroy-no-udata-v2-1-734fdcf667d5@kernel.org>
Subject: Re: [PATCH rdma-next v2] RDMA/bnxt_re: Validate udata before
 executing commands
Message-Id: <178419136985.300669.8668153347545684841.b4-ty@kernel.org>
Date: Thu, 16 Jul 2026 04:42:49 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 14 Jul 2026 13:50:00 +0300, Leon Romanovsky wrote:
> The destroy callbacks currently zero the udata output after tearing down
> driver resources. If the userspace access fails, uverbs preserves the
> uobject and allows the destroy callback to run again, even though the
> driver resource has already been freed.
> 
> Call ib_no_udata_io() before teardown so udata failures are detected
> while the resource is still intact, then return success after teardown
> completes.
> 
> [...]

Applied, thanks!

[1/1] RDMA/bnxt_re: Validate udata before executing commands
      https://git.kernel.org/rdma/rdma/c/36a29408795fe2

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

