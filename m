Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793320264;
	b=pNTP4mOCFO4orlXCsoK3gcGHqpfHIcGim00fL5XPDQrQILcm1ajLFt3e96bUWGARK/eJ
	 xq6BlFAbaTMVxXiZbqKPgwo67F8fKtWezhjMKD6JsRnxMB98sV82MUp8dx4y+7q5QJyWM
	 ZT1zG9DR1dTeWCsQSV/v+NmS39oIkkngvM8m3PwqVurD8EqLvoG1pYjx9Ph7dvOG1Brdn
	 jJ5pv/tZvZHj/24Be0MFP2tBeEZiG1DJWyAUs89Cxg0Cl2D+8/dBzhLO4glk6PG8UEK3w
	 BkHK36UXxvOxmfbYOtkAv8zrFVZXXECrGI3pnn95XHSr8xs44X1oBT9Xlk1Maemx/5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793320264;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ChOTsNZjnQ6OFlAbAaqLQu8ysJYkxnCoZ0YCNrW1AAI=;
	b=33YQjAijYB0oIWWhcltiqy3oFvyz/ablu7CBA5e+TxiL9Pe4IniHiMYG+/CsCjyOCxeM
	 +4O22vh0VDmngx6D443ZfmAywJpe29B74A/BABDYBLiz9A0U5P1eLZBHTlD/jv8/NNsFs
	 f2WDKg8K1vwwVsHkNM6kObLZBUXjRFhB1FnmvGWdfLCWc3nCMKAaLcdJ4+b6NiivzSbu9
	 DZONL421HJeKw3SR7suB2TQ+McjMoQSnWma7Wlw/+pjOCO5UKUcXBjMOEp1WBnFWoFspz
	 vaVNYpCvcp+piPQJ8dSc30M2l0RV2b0AyHtUgIvvL/IQwgtjOKIwT0zxMkDwgkEQCRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m5AVrTZd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DF3606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 00:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m5AVrTZd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A151F000C1;
	Fri, 30 Oct 2026 00:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793320263;
	bh=ChOTsNZjnQ6OFlAbAaqLQu8ysJYkxnCoZ0YCNrW1AAI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m5AVrTZdLmns58nJgZpKk5dl/0dmTjFg/wf9czeGF5x5C75/HspuPJqF8ZodHIyJu
	 2/DTO7dds8WHsL30Wlh0COnYUet+p6sT5iY5t5k+cY7VlxtJ6WD3FZ5ZEQCDnpv++Z
	 uk0ftknafpxGp2ljIXPdnNipC2p/681FDc+qkZY2RCxpzjcLGTZ3QvaC3RPe5XMdGQ
	 MIJrTFQVM/kHitUKwWb5+0vekAI8DeLY0uo7Kb8YNZHuq1tIlmjjfLl4c7hXwVGEt6
	 259z4W7L+3CBl+H0gok9tInSmCWfIIus7khYsWB7mi/6KrICDEusBFmO9XCJrU/8Ze
	 TS22Qhivpb0rA==
Message-ID: <sashiko-outbox-190128@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: IPOIB, Fix QPN lookup race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Prathamesh Deshpande" <prathameshdeshpande7@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030002241.8508-1-prathameshdeshpande7@gmail.com>
References: <20261030002241.8508-1-prathameshdeshpande7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 00:31:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5i_pkey_get_netdev() reads the QPN hash table without ht_lock,
> while mlx5i_pkey_del_qpn() removes entries under that lock and then
> frees them.
>=20
> PKEY child interfaces share the parent's RX resources, so RX lookups
> can overlap child removal and access a freed entry. A lookup for
> another QPN in the same bucket can also be affected.
>=20
> Hold ht_lock during lookup and save node->netdev before unlocking.
>=20
> Fixes: 7e7f4780c340 ("net/mlx5e: IPoIB, Use hash-table to map between QPN=
 to child netdev")
> Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030002241.8508=
-1-prathameshdeshpande7@gmail.com?part=3D1

