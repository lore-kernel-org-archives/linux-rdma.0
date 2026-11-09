Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794212254;
	b=Jvy/YE0kn1PEjxpMkKGozFht/qfKkmiqHBLr39q9vmRrUWvwrpq2G6t41yc5EIV8tI8B
	 1iEsbC8Fp6t6TJ79tZhAuc/YnZ5z5rycK4yH7HJdsmVFiX6PwTbME5wB517k8Xp231Z8f
	 oPUFQf6Q8CbFkQ+C2AhqBEU1Dkl2bL9gpZvuBAm/E9/7s/0101H1vpQFr8F8sO3B3Iisk
	 b2ptTtfXmfSA1wgAHLKdea68nTAfuF82tkCpOx9dkbI+GcCHpH/+qPzyAMR7MLphH1EM7
	 A1tmruvC2gyaaW0EU3rZc5FCpJILCJB3RP8Y2Lc/0Bxii3urE9Bb+H/IIP8iPfK3PXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794212254;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=H++bxWxaOTdrJ0Mp7NFq/7NO4bmuih/gMxYPCkSm39c=;
	b=2Y8Fzgdaf7rAIM3LfHgpba6N6c9iWPD0eFYVQleylSqFeGThfCQQHwtBI7Cb9XZaFl9D
	 RQfo024IYeH2TN6k7EtUL7Y8siir/L1lUZEPoGbcN7h/DUu7GGstH23wLMZ5CPpTKNDM5
	 9yNaoK3ms/jd9Zb/xUim0gXEo/fwqurPTzDnhRs7VvKdDGcpO7y3ioxeQUkqQvIjXJ9+L
	 /HlZCHzbvBsN/Qyhgg0hrLOJ1ztJ3kN+71iWG1K71MxImwSHFNOlL9nZTGZnjY5NvFemi
	 GAsmdSPRf5I9Jr5jXqE4VH13cGWLL5T1iuSbxQ/x8F1sa4saC6SVmZDCUXgHpRjdYNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dhFUYaEb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09503606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 08:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dhFUYaEb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54701F0089F;
	Mon,  9 Nov 2026 08:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794212253;
	bh=H++bxWxaOTdrJ0Mp7NFq/7NO4bmuih/gMxYPCkSm39c=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=dhFUYaEbTxbcM5jkup+RwCbQtY5sWoHWjgcjgQbrVygErvPX8wfbzjia8kADz+6Dk
	 WICFw0BRVOVlvvCC7Pn2vS+1ejKxQwh8RTSr+Mf+YCCFORAh15uGeLT3f6imnqS3b6
	 sA/SQ5y0f9ORKfgpkQBv4rN2iPCFSUWotT0hQpORIz+pnoT3IomLQeO7z6PGvFIZwz
	 jLODkRWWuyMim48jLbpkt8kZEQkpto8FVJLeswwjva3i7EU/yjDsv0Y1EbL2cb25MH
	 7X0PIsUpdvj0KGJhacOOOTywy54COPATAFvgkM/ELSysIqArR/VqH8BipPbwENKrmb
	 DvVQ4e/bQb/XQ==
Message-ID: <sashiko-outbox-204580@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next 1/3] RDMA/efa: Update device interface
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ilia Kolominsky" <ikolomin@amazon.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261109081349.27316-2-ikolomin@amazon.com>
References: <20261109081349.27316-1-ikolomin@amazon.com>
 <20261109081349.27316-2-ikolomin@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 08:17:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Align device interface definitions.
>=20
> Reviewed-by: Michael Margolin <mrgolin@amazon.com>
> Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
> Signed-off-by: Ilia Kolominsky <ikolomin@amazon.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109081349.2731=
6-1-ikolomin@amazon.com?part=3D1

