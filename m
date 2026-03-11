Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603F53DEAEB;
	Wed, 11 Mar 2026 16:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.32.30.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773247966; cv=none; b=Gbt4MEHPES/0wqibjcJJcpClycpwYC25j6v6YYk49QLZVXxJfPIIXer5v2KUgJFpT5ImsLTvq/K4oCcHqkwnMmtmidbJQZ8tXIlStn+uy78vvk/H90LDZTcHmpx64k85MmNhdNdyWGDcL333ocKSFbS2e4ak76Mxb2geW/j4ybs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773247966; c=relaxed/simple;
	bh=bWzneiJ4IHda7JaLKwlE8kyRQwSKFX283+EeLiYFgR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SR7Z2NdoXJUuxfCcfwbJbQPNIDe1YzsbvCP4nyPGf5xSJe1TZQZi8n0+mpiTSJOyQh+Ch6gLMevTcRbKrQCgmGg9AcfWLXeJ1aMJHPnZ9eR8E7cL3ygCkm/NoF1pvgu/Q8DFGPd7svjh3aGGgvId99fxzuW7mdkPbJmEzdqj/Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk; spf=none smtp.mailfrom=armlinux.org.uk; dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b=xBzYY7Vx; arc=none smtp.client-ip=78.32.30.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=armlinux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="xBzYY7Vx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IOU4FYp2Mavg+4y+nURWKTXm/MUcQxgEkuD1zFPesWk=; b=xBzYY7VxoM62hImxr1VBygl6qr
	oXO4dWHonS5SVoay10fjrp5mvSX+n8VlxChnKaYb1MpmrjozaEEnAQmYpEj6UjSYXQFd425lUm6Tg
	mTjag/ClBwdKsN0ahAuIyOSvjZAQJwUX4mglydDLFlYpmgPwWQ+nNg47JrqXgsU2qQoBoSE/t3V63
	9DFW7XUKiY+t7HJyxyqA4fhhcIJOJmj8zernVMGCWe0VXXB09Yg+Sw3zGovcT5qk1hk46N83NinPl
	ZWoWA24Dhm/H+1CC3cBNGHKSdEkeJ1pC7UMNMkDqmXuP/lX+p2bFy3rz/ybcz0XN93E1bGPuksF0u
	HhNOiWGA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52112)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1w0MnX-000000006g2-00uT;
	Wed, 11 Mar 2026 16:52:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1w0MnS-000000006OJ-43hU;
	Wed, 11 Mar 2026 16:52:34 +0000
Date: Wed, 11 Mar 2026 16:52:34 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Naveen Mamindlapalli <naveenm@marvell.com>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	netdev@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>,
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
Subject: Re: [RFC net-next v2 0/6] ethtool: Generic loopback support
Message-ID: <abGd0kJb0zEn2Yzb@shell.armlinux.org.uk>
References: <20260308124016.3134012-1-bjorn@kernel.org>
 <aa7P7UUUG1p5RVwO@naveenm-PowerEdge-T630>
 <87tsupnjbc.fsf@all.your.base.are.belong.to.us>
 <aa/Jt36h3EuhpPKf@naveenm-PowerEdge-T630>
 <de9f5282-6270-4bb5-b9bf-d80cbc977f14@lunn.ch>
 <abEEuPa3/cThM40a@naveenm-PowerEdge-T630>
 <0aa736b4-2c1c-4317-bcc1-1d4c9ad49380@lunn.ch>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0aa736b4-2c1c-4317-bcc1-1d4c9ad49380@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>

On Wed, Mar 11, 2026 at 01:32:09PM +0100, Andrew Lunn wrote:
> > > > With a SERDES component, the mapping becomes cleaner:
> > > >   component  name         supported
> > > >   MAC        mac          near-end
> > > >   SERDES     serdes-ned   near-end
> > > >   SERDES     serdes-nea   near-end
> > > >   SERDES     serdes-fed   far-end
> > > 
> > > If Linux where to drive the SERDES, what part of Linux would it be?
> > > Generic PHY? How does your SERDES hardware block fit into 802.3? Which
> > > clause describes it?
> > 
> > Hi Andrew,
> > 
> > On OcteonTx2 SoC, the SerDes (GSERM) is a HW block integrated into the
> > SoC die. It is not on an MDIO bus or any bus that Linux can enumerate.
> > The block is fully managed by the firmware running on the SoC. The NIC
> > driver configures it indirectly through firmware mailbox commands.
> > 
> > The data path looks like:
> >   MAC (RPM) --- SerDes (GSERM) --- module/PHY
> > 
> > In 802.3 terms, the closest match would be PMA. The GSERM handles
> > serialization/deserialization and the analog front-end.
> 
> A Linux Generic PHY is probably also PMA.
> 
> 802.3 says very little about SERDES, it is not a well defined term. So
> i think we want PCS and PMA, not SERDES as a loopback point.

That's a good point. I'm wondeirng whether to change "serdes" /
"SerDes" in my stmmac patches to be "pma".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
