Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794473697;
	b=n1pC6B8lqR2/LVDU0yBqmljo8GIjwfdU4vYfkfDAZwXDYR+vDVTyQX5dnGV+TsocVmqf
	 9cB7JB6gKlL8u0Qz+vAmn0smKdrBrxd594SbJMLqVbFgTTT+LwMESJ13HG2JrdbPFqcuG
	 I13kKe8mOfWXuVm6OEc7wF20dj/H+VzgwMLCGavoGqJhiLC4/hI2aQNtsL0bkaHgUAF2T
	 aZTJLXusoXDv8B7nEY/SV8gqNecNuaONYvLIfo1EFOLcCoTwqw7sa8/M1NXdeo1SB0+lk
	 6plqHCf5xGxhmpkQwH50+LbQQZumReiNhFdSOM6ymSzOSnso2hJSr18qOX8NSpjcAxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794473697;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=agYjtlPVrXUx1JpyDDg5OMp4jj9TP/xbtubBQgEubos=;
	b=fEvY77tCz7//hE7Q3clpATKh3ZY7Iw+NAvCDY92dnzetND5WEkQwVJS7mtF/ecbSpsih
	 QbCDyWhI1PzWzwWZ3fgi2hI3V4MT9/Rpcl/IDdxHTmrJ6i9eatSbtWGRa/t93Hn9wlVzv
	 2J601RURX92i6bhr8Gmd9YJfJ0vDOgnAEQBo4SwrxmUqJwThUeKxoUIREd8+rDTk286nr
	 9UDFWp8JlGnZ/USmUjp+gySuq5pHXevHW8/C4v4kY/AifItoGM8HmavxQWycBaMHSkZBi
	 nEksk4jRxoBqyMNoL2TIKiYpJCK7wANlMn6of+5VWitoaEZjbG03XtvwUIq8xHTOlmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PBlu2IZ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07346606A323
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 08:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PBlu2IZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8061F00A06;
	Thu, 12 Nov 2026 08:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794473696;
	bh=agYjtlPVrXUx1JpyDDg5OMp4jj9TP/xbtubBQgEubos=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PBlu2IZ2+HgphgYCtZwIttu3Zcj7aa4b0wKP0X8b6ZcXocGsUB8ql3Lzxr/Oo70y9
	 MF05zLHnJ0ANqbwJfTHYDlXbNV8d9yjSpJ2DC/c9qD2LCgCU3aCdD6qvAymm3ixOwx
	 HUhvGnTzWwLzxRPGHP4A5TS9+Q8sn5mJ4ufNgwVNSnz4F+CxIyfe00lcDGVdbViCNW
	 9b5m6HYsqp7vHGwipXD+zLrWvbDw0gRSeBB+gjB0RrbEtKg8wKRjgxR7G9Nj3GiQS4
	 nfA+9HeM3JBlhiQHKAOFCGrprVnCxFzykK5NQ5ZQ7Y4WOECoBX9gXNe8SoB362Od7d
	 By4YBoWbEg52g==
Message-ID: <sashiko-outbox-210798@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v11 4/9] RDMA/mana_ib: Maintain kernel RC QP
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261112084716.1483342-5-kotaranov@linux.microsoft.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
 <20261112084716.1483342-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 08:54:55 +0000
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
> Update mana_ib_modify_qp_state() to support RC QPs. Initialize the
> packet, message, and frame counters for use by work requests.
>=20
> Arm the requester receive queue at the initial PSN so that a CQE is
> generated when the specified PSN is acknowledged, indicating send
> completions.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112084716.1483=
342-1-kotaranov@linux.microsoft.com?part=3D4

