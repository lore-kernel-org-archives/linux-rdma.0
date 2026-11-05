Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873553;
	b=N+/dDSbqKiJ2nBCjlHfnTXD9mTlQZ7LlunWIpjOaj05F8cjksU9/FYmFi5CDHxZZee0Q
	 AgFPa3lsXDZ8aU60WepgxkC//WRj4U7xJ3LwxF+dzX3Yku4BmsK9hFf3l9x4jbU02P8k9
	 Js02fxECnrHxcl4m5WqRw10jh7O3SOuqVFFwMXoKyaMaqpWT9U/REod0QRMqpSy31Dd2O
	 KLgik3MJtQ26opDXKp+TmaBEDJYFgd8SmgTB1uE14ny4lsqwxDu4vBnKkVD3i0jE3U36V
	 zVqgvOHP5FNR0DiLRQ0LFjkE/reBD/J3BIgEuZ+VFJ5dUiqhIF2gLRq7RH5pYR+2eBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873553;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Z1/63qDXygQ4CByh13KVz1yFYBdXfuvUX950Qw+ndj8=;
	b=kEJ1JFJB7L4e04ivcCGRskQ3YQZT57XGCtKG4ncxP6t946rkgeF2y+0bd1Xtb1409aqW
	 qmyJdlZS92B5s3DqzF+r29Ro2sjqK9RgRthusVSjfTvdRyrQQa0YKHqMAUO3p/1YqaE39
	 g2TuwhxXiUpivqqgfMcYJ36qTDjEFWZCsGQ+iWrSymy7O1K9YAz0e3pJJQGfAPYtVt7j5
	 t+vVlEunibxA7C3q76CYRomNcKfl/63f0JlkJYY+79/SRt8I4OFLKJ1KTpJsNXkYQcC0v
	 kyA+WFni2sVNakLcjfXj+p3ZgzOpKl1a7BrcPo1ODpFLNzfb3PKV+Ewn+rVPcs+MJ9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a9Ol9J7r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E066606D814;
	Thu,  5 Nov 2026 10:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a9Ol9J7r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12C71F00919;
	Thu,  5 Nov 2026 10:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873553;
	bh=Z1/63qDXygQ4CByh13KVz1yFYBdXfuvUX950Qw+ndj8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a9Ol9J7rCo171L8D08tGvrfvh45idvAt9kmt+52gVvVZ4DXW8nEX1s9UdNic9zgNd
	 MhzX3Aes0q1jOxE+kwf4699UZoNUjAT8SSB9azQKSY26lxrMlucMbxhp5QBw5C/H1q
	 czmEzMXsrtFOs13TcTjqbeMgTOhTIAftqPpWMrzlOOHqrZ8JU5RAro0fmAFhpgxBnJ
	 31PzVn2qsarW20x2S7V0+WpNYC+kfDM59cEsZ0jH5UKT7KkNrmhDdXiGnSoBPcvy8z
	 r5EVvbRA/y81F6NuGDB54QHdZXVCG1+slD0Ry0OXhgbbSQP92Q7ZEr5zP8Y5romuuJ
	 Wdat6iMGjdrEg==
Message-ID: <sashiko-outbox-198820@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 09/19] PCI/P2PDMA: Route Relaxed Ordering
 Completions directly
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-9-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-9-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:12:32 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D9

