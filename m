Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A073537F8;
	Wed,  9 Sep 2026 03:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924588; cv=none; b=tF3o+nAMtG1cJCzMef/YYKwz/Sq9+XKyF9JR0APFvmE9KcKr4c4UWuoAPekMB6Wvi3IkbAjGGg72CKXaP4AaVCJFbfc6ip86Obd8rvQMBKW7GpCFo6jumHf4VYmx3Dot+Iw31EafkNyMTO7yK5JcsGOhxvVjVE13bNK1SVeMBYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924588; c=relaxed/simple;
	bh=Z1OrQRSjxbawGx2TOH46iDTEE7RR/c8262l68MJvplU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DIIg6ZHS9+6S6lX6R4dpwvTnJ3+EKKI3+tkNAKRdxR7syEvfO3VWLObC+iRyUPs2wz50mSWhQslwgmRKQALrkQ1kvUYv4LNHinIItNtR0rIZjzkrg3fEGDjV0iDcH2QrVZ8RbKJbnvlzry4MSjYoawqVFzYJ/1vyh8+LV6qKI9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GD0yBdUv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GD0yBdUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A837B1F00A3E;
	Wed,  9 Sep 2026 03:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924586;
	bh=Z1OrQRSjxbawGx2TOH46iDTEE7RR/c8262l68MJvplU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GD0yBdUv9zXsGHsykCbuHeSLXQ95amH2DKturh6ImLkmqUKx7Kst+QH2fJLGVqXWf
	 4WVLxK2P1HO6wuo8n/aTwFerq0X/3B0JLe58dvFxJLqpxiS32eP6gAIXSvQCM9SpT8
	 /Fom6Fy+rSsY/CN//8DXQHiMaliIWo0zTbfM7KG7aQ/OhvZzuQCDdMYvpsrz8A0Kc1
	 2YIchOexWCvhyOvmoGWuzgx7GdlAgzcY/dV2K5ojKmHcHWaFEqI3KeMVXds4n2zQBb
	 oqXn1QMPNK79BmPXr0R+ZmVm1/mGd4fq5QQUwEiyClSfyjUFpveKUrVBZkaN5iFKDH
	 96v+0uxJikiyg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 03/13] net: mana: swap queue sets in
 mana_set_channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260908032843.397667-4-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-4-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:46 +0000
Message-Id: <20260909032946.A837B1F00A3E@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D3

