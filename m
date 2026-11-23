Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446157;
	b=lcsYB11bR4lZatm2wRifNk+xdW59fA1ysL5kIksTPgEFaupzW9fvRrMCf/MyaKBCsHr7
	 7O6rH9xj2wV7i4wqQhc9YqWp84Zvd+RrjApGi59XmHmN/OOQdUH1EB9NVPECTMRMmj2Ep
	 fmiUfATEhSWOsbQOeI/WtNrcnS+Q7uihF+4ve9HAwveYMt2mmFA7xpAa2ocW7c8mKgfgP
	 KFvtYlT1eHGRvyohMnL6qK7a6imMCAgU2Vjt8uT+Aj0k2m8OXTHPmdnFIX0r7l2IT3cRt
	 qI0Esj2BPWhSIqpwsIjZiqgc86+1Inv2Ku+5JCDeNlRYRlklFCFTEKpg1frtje8OOGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446157;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HzpNQfv294tpDmZGUhk6s34i9rMoubfO7Z1hNpYoskI=;
	b=j7ohNiR+gedj9pNvc6IYunLzpNvAxuDicxDth8qMmCjRLIXBIIvWnwD9VSvFuDGOBkCt
	 D2p1MbP5oj4KTYgefW/HN9XnafbNkg6AC5TI1a+QTS9is7f8h3W1/uP5mmQNelcz0DB28
	 ZE/iWqxdrPpQo8dsqtumciI8s4vBb7eBzjwrFEms+vPGFnJ81ZJrbYym7RZmBoa4DuQjV
	 l8axBWKxC6MD40Gurav21knNmi6jLz5yhVgDe95Wz2I3gnVEIhWTqWL/VLVZaReRQlmyi
	 rV3FXYsdGSpfndbOvlcjfPmTECaOVuwYarQo4ZSEWNyiCeEyyPJ9YtaFS68wBWKEcbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=owPirzA2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631EF606A32E
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=owPirzA2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292141F000C6;
	Mon, 23 Nov 2026 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446157;
	bh=HzpNQfv294tpDmZGUhk6s34i9rMoubfO7Z1hNpYoskI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=owPirzA2U8a+dNe5cvZ+4DKXkH4pK6dQv/T0NrFrxT4hXYte9BdHPKnIna4ajggqM
	 ufgSS6xyYWs4qwEJ8FfdOveu37nReW5naZKEUj1kRPWu/DX3mzD/DmsPg00U1ITKB5
	 CnMqHePtUdiO5XM9+NDOJ1CgDHh+tK77EiaCAq+YShXs76QiJNnQKerIRL+3QPDdKX
	 j+18BOsABmHJzIefstzytfS/7d7ut3Feqz8Gqfp440QimDhZ/SWYyuJVT7ZmKmWetJ
	 1FRxZzTWNp2ZncN46ojW72m/nbUCWSG2YiyuEUDzq09JXR2MNCZ3AyuZtm19IVu3G5
	 3GSCR5jAoBMmg==
Message-ID: <sashiko-outbox-229469@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 0/9] Misc patches for RTRS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Md Haris Iqbal" <haris.iqbal@ionos.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261123143719.938876-1-haris.iqbal@ionos.com>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 15:02:36 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 9-patch series:

- Patches 2, 4, and 6-9: no issues found.
- Patch 1 ("RDMA/rtrs-clt: Add mpath_policy module parameter"): 2
  potential issues (1 Medium, 1 Low)
- Patch 3 ("RDMA/rtrs-clt: Trigger error recovery when posting L..."): 1
  potential issue (1 High)
- Patch 5 ("RDMA/rtrs-clt: rename pathname parameter to sessname..."): 1
  related pre-existing bug noted

Detailed reviews have been sent as separate replies to patches 1, 3, and
5.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123143719.9388=
76-1-haris.iqbal@ionos.com
