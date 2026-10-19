Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422525;
	b=AT0NmcP6Ui4zPXrEYF8utrzTThRqyjrZ7y0r6Tt4pYp+Hi622hU0oe1LLBoaUPyfsSSz
	 CeizfcZY7JFDlZDrBNI4fObMrq+IUS32q/yshmZ71nRnvd7vT7w1htL9TECqUk8tsIO3c
	 xi8gqtkapa0HR8ZKfCPvm6crcVnkGPWk6492npG4XJjLZfIVs2zx7ReH876kQAQzmsWh0
	 eUv8jltP/YVVL7rrjHj6rR+g2uhmkl+L6DotQO2bleqbt4TQQrqvijeZUGWQTJtUctDQ3
	 UYkWe+bHB4pZD7CZ5UCVUr4MREp6/AImJ07bO+DeosovWVH8Q/XvuSHchuLHPqurAVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422525;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uXfUL82pkmX2kLHkpR7FIbdmlkIkcFkrHgjPHkxNzlk=;
	b=GsWZNeC1BsM6vgmBbENjq66bZpzxRMZEsiiflYpjJeDamqdu/eh5KBPOtfdRtGIpYDON
	 CK55Vz6Yedgds9SmC4ueeb5YD48RwlEONktCxtc2ak6Niltg8+skzS3plBI0D3HoKPMFO
	 7wUpJql+82vzSBrWORKFQgxzIEOVWBhpQ/O99xqkjLHMOz+wXEKEmfBR8gGmNdZFWsixC
	 dkkYbz96HD0K3CvmpeXGA1EIa46MHZStJls7sxDf+lV21CYNhPRK7SfFrRQyfs6RdV7da
	 DqP0OOjFGW8e71QgtGYvZZIubOi66IGSTguxOeSUWY2Z/hgIR5tnrXCl/B88k215C7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jjLQ3gEl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9826086055
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jjLQ3gEl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89C01F000C4;
	Mon, 19 Oct 2026 15:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792422524;
	bh=uXfUL82pkmX2kLHkpR7FIbdmlkIkcFkrHgjPHkxNzlk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jjLQ3gElRBb3iufkEJnTTIy9zZ/a8QgWCb9h8b36mnuf0ddh8xEa9u0Wy9FZmN2vQ
	 a6xoECiEpfHNFxNDU727zaJ0M6rOG1xRViKtbktyu+tETYOwmAeX0SqPD9u8Xm1rwV
	 vOvKmQn9CUBt2PNYHGfgUYZYhxvaCy6AnRREFbC7Kd7cc31Ky1JJB4+9KEX5u6kNdU
	 e4TpyHmLvUfQDZdxSOHVa8yD4LKdb3xBSBf35ABNN1i5PIrOTZNRZG38WUaL9NBhau
	 MZ+sw2m+8dKdh+rXRMnMWfevxGilg/442BHsqA8iIVR4V6WaCCdNK/BaRZoUQifAUL
	 V5YJ5BvDpytIQ==
Message-ID: <sashiko-outbox-177622@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.1] RDMA/rxe: Check PDs for memory window
 binds
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019135441.1420968-403-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-403-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 15:08:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Zhiwei Zhang <202275009@qq.com>
>=20
> [ Upstream commit fbbe1d5cd7d400a98afcf337969cfdb808cb198f ]
>=20
> The IBTA Software Transport Verbs specification requires the QP,
> Memory Window and Memory Region for a Bind Memory Window operation
> to belong to the same HCA and protection domain.
>=20
> rxe only checked the QP and MW protection domain for type 2 MWs.
> Move the QP/MW PD check to the common bind path and also reject
> binding an MW to an MR from a different PD.
>=20
> Invalid bind requests continue to fail with IB_WC_MW_BIND_ERR.
>=20
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> Signed-off-by: Zhiwei Zhang <202275009@qq.com>
> Link: https://patch.msgid.link/tencent_FD4FB25AA4FFA845E63F5AC36CF4A46CDC=
0A@qq.com
> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-403-sashal@kernel.org?part=3D1

