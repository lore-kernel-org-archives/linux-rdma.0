Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F143346ADC;
	Fri, 20 Feb 2026 14:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771597136; cv=none; b=XZlCQRqmTH+8bYRh+Zv42hwvNlv6VXvVrc9RvZ9sLF+NvFifqlUDpyiFMW5amGY+GgpaBGBsM/5//8JjbJ3KM5DgOKNNPGwQ3St6U8b0lCXwSmwgceQ2QXKW2MpRko3Pq/qML+AgeDSfG1/S+G/ObvAHUeFdswH/v0ttpfy1ltw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771597136; c=relaxed/simple;
	bh=DRVNZZfSS1JbuE2p8ZZYT6kLTnF92Vr2AfclnpFdOgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HF137uzfuVgpZubRYUiWQdCywO72PO9D20kG1oxPay5XDbBnhw7oe2LeoxSVxBQVnkNDpduPLD4WrnKFxZ2TJjlNCDpOa0yemeG07e/1KWEVLF7Bx90t8ok89w5hDWYuGmYypZ6wQoliePtN4w17YEjRzlFq4TDZKQGvjBKSv4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=IEhRrGKz; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="IEhRrGKz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=/C0JYLTvJxU7N0XNis2h4waB8weL5GFpHQnSERQGpgU=; b=IEhRrGKzUjXEktA0X3swtIwAwt
	mX9BInLnVMT0VfzYLpP0cUUO1zynvIuUjBWYlsBkDctmh1/WSglfbCrmuJfNgblW0R8QERZAMIgk7
	uE8vurZE62oCAb6XCJWsoOwZlyHbt2CXw+S47Kg8lpdYVc3cQS27wQlzXQQtTn0TC5ko=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1vtRL6-0084uy-C2; Fri, 20 Feb 2026 15:18:40 +0100
Date: Fri, 20 Feb 2026 15:18:40 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Jakub Kicinski <kuba@kernel.org>
Cc: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	netdev@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC net-next 0/4] ethtool: CMIS module diagnostic loopback
 support
Message-ID: <3b0949fa-0b05-4bce-86c0-2a7a058865a5@lunn.ch>
References: <20260219130050.2390226-1-bjorn@kernel.org>
 <415c4922-cc8d-4e35-bbac-3a532f44d238@lunn.ch>
 <20260219160519.323041bf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219160519.323041bf@kernel.org>

> Something like:
> 
>   struct {
>      enum type;   // MAC, PHY, SFP
>      int type_id; // if type=PHY - phy id
>      int depth;   // counting from CPU, first loopback opportunity is 1
>                   // second is 2, etc.
>      bool direction; // towards CPU/host vs towards network
>      char name[16];  // "pcs", "far", "near", "post-fec", whatever
>   }

Lets see what comes from the drawing board, but i was more thinking
about expanding the bitmap this proposal already has, extending it to
other layers. As use cases are implemented, we define the bits needed
in the map. The ethtool kAPI has the needed infrastructure to map bits
to names, it is used for link modes etc, and that can be used here. So
the ethtool(1) part should be reasonably generic.

    Andrew

