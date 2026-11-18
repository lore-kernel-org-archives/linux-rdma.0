Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022021;
	b=F4fwm4kXscvUc1EIEVULP7V0JfvcDzK38ZKndW1goMA9Vv5Tz9gnOEN+5ehZBxHR9fDl
	 Qr07MHdKYx/rURmbV4rNxa0t3cCHa71xG6B2aoXLeinWsfGefbHK9Mjx29NwaFUtUY/lC
	 9nd55QxaSi9jjEKOzscnBh0BZT6DK+N90H0eXLAyYq9LeB2CnHW33sSebrWxDcbKLSoj8
	 p+hMadart8Ryqnj0kd9akDGCeXAqG42g/IQ4vZma2nem1RFG+COoCYtIIDGGkfTXt3NZB
	 oLTJKVkxyi1rbJ4nOYKHeOGF5SVXCnCiN898p4RDfZx5Rw0q6ARtN2WvSBL/SJ3E+bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022021;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RJ3Cui4qamPs425QqqLeM6kBemW8zqtzjErfTYmqCGw=;
	b=tZAZEkUycKmlA5eN4NLSH8+3Aqeg20HPbn9/brV12Bq/kK8PCkfafQRT2GAGISFuS7t5
	 U5ZXSxPCGlJ1p2TEKoMkda1oxkkc6L+2Ph+2REhPY0KBSdQn29OEC1wQ0EfUT4ukHb68b
	 oVwCZr5LjKMvQdSM7rC4iWnNjYKzQVgz63KSAXJazxkB/yRs7Z84997UP34wD768CFYVZ
	 z5t43soxzwuoGh+6nHjvK53QAr3/7Uv3J2oalnEg3RQGUO76uJ2iFmE9equcQnt4EwOY1
	 7iIrIqHatJz4CGHTakPCeSopVbAMWhI1aM7Uaa9AZDISzUxPrf6WhnreuyDgX2aNqgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwee8aw7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F46F606A335
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwee8aw7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F311F000C8;
	Wed, 18 Nov 2026 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022021;
	bh=RJ3Cui4qamPs425QqqLeM6kBemW8zqtzjErfTYmqCGw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hwee8aw7Bne1EuCB5kNr86EM9On39sQglgjHW6a03UVLSYJTYoAh+xOiTKt+TzDqm
	 hBnNL7ECyfPRkptvjwmzRksqsXyxuqVz1DXc3NUxBf9jCpzpe2xpAPzWGIjS7mwKPC
	 42NSJXEv/ejH3j7VhKlhGv1KXPXj3SjoZKIEaohCHb6OOyUD/Uw4c5p14fytl8ZLTm
	 Hf3TbQF5yYWaSBu1PbhfwR90sx325ElctG7s2ZY82T+DJXnNXSS7XHRTaJlt0yKKOs
	 mR3EoTdzv/ZqE0+cJ1/yssSYS/4LeV5wwonzjm4W4WQrok3B3kvFOOT32mK8J8oKEk
	 wKwUfVuI+HnOg==
Message-ID: <sashiko-outbox-221603@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 02/21] net/mlx5: Derive adversarial mode
 from CC guest memory encryption
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-3-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-3-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:40 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add mlx5_is_adversarial() to report whether the driver treats the NIC
> as untrusted. In a confidential computing guest, the hypervisor and any
> passthrough device are outside the guest's trust boundary, so the mode
> is derived from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) when the PCI
> function is probed. An SF inherits the mode of its parent function.
>=20
> This turns adversarial mode on automatically in such guests, without
> any administrator configuration.
>=20
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D2

