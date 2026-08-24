Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBCB370AFD;
	Mon, 24 Aug 2026 18:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787595286; cv=none; b=RxuZUf28zVI2aVAe71gQyW6NT6dTV6dDmsFC1G3rKLwj0MlIFqdtehK+xrwDEOJIzC8aRiP5JcUomW42ZU6RihWkdjMlND3yztZkHrgbMHVQsJ83GaAnzRLF8aqGw1guFOGGnd3WDvA1YkXQoR+Ne4KtC74nKJWtbhG1HVFb8OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787595286; c=relaxed/simple;
	bh=Xhe1unRIajt7SrD6EiFDRWwnD7KQaITwQrA/kd2OUMw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MYBExRgtoVyh4DAh9IW4LHGnbjEyvmfRsA3ChrnTRna0aMyPahN+zat1peqM5UK8cVmJ+95zrWb+As4x/HYJr+kWijlJOkGaDtIVXzeXGTAmNvFaLEWh9QmcIe4q/A1KFGglY1SwXF8iUKNw8m8W9N1ESCbRqWTyHvYMP8wIfbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgAXqGNa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgAXqGNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CDE1F000E9;
	Mon, 24 Aug 2026 18:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787595285;
	bh=bBAzJ1wZvTBzk2jjxXm3YqIN0/WHyV3eBtBFUun8nQ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jgAXqGNasidbaHQMnp5/SMprfR24IUmQiq8GmvgOdzqvGTFc2WNl2gHAGWyK4UJAA
	 ByhiiLyF1JoFw7QInGYLTqnz+lO0fpq17gGejgBfcoz7NmvTrzJBpPt8adRbXiucr1
	 L0t2oByWLooDg+TVK0h9NBQUcLB9lymHNbTp8uxRMCiTarrOWYheF9dynLWEDL9JSm
	 O8q+q9akjuhyhLslrVdA2J35E+njlTzbRjn74YPpXf151DwVAaHU7jc5HQd2inb97W
	 5Z7HSEz580eRcD1F//V50hLwnc5oh6A1WHNp1zrJNVf2qLx+W9sIf+z6hUf9fyKfHb
	 pqGoM30MOUnBg==
Date: Mon, 24 Aug 2026 11:14:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, anthony.l.nguyen@intel.com,
 przemyslaw.kitszel@intel.com, andrew+netdev@lunn.ch, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, maxime.chevallier@bootlin.com,
 mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
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
Message-ID: <20260824111443.34bffe04@kernel.org>
In-Reply-To: <aoiIarzdjk92RkCN@devvm7509.cco0.facebook.com>
References: <20260819160535.1472459-1-sdf@fomichev.me>
	<20260819160535.1472459-4-sdf@fomichev.me>
	<aoceSoSFMx69Z9up@boxer>
	<aoeoJ6-njBxcWs4w@devvm7509.cco0.facebook.com>
	<aogpDsa8hz6CPpD3@boxer>
	<aoiIarzdjk92RkCN@devvm7509.cco0.facebook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Aug 2026 10:28:47 -0700 Stanislav Fomichev wrote:
> > > I do agree that a better idea is to probably do these checks during control
> > > paths, but it's a bit more involved (and not sure if it's possible? if we
> > > have a bunch of xsk sockets and we change that max_sdu, do we go over all
> > > sockets on the system somehow?). My main motivation with this patch was
> > > to make our LLM reviewers less chatty about preexisting issues.  
> > 
> > I hear you, however I feel like we do not know this driver too much and
> > probably we don't have a HW to test out such changes, so maybe let us try
> > to fix existing behavior?  
> 
> Let's definitely fix it properly if you have better ideas. But since we
> don't have HW, I'm not super confident doing anything sophisticated
> myself :-D

Let me take the first 2 patches and leave the stmmac for later.
I don't think anyone involved care particularly deeply here.

Maxime said he bought a bunch of relevant HW. If we finally wrap 
the AF_XDP tests into driver runtime he should be able to help us...
