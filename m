Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138321;
	b=2e6ZzzduC6mPiytlRTW7pKFbLcYNIHi205l8Z9oV7e47r5uPX5hpI82sxVGn5SpheZNJ
	 c6xiaIxPUIym6uSS/aGGWlwJj+X5TUmEqcwQayHGuRnMvwyLyeXSBxlXng0s4/7BdPcWg
	 m30dGjsDbB5Mt5+rEYa54GgwOFz1konAlWtK/iHucYazSVe2WasEufmlJ883KfvDChtDV
	 XlXusRdU1YyTwCoJf52sUoCkMtGQpIVzIxWHFLwpe2klPrYU4eyzgESh7fxD+ncOEhFKH
	 rE8N2G2CpEb2OWURmtLUKWG4CZ18ib+X7x9FVQ2UivAV3cOrhgo7M6kB1AdMGZuaFAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138321;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/MYpxcLAPv923VNnchSximcRnuhCCSxCJ/uXpZE05bI=;
	b=wpOH+1amaG1i5uGESD3rwqI5SRXojy9BfMVNxFaRrkEDEuLqfzgY+MyOAiY4pLaCiVXC
	 3VKvt1g0MkBDxrAecxLkD9ytqlFADQ5Zl0jUfCOxjVhPP+mfXzAA3SrjO5qD4rX6H9u1o
	 G4zMVCCGNSyKV3eW4qlVngY5cEhRwEWQ2byu5tp23rxoKf0Z4Xyt2R4xRUvVOYFmalN71
	 i18o+lZHrTZXRv7ZqjFpbtrcdcd/ZZ0Hdvu7XDp3W9bCqkg5FR3zEMNJJltYqdHxKOXpM
	 ZYk0cPekkFqhNgAVdCM/bQam0Qb1QkfnxR6dCStuCJYsg9cG1JyZf8FsRNkVQbYqtug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q404qGpP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC84B606A320
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q404qGpP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261611F000C6;
	Fri, 20 Nov 2026 01:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138321;
	bh=/MYpxcLAPv923VNnchSximcRnuhCCSxCJ/uXpZE05bI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q404qGpPiOqPinw+0zP8k86bpsWq/V+DGom4ozrUiKvMndmTXtWZTW9Wk7GnXSlls
	 QEfyBbegs1VonlEYqFEEADTlzrpaMxPVOO4pK4SUjqQBY5SvfvyWOjlX9d4hreVddX
	 AjtsswowClCaUgJPCEQg7kospvv54cUNzqcLXaZeEr5X+ibMsIAzWz3+U0g51CQ9MA
	 St/Bu/g1R87/zJ45Xa+DKf+4vZO0S+7dOoO4MLwMsDS5QO3buyDQWA9bPAGAU04EV9
	 aPwNQNlpDjMNUq0xTfQ7I+xgCMyQSrjaKOifHj+fkemO8730YLM9hmnte2BT5rtwY5
	 WFYu0YdyvpY5g==
Message-ID: <sashiko-outbox-224316@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 09/12] selftests: drv-net: psp: test that
 software encap on ingress drops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-10-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-10-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:32:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Encap on ingress isn't supported: the action drops the packet.
>=20
> Verify it on traffic of a client behind a veth, with encap on the veth's
> ingress: forwarded, the packets must not reach the remote in clear text,
> and to a local address, they must not reach the local socket.
>=20
>   data_tc_encap_routed  routed packets are dropped by encap, IPv4 and
>                         IPv6
>   data_tc_encap_local   so are packets to a local address
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D9

