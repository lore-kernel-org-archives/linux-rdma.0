Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698750;
	b=BOBQ9J88/bIlERPijPosgt79v59wTWmlD7aowtahtFRKl6GR3BYF6WknA51yphakl3+Y
	 +OeNkANbd7a8Sgxzlo448Mwm8eibUlLAyXk50KjOQYmTsnHggdWb1JnIWe1YrXTzAW7M0
	 FBCO7Q2FhgFOC8A0tSm2vpzCDnjHbxmTkU4m2dOOroY3PYYQrlyjrTtd8WdC5Qwv3VWg6
	 9oj+QZu/5HLPryS3rgsefY2ycePmbLZnV+WzaPhKOuV5CCmlgrp2KQqHChqQTtMjyb3/r
	 8xwf+FEJeWeA6Ouuku492qaD9U2gsLTjLz4BiI7g9ungWI8tiNxBioPsnvi6BwJ55Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698750;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=70OZYAiGfrCRH9w66ppI1a9DmSJ080/BOFldkmgUrKY=;
	b=YBYfJtAkuum6Sbj8676bbuEe98jg1gTmPddQCe1oNIUQeKR1tlKRa1qWK7cwDyN52Mi4
	 G5DmQSsAUmK4dg4r/5e3XQe/o3XW42MQ2Eu9/mWgXWV5qro5zmdZi8gWVn+dO8q6eWg37
	 PZuqn6J5PXA7pp74QBpm0op15q9sWRPLsB/G4fSb0fspADh0WLwy71w//hYb7CuEyD0Xp
	 H0+SEgrfTDZ9V62cjaN52hxLII9XSgdlLktzqKGy4+M0l8v87h3NE9fW4Vb+1FEUnAJHN
	 DSsLh6NJWLewZmC4NFOdSe2HQH3b9NkJW6+AGCawKqehT4cb+D5f40//H/m/W5wUpPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mWbWiExk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A47606A336;
	Tue,  3 Nov 2026 09:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mWbWiExk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD9D1F00919;
	Tue,  3 Nov 2026 09:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793698750;
	bh=70OZYAiGfrCRH9w66ppI1a9DmSJ080/BOFldkmgUrKY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mWbWiExkLBcv4MdAdycawawclnUJbLii0JwfczPXvUDifRWrR+MOrxnCg3e21xoqN
	 xkrun/1MHKen1xZTYRv28M4c0x05NZXzlyMAHQAQY4N+GlP7XDTlxTPnQaYvF+/t3x
	 Ps9vZjd3iCnSfBSQZ1tnsvGYOuxHBi7yUNtkSBJVok3gtfLXpe5iJCmHrmUw/RYQFA
	 +SSJRpqxSRCY4bxQl5+yORoActf25lnc000TR0jMx0MKfWcjsfskokpGUReYzIu3Qc
	 70AEbOtc/RiJcZBRvrVQFZNGsUdUQUnJo0EKZckRdGN3vD99WaCcAwWq3g5eSC+9ey
	 znqxSKfvu1o3w==
Message-ID: <sashiko-outbox-194960@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 06/19] PCI/P2PDMA: Document directional ACS routing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-6-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-6-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 09:39:09 +0000
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

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D6

