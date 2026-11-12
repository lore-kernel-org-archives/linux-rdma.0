Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794485242;
	b=ZSXxm0MlCWglxt1XLcB+kCvW5MoK/0HK/cGjOtx0E0RjzKG5VUIcntkvOD/m6awmYFbR
	 VLv/EMGcif0H32kl5L1w7bs0vB2JfMaVL99Hp2mqVc8IlU7pEmZtX1ecvgzIlMK+/Gped
	 ztbyr57D5xC0gVVatGVnmGg+p6SIYz5yu1/ha8dBuXaYcWq2p4YktaZfDpWUv5JO64SZa
	 k8WJZ3hyLqZGRv1SNAYfrFRLqmitzUCa+ylgs+3HU52ltCWhq5OsvgeDLNuqPhFASVhV5
	 mA3I2vTqhE3EuH8sd9rnNbZ3RiK6pva3qO7afKBN8sdx1X6Hp0Zd378tdVg/H+ObgpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794485242;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=s2BpDYD2o1GF2JbXETSuauSs2W5dCUgUiyPoNy/wkj4=;
	b=WpFb5A9ihYwQTcoJdYKsdqRz11yDy8ov6YrSV1/OIDIrQlPUaR1Uu6vsZsNapWDHTNyb
	 hu8jTssMD+szFj1ERoq9b3RXr+nZWUJ4XYSWtQgo8RVOBg6DNl79ljiMwCdukO6BN+0Pe
	 OJOhwNEgBQssRf9VTM7AzGQV5pZMbWdNMsTZ9dIBUi76ZO+hZJOf6/gGIacSQnBUtgZSV
	 OWiY0+GczFd3/xj+O8DORY3pcOzeNny5XtC+d+pXLh4T2V/buQHbXfaYRQ7ilcWvSMSaa
	 cnR+py8PgnM6maSzc2pomn5jufEksHaLZVTGpn2kdLuIpGWMKuXwnryvIr3H/IZcyCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=BpRKMxcR;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8656B606A321;
	Thu, 12 Nov 2026 12:07:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8656B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=BpRKMxcR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=s2BpDYD2o1GF2JbXETSuauSs2W5dCUgUiyPoNy/wkj4=; b=BpRKMxcRXfYulH9zjS1/Las0Qn
	Vz6W2pTFE7YPudUcr7Wi342UTBCrxBS6IqrgsJoKnw/OOFCYXQIkCFkBHx+Pcc7komjSR6a33X0W3
	ATVgRVK9pXUqVZ0x+hremsXIUCgVYFULM7Gl+XlWxAbu5QNjyJpwgNl0C79CMRCPaTRd3TQYr1ile
	+UNGAJuzD0xSQ/2RRNU+1qS/PLRHFUuyddgZ0Ynzv4XGgQEJMOq2DD7RFvMfxLvrEitlxUwO8HYiH
	Gn/Z9Tacg8sZtfs5E1H85VfCbCu7SvTnXCulTKYifaCyIhiasOt4WyK6mXSwbp7stl+K7EW+3dQeW
	vt5slk/g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xRTaC-00DxPw-09;
	Thu, 12 Nov 2026 12:07:12 +0000
Date: Thu, 12 Nov 2026 04:07:06 -0800
From: Breno Leitao <leitao@debian.org>
To: Sahil Chandna <sahilchandna@linux.microsoft.com>
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com, 
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, 
	pabeni@redhat.com, weh@microsoft.com, kotaranov@microsoft.com, horms@kernel.org, 
	ernis@linux.microsoft.com, gargaditya@linux.microsoft.com, linux-hyperv@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: Add CQE polling as first-level TX
 timeout recovery
Message-ID: <avWrMQK_DuZ1hAwD@gmail.com>
References: <20261112105752.978446-1-sahilchandna@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112105752.978446-1-sahilchandna@linux.microsoft.com>
X-Debian-User: leitao

Hello Sahil,

On Thu, Nov 12, 2026 at 04:57:18AM -0600, Sahil Chandna wrote:
> Implement a graduated recovery approach: on the first TX timeout (or
> when the previous timeout was more than 2 minutes ago), schedule NAPI on
> the stalled queue's TX CQ via napi_schedule(). This triggers
> mana_poll_tx_cq() through the normal NAPI path, processing any pending
> completions without relying on the interrupt and recovering
> missed-interrupt scenarios without queue reset.

Which interrupt is being missed here?

> If any subsequent TX timeout fires on any queue, within 2 minutes of
> the previous one, escalate to the existing port-level detach/attach
> reset, as the CQE poll did not recover the queue.

How was 2 minutes chosen? mana sets watchdog_timeo to 15 * HZ, no?
