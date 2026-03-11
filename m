Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F0D2D5925;
	Wed, 11 Mar 2026 19:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773257217; cv=none; b=c61q+XTTw5Hth0KN6KnxgSf+7qS+sQ3zDcDy610rtOrzT1f79hZuiAdz1VlUvm/YSr0UBeeXlbK/+aog2H7xIu/Sd9yWGXHlSx40i62dAc0JfWOT3Qs0NaEWj/SuP5feYFFrBm+1v3OLywcXj7QmgOKffSinqy6d3G/y/cH3RuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773257217; c=relaxed/simple;
	bh=d0kLhs/uHqLSBTB+e/h64NsHmTY5C5Mu3yHAXejdHb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBHdvLqSI+O1YsD98TSI/YbHHh9d3Yh30fBqp7wrRNjAh6kkg6ebUo4JiLQfwMuKDrhumMFoDkE0tZ/w6qhO8HauXHVpdxclRW51QSyBOphMDoRP4pyelzhyQ1UZP5uilP8o+HUHx/AjLuyQ8hNyxaoB1oHzDAvJEC7beHcRTHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=1juymEJU; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="1juymEJU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=6XbbzJZw13LWqtzWQJD16rA4mQ8OaOgweEd1OKEwy60=; b=1juymEJUSooHN3CqAX4+BAVIu9
	n1hCYyJN6bM/TjvqhTLtqa3rsPAzrkgpgWJocxzQPCs+J93tUYMg3fZCizXGdd1MsTn1WqbhHh6D4
	lzUe59zcRIi96R+l+ZS2MGsMPsTK4UeLtcYsqJiuQegtITXek5bNmjs/n/Bkxqhi1iAE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1w0PCZ-00BEAU-LL; Wed, 11 Mar 2026 20:26:39 +0100
Date: Wed, 11 Mar 2026 20:26:39 +0100
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
Message-ID: <438dae03-4dac-4e66-9f4d-e08b0434c9b4@lunn.ch>
References: <20260310104743.907818-1-bjorn@kernel.org>
 <20260310104743.907818-3-bjorn@kernel.org>
 <580debbb-8f6c-4b60-95ef-22c68480ded1@bootlin.com>
 <b3825c0d-02e5-4625-831f-4346ce4eabd2@lunn.ch>
 <085bb0a9-85d3-4d62-9ac4-3461b61da5f3@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <085bb0a9-85d3-4d62-9ac4-3461b61da5f3@bootlin.com>

> So, the same name + depth ?
> 
>  +---|-PHY+
>  |   |    |
>  | SerDes |
>  |   |    |
>  |  PCS   | component = PHY, name = "pcs", depth = 0
>  |   |    |
>  |  MAC   |
>  |   |    |
>  | packet |
>  | buffer |
>  |   |    |
>  |  MAC   |
>  |   |    |
>  |  PCS   | component = PHY, name = "pcs", depth = 1
>  |   |    |
>  |  PMA   |
>  |   |    |
>  |  PMD   |
>  +---|----+
>      |
>      v 10GBaseT
> 
> For that we have what we need with phy_link_topology, as each PHY has
> its index, we should be good to go in that regard hopefully :)

So depth would be local to a component? We could have two PHY
components, each with a different index, and depth = 0?

I _think_ Jakub's depth was more at a global level? But then it would
need to be passed down as we do the enumeration.

     Andrew
