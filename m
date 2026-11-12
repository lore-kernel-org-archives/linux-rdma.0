Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445028;
	b=225elvJtx76Q9LwWtEq0P8++ySg9SDnq70hjcuten1ypyHbQSM5CrvMZVWI30874KFEt
	 nocsamCP9IYlLJ3dgl8Vudxb1g6Fcqv4iNcyjA3ohaspBhQBkMPiItGQblDJm+jzeZk/Q
	 2qpXvD4W5wxZcuT1xE532XHKuuJNCMxKZHl9K9Cu07D4B2RWyr8PRuypMEjf6t2Rne2Zs
	 7am1VlJxOiGjz7JMn4MRJYVRmVB570EOFHI04ERsme7C63XkeJRNA6OktAf0ztBhSPFrv
	 DY2Hm1SppHGwOnJxpCQRB3Mckw4C1IQYyZWIMqPPLP9NUPd9fi9GgX0yhDbnEUH8vtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445028;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lynr1NVd58Ycn0su78/svqJgQvcEeljqGGKeqsYXNEw=;
	b=a4fFr+/xebsgFdGXA/lN0mc8goCggKlPaAHHVeNu5TL5T8H4N4CwdDBslV4MR95ABZDm
	 csQTLmbgI7ZGgmLltY5LaR5FcCc4J3EQHS1hbtw1daKvR70h7Xl9PUcXiEv4WSa8fE1WN
	 lijSuIM5pGyohIpIQIYOnvaE5dcM904jDnHt5TUtGsffITtdtGjrygoTx/oe6RUpLJjPw
	 5+BbYVZEYyF4YcBgcCYGgL2mwcmktBc/XVCMmHvzoAoHyu1diX9v+szGxGjNmcVm+dzlu
	 6EK7f3o20k4BGR2CRqU2SA4r1eYa7hjSq3uPTlqfZMMFEfE0tuIkNOpVZJZnGmmVCVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U53jaW2Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFBF606A88C
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U53jaW2Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB341F00A07;
	Thu, 12 Nov 2026 00:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445028;
	bh=lynr1NVd58Ycn0su78/svqJgQvcEeljqGGKeqsYXNEw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U53jaW2QtjRycsyYTEqKNIUX1zkeKnzydwUR9k5d6VwZHt0I0TrnYu91PdGOOWM5F
	 BeEKX3d1AtuBEUoiP0LytqN8ncjNZnVtzide61W68/n6jXZLYSqlciIFH0i0KwYYu9
	 6VdPiYeHpvMuW3v95yeCOdBpFFPvlmiQKE/hBQwQ7JBIZeFUEZyYMdc4VHqIz04dP8
	 TeuoN4sT+icVM+H9rq6h0TwRJf/0Ai+O+DNsfOKODgAXByAJsUfDIGygN7Or96DFTD
	 dvtASLK+7tcC+m2jBbwrg4eiX5kOfGA6n/kROUxZ1NbMzdKvQtXirTEhX4gb/Z17KE
	 H3Asq9AEgsowg==
Message-ID: <sashiko-outbox-210015@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 12/15] selftests: drv-net: psp: test that
 software encap on ingress drops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-13-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-13-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:07 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> encap on ingress is hardware offload only. In software, the packet is
> dropped.
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D12

