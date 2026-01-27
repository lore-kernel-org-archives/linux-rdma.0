Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4F924293C;
	Tue, 27 Jan 2026 16:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769531930; cv=none; b=pr86SZ9YZYovH9ewHSdhpL02ARVegoTXtcjLWBC4T3bhK/futXoVJQ1Swgh3uAZkpn56ZQFG/bQJCkB+kVL9iD+3fYDPJ4taQ/D2BgETBsx4Ogatsoa53XjHJcEXwpyDGoQ6u/5yarwUrt0WHe8RqikwQh7Buv1L2I8dFGfZ7kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769531930; c=relaxed/simple;
	bh=zoDQLNJENOWECUDOYKbfyfNKm69pcYtvOv1AMHGm9fE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rysGtrpDkm5WBcV5oCKli4LDjzKxfFGpWQZzL4TEXOnqaQWfti1+aLQCMPn3kkk3xbNrj/4fzMxHOXGpzOnG2OZTspl3OtMOIlt5CX2pdEy4/IF06OTeoV+ypMwhWk/uiOo2TM2R2LoAX8JOAuf5IynX0TAXXHhLZG2xWBBl85U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EW4UBuPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EW4UBuPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A5EC116C6;
	Tue, 27 Jan 2026 16:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769531929;
	bh=zoDQLNJENOWECUDOYKbfyfNKm69pcYtvOv1AMHGm9fE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EW4UBuPt+sQ4Fyj1dMoqFmX4cWEdS0+Z7An+ud6F9HIoQH6/MCszRaktZeQ8h9owi
	 T/vJwq+CUZ/cooEn93z2EG7ug1GHJhci4V+HpL5Qn+8XHCvp8euTwQjchJJxw5Y1lB
	 oLPs1ldKzbFWod+aq0Bsx4ysnDm9f9W28FPh8iU61LkQKqcsTcEImaVBkXZJjwZ/JJ
	 4ugb0y61uiqpdo6iZIsBMqLu/kpLVUOMwowIKEl71dH16CKmp/RNDNnCfCkTfP0cmU
	 9O4sTz1DPQpjFy3w8MkK+ShONJaN8CnLWzgWZImSmBYJp/fYqTIB8T6xhls/m3bIk8
	 YBhkMT1UY1WlQ==
Date: Tue, 27 Jan 2026 08:38:48 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <ttoukan.linux@gmail.com>, Kery Qi <qikeyu2017@gmail.com>
Cc: tariqt@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, jackm@dev.mellanox.co.il,
 ogerlitz@mellanox.com, monis@mellanox.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx4: fix MAC table total count corruption in
 __mlx4_unregister_mac()
Message-ID: <20260127083848.6cb04d0e@kernel.org>
In-Reply-To: <85b9a197-9957-4646-8f97-5aa4d90eb415@gmail.com>
References: <20260122183906.2015-2-qikeyu2017@gmail.com>
	<85b9a197-9957-4646-8f97-5aa4d90eb415@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 Jan 2026 08:26:49 +0200 Tariq Toukan wrote:
> 1. Commit message is phrased as an RFC, with questions and uncertainty.
> Please re-phrase.
> 2. Do you hit an actual failure here? What are the steps? What error do 
> you see?

Alternatively, perhaps, seeing that Kery is sending patches to random
pieces of code - please add a paragraph explaining what kind of tool
you used to detect the issue, and stating that you haven't actually
hit it. Please note that disclosure that the issue has been found
by static analysis tool is _required_ in the kernel process.
