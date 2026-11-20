Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138316;
	b=Q7lUhIHMw8bYE7DKhCuoBY6dH4xitDItPvX8zY02ONajO1x3HgA5EKoVwUXGNZw5lpH1
	 QyIspsqUp9wZu8pgNAFgw33vf0yCWQ42T0m6k9BTHd3VLa5nYUGBJirl4Xx4u15pdSYsr
	 P2ZH6NwqgcMApY8iKMkr5OC5nhMHdqaLpPrKcDFqD6+8L36ogAvaPhfJ1b5R73V93b0M1
	 n6nt1PyYuPowbfsdFqnFihT2YLBQJWBiF6TTFlpKdGIB6PuIol/Lr6oDHfEXmMs/rbYjZ
	 fdMfsAPFkfSnuVKjglJO5+n/ZOQwSu/jbMoa+4nGh17M/emB5tSBCUceE/g/7NV8VXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138316;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZbbOHxzThfi1O39beK8yXESqi52aPY1QslO5ZJRXRPM=;
	b=aPrIx9TKU11anZdggFcFsdVoK6JTKEsB5fsao0GnESBGeQtvWIEnZwH+v1s8suL87gGA
	 xLRfDGXjjcU17fXijnbzY0nuWdQpGfUjxcXvWssn3L8n+Vr8VOUXSmi9WLeh4CiNJ5g38
	 PhrJw50VJ66epiDu6BNkASnMFZnYSQqByaFdvd/ZSvijd8qq84Z8uRWQfSEa4RjHfvhYc
	 lETaBeL/vSFvSzkmVJ4o41yMVl2ru/HsRUSsXktvHFRuOzqHiDnXjdK6NXFg2VrIb2M00
	 oruUg5fpYMz3bcN7J1i07TSnhtHodJKRduMLA1HAJOTi3Z1A2C4k9fmC4V0Bi+PNNxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fr4MehEg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90287606A320
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fr4MehEg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52E41F000C6;
	Fri, 20 Nov 2026 01:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138316;
	bh=ZbbOHxzThfi1O39beK8yXESqi52aPY1QslO5ZJRXRPM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fr4MehEg5opUitlAUe2laLHD/dmoecf+C8jtNGLU0X2ixoYpQOuFR0du7mliXR8A7
	 4eGljQZ16SThnfhlxq0goqrVD8tju5g5o4DfqxJhuSNvctyQEVQPyQ/XO17za3J9IJ
	 AanS+RYsbEEPnJW/DIJOgjAmVVSJRbYgGybEpec6ikVzBwXUcrNsx2wr/Ua3pnZ1mp
	 FO2f031U1+3M8eEfBaHAMQiXtvCRrsn2dBcJBd8m6BfEi0RuFB/lmpscQhAB3w/d84
	 08qbs+IK3LkUV3pLANTp6ges+mzEXnLt8vR+udAkojguTycWNLu68j3LDJSwWfi86L
	 s07eoToILLf9A==
Message-ID: <sashiko-outbox-224308@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 01/12] psp: get netns from net_device
 instead of sock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-2-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-2-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:31:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Every PSP skb is related to a socket today, but that will no longer be
> true once a PSP association can be attached to the skb by other means,
> such as the tc psp action added later in the series.
>=20
> Get the netns from the transmitting device instead.
>=20
> For the outer source port range, psp_write_headers() now explicitly uses
> sock_net(sk) in the socket case specifically, to maintain the existing
> behavior.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D1

