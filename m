Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793874095;
	b=QAIHdM6YDHRy+6jUQf6dohWYSlG0pedpG1gjRK0RY/ImyPQ3iUbGgGWOutECTI6dZalM
	 qTZMvZ7xIbj+h1y64yPCduuCoCPjAucLbWMoP/6eq2ReXVbrrvneRb6Sk6mQq5d+tWA1C
	 N8XYow5xSDdUCw37aoW20mdgMY7LkUFC8u0vHj+Y4l9S6jSf8Psaa5SOqA1goxYNRVL/X
	 tPZEtZmi8oo0SX/3/kVJ4yt3lKDeY2HARfY/JKA/xuwedtmgvYaARRNOR1DhbPrl0iXE0
	 vCesKDkFaehm8nf57Ug9R6NQ3EeDQ1uP/pYI8sOiSzEyh4fgXqNayHhY9aqV8gIRKAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793874095;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=s1K1EQLqOXj3fT22EwpIZjKDQB4P0bMP3Y6DY3YtSYw=;
	b=OO8ZPAh5caYolVUS7I0PZ34Ne3s8hzuuMoiI2Tg9Ijaztu1zhKBR8ukcj7i43Ju5a+2I
	 glwJ53Fsq6D8/vpj2BhQyYU/QXZU/ZkDHroeicEAJjQY0K+BUIrQ+3vrO1TjBzOVez4SE
	 IovmdjbYpebWaKDXaivZkYoeQjyyvdq2J7Z5EaC99e1zdr7wodnxhOSq4rIm+3azB7j5+
	 3I1AQF8lr7xzbgWYiVBwPeYhSRXafZMoluDD+camSvLSLGu7NefINI63ciVvPFFTiENbJ
	 2BYP5QhTDWzXwA32WMuFaKNWh+CIf9oIEPvsZiT2uZ84NiOSVxyf10tLFxztHDJJsDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lnQiSwWv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9C2606D80D;
	Thu,  5 Nov 2026 10:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lnQiSwWv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB3D1F00A15;
	Thu,  5 Nov 2026 10:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874094;
	bh=s1K1EQLqOXj3fT22EwpIZjKDQB4P0bMP3Y6DY3YtSYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lnQiSwWvV9jmq564ZRuFhV0GTcDcLnNk/tqpvNXUNnEfIXJ+ZSzHRtnF4U23RdpYU
	 T5+1Xkrm0aktRojYvAVELcupRcifYKwVIJtGDNLYDwjyt5SxvBDFyAOp5VCRH8VrX1
	 Z4nuroYGhFU36xk9adXweuO65fVG8bVjZPvh8QS95skH9k9FT8rHcN4/gOd0Hz4wsI
	 PsFJXCRqpq+h+wcr4e1Itet6tZYXQrmY54ANpq+4OtEm0XwmOtJmrCiXtl9RYLM5nm
	 9hCmr2d58gZPyekWhjg+TszjY99Sc/2d1yCjPjBF7y+GZ7obZ0WwHXJBAsM9JAizyM
	 PsfQKwlONOaWQ==
Message-ID: <sashiko-outbox-198844@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 03/19] PCI/P2PDMA: Derive routing from directional
 ACS controls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-3-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-3-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:21:34 +0000
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
> pci_bridge_has_acs_redir() treats Request and Completion Redirect as
> interchangeable. On asymmetric fabrics, a control for only the reverse TLP
> direction can unnecessarily force P2PDMA through the host bridge.
>=20
> Evaluate Request Redirect for the Requester's Requests and Completion
> Redirect for the Completer's read Completions. Continue treating enabled
> Egress Control conservatively as a Request redirect.
>=20
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D3

