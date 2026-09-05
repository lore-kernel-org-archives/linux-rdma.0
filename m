Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB90D1D6DA9;
	Sat,  5 Sep 2026 00:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788569854; cv=none; b=reBqXqnhXr4boeXGoK7B5Ww6W6i2mXNJLqcvxF/IFYvMORNcTu9nQK+emdieSMjtvGtAwCApsNxqSbED7RiRnxAvK+5PAN6vsqXU2UO3nnFg9WTbZwYoQIJRryUhCQ3WJgiLWpQ4cmM1cRXSupK4WMk+lmfDbdiEmlhkfYmiAyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788569854; c=relaxed/simple;
	bh=+rBBhzyZy2KTbRlkpBdRRhduv1c7PlfNckTEbePIkl4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CI91nMwyj4GhzFW5WU254L56wSlJSQNtJM+bz6AM8a1BbDIsBS94+BpftfWcIwMXkoT66ejrQHi/rFU/aWx2b6SlS/fHEG6x6CnBS/Tx02uhERvaSFF2CoRNgbkka1Gj0R+BdxglBnpIW0O9dzNJt/oTLFy99CSBYI5jGd1+kwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbVW3vyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbVW3vyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12631F00A3D;
	Sat,  5 Sep 2026 00:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788569853;
	bh=CrFnkS6LhKIKecfDMTJ75owdcJ9Inl+v+mhCPqyoC0Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nbVW3vyHdKvxTtLZjvAwAS6nEp8cxHZJgNwkt/zzBoPF2wW+CAMd46zC7nxnCK7vO
	 XD1OPFH0OW4fmvcTKHina1JQgYqDzmygC81zhQooAfgxroDX3ZRiNvMftfaOMTeChb
	 u5UKOVuX1QQ3HLzNywRMxvLXQUuBnk091lL911Fs6awt4odrsfhYqXPwi0ZENO4egR
	 gske1oyg9lcAuy0T83/xV/RsI6q16/5JSXYX3KUDdJiOyHYHvL4eHAdLv+ujvLNbVV
	 dCUC9BoQQOJZG7WnHZgKqQ0QdYmuz6ZkRP8Msqph6tjMPfpSO5DaLaHmpKEQjt48Mr
	 kbBLcaiec6j6Q==
Date: Fri, 4 Sep 2026 17:57:32 -0700
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
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/13] net: mana: reconfigure by replacing
 the queue set
Message-ID: <20260904175732.41c0d5b6@kernel.org>
In-Reply-To: <20260901014442.2945689-1-longli@microsoft.com>
References: <20260901014442.2945689-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 31 Aug 2026 18:44:29 -0700 Long Li wrote:
> MANA reconfigures a port by destroying its queues and building them again.
> mana_detach() tears the whole queue set down, mana_attach() allocates a new
> one, and every path that changes a queue property does this: the ethtool
> channel, ring and private-flag setters, the MTU change and XDP attach.

Given the sheer number of reports I'm going to assume that at least one
of the Medium+ ones is right and respin is needed. Please LMK if that's
not the case.

If you're respinning please take a pass and delete the more pointless
comments your LLM has added.
-- 
pw-bot: cr
