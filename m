Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336068;
	b=fdRu0Vl7EVCYoJddI+oi1QxhF78reohwPhWLNntIIXJlHI8U1QGugvSX27q71tdXrDQs
	 vz2nxqhqPaix/CjHqsFNNMBDlC1UnNIA4PSuhY8vgTgTxL7dskw/MCkaS+3xKAiudcagu
	 KocN+G6Mi2HYcI7WlWQN5fgwEZKZANkzxbCfUL5wdZg3778fppgByuquFrujgeB8pq0sL
	 ofY+XJYx5aNoQt/KBLNvJySrpnH+hbxEtEBs3298SCzUFv805RLzJHUx/7MQvuu89bBuH
	 uDoC23fpkEQt6B1l6Q10LQky5l2OFRnuXuuzyu8+/AzfKCSDhSCnhVr18w9eUOC4uTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336068;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LNPlNIl2Ho1cGl4oQ2qoTtIS/LlujmbIwJBJnRbyi5I=;
	b=mZPYkWRiUQ80DJ/P3W+KMtlX2KIqcRMuHQDht/U+FrOB4hQB3PAzPDaZz8XTIWF4z8zk
	 sV98uMKC4nHvPWkJlN6D0RZ+jm0Fgb+zyIhxCet3TNEfKrMz1Tjnq7KmVZ9gi7KSH8moE
	 NEFfms51F/8SNnXmSMXGcro6EuCzThaMsjtwLHoeEWIlGVglEVqqHdkDVIcfPBmuM7eAG
	 5FbudxuD9rQbspys+bCPayyue68tdxttUDyvMvx1Q8ymy1yEQNM7ISXoTbxapQCA8HgDv
	 9Y4yc4q54KH4BUXYvIFRQdOYQVVLnM3/arREl+nv98gyzR4ylGHo1zBu6VKdhwlO6uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fITpQ1vn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72E4606A327
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fITpQ1vn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2C81F00A02;
	Fri, 30 Oct 2026 04:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336067;
	bh=LNPlNIl2Ho1cGl4oQ2qoTtIS/LlujmbIwJBJnRbyi5I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fITpQ1vnq+ddxxzeXvM61v/DnzX2ly+OoGJK5SdKoCY81G9Q5Db0ff//B7+v2+gEJ
	 PwOjQwvD/W/g9upRKx2hDYjpmyNCCblmcTtbhYyufah8NY+Nm1LLKmDuwKFStfoWff
	 +FaTZD/kKJsZIi5DGesKgcvqLLGIZaO/5HKD/dmm+UK41FX4gDmypRFhu0cKL1VxMx
	 qWEuwkUTlOeDlI0tp6lYleVIYHGE+mszqbqPykvUXGfcKAc1L1nt6Go697TYTkJszJ
	 xnYYhWgs/J9sQGttTgSa18AqffDePAftovpxf8w0HOeZfYJ00ZkTrPhUUtbIZR87c6
	 VuBkEO+youaPQ==
Message-ID: <sashiko-outbox-190466@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next v4 4/5] RDMA/ionic: add completion timestamp to CQE
 format
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260610154216.712374-5-abhijit.gangurde@amd.com>
References: <20260610154216.712374-5-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Update the CQE structure to include hardware timestamp.
> When firmware supports RDMA completion timestamps,
> the hardware populates the timestamp field.
>=20
> Co-developed-by: Allen Hubbe <allen.hubbe@amd.com>
> Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260610154216.7123=
74-1-abhijit.gangurde@amd.com?part=3D4

