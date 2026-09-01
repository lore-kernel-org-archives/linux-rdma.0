Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86D2470EB5;
	Tue,  1 Sep 2026 10:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788258810; cv=none; b=N+/1oYNFrTAN69ZpM5B5zXitYuslVFZknQqMWqDAdbgXm8ZaA/UITnE9ftu3/YdJw0qQ4HgcHbmIG7FRzrhJ+537sypqBf1oSsG01G+osbUbyHxEa3lHX1WqsCj3b0vCd/8+RjBVgtPAEXKEX90nOuFoBR17ntFxe3Kap4pIXjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788258810; c=relaxed/simple;
	bh=lCLS0TVm1RpDBkHd3jhdYxYBBx13N8jaQjlaR/S9zZM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=naTgR2fVJ3KCwIhja3WpKLlyMVdOyJuTkeBzKWiqeiYArLVEAkCPBveLPOvBO0IWQoq0UXWpMcUm/udazTp3NJRjnZc4RiA3Gyeqb+xOjATGX6M4H5vk9FhU30+k7j4XgDEeiM3vvN9I78qWbvF9WQSFuFgwLkMLungGYLEZAvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPC+6HWu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPC+6HWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F1C1F000E9;
	Tue,  1 Sep 2026 10:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788258808;
	bh=8xAF/APPy/kREiKW8PaOl5qBTlu58K1/wYA90LimBu4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LPC+6HWuWe9CWtyQG88hBToDSYWa/xU0Xv/tLStsHLOK3Sw7fEo/W9qsIEAeb4+rh
	 qfFeeBFoa7Z/hVQuA23Elo3cMzuOUPPsUSq53ysOVUk6Xy3ZdPj2YjAPsu2enYHghO
	 VESbSkqty8AKRof0iYloGyB6zxFkrtEYz/+TRqlmEwGrXXKsKB2q2VVokDdKulwduG
	 zzRPzrOaHKyU+Hx7SnDtvKnU9DoFonX1T8EBOIsqjRUUJz+iQra7FqWzn/Ry02/2t6
	 XqFrxnF3ATt1Sh1TPO6NEn37+5kAmHzH5EU1cb/JZ6P9VCieJY1/Z0jMSr9Qc0d4kh
	 ToR9DxHMMZXIw==
From: Leon Romanovsky <leon@kernel.org>
To: Long Li <longli@microsoft.com>, 
 Konstantin Taranov <kotaranov@microsoft.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-rdma@vger.kernel.org
In-Reply-To: <20260831052108.903019-1-ekffu200098@gmail.com>
References: <20260831052108.903019-1-ekffu200098@gmail.com>
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: Remove redundant NULL check
 before netdev_put()
Message-Id: <178825880566.1161349.7028916760752685356.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 06:33:25 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 31 Aug 2026 14:21:07 +0900, Sang-Heon Jeon wrote:
> netdev_put() does nothing if dev is NULL, so the check before the call
> is redundant.
> 
> So remove it. No functional change.
> 
> This is the result of running the Coccinelle script from
> scripts/coccinelle/free/ifnulldev_put.cocci after commit f83b8a58695c
> ("coccinelle: ifnulldev_put: update outdated helper names").
> 
> [...]

Applied, thanks!

[1/1] RDMA/mana_ib: Remove redundant NULL check before netdev_put()
      https://git.kernel.org/rdma/rdma/c/2f02eee8d632f7

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

