Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C67F48381A;
	Wed, 26 Aug 2026 20:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787775649; cv=none; b=U+plzCpKNPYfG6f2aKgckBC8yuRP9vRR3LJJZhI2aco+29tthEY40H3uH/f/K++FMcLLYb7aidxKm5Q4OpmBdSmOOysZbsaiRrsDOJBduYRkI8nACY+TxSoUUC+VV4D63qbFgE6ive/3zrYbW4D0Tgmzm96kLYPOQXC3t8z8oqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787775649; c=relaxed/simple;
	bh=oWgU/vF3UQwHnvebEtjyYWTAVGBztNX0IX9qZ5hD+bE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qeGzEf145q5LoMgTeyHZjmsYGI3HvUBPO6goHb4OHA4Z95Mh7VlGuSLl0u9ksjd+DzkPt9alRdBoiPKeR/+OArsJOj9jMdE3C71SAsIYrDWiKE25XDNEMkaM8vF6FZbMXfKCEQMY2dpJvsCDSXPuDgzuAfoQoCQb7mfeuMtvHic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q294isjT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q294isjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8CE1F000E9;
	Wed, 26 Aug 2026 20:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787775647;
	bh=sdBgprMEYcaiSUj0ygVN2sdfjT+LVmQNKAKHSXm0dYs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Q294isjThieFDrLugvFd1j77TaAVB2QAfsB3TQVc990b36f+1TuRDchhHGUOCTYmZ
	 /qLud6mlMd5GX2gWFNZe7LJ+1QxL5wZWzZUyDBEUF7I9TXv5y2wYtUeu0+FCRaTzWY
	 cAvQDhTC0CuVC1M7qyRBuC5L8U6uFwyvdHHUh5/doxL+wsmj852Ov18fcsA5Om74iq
	 /viq4ftEPN1BpJsgIKXReyaVM8HFTfdzvgUX2sFbi8IqxPsYPvyR1B5ZN32bVpr9J8
	 5M2idS8spkwUTRc0+2K7cK0hA+Ho9M2Ks1MKT3zuz1xdZnFcHW5VUrPIjhanKtqtlf
	 2GfQQKik9shxA==
Date: Wed, 26 Aug 2026 13:20:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Stanislav Fomichev <sdf.kernel@gmail.com>, Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 anthony.l.nguyen@intel.com, przemyslaw.kitszel@intel.com,
 andrew+netdev@lunn.ch, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
 aleksander.lobakin@intel.com, horms@kernel.org, magnus.karlsson@intel.com,
 sdf@fomichev.me, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, guoren@kernel.org, dtatulea@nvidia.com,
 witu@nvidia.com, martin.lau@kernel.org, yoong.siang.song@intel.com,
 intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org,
 linux-csky@vger.kernel.org, leon@kernel.org
Subject: Re: [PATCH net v3 3/3] net: stmmac: document oversized AF_XDP frame
 handling
Message-ID: <20260826132043.39fb435a@kernel.org>
In-Reply-To: <dc2ccb14-c7c0-402b-93b3-afba52df78fa@bootlin.com>
References: <20260819160535.1472459-1-sdf@fomichev.me>
	<20260819160535.1472459-4-sdf@fomichev.me>
	<aoceSoSFMx69Z9up@boxer>
	<aoeoJ6-njBxcWs4w@devvm7509.cco0.facebook.com>
	<aogpDsa8hz6CPpD3@boxer>
	<aoiIarzdjk92RkCN@devvm7509.cco0.facebook.com>
	<20260824111443.34bffe04@kernel.org>
	<dc2ccb14-c7c0-402b-93b3-afba52df78fa@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Aug 2026 14:42:25 +0200 Maxime Chevallier wrote:
> >> Let's definitely fix it properly if you have better ideas. But since we
> >> don't have HW, I'm not super confident doing anything sophisticated
> >> myself :-D  
> > 
> > Let me take the first 2 patches and leave the stmmac for later.
> > I don't think anyone involved care particularly deeply here.
> > 
> > Maxime said he bought a bunch of relevant HW. If we finally wrap 
> > the AF_XDP tests into driver runtime he should be able to help us...  
> 
> Indeed, I haven't started looking into the AF_XDP (and XDP in general) on
> stmmac, lots of fixes lately on the subject so I'll get there eventually :)
> 
> I'm currently plumbing the driver selftest on my setup (ethtool -t) and just
> runnign this uncovers lots of issues al lover the place, once this
> passes I'll get on the kselftests and see what we can do on this.

Also if you try running driver ksfts - please keep us posted on what
the blockers are. I _think_ we just need to teach ksft to cross compile
C binaries?
