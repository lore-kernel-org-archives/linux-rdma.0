Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96933F9F25;
	Tue, 13 Oct 2026 14:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901690; cv=none; b=bd5+C4kJAOqgUD/sH25z82bSyQpB5qQ0vLsB3gQIDtskTLEX25OqOJSkSL/9ykSFG4dRkGhQ0EN164oZYj3dHa5jMvahuRmeWC1Ys6LxZ5EBTyxdL1T3cpxn4CxciNHNpz1zszK3mezRTWSf9fBVyY0/LBzEV03rFjHR4EyjMvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901690; c=relaxed/simple;
	bh=zW9nqbcwzZvUJjmMQ2ZwathJgs5Hxn43E8zejhaaWh4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ag6yCp+x9IjuEl4FygqMAMVuU+9nlgr1tjALvHYPZddwoyLVKVGc+sGxuUQ9DSHdgOv7JSJAOvgRPQt7FhzqOUh6Cm1cEA5psKqiWTzhaGpmw9D/ZE2t9OaixsRPkzXMz9GluKQr+b4y2MJTWGvyfXgtKdbWo07mzrX8xaxybIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AVfHhKKs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AVfHhKKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637DC1F000FF;
	Tue, 13 Oct 2026 14:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901689;
	bh=zW9nqbcwzZvUJjmMQ2ZwathJgs5Hxn43E8zejhaaWh4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AVfHhKKsxo3aHL0PwitLJQ4y4cpeJDTc3Lcqpekjlt3Ax3NUdwI3Syc4AXi/kpbjd
	 zcCjB+OkLMG+riLcwA8Imhu/lueBC6KccALTfS9y/SVbp5UK7gsuPc1VZw0HNsgJEI
	 D8Pbid31k/Seqwdu4ZGRXHjgQ1BCyQSI0cFVW+uwTM/h1EtkGBWJnZ57Z9JZlA7fED
	 Y6IgSKjTsxG5gyLMTVZplpqKGPb7OiYFX2dYm+AEaCyE3mq7Q92fXfu5DI/pBFUivs
	 dvbVfKKP/WuNtHgiC6z72gRvUeK0OzQRBBi5fCPC731ZSkJ9nGp9oKDEz1+M/N4per
	 gtVHmuwinAOHw==
Message-ID: <sashiko-outbox-169907@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 06/19] PCI/P2PDMA: Document directional ACS routing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-6-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-6-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:28:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> P2PDMA documentation describes ACS controls as path-wide, although Request
> and Completion controls apply to different transaction directions at the
> path divergence. Functions sharing one PCIe link may instead have no
> internal peer route even with redirect controls clear.
>=20
> Document the Requester and Completer roles, the directional controls and
> the separate requirements for sibling functions. Explain that a missing
> internal route requires upstream forwarding and host-bridge support, and
> cannot be created by clearing redirect controls.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D6

