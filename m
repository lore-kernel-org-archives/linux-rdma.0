Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695399;
	b=nWPyjY/pZ94qXf0D4vCK1q+IYEapLJ74nIeNRR7WGr5B9n32Azw/DGrCKLjkxxAijoPO
	 Qxo8a5N/K5UgTzveFFbOAdwjsu19uTgj20np1gDuw25+CDWN2VUNfa47OQVdpXb6fXfh8
	 CKkRRozfmNLONOqmZafCiO0QAinlDuw4Jsz/7m7foW614cOC8eWw62mQMYlwbO7K6xFo8
	 eCZwplADn92QIdKj5mw7D937hm69vXjCXws+tmd6ZgRiKa/WYeHm+okcFsT0RXgHIMoJE
	 0N+idmME6+XUNgLp/b2HqX6VdWw4mau4+9hHkU1gKXrI3NmUuItpb2M2of4h8AYrpOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695399;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=t2wVESkVQnlznXAGBnJHwQZD4xLfgLe9Ua/8tzqmHqU=;
	b=MybcE9cqyjPFIUaZiPzVlfLqOG0S9wW7Oz8j1P/xOjSsV/uKQOih7/QuZn6SVtA0s3RI
	 I6OPlIgO6tph44u5xqrXBr6Y6BbtyIesS0ogFnjyVjlqKmI8l5tpsMJT+9qFew1AjSHY/
	 Noo64fF9UGilRbtZl8UiiOVbOgN0TzDG0n92D/K6n6t9SkMNCjPAGVkc+rBcwMkPuPNz7
	 qRv/x/8Kj/i73HRrqcheKtPBLEcQITStXQBY9bGQTRSNxzpdvxth5iGux16NIbPooPABn
	 UskmCbtdX0MlQs2c/zbhiLn6xHelPNJjsyLw93KKeaCmoGUGM3R/q9RsmIIebaRHN8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OUjkSM5Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED22606A960;
	Tue,  3 Nov 2026 08:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OUjkSM5Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45081F000C1;
	Tue,  3 Nov 2026 08:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695398;
	bh=t2wVESkVQnlznXAGBnJHwQZD4xLfgLe9Ua/8tzqmHqU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OUjkSM5Y3fPkO4z29Yv/1nyV8eNAI/O+GP2JLqmBfsKwd7ZMKOLCwRQ8nYG0sfoWo
	 HZfQh2gVOFBXaouUjLGvsXI1c3Neuqjo4oCVGy/bVjjE2veBIbzRfWrt7k6c9oyHgG
	 AEpjpUVPlRdcfj/CuWJYBiilsP+OpeT1IuPaX0YkG+jDVUAqzvakPLYau39hQzC4qt
	 xiV9nnIiMOcnshu1vLuA2Bp+4lJ6wEAx6Dqr0SO1Qbzk6ZGXSihcREem9+Q0HBUaBz
	 zHJjCwIDhs7HEE2W+7G+HsKuBtK/NUftRXkILGBDY7t+K2IHKR3pc5mpxpGHToRUCR
	 EKiEg1Od2ERNA==
Message-ID: <sashiko-outbox-194858@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 01/19] PCI/P2PDMA: Honor device-specific ACS
 redirection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-1-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-1-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:43:18 +0000
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
> Some ports, such as Zhaoxin Switch Downstream Ports, redirect peer-to-peer
> traffic without an ACS capability, as their device-specific ACS quirks
> report. P2PDMA reads only ACS Control, so below such a port it hands out
> bus addresses for traffic that goes to the host bridge.
>=20
> Take Request and Completion Redirect from a bridge's quirk too. Ignore
> endpoint quirks, which only describe traffic between an endpoint's own
> functions. Skip bridges on a root bus: they never sit between two peers,
> and the AMD southbridge quirk may sleep there during DMA mapping.
>=20
> pci=3Ddisable_acs_redir=3D cannot override a quirk, so name such ports
> separately.
>=20
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D1

