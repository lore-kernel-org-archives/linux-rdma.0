Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793164058;
	b=ehAfuZhZI+50Rdb3dXOPzvQdX6eK+StEUmlbIV46mnHy/yNdJvhklZpLS5GjldTMXgW/
	 MybVZn5C+2hCGLklyKR25Q1XEqYXXuRKsCvKJ/GWdovzkmAQ/fADKGbYee/PF6LtAfPMz
	 o59oLYIl0042Y1uVHVseLH5S/wVi6LMj+jVU0eBuJGycwT7FGKSeAMxkfXdR/tysvYZNV
	 3XZ6GynjgqnCr5rUOADd3ltbVn1JibQCxXqw/i1BpKK4TsYpiP/3zQlpW3pivbdmdv4q+
	 n6cttY/i169yBLDm45pY04JvNsioiX6mRd8YrjRY7LU7ZObidbUZ3biJQPyaXMPw6PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793164058;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OZnfx30dEycAUSpL0nn60lPnk8oxzSNvCV51Jfne14o=;
	b=u+TEa14oumBqs4JbXTckFh2GMIxCL+yCE5ECqu/PAzEHMLjaBSgG7sHaGohQATI4clOG
	 LQD9c9nGGacGPWJk+cvQWrq7Uo+W4ddhxPNIMRCADQ69bBJfvzSqY1d/FI7pnTkLK45N0
	 +CfyWIyYs1vLW+00AwpJAE+zq/Q2CVdiOv6YliYZdgWX6MiPUsZnuON63YwVLS6eKAXyW
	 +Hxqgn/Ah9RS9hSy3nEqZPSDPhPuUTGDyItUVBbzY84wq4RSnAB0649mCYV7iF8n38BjA
	 Fg5Wc65L5KMCw7w2lvOePblzEAdBbBiXqbdytTi/lzO3FDebnBBuEU4WjwLtGh9y9NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Rh9/MTGf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D097E606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 05:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rh9/MTGf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899C61F01825;
	Wed, 28 Oct 2026 05:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793164057;
	bh=OZnfx30dEycAUSpL0nn60lPnk8oxzSNvCV51Jfne14o=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Rh9/MTGfvJsDrqfLJ/xxMqLLKlH2Z1q+R9UGMjtFBtn5Z9xF+9wnVi7Ky/5W082p5
	 yKhqv9GRTCBUoxU1thhN38PGOOS3/A9Fhu6/8qLLCkVtUPJzVKtaDGCHikZ7SKQQTg
	 F+dRAMbjZff7ot7rBJHSTQhmsBfd1SUDHUKpGJiIjL+uV70/ICiNoUJnGNrKR2Nnii
	 Q4l6Gaiko7BGrwfOtbYW2sJy53I5UUswyLhNYg0K/nI2V9Epn8Ox5P7SxMgXdsTyZ0
	 E9d+BFwcuLNMQUBMtRvOdhSuI/Hcqv1pO1vNh3hxWfRCKT5kJAAhowehVl778KiZmD
	 nbquTzZiF1bzQ==
Message-ID: <sashiko-outbox-187503@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/core: skip compat cleanup for init_net
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261028050245.125370-1-yaojiale02@163.com>
References: <20261028050245.125370-1-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 05:07:37 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rdma_dev_init_net() does not allocate an rdma_nets XArray entry or
> create compatibility devices for init_net.  rdma_dev_exit_net() still
> runs the common cleanup, using the zero-initialized rnet->id to hide and
> erase an entry and removing compatibility devices with that ID.  ID zero
> may belong to a non-default network namespace.
>=20
> Handle init_net separately on exit, mirroring the initialization path.
> Only tear down its netlink state and leave the XArray and compatibility
> devices untouched.
>=20
> Fixes: 1d2fedd8561d ("RDMA/core: Support netlink commands in non init_net=
 net namespaces")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028050337.1274=
64-1-yaojiale02@163.com?part=3D1

