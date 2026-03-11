Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ACF331A76;
	Wed, 11 Mar 2026 19:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773257848; cv=none; b=BLxWASL3JqNqDYyuTWuS1T1TrLUtAYBZHwhAjyNQMZV2ENfAUY9fLjL6zTejiCw087C0IgxmVCxwzN8PIpLaAnJQbvojaRXO4aV00YekoNzkuBnXqzatgstHXSd9REPKP+dXqHgq2eAb34ebUJWsi8AkNkONVYwQR0mDz4Q8rh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773257848; c=relaxed/simple;
	bh=6jurl6Rf0zj4uPC6QLg//I6pI8LkP/UEBlFXK4sA+Ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PHaaB6nAXtauj1aLw+homlZaet+UgqfPDdCLlQHNdKJ/zobZpnSoaMhlVz+vk2Y9+GH50gRGW66hY4O9STibJj5MxldUzwWLCpsV10Neu38peA/TNMmzyaWAfBVISSd5Umc84sna3/xOrPlUlQPR8Izsd4dlrc6uw0hNAsLtxZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=ZYei+IfG; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="ZYei+IfG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=beEtVvUryGAcp/KY4RfPpaaoPzXn1sjxBLfBcJlVyrM=; b=ZYei+IfGTVv6TduN/E8kAlsfsk
	bYhkMItgO4q4MWM6giDPal5uuX6zfWvkpmFt/6YpB5WPpz7mYJRRi+ZbiMyWsOjdVDp9vze2wxZH2
	4WGejucuNvj+b36SHv9sMQP3n+pS71ebXy2NxoEI7sYTBJo6t/HOy4OCSjlZ5/8ibee0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1w0PMm-00BEEG-6G; Wed, 11 Mar 2026 20:37:12 +0100
Date: Wed, 11 Mar 2026 20:37:12 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Donald Hunter <donald.hunter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <0d2eaeb0-b47e-4ab6-a440-9d163cc27345@lunn.ch>
References: <20260310104743.907818-1-bjorn@kernel.org>
 <20260310104743.907818-3-bjorn@kernel.org>
 <580debbb-8f6c-4b60-95ef-22c68480ded1@bootlin.com>
 <87tsum3b1o.fsf@all.your.base.are.belong.to.us>
 <ed30934a-4931-40e5-a659-6fc8d12741b5@lunn.ch>
 <acb7ff65-3fed-4a89-a560-f09b53acea9d@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acb7ff65-3fed-4a89-a560-f09b53acea9d@bootlin.com>

> > https://gist.github.com/mjball/9cd028ac793ae8b351df1379f1e721f9
> > 
> > enum gets you around level 9. string around level 3.
> > 
> > 	Andrew
> 
> Oh didn't know that manifesto.

Rusty has not been involved in kernel work for around 10 years. But it
is much older than that, a keynote from Ottawa Linux Symposium 2003.

https://ozlabs.org/~rusty/ols-2003-keynote/img0.html

      Andrew

