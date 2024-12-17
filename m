Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012A170827;
	Tue, 17 Dec 2024 02:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734402505; cv=none; b=FB1TnGZap189vwuscDPYnlISaBVbwJI0eG3dH52TLm1EQyEyF5FT8aIjMQlztm33xpoEEP0CJ4HXO+HbubU4akSqKYSai7dIDO9jOIz1/CJiN9HhQxoFu2XSdUBiXEb07ml2PIPAwxFnGntymbRGT4rRUomNhx/ckYxjKVyctJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734402505; c=relaxed/simple;
	bh=Z0kXIoZ7M8uFKYlucGZUMgaTBP+bzRmnCOsN5JMzWq0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jg9bGIL44rfXsKxAmVDRz6mQxV0kKuPFb4bBvKnkrMz1PuxDyX9A56vp5nVCPeqKS4GJt9d2UtDOClgnDYuTH9qRA5cUXLQcoRFlvevVsdf879BQAGFK9PSS/ofbU8/JVIR+51k/GGt8eyTbilKChA8Ie/SnKqS0/9fFR27bkcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BnIdWC/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BnIdWC/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01797C4CED0;
	Tue, 17 Dec 2024 02:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734402504;
	bh=Z0kXIoZ7M8uFKYlucGZUMgaTBP+bzRmnCOsN5JMzWq0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BnIdWC/bT2LrZqZ2Gnmx0o8y2CbCH+1NbYgHTwOmp8WoGPxqmSrjpNQ/8lwsSjTY0
	 jeKxGbXxtOOyu3EOi2qyO93vALZSqBBWYoqGuXZwq04gEaToTOzvhWIrdYdYt7hLFK
	 kpJHuCiSEAtPPo5yD+DKkkxs3+L44osb92xcWnm6rMq/fRf/gnx76QXmKHxwZesvQE
	 Ab41XpM2Xgg6y4i6Q3eTRxDZYjq10aa8hhKhn1KAsXKq4pptvjuVZXKcuGsE1xkqmM
	 svtQwAaOsR48V+NqfhkSOzcbAxbqy6z5Ktrf0pCeueyRmkQTZCQwEYDmwQuhALTUiF
	 QZzTzT8DCDpkw==
Date: Mon, 16 Dec 2024 18:28:23 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: longli@linuxonhyperv.com
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Ajay
 Sharma <sharmaajay@microsoft.com>, Konstantin Taranov
 <kotaranov@microsoft.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Stephen
 Hemminger <stephen@networkplumber.org>, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hyperv@vger.kernel.org, Long Li <longli@microsoft.com>
Subject: Re: [Patch net-next v2] hv_netvsc: Set device flags for properly
 indicating bonding in Hyper-V
Message-ID: <20241216182823.03fb6276@kernel.org>
In-Reply-To: <20241216180300.23a54f27@kernel.org>
References: <1734120361-26599-1-git-send-email-longli@linuxonhyperv.com>
	<20241216180300.23a54f27@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 16 Dec 2024 18:03:00 -0800 Jakub Kicinski wrote:
> > + *	@permanent_bond: device is permanently bonded to another device  
> 
> I think we have been taught a definition of the word "permanent"
                               ^ 
                               different
