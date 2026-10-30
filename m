Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336043;
	b=Hnr9bdLxNo5NtKvtK4fvCcG7P9vsY4kUWR77YecGO0Pb7HnFBXJGSUpkN3A7NBtqkzQY
	 +F3Nnst7UzaQQOkj9OnXxG4jteyVD5Qvv/y8BJMzal0qyoX0UC3Us7DzcMeUN4yrs0woy
	 5KaPoQJmKYfUh+bT3rraPc76p29HkqFj4slUJAMvf1qljrBAlkbOJ6BgPVFHEHiuu5fHx
	 qPoK82FJeCzIBLNDKDrDvy0LbRbHBRR9051ewn7153rxGhZaBJDcLOSbGoh1Br4uxk7yb
	 kBKYpwwlhS/3NdLDPb1ynDzGD49QJ0seZsQDpJXOqhHw5zFnFxy/eJEeimc7bKxAnYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336043;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LMMbYHyxoQ7TdC0EkF/3ny8qu7lIVwCpziOnBCQqmPc=;
	b=Ki2JemorywM0QakibpOaJFe1a/ccj6n9t1X6TJiU8XmVdFY1JR0LoO5Ql/ezUW2a8ba0
	 EcQaKcM2/br0UZZfVm4GrfMqFnZB59a6UrKc4kMrJB8bXEXPrjUacf/6OKzgHBf9hssai
	 DGNs8/w/CKS6p/fLW3tX2c2l2AnFoP3fFwrWsavG/fh1zFVDg3iIynwRyk0vQWZaCFlOD
	 wKTaWFxCNVRcdc1B/cfdgX5ZYrJ88txRsFIfyUXw2fBdjyPktxgq1tNfy68EMeucL+ka+
	 iR092b9l+04AZJ4GOXflG5hCk7Q7E8IZ//U4bi60Qi8dsl1Vi079l/+rowFBjvZ8vYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nPduYhn7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE0D606A324
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nPduYhn7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F501F0093A;
	Fri, 30 Oct 2026 04:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336043;
	bh=LMMbYHyxoQ7TdC0EkF/3ny8qu7lIVwCpziOnBCQqmPc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=nPduYhn7l7irHgrvB+FJ9HEdWhJ15lKreCsCuwD1/ZmWbGRwDBJ3enIrPUYqIHLXM
	 tNMEhaRg8hyjzwy7dDRAc08xABOuAJs4DJ6KR259SHon3i60VZxhrXDtsIJFcFOXDe
	 OFRBVLUNLGQAM2w1q0Rmtl2nxIkR2cea9LlQsjY156w0+bsq77HVzSyqOopbxuooPV
	 EJLr1PALNVS/7XOTmYIVYh+9V0BNpklImDhozCx9sncVjqT+6latk+V+ReVkKQLhvE
	 h2WE7XuiscA690CdaqxllVq+3mOkziu/5D5WbSCJfIKxXIfTBgxFLDmdo39MBxh9Sk
	 sB/UEfwZkjkTA==
Message-ID: <sashiko-outbox-190397@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 net-next 2/9] net/mlx5e: trim stack use in PCIe
 congestion threshold helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ratheesh Kannoth" <rkannoth@marvell.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20260508034912.4082520-3-rkannoth@marvell.com>
References: <20260508034912.4082520-3-rkannoth@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:02 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> union devlink_param_value grew when U64 array parameters were added.
> Keeping a four-element array of that union in
> mlx5e_pcie_cong_get_thresh_config() inflated the stack frame past the
> -Wframe-larger-than limit.
>=20
> Read each driverinit value into a single reused union, then store the
> four u16 thresholds in struct mlx5e_pcie_cong_thresh field order via a
> temporary u16 pointer to config.
>=20
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508034912.4082=
520-1-rkannoth@marvell.com?part=3D2

