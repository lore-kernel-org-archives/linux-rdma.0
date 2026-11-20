Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138322;
	b=QdBKHucVA5t4ODjBOQxRLzTK7I2rFKdOX7bXQKuqQgXI0jQ+/zxoKgyCb2okTT8OPHFx
	 VF/zbiuQbA1tfSXG4K78ALI4GW5s5iwjvpY2mx1Ei7R6Yssw5eOwExd4rGwm6YbfvFBpn
	 qzuB3DvrL2OmpxmUui3mfBu0PUc5c9jNY4BmhJUUMGb/193Ne63N9O56+0xn8gkVqSK/L
	 9VvFpwgB28UDJZfqNbGJSEfWN6idE/6tEtwwajzfy0dXSyp8BdgyUerCknGNGGGIT9I5y
	 nfNsumy07uO8ibOrYU3k1C9Zb/vWcDJvyJ1Bmcy98znthupdQ8DHWzOIb5AOGfymISw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138322;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K12yAEeqM9fUTb4kTyzBJw9dS8O7Nzgo6PpzHyr9f+o=;
	b=k90g/hsZhSLQKxKopEFoA8ltwEtfAWHv5fkSlgdh3b5h9w6NwJVKUmjW4cFebZTpwNzS
	 z41oiVy3y2Rx2kN28hFLUjcu52/s7OidiTlVvJMe1XkDMYiFG+Ua0EAl0OhbC5XZh4sz5
	 DvvCsiG+7XS1paJR42nbaVN2TEnqC0nhIdYnKV3E0YJxpH/Xnj9QDPJ32L8sFvAVdE6qc
	 D6ik8QqJfQtfJdJJbnUsjvlJa3fBFUXYPNX/S05CHrHKbPwfOTIx08S2I6GjuNKz+8/c2
	 53cm0GmSlS+XTNwWCCnbzAMBTpjMot5B0V3L6uj1rJpLHbNjc+I7vA41XjB203c6gqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WURjHJve;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19711606A32A
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WURjHJve
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4801F000C4;
	Fri, 20 Nov 2026 01:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138322;
	bh=K12yAEeqM9fUTb4kTyzBJw9dS8O7Nzgo6PpzHyr9f+o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WURjHJveUzPXBbiyBZXoChYX+fQQIHN7eTUaKZ3DkIQcp3NQIjR9KauRAEinN4oQr
	 X96YJRz+Uu2RDToKuWDOjWx5/c0FnwqVFl431VMjofY/bOELpBgyYqfY5E8ESqxGuk
	 YzXYydjOuVfn2DXAu251o23HW+7lA0Jil2RLpzjewTNe+F+3TIonaUcvJEY1DCerzb
	 KUWoKS/Gkl7jRWvhUqbcEDcu411qBL1YliQVBT3YC2Y71PxAAFdM/Kbm2MBLmLn2oR
	 KfksX6ItffCcop7+MKO2zOJLzc8DN+tjMBQfFCEahbZ0loAGgNgiPKQSlEDWnMnaHY
	 XZKcUcPSw409A==
Message-ID: <sashiko-outbox-224317@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 10/12] selftests: tc-testing: run dependsOn
 probes outside the test namespace
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-11-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-11-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:32:01 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A test's dependsOn probe runs as an execute stage command, but before
> the test's namespace is created. nsPlugin prefixes the command with
> "ip netns exec tcut", which makes it fail. Every test with a probe
> that requires nsPlugin is therefore skipped currently, for example the
> mirred blockid tests and the tunnel_key nofrag test.
>=20
> Probes are meant to check what tc and the kernel support, not anything
> in the test's namespace. Run them as their own stage ("probe"), which
> makes them run in the base namespace. Add the stage to the README, and
> say in AddingTestCases.txt that dependsOn runs in the base namespace.
>=20
> Fixes: 98cfbe4234a4 ("selftests/tc-testing: localize test resources")
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D10

