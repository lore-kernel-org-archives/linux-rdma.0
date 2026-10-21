Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792543200;
	b=jDXb8pEfMC6oLHNunVX9muSpze+yvsFbLoLTZsqEqeyCyiYBrN5QU6y+gzd287DXfp9o
	 BZDUxjwYiRhCt8nb2rrQSgMtXBNOSYj9WtL4zKkWpikMXiotgDO+9Z44p2m7KJLZgB2UV
	 V9vVbaJK5qZNCMSCoyPUV5O+Xxp7AM6XbuZiRz+27WG17Z40xrIHVhbaWhh6czoSDsZT9
	 aZ67+Idqj/YWka1RioE2aVtbd1KpLO6D/TMqodpD6c2dF7t0nxIiLV3y8NbQC2yRUm8AT
	 h28+WlDNhcgvfgm0qPpnKZsMw09EbUXt+LV7cHWyGkgeeGIptbY8NMdmqk24An/e4DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792543200;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=5XczBISy9Plu4tToBmWZIMbL1M66Nrl1Ew2vxOyeA7Y=;
	b=qmFfppdJ/Oavz45i6MJpKpYbbra3SgLfuQbHxc+wrG17DRJoNkYgA6Hv+WdwDk4Isk0A
	 6sRLOz79dJ9coHvUDcpvDp2VDh3WGbIK1bmZ4Gei9e7vzQg5HpJ+z+QrJOIzGrLPF2S1N
	 Z5lNnESC976bd8AOGiAPL+1mxuszlk78v9f1LblACaovcBQURdM5aQThs3GyopPMO+NHX
	 gOuBmDOiZKalNl4RYlI8vsnH6+Je63VC44VxUFCDnq8nHaT6Xj3KMHqoUHfCA3Ydna4jL
	 cMWAVb2V4jZrP4lQ0DANmnvsypMkiPxBEI89CdumpYHk00bMThKI1plZrYKahM6hwEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kBkFdLlA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109F7606A321;
	Wed, 21 Oct 2026 00:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kBkFdLlA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDA61F000CB;
	Wed, 21 Oct 2026 00:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792543199;
	bh=5XczBISy9Plu4tToBmWZIMbL1M66Nrl1Ew2vxOyeA7Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kBkFdLlATgM85ug8lkBWCZ/nFQeE10a7ZE6mq+CkFQHVxsy9eNXu7BKWd9vKwnZ3Q
	 bnrTGP+FzArWdcvChcZb6MRQ9tIKOw9jZA6rCIBhAuIJu70t+Pj73zlalcUkuB3oI7
	 RfRdgi2uqXi+BAsA8vG+FxGaX60SlpGIY6gxk5fYYsyXoqJo9k2IOk4ZZ2Qj2/5yKQ
	 oRD1aCDdnoFZtLmT0Q6lIoj7lsSQYcPRvZuVrrS2rtsuVnLrus7c9nssie/OE08Tzv
	 3+dhZVG6zcGTA2ASvCjmZus7NFVfg0G2U5DiTIe5fP4Xho/uKro5gYssR0nwr2kXw3
	 0a8Qbtm4v0Ebw==
Date: Tue, 20 Oct 2026 17:39:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Sahil Chandna <sahilchandna@linux.microsoft.com>
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 pabeni@redhat.com, kotaranov@microsoft.com, horms@kernel.org,
 ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, leitao@debian.org,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH net v2] net: mana: Add support to process throttled EQEs
Message-ID: <20261020173958.3262308d@kernel.org>
In-Reply-To: <20261014134304.4177657-1-sahilchandna@linux.microsoft.com>
References: <20261014134304.4177657-1-sahilchandna@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Oct 2026 08:43:01 -0500 Sahil Chandna wrote:
> When an event queue nears full, the hardware coalesces the per-CQ
> GDMA_EQE_COMPLETION notifications into a single throttle EQE (type 4)
> that carries no cq_id. The driver does not handle this event type, so
> it falls through to the default case and is dropped. Any CQ whose
> completion notification was replaced by the throttle EQE can remain
> unserviced, causing its queue to stall.
> The issue was observed internally and following Tx stall logs were
> seen:

Does not apply, please rebase & repost.
-- 
pw-bot: cr
