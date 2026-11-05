Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873518;
	b=K1XuQLjTqEopFJ6AenhHzNjatKzWcqD8JiR/5cEMlTXMTKRkw+A2/4P48lZM5LPO3Bc6
	 LNTBwjMUEBKktbWfg4Nq+d6HdFEROWTmfBNIeD0kmkjm/9NSs4Y5Yovkpd9CZ1xTJaX/A
	 FYMIYtoSbHYYvHwIpq0vVs/Ao6IM6vI4DI8TUelvuM2KojnHff0wTiboCSne7NFlbMaQQ
	 tOPBCXvkXtEOnQ/xmEPfiIIBiHUHVuhws6S8T1pLLUE1GBLeeCy1cqXVY5BIBRHlaTdG2
	 jepmcSzM58e3pJe63MCdfWABZXAWDDuyJbfOSnwo9qZg6hSD0UMvhxcttOKlbG6V5Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873518;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QuKK9QKD88egRoEiPff5CwHsj/iKSCv/MI/iRQBX8xE=;
	b=XGkp8kb0qCFxRJ2XfMPoH0IviQcya5YGSa7PqbE2sr4qJilTEVgaywUPwSS28NGeqRD7
	 O72pruSdSJlKO8vB7XgzDkZ4138ju+OLN8zlUiDDKvYe8E9pIdCG3kzExoScfEh3uAkXm
	 EIKanNya1rcu7IudPP+FLOpDwlxCSvmC7370SQ8dlaxkttOBQD6fviGwBZPHbpEtbH73+
	 d4FoK9DdsEMlgJava/BdZTtHieyoXlJUxGWxA/6zOZ8okqp/xlyRBxvvRLWESE84Tc3Xk
	 ouW4AdKX+jBdfsD+Aw9PvB59WbVTFdC6ulu8TlN9g3LvW0FR8QRoKNTE7x//Ft+xekg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c1DA15X0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7719D606A336;
	Thu,  5 Nov 2026 10:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c1DA15X0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D942F1F000C1;
	Thu,  5 Nov 2026 10:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873518;
	bh=QuKK9QKD88egRoEiPff5CwHsj/iKSCv/MI/iRQBX8xE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c1DA15X0t8oUic2cKMFbgNE9q1/1WHi6H/32wiXgsJqiuEzzgopUSEgPYq8RdMtnT
	 dUYGeVu37QctJTs2B9CAaC46uHTYMMC4oz3c5DOkV7wTV/96JYhnQKJJgzpV5jAAn6
	 40r5azCyQu0qf5rYAMpOEuHsENMVqq7qge6SRK+Xa9Zmd5kF++wg85uqRP7m6CUC3m
	 9gqg62ii+U1WeyLxNwB4DczA+wFdNMdG9LVA4IBHijop6NfpLGrLzm55o/31NyPlLA
	 dAdLruJZFfO86H6SJVGXLwqd+Qmp22fB2eSu4pk4ml5Nk1feVXAA2cZ3dXGnD5WWLx
	 mwhAgHNZXANkA==
Message-ID: <sashiko-outbox-198818@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 06/19] PCI/P2PDMA: Document directional ACS routing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-6-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-6-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:11:57 +0000
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
> the forwarding requirements at shared ancestors for host routes. Explain
> that unusable forwarding leaves direct routes available, while clearing
> redirect controls cannot create an unsupported internal sibling route.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D6

