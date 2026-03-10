Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C28D38B129;
	Tue, 10 Mar 2026 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773150997; cv=none; b=q76X0yLGCvHUFTxlYZjY0Wag9IuCZQHE8Ci9PSjQM79w2d/uuAMG4oUb152h2TQuAqqSFlykx7UEM5MGV9aGQMtAUdoxMtjfEa+n31l39BiIqoEVdb2nEx++O1Hbg7Y4VXCxClM0kRMqmd9q2aryypoEkXMarBL9j+YeXqysj94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773150997; c=relaxed/simple;
	bh=UjHUrlNK9qEEFDD66wIrprv1tD9qUZkYbo9BKEZjJn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvWCuVY32zEWZrRI88mdCilRs+si/S7JMEIuYk+gtmHpSSpnquBKtCDwd+6vXKg+cOQnUg2TGP7CHwDThrD4zuemZmsAhTUhCCQQSSbAtJnAkIUgkDogkeH+GOrdS0H9ig97AzNHOBVZtVKq6EU1NWnY2A1dei6OapdVoyRKCmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=PrMwfVHW; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="PrMwfVHW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=WBPC/sgOhbZBTJwuat4vsffRkLbMKhx6QPKwGUp06Qk=; b=PrMwfVHWPJSWQpETtzmbKYVqt0
	EOJhUrdJhUawaMB39GNvWA46ItVMg9q/atppQ9xF2FO4IXFy2j30VXdzKw86G82iBq2Q9uDFCRcr4
	14RU5p36jrB7JYmGnyTpdP1HX1ZHQsOOs3/I8TWiH7YZGHMDFu3WnLwNGU455Ipb3f8I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1vzxZM-00B2Ed-Kr; Tue, 10 Mar 2026 14:56:20 +0100
Date: Tue, 10 Mar 2026 14:56:20 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	netdev@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Michael Chan <michael.chan@broadcom.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC net-next v2 1/6] ethtool: Add loopback netlink UAPI
 definitions
Message-ID: <5429fba4-ea76-4bd7-8aaf-03b0d01bef4e@lunn.ch>
References: <20260308124016.3134012-1-bjorn@kernel.org>
 <20260308124016.3134012-2-bjorn@kernel.org>
 <456697d6-c0d8-4edf-abd2-85062f4b25ab@bootlin.com>
 <e138acb9-f2ab-4d76-a9b1-fa7299b1260f@lunn.ch>
 <2ed52f3c-ce2b-4ac9-baf5-224fd3e946f1@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ed52f3c-ce2b-4ac9-baf5-224fd3e946f1@bootlin.com>

On Tue, Mar 10, 2026 at 11:23:48AM +0100, Maxime Chevallier wrote:
> 
> 
> On 09/03/2026 17:45, Andrew Lunn wrote:
> >>> +    doc: |
> >>> +      Loopback component. Identifies where in the network path the
> >>> +      loopback is applied.
> >>> +    entries:
> >>> +      -
> >>> +        name: mac
> >>> +        doc: MAC loopback
> >>> +      -
> >>> +        name: pcs
> >>> +        doc: PCS loopback
> >>> +      -
> >>> +        name: phy
> >>> +        doc: PHY loopback
> >>> +      -
> >>> +        name: module
> >>> +        doc: Pluggable module (e.g. CMIS (Q)SFP) loopback
> >>
> >> Should we also add "serdes" ?
> > 
> > What is the difference between SERDES and PCS?
> 
> By Serdes I mean "generic PHY", but as you state below I don't really
> want to use the word "PHY" as it's very prone to confusion with Ethernet
> PHYs.

We probably want more than a minimum for doc: We actually want a full
sentence, maybe a paragraph, clearly defining what we mean by each
entry.

We also need to the careful with generic PHY and serdes. Marvell's
comment was that they have multiple loopback points, and named some of
those with -serdes. Is that actually a PCS? Or is it the same
functionality as a generic PHY, just not implemented as a Linux
generic PHY?

We have to assume vendors will get names wrong, because vendors often
get names wrong. Ideally we want to point to clauses in 802.3, since
it is very hard to argue against that.

	Andrew
