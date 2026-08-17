Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E072A3A4F2F;
	Mon, 17 Aug 2026 23:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787010070; cv=none; b=f+gxiNXy8014dX8Ef7GfPLBtwHfjbSN41vA6JpwAJ91aJhett+0ucwBpJVM0Veec2SM9Mmu17VXq9S8FcMrSDh/6ZOLRtAdZ0G2DLRjFv3bYE85mHFYWEThy6WxXMZAUKJo+qB68cpnwy3WOdOi5mHNZ/tMklnM8VtthJJwfCrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787010070; c=relaxed/simple;
	bh=OIqFykbVmpRxnM8vPCamvdXZVYf4udsPnWW7tPJ2hZo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YNCJyzAM+dxjGyaG1/ub2eQb2bLWwu7lKjbdlcMHpq1oIa1ypWdP0zBx+OJ+2UlhsPVPhVcVPb4j+AGDxMTp2mrWkWbogcZwFeWRldG0tDUwngyCg0oSSAmmlGDA2ol9MS9Y3ffUOhO4EQvlKy7tRquiYWMH4NHm8SdwnNKMB6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R4sDxJ5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4sDxJ5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05091F000E9;
	Mon, 17 Aug 2026 23:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787010069;
	bh=kltHfNBZKgyTDetzWkUs7bPufZVsoQeU5dOPU0m3tHc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=R4sDxJ5tFEU6JIxfjYpoBeH+lQaX7XiLQOZziX+zWu1ZaYsTDuEr3o41QSPkem6im
	 kQJKepKaQOlQYrGfEFkqh4tD1sKULPItbc61gkOFOutw+jmXsZ+koJP3uswZNlHDvU
	 41Pr9XAQXFkRJmoE7Byqs5h0OeCVa4iinMCnuIR90Y6+Fj64cQfwGV0QFJEGnqGee1
	 hFALI8j4sEDPzqW0KCM6hgvPLiFXQkW0vjCJ1FgXXaZ8VOe1GCFLApdrc8FkvZfzJ5
	 +ddEIWQZVPKYkHtUTpu6PeY/AUUsgrMCnlUfgNZwZ7v/7F1+8kPNBSsgrRMWGWAHYD
	 kJOp8FmpUF0Lg==
Date: Mon, 17 Aug 2026 16:41:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Konstantin Taranov <kotaranov@microsoft.com>, "David S . Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Haiyang Zhang
 <haiyangz@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>, Wei Liu
 <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 shradhagupta@linux.microsoft.com, Simon Horman <horms@kernel.org>,
 ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/13] net: mana: add queue-set allocation
 and teardown helpers
Message-ID: <20260817164108.4b047ec8@kernel.org>
In-Reply-To: <20260813050418.2906468-2-longli@microsoft.com>
References: <20260813050418.2906468-1-longli@microsoft.com>
	<20260813050418.2906468-2-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Aug 2026 22:04:06 -0700 Long Li wrote:
> The ethtool reconfiguration paths (channel count, ring size, private
> flags), mana_change_mtu() and mana_xdp_set() rebuild the queues with
> mana_detach() then mana_attach(). That tears the vport down, so RDMA can
> claim it while released, and a failed mana_attach() leaves the port down
> with no way back but manual intervention.

The kernel-doc script run with -Wall reports:

Warning: drivers/net/ethernet/microsoft/mana/mana_en.c:3936 No description found for return value of 'mana_qset_scratch_alloc'
Warning: drivers/net/ethernet/microsoft/mana/mana_en.c:3936 No description found for return value of 'mana_qset_scratch_alloc'

Please note that net-next is *closed* until Aug 31st (merge window).
-- 
pw-bot: cr
