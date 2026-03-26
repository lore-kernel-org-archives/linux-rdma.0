Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BB834751C;
	Thu, 26 Mar 2026 09:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518021; cv=none; b=kzB0dV6+RSSbxr1YbSnpnbxo/XR166v4jsm77UZsUlP25K3LOuISAy9T7DVR/gccs99n/+sjDPLnEx5WF27xJPD0CGNAG8cz01bwkAzAWzwshEefTAKtWzqjqifMGmZYbR8hUdO0mOnz0SSPqLJD+tM6qGTD2gKX5cPou3wrga0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518021; c=relaxed/simple;
	bh=DBWlVDLpjlSJOQIjxFfylhxmNpzxCQh62zKEJ4rruW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGSrx2rfMtAntafBzGsftrK+vcmr1MOSfyJ1C6xFZwNBYVNNHhITYZu5qClXawHAU+jli+uk4ZiNUN7thRQPyejMrL1COISIt0EkIR9epU0Nj9/65HQGZtt3t/Fr4cA63ME2/ja2YRZSXOCSvTZ+SETk9LwpkaUpzRtv+OLX53s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=uU3ip+Re; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="uU3ip+Re"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=sO7ZNNloh/wmoaVe3Wp31yt1J+XfYMQrOZ79Y8JLbdM=; b=uU3ip+ReM9snb4+J1PCUo53y9u
	0P+h0Okwk8pWT+XN49Iiwg8P7bWCp6p0w1z7IeRcNoyNBJC3kBbOuvgLjdRmRmr2zTjXlu2oVwBaD
	ag+hRTYAET2jYnOAJNtkwc8Kni1MREqL1EzbxVh3djl+dUP4tcEwSb+WOntgyZ1wp4mLYF7lAjGSo
	Cej51+w2sVuwWjBe8e1//wHITlycsr2XhTqP0wQFmtTL3mEyiHXo6asd5WNgMsBod+DHnU4KAjHJZ
	luFtiMaL2H4X+VVKYwlqIriR5jm77syVazXdLk/FJz43A4YDYcVPEoZ2SQP3TSQYUtS4I3nFNj2Na
	wFSybENw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w5hCK-009l21-Cl; Thu, 26 Mar 2026 09:40:16 +0000
Date: Thu, 26 Mar 2026 02:40:09 -0700
From: Breno Leitao <leitao@debian.org>
To: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Donald Hunter <donald.hunter@gmail.com>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Maxime Chevallier <maxime.chevallier@bootlin.com>, Naveen Mamindlapalli <naveenm@marvell.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Danielle Ratson <danieller@nvidia.com>, Hariprasad Kelam <hkelam@marvell.com>, 
	Ido Schimmel <idosch@nvidia.com>, Kory Maincent <kory.maincent@bootlin.com>, 
	Leon Romanovsky <leon@kernel.org>, Michael Chan <michael.chan@broadcom.com>, 
	Oleksij Rempel <o.rempel@pengutronix.de>, Pavan Chebbi <pavan.chebbi@broadcom.com>, 
	Piergiorgio Beruto <piergiorgio.beruto@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	Willem de Bruijn <willemb@google.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2 08/12] netdevsim: Add MAC loopback simulation
Message-ID: <acT-G3_9sUR3Npo1@gmail.com>
References: <20260325145022.2607545-1-bjorn@kernel.org>
 <20260325145022.2607545-9-bjorn@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260325145022.2607545-9-bjorn@kernel.org>
X-Debian-User: leitao

On Wed, Mar 25, 2026 at 03:50:15PM +0100, Björn Töpel wrote:
> Implement the three ethtool loopback ops for MAC-level loopback
> simulation:
> 
>  - get_loopback(): exact lookup by name ("mac")
>  - get_loopback_by()_index: enumerate (single entry at index 0)

  - get_loopback_by_index(): enumerate (single entry at index 0)
