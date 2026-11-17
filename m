Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794938849;
	b=NYV7DNhFN0o1h7vMOyBsmM7iPIyd2qNWNEu3lSXQ/QdWvA3iB07pgQesRE2VI+U8nqD4
	 eRTNbcGJnKu4N+gT4NIO774lh/yLetuAO7BXs29kjSdFYv3mQ7Eh0CZzVbVxK3zLJKBNt
	 oufNGsSZe+1SklKN1doShEh7Bsg4TbDLlAQcOH3vPwgAyEx13UzneedVFPuNvIRWeivbu
	 wb1OPK5BEqr+eqYYsaeKe0smddVi5TH3U7jldbL7zydlwO1vhENY2xGkbHl9dNcasVD0e
	 zdci7GhtCmJ47uCCnRKOMycmjB5j9Tdzd3wL4h9nFnjMVtTcB4nD9OC11Ozde0nutjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794938849;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=FWa7z5prr3r+MhfpTRC3FLYq50rHdCPulBDCVNz2EfY=;
	b=Ln3WZXrnrWAvTtwCMysFwkZcOds33ijqGrKcsKKgdFeAkqqqedxxRSYuS6KLLOLR0eyM
	 Xn6iKezSd5rEOZZbISFwUK8AvSnzOoe96y4AEeMA/bO+u2MSnq9DJbf893eMV2PnaxxUx
	 DbkyReNp3sgOlRtuzha8ByN66h7SkNfSBjwo8dKqrdQ5lumz3NWycXgP5kK08nIROwRbO
	 /hU9MMoEEs5PDb731L9Y46W6VB95FlrHhvuJtBDLsi3VOZfojGdwwY88c4O4ZW8lHb2Fg
	 afUiVKDlavT2I/JU+d8ego4p5VP3tmQ6+Xo8YVdejbntiX6S/x5dd6VKoVELDYa4M4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oY3+I7hv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D38606A31C;
	Tue, 17 Nov 2026 18:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oY3+I7hv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B571F000C4;
	Tue, 17 Nov 2026 18:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794938849;
	bh=FWa7z5prr3r+MhfpTRC3FLYq50rHdCPulBDCVNz2EfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oY3+I7hvFvTHmpotueR1VWhuZb3+Ilx2ffad2ROiBk2ZodPQLubPeWmDFYwZYrkux
	 5pv6lN9DXjX1elCklpgpuSkzAtHet/YgMQkwc//gCZkvcZS/eMTB9a7NENFO+4XXvX
	 ES7Fzf6jkmNulMF9QsW2YeG7Fp2LXwbfYydeCp3cx9T5W8x/IPbkrrBIf+YTfZuG0x
	 4pHL7DDXxcIge7cEdYw4Bt+9VhSqoYAqWJ7+v0hCjW9oJR96rfxMpBJ3gIegFhA+xb
	 bQ9ZaEbR0dUDi22sovsQ9XGoz3trstKbt6IzcaIZnl9pOPtMOPRonVahCZkJiTF3/X
	 o6WShB/ZCsdng==
Date: Tue, 17 Nov 2026 20:07:24 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Wei Hu <weh@linux.microsoft.com>
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
	davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
	andrew+netdev@lunn.ch, jgg@ziepe.ca, haiyangz@microsoft.com,
	wei.liu@kernel.org, decui@microsoft.com,
	shradhagupta@linux.microsoft.com, horms@kernel.org,
	ernis@linux.microsoft.com, stephen@networkplumber.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com, kees+treewide@kernel.org,
	kees@kernel.org, mawasthi@linux.microsoft.com, weh@microsoft.com,
	edumazet@kernel.org, shacharr@microsoft.com
Subject: Re: [PATCH net-next v11 3/4] net: mana: support concurrent HWC
 requests
Message-ID: <20261117180724.GD162713@unreal>
References: <cover.1794751992.git.weh@linux.microsoft.com>
 <45db2acd8f03421191f5b3a9f4bd7ce9e9259b33.1794751992.git.weh@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45db2acd8f03421191f5b3a9f4bd7ce9e9259b33.1794751992.git.weh@linux.microsoft.com>

On Tue, Nov 17, 2026 at 04:01:00PM +0000, Wei Hu wrote:
> From: Long Li <longli@microsoft.com>

<...>

> For RDMA, leave live verbs objects and their dependencies intact on local
> rejection. Retain queue mappings on failed creation unwinds, including
> regions already transferred to a QP/CQ handle and partial multi-command
> DMA-region creation. Do not unpin their memory merely because a cleanup
> request could not acquire an HWC slot. This may deliberately retain
> resources on a failed cleanup; it is not proof of device quiescence.

This sounds wrong at first glance. Unfortunately, the entire series was
written using AI tools, making it difficult to provide meaningful feedback
based on the commit messages. However, in RDMA, object destruction should
not fail and we shouldn't leave pinned memory for the user space process
which already exited.

Thanks
