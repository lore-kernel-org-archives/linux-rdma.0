Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794287678;
	b=KOz4YyJ7SKovDGdViXdGDYsShu0nAHiUI8eHBzx0OLbonRM1uYUZQmjEgWjsbmyjlalQ
	 BWvidWZgjjXQzrsZkp/eMmUgzw9BWnbWI7PsTx6i0iRjAYfgD1QaJ5kyLkBgVN1JWuc8N
	 YYf+3568SceBdq/9Q/0s3AvFKR+LMpcImErWFZnO2tPXEtK9TNOJV4jmmHE5mfKuEiEeo
	 6f5lzdZwfhNosOJ36SFY7eZFLW4iNZRYs7ccaiknUuZ7Ac4Vt0fjKqS/H1b6EjFyO9oIH
	 XbpwEGoj3rwqnejiKa4sDxAcvi7U2wKsCC5aj6FbmZm3i3c3O+ZkVZdzZ1v1p20qYFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794287678;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lz28E3bw4HgiyhPz/u/8Ad7b5FrJMKNN4JXBDMjc2A4=;
	b=hIhmLzDs784zVBWt+T/Vg5P0aom46TbqSMMj+1qAadKgnbvLQS4uiA7IbVbP1mUbsUpi
	 VoZurCz2v+pX1BMROdIDYsJd6zimh19gNZtg4ddeFk21evVRPjVkuHYd5Ure1U/l5/avb
	 Lqm8iFIvaYBaiAKDu9Mk+duVGa5WlZhJ0aUBgztyHZbhcHWR5enR/yFQTmYjV7gNfYZqx
	 aV6RhhXCI4USYQeK0ilRSMSGCv1bhqL2Qs3EpXUFJfgAzPyMIb+TN6iqWy9iqpFzBgr1E
	 1iW0sVpXeF+/kRKvJlyPwHQZwZC94S3haFvNXUPppgJjrV6gSihtWlGgmPCk6HpCEBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dl0P9OhI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FAF606A325
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 05:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dl0P9OhI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A911F0089F;
	Tue, 10 Nov 2026 05:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794287677;
	bh=lz28E3bw4HgiyhPz/u/8Ad7b5FrJMKNN4JXBDMjc2A4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dl0P9OhIv0T8V01TfUPD+dn5LUeo6yloQCUVEBcZR/rcrc1gwPuJREM3xDg9NJLDm
	 VQzPOx8udfqFWwW2kAwvJy6wLVC2PsAZ5O2CPXUZYRxk8WlShA9I8S949neur6O4nU
	 5Ge1twxj0Y2NAN55+f+fpT/VIU50GkvEWjUOig0HhdsQs62DAiwKnpeRSoZWKO/u+Q
	 VIVnOJH7WnBOSagDkE+ww2B1qLBWYLp2Ey0eXfBuN4GtEEYgl4aG/qrrgoZvy4TgtG
	 /dhjo+s6o1atPgz9KrOPcPWZCjDoeJWFcVhchr/zZ7vw9LaUikvgNpg/ZTnJycMYiZ
	 5ZSXpHW2xyCtw==
Message-ID: <sashiko-outbox-206270@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 09/13] RDMA/core: create a queue pair ready
 to send
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-9-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-9-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:14:37 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Some transports have nothing to negotiate, so a queue pair can be ready
> to send the moment it exists and the modify sequence carries no useful
> information. Let a reliable unconnected queue pair be created with the
> attributes that sequence would have supplied, in the same form the
> modify command uses, and apply them as that modify to RTS once the
> queue pair exists, so its checks run. A queue pair whose modify fails
> is destroyed, and a later modify may change no more than those
> attributes.
>=20
> Note that the QP handle field is refused, since the create is what makes
> the handle.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D9

