Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E0F35836C;
	Thu, 12 Mar 2026 13:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773323216; cv=none; b=K8wRyT5ei1PLGYCZBwTvdKZHCTjHhri4f7b99h2ZVq86htNhvZ94EoC9I2928iNc7ntFYb3LjYzYGmDS2WXPhna4ZrARdGkvQUOyVcHCD8ZdWvsJ6MQnzcsA55ji6DoosxaUx20o+G5Q9z59lygK2b7BO38E0U9vVjcF3lDr3qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773323216; c=relaxed/simple;
	bh=NK1kpQElP7tNVLZej9yCF2N25n97vfLQ1BBFkHBs9D0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C1ekyCr1mhVtT22qiP226Hn89spFj2TOFRWtaV4dvYKlVMmyvX0T5T3obvz3K+zNyatu+uQweJYwkS6gkLALHpvI8fGCw9UpFsioMmg866Xl/z1kFJ67gJMjpXs/DZhdfvcbHdFsxGXl+aq9QbCqA/F0tzeeLSN2G1AKrwfKIX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=eQ3z5RCw; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="eQ3z5RCw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=X/6xw+BeY313gcMqR/pFQo1XTTFv4aKjsic0QBnZdo0=; b=eQ3z5RCwWKU5AfPBqS5uheIaUJ
	3DuZU7lGyCHRJFIpXZ2TwJp4RvUSn4rGWk5clcHIrX+gibC6UCgkLqBMcCluNv2nA6CByqYPP2Fyw
	mWyoBldBX4pt+KOicMYEIxBY/On1o1A1SRriOOTS918g9cjrno5KjXa7j5XR3knpUo6g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1w0gN6-00BKQL-HQ; Thu, 12 Mar 2026 14:46:40 +0100
Date: Thu, 12 Mar 2026 14:46:40 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Jakub Kicinski <kuba@kernel.org>
Cc: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Donald Hunter <donald.hunter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
	Danielle Ratson <danieller@nvidia.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Leon Romanovsky <leon@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Willem de Bruijn <willemb@google.com>, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 02/11] ethtool: Add loopback netlink UAPI
 definitions
Message-ID: <171da8e9-fb09-4cfc-a29e-aefbdc8c3ce9@lunn.ch>
References: <20260310104743.907818-1-bjorn@kernel.org>
 <20260310104743.907818-3-bjorn@kernel.org>
 <580debbb-8f6c-4b60-95ef-22c68480ded1@bootlin.com>
 <87tsum3b1o.fsf@all.your.base.are.belong.to.us>
 <ed30934a-4931-40e5-a659-6fc8d12741b5@lunn.ch>
 <20260311194716.600704aa@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311194716.600704aa@kernel.org>

> Which reminds me -- I was suggesting that we add an order / id to the
> stages, not just name. Because AFAIU being able to request the loopback
> "very last loopback point of MAC" or "first loopback point of PHY"

How do you define where the MAC ends?

I suspect some vendors will include the PCS and the PMA, because the
MAC ends at the MII pins on their SoC. Other vendors are going to say
the MAC ends at the interface to the PCS, especially those who have
licensed the PCS, and are using the shared Linux driver for the
PCS. And the PMA might again be a shared implementation, since it is
also used for USB, PCIe and SATA.

If Linux is driving the hardware, using phylink, phylib, PCS drivers
and generic PHY, we are very likely to have a uniform definition of
all these parts. Are we happy firmware devices will have a much
fuzzier, different interpretation, conglomerating it all together?

	Andrew
