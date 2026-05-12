Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CD733F385;
	Tue, 12 May 2026 02:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778552142; cv=none; b=S86GrPTJcIj1ObAcHgAnEc/SvPLH0MUL0wFCS2yo8z+KuczbBo33Ogx10ZoSioIdkmHIO+4vHKAbzvhfdlBj3oDXj4fIv8zOCwkJ11q0sTMoOIixC7ZxycbbN37EYT2bbeF1ZaTYsWjP0EvZhHYVp5W7LDs3WQcMXytmY5jwwKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778552142; c=relaxed/simple;
	bh=68AgXR9l3iD8htL5MmuZ7szDZ4wVnTkPpaQWxaYENUw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DnE6S0xb5RWf6EM11vtQgs3MPV8ATj0pOXX0//WgK+1jM0LNO73D9wvwWOWSu/ASua34qOXc5gF1rqNpVwJvNIyD+teBYJYx/jpehHS/8DUfur2/ivJECNYsY8Yct+z4BGyEEzQfPl3lOPIlD8amjtYr2mhsqoRaPHcR5BH8B7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOEiMroK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOEiMroK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DF0C2BCFB;
	Tue, 12 May 2026 02:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778552142;
	bh=68AgXR9l3iD8htL5MmuZ7szDZ4wVnTkPpaQWxaYENUw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DOEiMroKHpEciOw3vS9D9AAWrZiehmHYe2gHXGL55TgMf2BUVfi9kkZiRxJAxdb5e
	 dz9/E0e5P1PM6kxs/FS2b1qemoOI+8VWaCSgwZgyRvm6OpqlaK9qJnvKvtdkc0tGhS
	 w2FiPOipQEZfqU0EfCEgINF3q0hFlU+lnH1jEFoD+kG6iUaK9sDdNUh9GSCCPkbM1E
	 PTBpP6FWRaqezZdo/xpnkHzyrtbP+WWu8aVgeHJc/g/5836PnKm2nJo37zB+HmpA/Z
	 bX3o437jObQyZ0A2RqKrymC7fQzb49g2bX6GOPo1hZG1RsXkt8FC87dgMLbMZMOMQF
	 rS8UWJUdltDJA==
Date: Mon, 11 May 2026 19:15:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Konstantin Taranov <kotaranov@microsoft.com>, "David S . Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Haiyang Zhang
 <haiyangz@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>, Wei Liu
 <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 shradhagupta@linux.microsoft.com, Simon Horman <horms@kernel.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 0/6] net: mana: Per-vPort EQ and MSI-X
 interrupt management
Message-ID: <20260511191540.630e09b3@kernel.org>
In-Reply-To: <20260507191237.438671-1-longli@microsoft.com>
References: <20260507191237.438671-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  7 May 2026 12:12:31 -0700 Long Li wrote:
> This series adds per-vPort Event Queue (EQ) allocation and MSI-X interrupt
> management for the MANA driver. Previously, all vPorts shared a single set
> of EQs. This change enables dedicated EQs per vPort with support for both
> dedicated and shared MSI-X vector allocation modes.

Once all the AI review comments are address / only false positives
remain - could you pop these patches on a branch and add PR info
to the cover letter so that both RDMA and netdev can pull this?
