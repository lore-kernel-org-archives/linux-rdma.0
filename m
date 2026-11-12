Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445025;
	b=pS+ef3fcO1FlKx4fa2XJPaFn6hlt4iDrYmm6IJtSAnZU68tGjTFOtTchvDuWl+e/mA5k
	 LrTEgnrO1BwF67mSCBaywxSRts/eO2rNNFZ5c/SQOfb35fZl12EIX0aw/+QUxJJask6O5
	 xea6MaAa1Qm2gwtwtxj2tV1mkncooBWUk4BntgmwkpataxNadB1YpvPklQkZw5D3qN92q
	 QdEDZgTnqiRwQ9n/iI4Goh/zwbC3ZAOw3HdM0e3riH5VNyWafrY7h9IQXnhO0WrmoQaqf
	 KBQB6vQahq5a+DYhf4TUwbPMsBDgYJToo1rMiCjnDbqbWeaSt19K90OSduWONf46hcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445025;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KtAKby5qAM3mKR6ZPjAtpp7BAVFe8nHYCZaSmBL85bU=;
	b=JrRzZ1Ft/o+AAFzPpRN7PfELyk0Nf9dc8nDuT5UX7LCAFgUT3fyMh5iTYHm95tBmWYO5
	 2/AUHPpTzS05BlmhpUkckDhdtuqhE3k8zpJz4ybxVSnxqDh28RxTaja4qbJMspamJ7Kl8
	 nmDo7pAAW0jOxUowo6QI+BYWSkX16UgjWnyrylBXrj/+pApUSImipc2cS5zG4PX8ZEwnp
	 aw53KawEEjyrGJQKVbd1yhEZTyXRxO+wBls5J2No1Neq7JBNgHhsIzXHlKowcaT0VQ2Xv
	 DF0dbSwCNN7h7qX41yTk/oNYOmqM6J87i75eOpLDoY5d9YjMGHXai2r7cKat5hp/YSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=McAbBjGd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B8C606A88F
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=McAbBjGd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0587A1F00A05;
	Thu, 12 Nov 2026 00:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445025;
	bh=KtAKby5qAM3mKR6ZPjAtpp7BAVFe8nHYCZaSmBL85bU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=McAbBjGdyBr+1/B0ah909xSMmCPezslhbNAOww7nObaNRfsU2WHFcqpvOYp2dFdzd
	 u973pEjBNxf/6L3vDE+Aplo60Ku4ikTjmd2p62Srm9CQM2NuTvCqKz6RnNyxOv1S4r
	 NO5Q6CX+7QGmtI2uOjla9rST+qxAyajkzhzRK/YZtOY84pzZztu3/bGY9a0vpLvalR
	 ZjGJnbmq4vUq+cm5In+qRPxXFkBSFh7HmD9tzqZI9bCYpghxSM8dkWbF9IbCjNZB9H
	 pbUIeFg3mnW01wmuGFTGsP5+KRjDNf/qEqsdOdU58u2mjnJs0ClddsYMhgoUCLj1p+
	 oQPxQFDOy7hiA==
Message-ID: <sashiko-outbox-210011@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 08/15] psp: only give time-wait sockets of
 psp connections a validator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-9-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-9-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> psp_twsk_init() sets tw_validate_xmit_skb on tcp time-wait sockets.
> today, that becomes set whether or not the socket has psp offload, which
> is not needed but is harmless. psp_validate_xmit() passes such packets.
>=20
> but a validator makes a socket look like it has an encryption offload of
> its own, and the tc psp action, added in the next patch, relies on that:
> encap refuses the packets of such a socket, and sk_validate_xmit_skb()
> drops a packet with a psp association whose socket has a validator.
>=20
> set the validator only when the socket has a psp association.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D8

