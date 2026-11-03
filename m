Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700612;
	b=PdlTZprKcgNk6VfXjqM94d69sIIwytMyFtCgss1k2FmyZkveHKoULKpeW+rxVpCXV5HH
	 4i67QBpgfYXYiEVhJLIBblYDl1XgkzzdyK4JUtgJ3SQCUbuGk0sydnUKAgCtFqLFCqzka
	 t/duhsQEd7AcvHttiUDeVJ//zZmjy0Ed4op6cMFo1Lh4V/pt5GnYGU8MtOdOkJPRlzZSk
	 h82+pnpGAOgUlvQinH7gooT5Qw4L3t+5E+NTkD/gLRSppnW2NLaw5LZFX3LYwjeazOGNE
	 Vw3XztbT7MsyINRV3qPefWDEZ5RnF7imAUFLGNi2eBfI0R0U6WFnbWic3szaUs3Mjsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700612;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FzKSPFtrnMdQXUg8B+1w3hd31jRQQ2g4UAoa0AdufIo=;
	b=W+sjUAxt4wWe8b2yyzhA/jJBbbl0j8q+rBjj9O5C6D/EOEnc8rgsAAuXvLX7T/yJ5Ry+
	 sWV/Tmo7p9TJ52/gbW23KXAz9C7xTmElJ0KoTqGWoN/W9wUiXDYQaa6rGbqyOsFdC1wLN
	 wk1rgKjOLWtBleYUAVj/q+ga9QWIhvezuEI3J12mhuAblQ7QFzII4mgxRw2QNLWcUJQ+D
	 VqkLWuKxFcko4NINDJ70qUrEx0fzdaMQ+x/f6GAVV6Sac0Y52JG7gqWtV49ywbimN+TBm
	 jeWBi5Oe60vvgcIoDmo5a3rIjXE8ESqUCuwkz3C1uBkg8bmYuUkoaWnqRULRDdIimPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=duFtv6CA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC89660850A1;
	Tue,  3 Nov 2026 10:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=duFtv6CA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A1F1F0093A;
	Tue,  3 Nov 2026 10:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700611;
	bh=FzKSPFtrnMdQXUg8B+1w3hd31jRQQ2g4UAoa0AdufIo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=duFtv6CATf8pWAONDDaZBCQlohFu3RdGpP4Vg7G2W3zM1ZBc5h7wQu75rmkQJz6Hd
	 8iFj3msv064vkEIBn4lYX2KADsySFLrRNRi7PfJFDikQy8ALG1AcAMXVisayC+RkXR
	 n6W4HEwNXCuOOiLGdcH/xh9o3Dw3rcrXBISsOvkCkPMtnNNznXIgwuLnLSlDFWB3Kp
	 0ctT/SnyiWm/ZGnXLFnBpW8lsS2arT1zqVg2JERCF2E9yCGXT1Qkfz3+ZNG9RvIH1F
	 vGHmg1Ta7urVkAk1ZAcRvP5uu97WcBePlD5f/wYNNOBEKTZ8UjtnE2x7OY43wJhKUv
	 FQ7xekrLVa3JA==
Message-ID: <sashiko-outbox-195011@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 09/19] PCI/P2PDMA: Route Relaxed Ordering
 Completions directly
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-9-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-9-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 10:10:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> ACS P2P Completion Redirect leaves Completions carrying Relaxed Ordering
> alone, per PCIe r7.0 sec 6.12.1.1. A Completion copies that attribute from
> its Request, so a client setting it on Non-Posted Requests need not use t=
he
> host bridge solely because Completion Redirect is enabled.
>=20
> Route Completions directly for PCI_P2PDMA_TLP_RELAXED_CPL unless a device
> quirk redirects them or the Completer lacks an internal route to its
> sibling. Neither restriction promises a Relaxed Ordering exception. No
> caller selects these classes yet.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D9

