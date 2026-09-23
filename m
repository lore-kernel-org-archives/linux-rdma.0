Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED097495AE9
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 10:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160018; cv=none; b=ndJuMb6dW04tHugQDBrTGBPJ5DoQte+gFu0DkRk3S38zt+STKH2ahAWGJIsptOmKUUtu2mlHqQwZ9WRh3SflY/sFfxU36TDJRkzwN+sOgowJZkBL3b5NEAVeKvR2fNWIhWmKnQRyIs94MrjQkvPEPpmdh+2LqL6oPG4eGMgFmnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160018; c=relaxed/simple;
	bh=AKWPTnCYfFmzshj8BGIpHrggqdS11Zq5EB6dOCs7jcM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bOyiOCtExiBMRVPWntE/LAj8DYdsVq4iuT/iOfShO4h3SyU2qf39HVnqlvkDULB3e1vii9vB2blhFdSt95uHZEUrvfNs8PDxcHDTEN/aYfhwM6+qtDhOeFYCh25I7mEamPuGtUyg9JVaOqTPOv55I72LxO/Jr7Rl5sABGA4NnDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bx49Q9Fa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bx49Q9Fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAAF1F00893;
	Wed, 23 Sep 2026 10:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790160009;
	bh=baZ0VYcFOQOU638DUYm+WJiCo9F7vi6cI2D0zqizKR4=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=Bx49Q9FahOX69nkt18HBnyuQPiL0rYIRCQ9a5EGjckjSRMt/uzYjuRVveQcIsjjag
	 ld7FWhEI12Oz+T8TqgcuB9R4sUl6lS4PyrmrE+LoMZra/yZIjdeM2RKCzaJfz5/m7c
	 Re6mA653uVH3OyxHv9ZJTycG2FkE/UHQuo2TInJ4c+b/ntY0tjUVv9Sd4X257U44zQ
	 1hSisJLPEnJpikJsF1VMLZ6sE3AhtrtQnEZofaxdU7ieHnoPKctNfKBWem+awuMauf
	 RKCjIRbQ3OQi9G+9ttFaVzf469fbh4pnarEJwpvSp3/zFvA4t0hF7yg/PGdjG+iu8c
	 QFgg15KE5Ygzg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook <kees@kernel.org>, 
 linux-rdma@vger.kernel.org, lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260917052012.2181-1-lirongqing@baidu.com>
References: <20260917052012.2181-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/multicast: Fix rb-tree corruption on MGID
 reassignment in join_handler
Message-Id: <179016000721.3399728.5791117560056824769.b4-ty@kernel.org>
Date: Wed, 23 Sep 2026 06:40:07 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 17 Sep 2026 13:20:12 +0800, lirongqing wrote:
> When the SA assigns a wildcard (mgid0) join a concrete MGID that already
> has a group in the port table, join_handler() erases the group from the
> tree and calls mcast_insert() with allow_duplicates=false.  mcast_insert()
> then finds the existing group and returns it without re-inserting, but
> join_handler() discards the return value, leaving the group erased yet
> still alive.
> 
> [...]

Applied, thanks!

[1/1] RDMA/multicast: Fix rb-tree corruption on MGID reassignment in join_handler
      https://git.kernel.org/rdma/rdma/c/d1fa82ef992bc1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

