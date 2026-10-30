Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793365604;
	b=PZNqNyx+AnrK8mCwO6hS3ldCdWwY/t/xObe2EvgRjUU5kGIhLs9BZcU8L9EcsWLdY/eo
	 /b6KZcmGvTnaYJHN4+8gCVQCrVrB89VNZ3KHTgOGziE5T6+LeD8AJJPnpjjMNDlZSwxWU
	 gDiDTTBqZ9vbQF6QuPsPvj7zVpmJLgYQmBKduwVZMS67ghSWEzzH7bx+JY6po1wlQdknm
	 CfzdIOjGXiiP2aiG5TDs2tR8YZzduO9zWQjF3LOTHT4UkU1PTbWN0NgftkAQJnQcQTOzo
	 SZ3pMAuVKvslmLcFGnJ6DqS3DzEAAwq3RmFY7UmToykA7Gl7yRIpBj+ZCGg9uJ8ZD5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793365604;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=B4Y3gvfFFB0nGxgL4NNCqNiToxK2oCffQji2UCcc2z4=;
	b=40KoKlyY74FO5ggk8qyo/M6w/weg+dV3qh3SEszxpWo/GA+kXiAEm6vov3Wfdp/plDXw
	 PzdInlGJ8KeLVz0du76r6oXgiK+gU4+JP1AO3oK98D584YLhXTVZpnq23LdNiS+9FA3uB
	 ZclFbZwxlVPboEmonuhM/Fa383Kmais/BaDytkC0P+kEspzWxxtj7lujw8w2Ez6ShVejZ
	 4tzLUz7NjodV0E/LRftUXnjNmrgGTXo7Cg7fjm9BCif7zFmfj+gUFhG5w7Z9mo1IbNZOy
	 9TpPiI0oxstjt1tOr/uuNzpRrxEb+SXBz3Pm7uFR7qwYFSc3oCWm/MDcF8684vk+5ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AA+SJwDL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C669606A320
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 13:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AA+SJwDL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5D91F00A15;
	Fri, 30 Oct 2026 13:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793365603;
	bh=B4Y3gvfFFB0nGxgL4NNCqNiToxK2oCffQji2UCcc2z4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AA+SJwDLBdJUy2Ohu6c6MqxU010I+v5JfMjQSrNbzWTlALN3FtUNSp6qp+Rd4tc95
	 AMPcZdRttkknSL1tqh+kDAtMPvaR/X8N/jjG+xSNmM7EVIphHkgi3ILlUW0oSAlzyP
	 DIZcHlSeFeG8GGRMJUrT+Zu2RW6yFO+++8Ms/Aszq0wOQNKVLK01VK/Ylre8hrV5A4
	 Lz+Cj+DDmxAZQoiMfE3ONsAARwEGUT6pMz8GK176ggiC0tTVXYrLacFFSfGP0KYbKC
	 zuZnfa+StYxF+40qm4BtxhCrLWirHEnhn6s5n4DhAy5UPs/eZLcD008p3kjS328NMk
	 /EkdjyKInlAKA==
Message-ID: <sashiko-outbox-191045@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v6 01/10] RDMA/mana_ib: Allocate and map
 fast-registration MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030130038.4040789-2-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
 <20261030130038.4040789-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 13:06:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement alloc_mr and map_mr_sg for memory-registration MRs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030130038.4040=
789-1-kotaranov@linux.microsoft.com?part=3D1

