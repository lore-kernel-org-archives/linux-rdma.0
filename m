Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E63C3AD52B;
	Wed, 26 Aug 2026 20:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787777892; cv=none; b=krrCOz1akLTAjzg+bi4jOHPho7Muqe3FXZtYrd8i8uF5nqSvH/q8ETsOzX7MgN48yi3bM0z1G/s5CoF2Lt02U/eXq0l0f8HHICVD0gpppKaEUw9POg4xeo3e8kRVPPicHxGABN2lUdIRjbzTykpr7pjXPT9UnS77Swfqy4vW+qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787777892; c=relaxed/simple;
	bh=0z9/8QDTndRX0GOVClV5gilwMHhR4WDORaNJ2Jj8ySM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UKLThnQq66BZ0fAmZxH9s4AsVjqdq2rVtZn9v48jOEqwwaMazjOMGJ8s+RA+Ptc2WejDajFqLUeflS9psRRo7dsEhLsebsMZoDblmODS4sGKzbcPR9xhpP8nBV29G/MlDuWIYdcIiO/8DskvN3+v4e2l3OLtRKCURdmt0jOOGE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=Gk++gNb7; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="Gk++gNb7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=6BSYdpEPt01McAnG4u8lln5Yld57nZzWrLhCayqxD+0=; b=Gk++gNb7sGZR1YerBxsUPWVOAv
	UOLsd1KSFlgVFGFo/4Dm7AT9R5ueV3ELForjXbWCOik5M3t7GhBzcbhrDpk6H5obJIo838smYoKG9
	390FgaW/u4wyOhISwb+DP4JolTFF9jLWkY8P5JQLIqmEqKIli3ytdmFt7jXYDAAzgGfQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wzKgm-001Zg2-1Q; Wed, 26 Aug 2026 22:57:40 +0200
Date: Wed, 26 Aug 2026 22:57:40 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, anthony.l.nguyen@intel.com,
	przemyslaw.kitszel@intel.com, andrew+netdev@lunn.ch,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
	aleksander.lobakin@intel.com, horms@kernel.org,
	magnus.karlsson@intel.com, sdf@fomichev.me, ast@kernel.org,
	daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
	guoren@kernel.org, dtatulea@nvidia.com, witu@nvidia.com,
	martin.lau@kernel.org, yoong.siang.song@intel.com,
	intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org,
	linux-csky@vger.kernel.org, leon@kernel.org
Subject: Re: [PATCH net v3 3/3] net: stmmac: document oversized AF_XDP frame
 handling
Message-ID: <0c17200b-105b-463a-8677-45f575c294f0@lunn.ch>
References: <20260819160535.1472459-1-sdf@fomichev.me>
 <20260819160535.1472459-4-sdf@fomichev.me>
 <aoceSoSFMx69Z9up@boxer>
 <aoeoJ6-njBxcWs4w@devvm7509.cco0.facebook.com>
 <aogpDsa8hz6CPpD3@boxer>
 <aoiIarzdjk92RkCN@devvm7509.cco0.facebook.com>
 <20260824111443.34bffe04@kernel.org>
 <dc2ccb14-c7c0-402b-93b3-afba52df78fa@bootlin.com>
 <20260826132043.39fb435a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826132043.39fb435a@kernel.org>

> Also if you try running driver ksfts - please keep us posted on what
> the blockers are. I _think_ we just need to teach ksft to cross compile
> C binaries?

It would be nice to make it not give out 1000s of warnings on 32 bit
builds. At least that is my experience doing a native ARM 32 bit
build.

	Andrew
