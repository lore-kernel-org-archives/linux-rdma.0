Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A205A34A76E;
	Thu, 19 Feb 2026 15:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771516325; cv=none; b=Pop2/HKeQNgbih3vOQepTEyjUqciTXO84Zn264w7RI1j28TUYcNl2+GSYwmLA8+Vh4HlwUAkgAuVOQQTWy7rpnKTt0VovzTassadZJqHYzn1gqcs0qj4kdp0FNQ51IhVQKm5te3+tGd0Gf48doRMtVMVkB1UlIOpDRg4fHdtyzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771516325; c=relaxed/simple;
	bh=MwXjeiK98l6Lk89vIKKCcxf5j+pICIFXb5gOe/tK070=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/dM5lAlIVLxrHSh3a5Fp0QzDE9JhU9LB7cj8TVeVT7UKDBKAoQpDFQ8FuLqi9YihEAj+nz2UlBdfn7urhqbQRMzV+9/yi9L3qVOu2miwUfWYndEVoKn/8qRAnZtXk/VYYgZXUvssaUyEuDFSumELSON2aVnGrhPVA+Rja2AU1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=cdwCGy5l; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="cdwCGy5l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=oEHgRQgPyNlUzdqBRtYibx7nGlkM1RsG4DFfxyIYCRc=; b=cd
	wCGy5l0X1ep3TrbPdLRCXt2QlrHfyEBuHZE9P2DlwW1C1YbzfGYsPP4HzABZ+cVJmV6yMTcBZZdgH
	cKLphqGoz8zbjSO/cb6yjavzWqtynLeKRREewdo1O5P2hyERDLO1OoYKwk0lEQ0ZQeeNGAaRQnoR7
	akxYosA5GITfFcQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1vt6Jf-007w7q-JI; Thu, 19 Feb 2026 16:51:47 +0100
Date: Thu, 19 Feb 2026 16:51:47 +0100
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
Subject: Re: [RFC net-next 0/4] ethtool: CMIS module diagnostic loopback
 support
Message-ID: <415c4922-cc8d-4e35-bbac-3a532f44d238@lunn.ch>
References: <20260219130050.2390226-1-bjorn@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260219130050.2390226-1-bjorn@kernel.org>

On Thu, Feb 19, 2026 at 02:00:41PM +0100, Björn Töpel wrote:
> Hi!
> 
> Background
> ==========
> 
> This series adds initial ethtool support for CMIS loopback.
 
> Related work
> ============
> 
> * New loopback modes [1].
> * PHY loopback [2]

Hi Björn

Great to see you looked around at the problem space.

> [2] https://lore.kernel.org/netdev/20240911212713.2178943-1-maxime.chevallier@bootlin.com/

Quoting myself from this thread:

> We might want to take a step back and think about loopback some more.
>
> Loopback can be done at a number of points in the device(s). Some
> Marvell PHYs can do loopback in the PHY PCS layer. Some devices also
> support loopback in the PHY SERDES layer. I've not seen it for Marvell
> devices, but maybe some PHYs allow loopback much closer to the line?
> And i expect some MAC PCS allow loopback.
> 
> So when talking about loopback, we might also want to include the
> concept of where the loopback occurs, and maybe it needs to be a NIC
> wide concept, not a PHY concept?

I still think this is true. We want a generic kAPI for loopback, not a
PHY loopback kAPI, and a MAC loopback kAPI, a PCS loopback kAPI, and
an SFP loopback kAPI, and a CAN bus transceiver loopback kAPI,
assuming CAN bus supports loopback?

So i think we need one ethtool API for loopback. We probably want an
API call to enumerate what loopbacks are supported for a netdev. The
MAC will fill in bits indicating what it can do. If the MAC has a PCS,
it will ask the PCS what it can do. If there is a PHY, it will ask the
PHY to fill in the bits indicating what it can do, if there is an SFP,
it will ask it what it can do, and if there is a CAN bus transceiver,
it will fill in its bits. And we probably want two values for each
loopback location, is it looping the media side, or the MAC side?

So the return value lists all the different loopbacks associated to a
netdev.

And then we need a set operation, to enable/disable a specific
loopback, and a get operation to return the status of all the
different loopbacks of a netdev. The MAC will again need to call into
the PCS, the PHY, the SFP to implement these.

I'm not saying you need to implement all these, you just need to make
what you do implement generic, and plumb it through the network stack
so that others can later easily add PHY, PCS, and MAC loopback
support. And from your background research, you know others are
interested in this, so you might be able get some help with parts you
are not particularly interested in.

	Andrew
