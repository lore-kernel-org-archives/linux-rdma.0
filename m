Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F3149E148;
	Thu, 10 Sep 2026 22:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079125; cv=none; b=q/tgNk6ncZ08HFyun4wSPmV34b44I7VJhDQ6oaJ73nksDjCsY+HwCiENFCBW7ad0/2jxfhh5aWVoaUg7yqgC1vjvvEkwBTppZVpX/g/W8FkC2cBUmXNRtJHEN7s+p7Floyg0P5g6Pf2dGDEe4w0yy562fjPeIUkqDT4wsdjrtjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079125; c=relaxed/simple;
	bh=nsQTrwniU71E++T1KTqOy2RJZ70Ir41GSaaF5HS1bsA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PcjRYgk1aqkJn748hsMfp8UNds1WcuigogXeINLzpFnLoSPrsgjBNV7xGAn10FRF1iew7GVCVfyPxEZx1xj3fz+/gUwvl3kuTTQ3mUzB3q3FWterZhFKzKs9dRr8vLYEJ2Ho8bIgU6p9aOT0f1kyuuX9oSZ1FrNIVus3KN1sLVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GxovDq0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GxovDq0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F2E1F00898;
	Thu, 10 Sep 2026 22:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079120;
	bh=nsQTrwniU71E++T1KTqOy2RJZ70Ir41GSaaF5HS1bsA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GxovDq0owzQZjetAjPXZ6S3RGrtPbkakQBN7P8f8smqywIi/jNNg7yikFNtnEqGJm
	 TTLFydpuinwuvrtWbUQDEb7GeLcSzYpNu4fRvjfU5mjac3XkD0Vj+BVz10Q+ihHc3o
	 todYfWh+Owa/gTvoW6VnQ+WOI7jVFNbzDgSTK327EtYk1IjuxAgPOXxKdD6eeb1Ol8
	 gdfloYbZAYWc4oJCktQbyl1ym2h6aPBr5m/XgMcgw2G6N2C8JxfTKnmEaSmytWyw08
	 dxlW28oGkGujVK/Aef4WwQWv3e7SpdNJtfbNESrwgTusd8g6eyNeiP6v/omLjXZsaU
	 s6ToN6zjNo1mA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 03/13] net: mana: swap queue sets in
 mana_set_channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260909222416.884246-4-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-4-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:19 +0000
Message-Id: <20260910222520.08F2E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Build a replacement queue set before quiescing TX, then publish it and
> retire the old set. Allocation failure preserves the running queues;
> publication failure attempts rollback. If rollback also fails, close the
> port and lower carrier, allowing a later administrative reopen.
>=20
> Keep RX queue indices valid until retiring queues stop delivering. Order
> the port-up store before TX ring reads to avoid a missed queue wakeup.
>=20
> The temporary SQ/RQ peak is old + new. Later patches remove that peak for
> channel-count changes; full per-queue rebuilds still require it.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D3

