Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB6C3ACA7E;
	Mon, 23 Mar 2026 13:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273422; cv=none; b=TU8Qf4R1A364Ff+yrqT4S80IamYxpTh3Gq0jzHYhzpw4QKG0f1Jf+DdY9UuLWfnsKPyb498uxdeGO9i7oHjyn9Z6DM9bgHj+brAAJP8CT1kAuqqwN+3Mq6KYKD1+2GKXLaqfjuf13SXby1YaoCWlfGIffwUZS+cO9gWrgkT2SnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273422; c=relaxed/simple;
	bh=2gAh46bnXzvKN6q6mWP0+u0mLvNWEaJFhp7X4eThwhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWBQO3R2PxcyE7yukIG86z1ECltk68PATvCnTRNO6tbO+K7AuDYow0qTomBDRBLzIv/63WoXOJ3uzfpQzWLj8SC1KMviaMAqM6JhiUTIU3H3FKcK2f68ipbm8Ue6M9m4gyBDZMKIRHG86VspRRiCgiSI2F1Fy9QBCDhXzo4Ij+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lT932sFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lT932sFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D686C2BC9E;
	Mon, 23 Mar 2026 13:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774273422;
	bh=2gAh46bnXzvKN6q6mWP0+u0mLvNWEaJFhp7X4eThwhI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lT932sFZ6P+WjvzQJxtSB3mBmV7Bi0HTTmUnDI2cZAJctN37xBFvuohOAZsmzEDy5
	 dwAOtsDBkoG2L6WlKVj0gq3czZ0LjqA99WGdgEKbNL9Q7Hji3ZzX2Zl1vnY+HIAtgd
	 y5mlBuYotGtfMC5tZT5LRXaSPkRcksoazSQdZHFZfhPE8JtKhbbT8UK6BSH0QiOiKH
	 UNxlL3IqmU2ez0ksrndemuTWrtt9QDgj4VCTGzpV6sGYs5sNxpjFyFPmwTEQsHtwdl
	 tr+lB/MlROz0SoJ/I3DyIyud7FBgi+gfGkPmgmKbEMTfqOAFww0tASflfkg8E1WsQ2
	 E87QO3G4R8EpQ==
Date: Mon, 23 Mar 2026 13:43:37 +0000
From: Simon Horman <horms@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/6] net: mana: Per-vPort EQ and MSI-X
 interrupt management
Message-ID: <20260323134337.GA69756@horms.kernel.org>
References: <cover.1774049761.git.longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1774049761.git.longli@microsoft.com>

On Fri, Mar 20, 2026 at 04:54:13PM -0700, Long Li wrote:
> This series adds per-vPort Event Queue (EQ) allocation and MSI-X interrupt
> management for the MANA driver. Previously, all vPorts shared a single set
> of EQs. This change enables dedicated EQs per vPort with support for both
> dedicated and shared MSI-X vector allocation modes.

...

Hi Long Li,

Unfortunately this series did not apply to net-next cleanly.
Which breaks our CI.

Please rebase and repost.

Thanks!

-- 
pw-bot: changes-requested
