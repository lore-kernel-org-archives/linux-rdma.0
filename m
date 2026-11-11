Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794438822;
	b=amavXJUV67Q8nS5WPoETEaRWFfyT+T0Uw0kpkmC3IihvhKvZmISOknLr7JokMf4WSvCi
	 c7dE3U/bmPIBRvRzVtMyE6MAr+ohG9yzCmjTgzUYm7hu5173vnzWdGBpyd4xn5lRna5R5
	 jIwzxhjj11+dMA9f3zWYzmajH4ybTuvQMj5Naqn9gxNctf886RSFEEi3StbwsR9HPS5XS
	 iA4Z5iQJpjuXefT3b4aS43UHs4MInLnPV7yojJHk5fBsrRp91VUjVyvmeb38UXu8mILhg
	 3PrWZTSC0Xn8ankO3zqtHuoQbU+pGyEWrSuDUT9co2VVl0mxqaeZobIQd99XlBpe2Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438822;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tVXjw+SzZJb0Lhm7FqIF3z4Dvm2Ag9P1VWUpaE+5YaQ=;
	b=gAI37SYqxZTMmUhROgaSHEN5ldNbmWF/tPB28C15FNdQCby9etVyN/pK0p0jC4o4WpLm
	 jkmZJEMaBxbbEs3t8umaEYErs7Xrr9t5C/4ujpbnGyeKBZenOaDP/709SQFpFyKxIwnAW
	 Y4BqlEXq/6k5QvtgxoFXsIs8bBCFTuldc+qQTAWp3YLWfk3r93VywpWjg/bM03fdO588a
	 u5QGHCEfQeisTzWP4xEJm4nmQ4B5tdA9VO7w/QWnLNbeZURWXKAimfjBmQrAfDBa4zM8b
	 lE7GaSybuJ6DDn1jdU02iaRRIiezXm0tnao4SW3F3s2uNeN3ZrVZJlsQukjOqloAX9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nNQIFcv+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3B9606A32A
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 23:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nNQIFcv+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D971F00A06;
	Wed, 11 Nov 2026 23:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794438822;
	bh=tVXjw+SzZJb0Lhm7FqIF3z4Dvm2Ag9P1VWUpaE+5YaQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nNQIFcv+Ny1hdmlAFj6qzelTAX48nVyboMMXAah3r2rV3HT6n7MtmM/tx/ocDTVpl
	 SX4wv7k4zI/9S7RXUj5QVmBJLIHJEfPe5CxBxtqqcjkbOqhw06QXoJqUqZg5WKd3LN
	 maTeQxAuM5Z1gcrVRMaHBeHyFgJuE6HNM0lMadf7CUH22OnzIqeyaxbBP6W3TmIHjB
	 6nXVIVro0IpQCPD7Bus3Z4LpFEsqTskmmTpW71BsNWYqRe8OINIGJkAIVzW3ossD6t
	 1w0IdkYi7VPOLUpZSbFBQ8f1xO+7VpfDUosLMYVG1nPG7mbGDg+3Yk6+8FX6z9MfSD
	 nlglLT+OuSaaQ==
Message-ID: <sashiko-outbox-209846@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/5] net/mlx4: factor csum flags into
 mlx4_en_csum_flags()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joe Damato" <joe@dama.to>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110231304.1859217-3-joe@dama.to>
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-3-joe@dama.to>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 23:13:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Extract the code which converts skb csum fields to WQE fields into a
> helper. This helper will be used by a follow-up series implementing
> software USO, to reduce code duplication.
>=20
> Signed-off-by: Joe Damato <joe@dama.to>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110231304.1859=
217-1-joe@dama.to?part=3D2

