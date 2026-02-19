Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B63A34BA49;
	Thu, 19 Feb 2026 16:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771516818; cv=none; b=aBW7lHACMvwXxvf8m6SdCokB2jXV9gSIYncXS/snicDSnK5k8Bz5w5JGR0Joq5hT1IKEkHp5cGsrpHEGrlqGwW24vp7R4GsHZhWp6ELFeK5BW0l9uC+ZUjHowiRWWimWEQEE+qB8BJBYk0NtjrYDtVc4vRt+hjQKhKycGP2CZCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771516818; c=relaxed/simple;
	bh=Hof1zE1EM5hEZsMZofuQELn9nB1DN3GqwwbgsrABHGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OTDj8C/A457zTjuXwLZHe3ltPQ60Jus3IoBo+y280Q6O06zYUdsYVaUQJc7NZM3zUwYsR3bB39+fcCJ9c+JtnAUlYjCvZqwzKc7N05tXmK7YrDljh4mqAs4wtXPTxQtFuqtA5Yqlte6xRhQ41VevIcYoweazq0DqpVke8+XLfTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=C61XY+J1; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="C61XY+J1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=GNz+UgohJmtmkQiCPBGRv7QOHwsgNjtEAhXiIcytNy0=; b=C61XY+J1BqEpLrURfi5JzkomIa
	hm0r41Ai0CN4kaeOGSZNLlIs53V6KAVwYBX6VpSHOII5c0cfR9TWG00HtB9IV7CroStu8BzZkzOAd
	PNHJFtfvcVehkKm80nzcS08Vu7KaDiNjl5NTC2UnQvdiXPtJ0bsFEJY2lpmlzjaY4u60=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1vt6RZ-007wBo-Qf; Thu, 19 Feb 2026 16:59:57 +0100
Date: Thu, 19 Feb 2026 16:59:57 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>
Cc: netdev@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
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
Subject: Re: [RFC net-next 2/4] ethtool: module: Add CMIS loopback GET/SET
 support
Message-ID: <cab8f239-d72c-4071-8584-7e331afd466f@lunn.ch>
References: <20260219130050.2390226-1-bjorn@kernel.org>
 <20260219130050.2390226-3-bjorn@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219130050.2390226-3-bjorn@kernel.org>

> + * struct ethtool_module_loopback_params - module loopback parameters
> + * @caps: The loopback types, %ETHTOOL_MODULE_LOOPBACK_TYPES_*,
> + *	supported by the module.
> + * @enabled: The loopback types, %ETHTOOL_MODULE_LOOPBACK_TYPES_*,
> + *	currently enabled by the module.
> + */
> +struct ethtool_module_loopback_params {
> +	u32 caps;
> +	u32 enabled;

You probably should be using ethtools bitset API for this.

    Andrew
